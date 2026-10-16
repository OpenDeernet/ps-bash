using System.Net.Sockets;
using PsBash.Core.Runtime.Ipc;
using Xunit;

namespace PsBash.Core.Tests.Runtime.Ipc;

/// <summary>
/// A burst of concurrent launchers can fill the host's accept queue. A Unix-socket connect to a
/// full queue fails AT ONCE with EAGAIN instead of waiting, which surfaced as exit 125 ("host
/// communication failed: Resource temporarily unavailable") for 1 of 30 parallel `ps-bash -c`.
/// Oracle note (Directive 1): no bash oracle — ps-bash IPC surface.
/// </summary>
public class UnixSocketBacklogTests
{
    [SkippableFact]
    public async Task Connect_ToAFullAcceptQueue_WaitsForTheHostToDrainIt()
    {
        Skip.If(OperatingSystem.IsWindows(), "EAGAIN on a full queue is Unix-socket behaviour");
        var path = Path.Combine(Path.GetTempPath(), $"psb-backlog-{Guid.NewGuid():N}.sock");
        using var listener = new Socket(AddressFamily.Unix, SocketType.Stream, ProtocolType.Unspecified);
        listener.Bind(new UnixDomainSocketEndPoint(path));
        listener.Listen(backlog: 1);
        var queued = new List<Socket>();
        try
        {
            // Fill the queue until the kernel refuses with EAGAIN.
            while (true)
            {
                var s = new Socket(AddressFamily.Unix, SocketType.Stream, ProtocolType.Unspecified) { Blocking = false };
                try { s.Connect(new UnixDomainSocketEndPoint(path)); queued.Add(s); }
                catch (SocketException ex) when (ex.SocketErrorCode is SocketError.WouldBlock or SocketError.TryAgain) { s.Dispose(); break; }
                Assert.True(queued.Count < 64, "the kernel never reported a full accept queue");
            }

            await using var transport = new UnixSocketTransport(path);
            var connect = transport.ConnectAsync();
            // The host starts draining a little later, as a busy accept loop does.
            await Task.Delay(200);
            Assert.False(connect.IsCompleted, "connect must wait for the queue, not fail or pass early");
            foreach (var _ in queued) listener.Accept().Dispose();
            using var accepted = listener.Accept();
            await using var stream = await connect.WaitAsync(TimeSpan.FromSeconds(5));
            Assert.NotNull(stream);
        }
        finally
        {
            foreach (var s in queued) s.Dispose();
            File.Delete(path);
        }
    }
}
