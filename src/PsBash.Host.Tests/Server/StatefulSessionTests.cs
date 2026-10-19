using PsBash.Core.Runtime.Ipc;
using PsBash.Host.Runtime;
using PsBash.Host.Server;
using Xunit;

namespace PsBash.Host.Tests.Server;

/// <summary>
/// A stateful host (durable named session) pins ONE runspace, so state set by one connection is visible
/// to the next; a stateless host gives each connection a fresh runspace. PowerShell state is asserted
/// directly: these tests are about runspace pinning, not bash semantics.
/// </summary>
[Collection("SdkHost")]
public sealed class StatefulSessionTests
{
    private static async Task<(string Output, int Exit)> SendAsync(string socket, string command)
    {
        await using var client = new UnixSocketTransport(socket);
        using var cts = new CancellationTokenSource(TimeSpan.FromSeconds(60));
        using var stream = await client.ConnectAsync(cts.Token);
        await HostProtocol.WriteRequestAsync(stream, new Mode.Command(command), cts.Token);
        var lines = new List<string>();
        var exit = await HostProtocol.ReadResponseAsync(stream, lines.Add, cts.Token);
        return (string.Join("\n", lines), exit);
    }

    private static async Task<(string, string)> RunTwoAsync(bool stateful, string first, string second)
    {
        var socket = TestSockets.New(stateful ? "stateful" : "stateless");
        await using var pool = new WorkerPool<SdkWorker>(warmTarget: 0, max: 2, SdkWorker.Create);
        await using var server = new HostServer(new UnixSocketTransport(socket), pool, stateful: stateful);
        using var cts = new CancellationTokenSource();
        var run = server.RunAsync(cts.Token);
        await server.WhenListening;
        try
        {
            await SendAsync(socket, first);
            return (first, (await SendAsync(socket, second)).Output);
        }
        finally
        {
            cts.Cancel();
            try { await run.WaitAsync(TimeSpan.FromSeconds(3)); } catch { }
        }
    }

    [Fact]
    public async Task Stateful_VariableAndCwdSurviveAcrossConnections()
    {
        var dir = Path.GetTempPath().TrimEnd('\\', '/');
        var (_, output) = await RunTwoAsync(true,
            $"$global:sessVar = 'kept'; Set-Location -LiteralPath '{dir}'",
            "\"$sessVar|$((Get-Location).Path)\"");
        Assert.StartsWith("kept|", output);
        Assert.Contains(Path.GetFileName(dir), output);
    }

    [Fact]
    public async Task Stateless_VariableDoesNotSurviveAcrossConnections()
    {
        var (_, output) = await RunTwoAsync(false, "$global:sessVar = 'leak'", "\"[$sessVar]\"");
        Assert.Equal("[]", output.TrimEnd());
    }

    [Fact]
    public async Task Stateful_FaultedCommandDoesNotEndTheSession()
    {
        var socket = TestSockets.New("fault");
        await using var pool = new WorkerPool<SdkWorker>(warmTarget: 0, max: 2, SdkWorker.Create);
        await using var server = new HostServer(new UnixSocketTransport(socket), pool, stateful: true);
        using var cts = new CancellationTokenSource();
        var run = server.RunAsync(cts.Token);
        await server.WhenListening;
        try
        {
            await SendAsync(socket, "throw 'boom'");
            var (output, exit) = await SendAsync(socket, "'alive'");
            Assert.Equal(0, exit);
            Assert.Contains("alive", output);
        }
        finally
        {
            cts.Cancel();
            try { await run.WaitAsync(TimeSpan.FromSeconds(3)); } catch { }
        }
    }
}
