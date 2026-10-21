using System.Text;
using PsBash.Core.Runtime;
using PsBash.Core.Runtime.Ipc;
using PsBash.Shell.Sessions;
using Xunit;

namespace PsBash.Shell.Tests.Sessions;

/// <summary>
/// A real broker with a real interactive shell on a real PTY: output typed by one client is replayed to the
/// next one after the first detaches, and the shell's exit reaches an attached client. Protocol-level (no
/// tty needed for the test process); ps-bash-specific surface, so there is no bash oracle.
/// </summary>
public sealed class TerminalBrokerEndToEndTests
{
    private static readonly TimeSpan Limit = TimeSpan.FromSeconds(90);

    private static async Task<Stream> ConnectAsync(string socket, byte flags, CancellationToken ct)
    {
        while (true)
        {
            ct.ThrowIfCancellationRequested();
            if (File.Exists(socket))
            {
                try
                {
                    var t = new UnixSocketTransport(socket);
                    var s = await t.ConnectAsync(ct);
                    await TerminalProtocol.WriteAsync(s, TerminalProtocol.Hello, new[] { flags }, ct);
                    await TerminalProtocol.WriteAsync(s, TerminalProtocol.Resize, TerminalProtocol.EncodeResize(100, 30), ct);
                    return s;
                }
                catch (IOException) { }
                catch (System.Net.Sockets.SocketException) { }
            }
            await Task.Delay(100, ct);
        }
    }

    /// <summary>Read output frames until <paramref name="needle"/> appears in what has been received; returns all of it.</summary>
    private static async Task<(string Text, int? Exit)> ReadUntilAsync(Stream s, string? needle, CancellationToken ct)
    {
        var sb = new StringBuilder();
        while (true)
        {
            var f = await TerminalProtocol.ReadAsync(s, ct);
            if (f is null) return (sb.ToString(), null);
            if (f.Value.Type == TerminalProtocol.Output) sb.Append(Encoding.UTF8.GetString(f.Value.Payload));
            if (f.Value.Type == TerminalProtocol.Exit) return (sb.ToString(), TerminalProtocol.DecodeExit(f.Value.Payload));
            if (needle is not null && sb.ToString().Contains(needle, StringComparison.Ordinal)) return (sb.ToString(), null);
        }
    }

    [SkippableFact]
    public async Task ShellOutputSurvivesDetach_IsReplayedToTheNextClient_AndExitIsReported()
    {
        var host = Path.Combine(AppContext.BaseDirectory, IpcWorker.GetHostBinaryName());
        Skip.IfNot(File.Exists(host), "ps-bash-host is not next to the test binary");

        var socket = Path.Combine(PsBashRuntimeDirectory.GetPath(), $"t-{Guid.NewGuid():N}"[..12] + ".sock");
        Directory.CreateDirectory(Path.GetDirectoryName(socket)!);
        using var cts = new CancellationTokenSource(Limit);
        var broker = TerminalBroker.ServeAsync(host, socket, idleSecs: 600, cts.Token);
        try
        {
            await using (var first = await ConnectAsync(socket, 0, cts.Token))
            {
                await TerminalProtocol.WriteAsync(first, TerminalProtocol.Input, Encoding.UTF8.GetBytes("echo marker-$((6*7))\r"), cts.Token);
                var (text, _) = await ReadUntilAsync(first, "marker-42", cts.Token);
                Assert.Contains("marker-42", text);
            } // detach: the shell must keep running

            await using var second = await ConnectAsync(socket, 0, cts.Token);
            var (replay, _) = await ReadUntilAsync(second, "marker-42", cts.Token);
            Assert.Contains("marker-42", replay);

            await TerminalProtocol.WriteAsync(second, TerminalProtocol.Input, Encoding.UTF8.GetBytes("exit 7\r"), cts.Token);
            var (_, exit) = await ReadUntilAsync(second, null, cts.Token);
            Assert.Equal(7, exit);
            Assert.Equal(7, await broker.WaitAsync(TimeSpan.FromSeconds(30)));
        }
        finally
        {
            cts.Cancel();
            try { await broker.WaitAsync(TimeSpan.FromSeconds(10)); } catch { }
            try { File.Delete(socket); } catch { }
        }
    }

    [SkippableFact]
    public async Task ReadOnlyClient_CannotTypeIntoTheShell()
    {
        var host = Path.Combine(AppContext.BaseDirectory, IpcWorker.GetHostBinaryName());
        Skip.IfNot(File.Exists(host), "ps-bash-host is not next to the test binary");

        var socket = Path.Combine(PsBashRuntimeDirectory.GetPath(), $"t-{Guid.NewGuid():N}"[..12] + ".sock");
        Directory.CreateDirectory(Path.GetDirectoryName(socket)!);
        using var cts = new CancellationTokenSource(Limit);
        var broker = TerminalBroker.ServeAsync(host, socket, idleSecs: 600, cts.Token);
        try
        {
            await using var writer = await ConnectAsync(socket, 0, cts.Token);
            await using var watcher = await ConnectAsync(socket, TerminalProtocol.HelloReadOnly, cts.Token);
            // The watcher's attempt to run a command must be ignored; the writer's must not.
            await TerminalProtocol.WriteAsync(watcher, TerminalProtocol.Input, Encoding.UTF8.GetBytes("echo from-watcher\r"), cts.Token);
            await TerminalProtocol.WriteAsync(writer, TerminalProtocol.Input, Encoding.UTF8.GetBytes("echo from-writer\r"), cts.Token);
            var (text, _) = await ReadUntilAsync(watcher, "from-writer", cts.Token);
            // The typed text echoes once for the writer's command; the watcher's was never sent to the shell.
            Assert.DoesNotContain("from-watcher", text);
        }
        finally
        {
            cts.Cancel();
            try { await broker.WaitAsync(TimeSpan.FromSeconds(10)); } catch { }
            try { File.Delete(socket); } catch { }
        }
    }

    [SkippableFact]
    public async Task ConcurrentServe_DoesNotReplaceTheRunningBrokersEndpointOrShell()
    {
        var host = Path.Combine(AppContext.BaseDirectory, IpcWorker.GetHostBinaryName());
        Skip.IfNot(File.Exists(host), "ps-bash-host is not next to the test binary");
        var socket = Path.Combine(PsBashRuntimeDirectory.GetPath(), $"t-{Guid.NewGuid():N}"[..12] + ".sock");
        using var cts = new CancellationTokenSource(Limit);
        var original = TerminalBroker.ServeAsync(host, socket, idleSecs: 600, cts.Token);
        try
        {
            await using var first = await ConnectAsync(socket, 0, cts.Token);
            Assert.Equal(0, await TerminalBroker.ServeAsync(host, socket, idleSecs: 600, cts.Token)
                .WaitAsync(TimeSpan.FromSeconds(5)));
            // Discovery must still reach the original shell after the losing serve returns.
            await using var second = await ConnectAsync(socket, 0, cts.Token);
            await TerminalProtocol.WriteAsync(first, TerminalProtocol.Input, "echo sole-owner-$((6*7))\r"u8.ToArray(), cts.Token);
            var (text, _) = await ReadUntilAsync(second, "sole-owner-42", cts.Token);
            Assert.Contains("sole-owner-42", text);
            await TerminalProtocol.WriteAsync(first, TerminalProtocol.Input, "exit 0\r"u8.ToArray(), cts.Token);
            Assert.Equal(0, await original.WaitAsync(TimeSpan.FromSeconds(30)));
        }
        finally
        {
            cts.Cancel();
            try { await original.WaitAsync(TimeSpan.FromSeconds(10)); } catch { }
        }
    }
}
