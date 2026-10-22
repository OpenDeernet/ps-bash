using PsBash.Core.Runtime.Ipc;
using PsBash.Host.Server;
using Xunit;

namespace PsBash.Host.Tests.Server;

public sealed class LauncherStdinFeedTests
{
    [Fact]
    public async Task Pump_DrainsPastTheMemoryBound_SoPeerEofIsStillSeen_AndOrderSurvivesTheSpill()
    {
        // A command that never reads stdin must not park the pump: a parked pump cannot see the
        // launcher disconnect. 200 x 48 KiB is well past MaxMemoryBytes and nobody consumes it here.
        const int chunks = 200;
        var wire = new MemoryStream();
        for (int i = 0; i < chunks; i++)
        {
            var line = new byte[HostProtocol.MaxStdinChunkBytes];
            Array.Fill(line, (byte)'a', 0, line.Length - 1);
            line[^1] = (byte)'\n';
            await HostProtocol.WriteStdinFrameAsync(wire, line);
        }
        wire.Position = 0; // no EOF marker: the peer simply closes

        using var feed = new LauncherStdinFeed(CancellationToken.None);
        bool peerGone = await feed.PumpAsync(wire, CancellationToken.None).WaitAsync(TimeSpan.FromSeconds(30));
        Assert.True(peerGone);

        var cursor = feed.CreateCursor();
        int records = 0;
        while (cursor.TryDequeue(CancellationToken.None, out _)) records++;
        Assert.Equal(chunks, records);
    }
}
