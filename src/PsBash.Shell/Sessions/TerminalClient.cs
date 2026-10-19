using System.Diagnostics;
using PsBash.Core.Runtime;
using PsBash.Core.Runtime.Ipc;
using PsBash.Shell.Pty;

namespace PsBash.Shell.Sessions;

/// <summary>
/// <c>ps-bash session attach NAME</c>: connect this terminal to the session's broker (starting it if
/// needed), replay its screen, and pump keystrokes and output until the shell exits or the user detaches
/// with <c>Ctrl-]</c> <c>d</c>. Works over ssh: <c>ssh -t host ps-bash session attach NAME</c>.
/// </summary>
internal static class TerminalClient
{
    internal static readonly TimeSpan BrokerStartTimeout = TimeSpan.FromSeconds(30);

    /// <summary>
    /// The interactive host has not been verified under ConPTY (the PTY end-to-end tests are POSIX-only), and
    /// a broker whose shell exits at once is worse than a clear refusal.
    /// </summary>
    internal static bool Unsupported(out string message)
    {
        message = OperatingSystem.IsWindows()
            ? "ps-bash session attach/serve: reattachable terminals are supported on Linux and macOS only (the interactive host is not yet verified under ConPTY)"
            : "";
        return OperatingSystem.IsWindows();
    }

    public static async Task<int> AttachAsync(string name, bool readOnly, CancellationToken ct)
    {
        if (Unsupported(out var why)) { Console.Error.WriteLine(why); return 2; }
        if (Console.IsInputRedirected && !readOnly)
        {
            Console.Error.WriteLine("ps-bash session attach: stdin is not a terminal (use ssh -t, or --read-only)");
            return 2;
        }

        var (_, hostEndpoint) = IpcTransportFactory.ResolveEndpoint();
        var socket = TerminalBroker.TerminalEndpointFor(hostEndpoint);

        var stream = await ConnectOrStartBrokerAsync(name, socket, ct).ConfigureAwait(false);
        if (stream is null) return 1;

        await using (stream)
        {
            await TerminalProtocol.WriteAsync(stream, TerminalProtocol.Hello,
                new[] { readOnly ? TerminalProtocol.HelloReadOnly : (byte)0 }, ct).ConfigureAwait(false);

            using var raw = TerminalMode.EnterRawIfTty();
            using var done = CancellationTokenSource.CreateLinkedTokenSource(ct);

            var tasks = new List<Task>();
            if (!readOnly)
            {
                tasks.Add(PumpResizeAsync(stream, done.Token));
                tasks.Add(PumpInputAsync(stream, done));
            }
            var output = PumpOutputAsync(stream, done.Token);

            int code = await output.ConfigureAwait(false);
            done.Cancel();
            foreach (var t in tasks) { try { await t.WaitAsync(TimeSpan.FromMilliseconds(200)).ConfigureAwait(false); } catch { } }

            if (code == DetachedCode)
            {
                raw.Dispose();
                Console.Error.WriteLine($"\r\n[detached from {name}; `ps-bash session attach {name}` resumes]");
                return 0;
            }
            return code;
        }
    }

    /// <summary>Tell a running broker to end its shell (<c>session stop</c>). Silent when there is none.</summary>
    public static async Task QuitAsync(CancellationToken ct)
    {
        try
        {
            var (_, hostEndpoint) = IpcTransportFactory.ResolveEndpoint();
            var stream = await TryConnectAsync(TerminalBroker.TerminalEndpointFor(hostEndpoint), ct).ConfigureAwait(false);
            if (stream is null) return;
            await using (stream)
            {
                await TerminalProtocol.WriteAsync(stream, TerminalProtocol.Hello, new byte[] { 0 }, ct).ConfigureAwait(false);
                await TerminalProtocol.WriteAsync(stream, TerminalProtocol.Quit, ReadOnlyMemory<byte>.Empty, ct).ConfigureAwait(false);
                // The broker ends the connection once it has taken the shell down.
                using var wait = CancellationTokenSource.CreateLinkedTokenSource(ct);
                wait.CancelAfter(TimeSpan.FromSeconds(5));
                try { while (await TerminalProtocol.ReadAsync(stream, wait.Token).ConfigureAwait(false) is not null) { } } catch { }
            }
        }
        catch (Exception ex) when (ex is IOException or UnauthorizedAccessException) { }
    }

    /// <summary>The hidden <c>session serve NAME</c> entry point: run the broker in this (detached) process.</summary>
    public static async Task<int> ServeAsync(CancellationToken ct)
    {
        if (Unsupported(out var why)) { Console.Error.WriteLine(why); return 2; }
        var host = Environment.GetEnvironmentVariable("PSBASH_HOST");
        if (string.IsNullOrEmpty(host))
        {
            var sxs = Path.Combine(AppContext.BaseDirectory, IpcWorker.GetHostBinaryName());
            host = File.Exists(sxs) ? sxs : null;
        }
        if (host is null)
        {
            Console.Error.WriteLine("ps-bash: ps-bash-host binary not found. Set PSBASH_HOST=<path> or install alongside ps-bash.");
            return 127;
        }

        var (_, hostEndpoint) = IpcTransportFactory.ResolveEndpoint();
        var socket = TerminalBroker.TerminalEndpointFor(hostEndpoint);
        int idle = int.TryParse(Environment.GetEnvironmentVariable("PSBASH_HOST_IDLE_SECS"), out var s) && s > 0
            ? s : SessionCommands.DefaultIdleSecs;

        using var stop = CancellationTokenSource.CreateLinkedTokenSource(ct);
        // The terminal that launched us may hang up; the session must not. SIGTERM ends it cleanly.
        using var hup = System.Runtime.InteropServices.PosixSignalRegistration.Create(
            System.Runtime.InteropServices.PosixSignal.SIGHUP, c => c.Cancel = true);
        using var term = System.Runtime.InteropServices.PosixSignalRegistration.Create(
            System.Runtime.InteropServices.PosixSignal.SIGTERM, c => { c.Cancel = true; stop.Cancel(); });
        try { return await TerminalBroker.ServeAsync(host, socket, idle, stop.Token).ConfigureAwait(false); }
        finally { try { File.Delete(socket); } catch { } }
    }
    private const int DetachedCode = int.MinValue;

    private static async Task<int> PumpOutputAsync(Stream stream, CancellationToken ct)
    {
        await using var stdout = Console.OpenStandardOutput();
        try
        {
            while (true)
            {
                var frame = await TerminalProtocol.ReadAsync(stream, ct).ConfigureAwait(false);
                if (frame is null) return 1; // broker went away
                switch (frame.Value.Type)
                {
                    case TerminalProtocol.Output:
                        await stdout.WriteAsync(frame.Value.Payload, ct).ConfigureAwait(false);
                        await stdout.FlushAsync(ct).ConfigureAwait(false);
                        break;
                    case TerminalProtocol.Exit:
                        return TerminalProtocol.DecodeExit(frame.Value.Payload);
                }
            }
        }
        catch (OperationCanceledException) { return DetachedCode; }
        catch (Exception ex) when (ex is IOException or InvalidDataException) { return 1; }
    }

    private static async Task PumpInputAsync(Stream stream, CancellationTokenSource done)
    {
        var filter = new DetachFilter();
        var buf = new byte[4096];
        try
        {
            // Not Console.OpenStandardInput(): on a tty that stream is a line reader that swallows control
            // bytes (the detach chord's Ctrl-]) and delivers keystrokes a line at a time. Read fd 0 raw.
            await using Stream stdin = OperatingSystem.IsWindows()
                ? Console.OpenStandardInput()
                : new FileStream(new Microsoft.Win32.SafeHandles.SafeFileHandle(0, ownsHandle: false), FileAccess.Read, bufferSize: 1);
            while (!done.IsCancellationRequested)
            {
                int n = await stdin.ReadAsync(buf, done.Token).ConfigureAwait(false);
                if (n <= 0) { done.Cancel(); return; } // stdin closed: detach
                var forward = filter.Filter(buf.AsSpan(0, n), out var detach);
                if (forward.Length > 0)
                    await TerminalProtocol.WriteAsync(stream, TerminalProtocol.Input, forward, done.Token).ConfigureAwait(false);
                if (detach) { done.Cancel(); return; }
            }
        }
        catch (Exception ex) when (ex is OperationCanceledException or IOException) { }
    }

    private static async Task PumpResizeAsync(Stream stream, CancellationToken ct)
    {
        int lastW = -1, lastH = -1;
        try
        {
            while (!ct.IsCancellationRequested)
            {
                int w = 80, h = 24;
                try { if (!Console.IsOutputRedirected) { w = Console.WindowWidth; h = Console.WindowHeight; } } catch { }
                if (w > 0 && h > 0 && (w != lastW || h != lastH))
                {
                    lastW = w; lastH = h;
                    await TerminalProtocol.WriteAsync(stream, TerminalProtocol.Resize,
                        TerminalProtocol.EncodeResize(w, h), ct).ConfigureAwait(false);
                }
                await Task.Delay(250, ct).ConfigureAwait(false);
            }
        }
        catch (Exception ex) when (ex is OperationCanceledException or IOException) { }
    }

    private static async Task<Stream?> ConnectOrStartBrokerAsync(string name, string socket, CancellationToken ct)
    {
        var existing = await TryConnectAsync(socket, ct).ConfigureAwait(false);
        if (existing is not null) return existing;

        if (!SpawnBroker(name)) return null;

        var deadline = DateTime.UtcNow + BrokerStartTimeout;
        while (DateTime.UtcNow < deadline)
        {
            ct.ThrowIfCancellationRequested();
            var stream = await TryConnectAsync(socket, ct).ConfigureAwait(false);
            if (stream is not null) return stream;
            await Task.Delay(100, ct).ConfigureAwait(false);
        }
        Console.Error.WriteLine($"ps-bash session attach: the terminal broker for '{name}' did not start within {BrokerStartTimeout.TotalSeconds:0}s");
        return null;
    }

    private static async Task<Stream?> TryConnectAsync(string socket, CancellationToken ct)
    {
        if (!File.Exists(socket)) return null;
        try
        {
            await using var transport = new UnixSocketTransport(socket);
            using var cts = CancellationTokenSource.CreateLinkedTokenSource(ct);
            cts.CancelAfter(TimeSpan.FromSeconds(2));
            return await transport.ConnectAsync(cts.Token).ConfigureAwait(false);
        }
        catch (Exception ex) when (ex is IOException or System.Net.Sockets.SocketException or OperationCanceledException or UnauthorizedAccessException)
        {
            ct.ThrowIfCancellationRequested();
            return null;
        }
    }

    /// <summary>Start <c>ps-bash session serve NAME</c> detached from this terminal, so closing it (or the ssh link) does not end the shell.</summary>
    private static bool SpawnBroker(string name)
    {
        var exe = Environment.ProcessPath;
        if (string.IsNullOrEmpty(exe))
        {
            Console.Error.WriteLine("ps-bash session attach: cannot locate the ps-bash executable to start the broker");
            return false;
        }
        var args = new[] { "session", "serve", name };
        try
        {
            var psi = new ProcessStartInfo { FileName = exe, UseShellExecute = false, CreateNoWindow = true,
                RedirectStandardInput = true, RedirectStandardOutput = true, RedirectStandardError = true };
            foreach (var a in args) psi.ArgumentList.Add(a);
            using var p = Process.Start(psi);
            if (p is null) return false;
            try { p.StandardInput.Close(); } catch { }
            _ = p.StandardOutput.BaseStream.CopyToAsync(Stream.Null);
            _ = p.StandardError.BaseStream.CopyToAsync(Stream.Null);
            return true;
        }
        catch (Exception ex) when (ex is IOException or System.ComponentModel.Win32Exception or InvalidOperationException)
        {
            Console.Error.WriteLine($"ps-bash session attach: cannot start the broker: {ex.Message}");
            return false;
        }
    }
}
