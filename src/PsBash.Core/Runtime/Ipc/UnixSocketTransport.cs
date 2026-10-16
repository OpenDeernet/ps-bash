using System.Net.Sockets;
using System.Runtime.InteropServices;

namespace PsBash.Core.Runtime.Ipc;

/// <summary>
/// AF_UNIX socket transport. Used on POSIX platforms (Linux/macOS) and
/// also on Windows 10 1803+ where AF_UNIX is supported, but the launcher's
/// fallback decision (T03) prefers the named-pipe transport on Windows.
/// </summary>
public sealed class UnixSocketTransport : IIpcTransport
{
    private readonly string _socketPath;
    private Socket? _listener;
    private bool _listening;
    private int _disposed;

    public string Endpoint => _socketPath;
    public string Scheme => "unix";

    public UnixSocketTransport(string socketPath)
    {
        if (string.IsNullOrEmpty(socketPath)) throw new ArgumentException("socketPath required", nameof(socketPath));
        _socketPath = socketPath;
    }

    public Task ListenAsync(CancellationToken ct = default)
    {
        if (_listening) throw new InvalidOperationException("Already listening");
        ThrowIfDisposed();

        // Stale socket file from a crashed previous host: remove before bind.
        if (File.Exists(_socketPath))
        {
            try { File.Delete(_socketPath); } catch (IOException) { /* let bind surface the real error */ }
        }

        var dir = Path.GetDirectoryName(_socketPath);
        if (!string.IsNullOrEmpty(dir))
        {
            // The canonical socket lives in the per-user runtime directory:
            // validate owner + 0700 BEFORE bind so another local user cannot
            // pre-create the path or replace the socket. An explicit
            // PSBASH_IPC_ENDPOINT override is the user's own choice and is left
            // to plain creation.
            if (string.Equals(dir, PsBashRuntimeDirectory.GetPath(), StringComparison.Ordinal))
                PsBashRuntimeDirectory.EnsureDirectory();
            else
                Directory.CreateDirectory(dir);
        }

        var sock = new Socket(AddressFamily.Unix, SocketType.Stream, ProtocolType.Unspecified);
        var ep = new UnixDomainSocketEndPoint(_socketPath);
        sock.Bind(ep);
        // Declared cap. 16 overflowed under a burst of parallel launchers (an agent fanning out
        // commands): HostServer handles up to 64 at once, and once the queue is full a Unix
        // socket connect fails at once with EAGAIN instead of waiting (ConnectAsync retries).
        sock.Listen(backlog: ListenBacklog);
        _listener = sock;
        _listening = true;

        // 0600 — owner read+write only. POSIX-only; no-op on Windows where ACL
        // is the security boundary instead.
        if (!RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
        {
            try { File.SetUnixFileMode(_socketPath, UnixFileMode.UserRead | UnixFileMode.UserWrite); }
            catch (PlatformNotSupportedException) { /* old runtime — best-effort */ }
        }

        return Task.CompletedTask;
    }

    public async Task<Stream> AcceptAsync(CancellationToken ct = default)
    {
        if (!_listening || _listener is null) throw new InvalidOperationException("Call ListenAsync first");
        var client = await _listener.AcceptAsync(ct);
        return new NetworkStream(client, ownsSocket: true);
    }

    internal const int ListenBacklog = 512;

    // A full accept queue is transient (the host drains it), so EAGAIN is retried for a bounded
    // ~2 s before it is reported. 30 concurrent `ps-bash -c` against a backlog of 16 failed one
    // of them with "host communication failed: Resource temporarily unavailable" (exit 125).
    private static readonly TimeSpan BacklogFullRetryWindow = TimeSpan.FromSeconds(2);
    private static readonly TimeSpan BacklogFullRetryDelay = TimeSpan.FromMilliseconds(10);

    // EAGAIN. .NET reports it as WouldBlock (EAGAIN == EWOULDBLOCK on Linux); TryAgain is the
    // DNS code, kept for platforms that map it there.
    private static bool IsQueueFull(SocketException ex)
        => ex.SocketErrorCode is SocketError.WouldBlock or SocketError.TryAgain;

    public async Task<Stream> ConnectAsync(CancellationToken ct = default)
    {
        ThrowIfDisposed();
        var ep = new UnixDomainSocketEndPoint(_socketPath);
        var giveUpAt = DateTime.UtcNow + BacklogFullRetryWindow;
        while (true)
        {
            var sock = new Socket(AddressFamily.Unix, SocketType.Stream, ProtocolType.Unspecified);
            try
            {
                await sock.ConnectAsync(ep, ct);
                return new NetworkStream(sock, ownsSocket: true);
            }
            catch (SocketException ex) when (IsQueueFull(ex) && DateTime.UtcNow < giveUpAt)
            {
                sock.Dispose();
            }
            catch
            {
                sock.Dispose();
                throw;
            }
            await Task.Delay(BacklogFullRetryDelay, ct);
        }
    }

    public ValueTask DisposeAsync()
    {
        if (Interlocked.Exchange(ref _disposed, 1) != 0) return ValueTask.CompletedTask;
        try { _listener?.Dispose(); } catch { /* idempotent */ }
        _listener = null;
        if (_listening)
        {
            try { if (File.Exists(_socketPath)) File.Delete(_socketPath); }
            catch (IOException) { /* best effort */ }
        }
        return ValueTask.CompletedTask;
    }

    private void ThrowIfDisposed()
    {
        if (_disposed != 0) throw new ObjectDisposedException(nameof(UnixSocketTransport));
    }
}
