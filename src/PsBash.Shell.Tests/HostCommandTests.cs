using PsBash.Core.Runtime.Ipc;
using Xunit;

namespace PsBash.Shell.Tests;

public sealed class HostCommandTests
{
    [Fact]
    public void BuildStatusLines_WhenCompactOutputEnabled_CollapsesMetadata()
    {
        var meta = new HostMetadata(
            Pid: 1234,
            ExecutablePath: @"C:\tools\ps-bash-host.exe",
            ProtocolVersion: 1,
            BuildIdentity: "test-build",
            TransportScheme: "unix",
            Endpoint: "/tmp/psbash-test.sock",
            StartedAt: DateTimeOffset.Parse("2026-05-28T20:00:00Z"),
            Owner: "andy");
        var health = new[] { "health: ok", "runspace: ready" };

        var verbose = HostCommands.BuildStatusLines("unix", "/tmp/psbash-test.sock", meta, 0, health, compactOutput: false);
        var compact = HostCommands.BuildStatusLines("unix", "/tmp/psbash-test.sock", meta, 0, health, compactOutput: true);

        Assert.True(compact.Count < verbose.Count);
        Assert.True(string.Join('\n', compact).Length < string.Join('\n', verbose).Length);
        Assert.Single(compact);
        Assert.Contains("status: running", compact[0]);
        Assert.Contains("endpoint=unix:/tmp/psbash-test.sock", compact[0]);
        Assert.Contains("pid=1234", compact[0]);
        Assert.Contains("protocol=1", compact[0]);
        Assert.Contains("health=\"health: ok | runspace: ready\"", compact[0]);
    }

    [Fact]
    public void BuildStatusLines_WhenStoppedAndCompactOutputEnabled_PreservesState()
    {
        var compact = HostCommands.BuildStatusLines(
            "unix",
            "/tmp/psbash-test.sock",
            meta: null,
            exitCode: null,
            healthLines: [],
            compactOutput: true);

        Assert.Equal(
            "ps-bash-host status: stopped endpoint=unix:/tmp/psbash-test.sock metadata=absent",
            compact.Single());
    }

    [Fact]
    public async Task ControlRequest_WhenHostClosesDuringResponse_ReturnsUnavailableWithoutThrowing()
    {
        // macOS limits an AF_UNIX path to 104 chars and $TMPDIR already takes ~49, so the
        // name carries only 8 hex digits of a guid. Collision risk in a single run is negligible.
        var sockDir = Path.Combine(Path.GetTempPath(), "ps-bash");
        Directory.CreateDirectory(sockDir);
        var endpoint = "unix:" + Path.Combine(sockDir, $"abrupt-{Guid.NewGuid().ToString("N")[..8]}.sock");
        await using var transport = IpcTransportFactory.CreateDefault(endpoint);
        await transport.ListenAsync();

        // Pass a cancellation token to AcceptAsync / ReadRequestAsync so the
        // server task can be aborted cleanly. Under Windows CI load the
        // client's 750ms connect timeout (HostCommands.SendControlRequestAsync)
        // can fire before the server task has even called WaitForConnectionAsync,
        // leaving the server stuck waiting for a client that already gave up.
        // Cancelling at test end unwinds that state deterministically so the
        // final WaitAsync never times out.
        using var serverCts = new CancellationTokenSource();
        var serverTask = Task.Run(async () =>
        {
            try
            {
                await using var stream = await transport.AcceptAsync(serverCts.Token);
                _ = await HostProtocol.ReadRequestAsync(stream, serverCts.Token);
            }
            catch (OperationCanceledException) { /* expected when client aborts before/after connect */ }
            catch (IOException) { /* expected: client closed without sending a full request */ }
        });

        var (exitCode, lines) = await HostCommands.SendControlRequestAsync(
            new Mode.Health(),
            CancellationToken.None,
            endpoint);

        Assert.Null(exitCode);
        Assert.Empty(lines);
        serverCts.Cancel();
        await serverTask.WaitAsync(TimeSpan.FromSeconds(5));
    }
}
