using PsBash.Core.Runtime.Ipc;
using PsBash.Shell.Pty;

namespace PsBash.Shell.Sessions;

/// <summary>
/// The durable side of <c>ps-bash session attach</c>: a detached process that owns a PTY and the
/// <c>ps-bash-host --interactive</c> shell running on it, and serves terminal clients over an AF_UNIX
/// socket (<see cref="TerminalProtocol"/>). Clients come and go — an ssh connection drops, a window
/// closes — and the shell and its screen survive; the next client gets the scrollback replayed and a
/// forced redraw. Ends when the shell exits or after an idle window with nobody attached.
/// </summary>
internal sealed class TerminalBroker
{
    internal const int ScrollbackBytes = 1 << 20;

    private readonly ScrollbackBuffer _scrollback = new(ScrollbackBytes);
    private readonly SemaphoreSlim _fanout = new(1, 1);
    private readonly List<Client> _clients = new();
    private readonly IPty _pty;
    private readonly Stream _ptyInput;
    private short _cols, _rows;
    private readonly TaskCompletionSource _quit = new(TaskCreationOptions.RunContinuationsAsynchronously);

    private TerminalBroker(IPty pty, short cols, short rows)
    {
        _pty = pty;
        _ptyInput = OpenWriteStream(pty);
        _cols = cols;
        _rows = rows;
    }

    private sealed class Client
    {
        public required Stream Stream { get; init; }
        public required bool ReadOnly { get; init; }
        public readonly SemaphoreSlim WriteLock = new(1, 1);
    }

    /// <summary>
    /// On POSIX the PTY master is ONE FileStream for both directions, and a single FileStream is not safe
    /// for a concurrent read (the output pump) and write (client keystrokes). Write through a second,
    /// non-owning stream over the same descriptor; ConPTY already has separate pipes.
    /// </summary>
    private static Stream OpenWriteStream(IPty pty)
    {
        if (pty.Input is FileStream master && ReferenceEquals(pty.Input, pty.Output))
        {
            var handle = new Microsoft.Win32.SafeHandles.SafeFileHandle(master.SafeFileHandle.DangerousGetHandle(), ownsHandle: false);
            return new FileStream(handle, FileAccess.Write);
        }
        return pty.Input;
    }

    /// <summary>Terminal socket for the session whose host endpoint is <paramref name="hostEndpoint"/>.</summary>
    internal static string TerminalEndpointFor(string hostEndpoint)
    {
        const string suffix = ".sock";
        var stem = hostEndpoint.EndsWith(suffix, StringComparison.Ordinal) ? hostEndpoint[..^suffix.Length] : hostEndpoint;
        var path = stem + "-t.sock";
        if (path.Length > IpcTransportFactory.UnixSocketPathBudget())
            throw new IOException(
                $"terminal socket path '{path}' is too long for a unix socket; shorten TMPDIR or the session name");
        return path;
    }

    /// <summary>Run the broker until the shell exits or the idle window passes. Returns the shell's exit code.</summary>
    public static async Task<int> ServeAsync(string hostBinary, string terminalSocket, int idleSecs, CancellationToken ct)
    {
        short cols = 80, rows = 24;
        await using var pty = await PtyAllocator.AllocateAsync(cols, rows).ConfigureAwait(false);
        var env = new Dictionary<string, string>(StringComparer.Ordinal) { ["PSBASH_PTY_ATTACHED"] = "1" };
        // A detached broker has no terminal type of its own; the shell it hosts speaks xterm.
        if (string.IsNullOrEmpty(Environment.GetEnvironmentVariable("TERM"))) env["TERM"] = "xterm-256color";
        await using var shell = PtySpawner.Spawn(hostBinary, new[] { "--interactive" }, pty, env);

        var broker = new TerminalBroker(pty, cols, rows);
        await using var transport = new UnixSocketTransport(terminalSocket);
        await transport.ListenAsync(ct).ConfigureAwait(false);

        using var stop = CancellationTokenSource.CreateLinkedTokenSource(ct);
        var pump = broker.PumpOutputAsync(stop.Token);
        var accept = broker.AcceptLoopAsync(transport, stop.Token);
        var idle = broker.IdleWatchAsync(idleSecs, stop.Token);
        var exitTask = shell.WaitForExitAsync(CancellationToken.None);

        var first = await Task.WhenAny(exitTask, idle, broker._quit.Task).ConfigureAwait(false);
        int code;
        if (first == exitTask) code = await exitTask.ConfigureAwait(false);
        else
        {
            code = 0;
            await shell.DisposeAsync().ConfigureAwait(false); // idle: take the shell down with us
        }

        // Let the last output reach the clients before announcing the exit.
        try { await pump.WaitAsync(TimeSpan.FromSeconds(2)).ConfigureAwait(false); } catch { }
        await broker.BroadcastAsync(TerminalProtocol.Exit, TerminalProtocol.EncodeExit(code)).ConfigureAwait(false);
        stop.Cancel();
        await broker.CloseAllAsync().ConfigureAwait(false);
        try { await accept.ConfigureAwait(false); } catch { }
        return code;
    }

    private async Task PumpOutputAsync(CancellationToken ct)
    {
        var buf = new byte[16 * 1024];
        try
        {
            while (!ct.IsCancellationRequested)
            {
                int n = await _pty.Output.ReadAsync(buf, ct).ConfigureAwait(false);
                if (n <= 0) break;
                // Snapshot-and-register in HandleClient takes the same gate, so a new client sees every
                // byte exactly once: either in its replay or in the live stream after it.
                await _fanout.WaitAsync(ct).ConfigureAwait(false);
                try
                {
                    _scrollback.Append(buf.AsSpan(0, n));
                    await SendLockedAsync(TerminalProtocol.Output, buf.AsMemory(0, n)).ConfigureAwait(false);
                }
                finally { _fanout.Release(); }
            }
        }
        catch (OperationCanceledException) { }
        catch (IOException) { }
    }

    private async Task AcceptLoopAsync(IIpcTransport transport, CancellationToken ct)
    {
        while (!ct.IsCancellationRequested)
        {
            Stream stream;
            try { stream = await transport.AcceptAsync(ct).ConfigureAwait(false); }
            catch (OperationCanceledException) { return; }
            catch (IOException) { await Task.Delay(100, ct).ConfigureAwait(false); continue; }
            _ = Task.Run(() => HandleClientAsync(stream, ct), CancellationToken.None);
        }
    }

    private async Task HandleClientAsync(Stream stream, CancellationToken ct)
    {
        Client? client = null;
        try
        {
            using var helloTimeout = CancellationTokenSource.CreateLinkedTokenSource(ct);
            helloTimeout.CancelAfter(TimeSpan.FromSeconds(5));
            var hello = await TerminalProtocol.ReadAsync(stream, helloTimeout.Token).ConfigureAwait(false);
            if (hello is not { Type: TerminalProtocol.Hello }) return;
            client = new Client
            {
                Stream = stream,
                ReadOnly = hello.Value.Payload.Length > 0 && (hello.Value.Payload[0] & TerminalProtocol.HelloReadOnly) != 0,
            };

            await _fanout.WaitAsync(ct).ConfigureAwait(false);
            try
            {
                var replay = _scrollback.Snapshot();
                if (replay.Length > 0)
                    await TerminalProtocol.WriteAsync(stream, TerminalProtocol.Output, replay, ct).ConfigureAwait(false);
                lock (_clients) _clients.Add(client);
            }
            finally { _fanout.Release(); }

            while (true)
            {
                var frame = await TerminalProtocol.ReadAsync(stream, ct).ConfigureAwait(false);
                if (frame is null) break;
                switch (frame.Value.Type)
                {
                    case TerminalProtocol.Input when !client.ReadOnly:
                        await _ptyInput.WriteAsync(frame.Value.Payload, ct).ConfigureAwait(false);
                        await _ptyInput.FlushAsync(ct).ConfigureAwait(false);
                        break;
                    case TerminalProtocol.Quit when !client.ReadOnly:
                        _quit.TrySetResult();
                        break;
                    case TerminalProtocol.Resize when !client.ReadOnly:
                        if (TerminalProtocol.TryDecodeResize(frame.Value.Payload, out var c, out var r))
                            await ResizeAsync(c, r).ConfigureAwait(false);
                        break;
                }
            }
        }
        catch (Exception ex)
        {
            // Client gone or misbehaving: drop it, never the broker (the shell outlives every client).
            if (ex is not (OperationCanceledException or EndOfStreamException)) Log($"client dropped: {ex}");
        }
        finally
        {
            if (client is not null) lock (_clients) _clients.Remove(client);
            try { await stream.DisposeAsync().ConfigureAwait(false); } catch { }
            Volatile.Write(ref _lastDetachTicks, Environment.TickCount64);
        }
    }

    /// <summary>
    /// Resize the PTY. A reattaching client usually has the size the PTY already has, which delivers no
    /// SIGWINCH and so no redraw; nudge it one row and back so a full-screen program repaints.
    /// </summary>
    private async Task ResizeAsync(short cols, short rows)
    {
        bool same = cols == _cols && rows == _rows;
        _cols = cols;
        _rows = rows;
        if (same && rows > 1)
        {
            _pty.Resize(cols, (short)(rows - 1));
            await Task.Delay(30).ConfigureAwait(false);
        }
        _pty.Resize(cols, rows);
    }

    private long _lastDetachTicks = Environment.TickCount64;

    private async Task IdleWatchAsync(int idleSecs, CancellationToken ct)
    {
        var window = TimeSpan.FromSeconds(Math.Max(1, idleSecs));
        try
        {
            while (true)
            {
                await Task.Delay(TimeSpan.FromSeconds(Math.Min(30, Math.Max(1, idleSecs))), ct).ConfigureAwait(false);
                bool attached;
                lock (_clients) attached = _clients.Count > 0;
                if (attached) { Volatile.Write(ref _lastDetachTicks, Environment.TickCount64); continue; }
                if (Environment.TickCount64 - Volatile.Read(ref _lastDetachTicks) >= window.TotalMilliseconds) return;
            }
        }
        catch (OperationCanceledException) { /* shutting down: treated like idle so the shell is taken down too */ }
    }

    private Task BroadcastAsync(byte type, ReadOnlyMemory<byte> payload) => BroadcastCoreAsync(type, payload);

    private async Task BroadcastCoreAsync(byte type, ReadOnlyMemory<byte> payload)
    {
        await _fanout.WaitAsync().ConfigureAwait(false);
        try { await SendLockedAsync(type, payload).ConfigureAwait(false); }
        finally { _fanout.Release(); }
    }

    /// <summary>Send to every client (caller holds <c>_fanout</c>); a client that cannot take it in 5 s is dropped.</summary>
    private async Task SendLockedAsync(byte type, ReadOnlyMemory<byte> payload)
    {
        Client[] snapshot;
        lock (_clients) snapshot = _clients.ToArray();
        foreach (var c in snapshot)
        {
            try
            {
                using var cts = new CancellationTokenSource(TimeSpan.FromSeconds(5));
                await c.WriteLock.WaitAsync(cts.Token).ConfigureAwait(false);
                try { await TerminalProtocol.WriteAsync(c.Stream, type, payload, cts.Token).ConfigureAwait(false); }
                finally { c.WriteLock.Release(); }
            }
            catch
            {
                lock (_clients) _clients.Remove(c);
                try { await c.Stream.DisposeAsync().ConfigureAwait(false); } catch { }
            }
        }
    }

    /// <summary>Best-effort diagnostic trail beside the sockets; the broker is detached and has no stderr.</summary>
    internal static void Log(string message)
    {
        try
        {
            File.AppendAllText(Path.Combine(PsBash.Core.Runtime.PsBashRuntimeDirectory.GetPath(), "terminal-broker.log"),
                $"{DateTime.UtcNow:O} {message}\n");
        }
        catch { }
    }

    private async Task CloseAllAsync()
    {
        Client[] snapshot;
        lock (_clients) { snapshot = _clients.ToArray(); _clients.Clear(); }
        foreach (var c in snapshot)
            try { await c.Stream.DisposeAsync().ConfigureAwait(false); } catch { }
    }
}
