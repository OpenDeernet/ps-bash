using PsBash.Shell.Sessions;
using Xunit;

namespace PsBash.Shell.Tests.Sessions;

public sealed class TerminalSessionUnitTests
{
    [Fact]
    public void Scrollback_UnderCapacity_ReturnsEverythingInOrder()
    {
        var sb = new ScrollbackBuffer(8);
        sb.Append("abc"u8);
        sb.Append("de"u8);
        Assert.Equal("abcde"u8.ToArray(), sb.Snapshot());
    }

    [Fact]
    public void Scrollback_Wraps_KeepsTheNewestBytesOldestFirst()
    {
        var sb = new ScrollbackBuffer(5);
        sb.Append("abcd"u8);
        sb.Append("efg"u8);
        Assert.Equal("cdefg"u8.ToArray(), sb.Snapshot());
    }

    [Fact]
    public void Scrollback_SingleAppendLargerThanCapacity_KeepsTheTail()
    {
        var sb = new ScrollbackBuffer(4);
        sb.Append("xy"u8);
        sb.Append("0123456789"u8);
        Assert.Equal("6789"u8.ToArray(), sb.Snapshot());
        sb.Append("A"u8);
        Assert.Equal("789A"u8.ToArray(), sb.Snapshot());
    }

    [Fact]
    public void Scrollback_Empty_IsEmpty() => Assert.Empty(new ScrollbackBuffer(4).Snapshot());

    [Fact]
    public async Task Protocol_RoundTripsFramesIncludingEmptyPayload()
    {
        var ms = new MemoryStream();
        await TerminalProtocol.WriteAsync(ms, TerminalProtocol.Input, "hi\x1b[A"u8.ToArray(), default);
        await TerminalProtocol.WriteAsync(ms, TerminalProtocol.Quit, ReadOnlyMemory<byte>.Empty, default);
        ms.Position = 0;
        var a = await TerminalProtocol.ReadAsync(ms, default);
        var b = await TerminalProtocol.ReadAsync(ms, default);
        Assert.Equal(TerminalProtocol.Input, a!.Value.Type);
        Assert.Equal("hi\x1b[A"u8.ToArray(), a.Value.Payload);
        Assert.Equal(TerminalProtocol.Quit, b!.Value.Type);
        Assert.Empty(b.Value.Payload);
        Assert.Null(await TerminalProtocol.ReadAsync(ms, default));
    }

    [Fact]
    public async Task Protocol_OversizedLength_IsRejectedBeforeAllocating()
    {
        var ms = new MemoryStream(new byte[] { (byte)'I', 0x7f, 0xff, 0xff, 0xff });
        await Assert.ThrowsAsync<InvalidDataException>(() => TerminalProtocol.ReadAsync(ms, default));
    }

    [Fact]
    public async Task Protocol_TruncatedFrame_Throws()
    {
        var ms = new MemoryStream(new byte[] { (byte)'I', 0, 0, 0, 5, 1, 2 });
        await Assert.ThrowsAsync<EndOfStreamException>(() => TerminalProtocol.ReadAsync(ms, default));
    }

    [Fact]
    public void Resize_RoundTripsAndRejectsGarbage()
    {
        Assert.True(TerminalProtocol.TryDecodeResize(TerminalProtocol.EncodeResize(132, 43), out var c, out var r));
        Assert.Equal((132, 43), ((int)c, (int)r));
        Assert.False(TerminalProtocol.TryDecodeResize(new byte[3], out _, out _));
        Assert.False(TerminalProtocol.TryDecodeResize(new byte[4], out _, out _)); // 0x0
        Assert.False(TerminalProtocol.TryDecodeResize(new byte[] { 0xff, 0xff, 0, 1 }, out _, out _)); // > short
    }

    [Fact]
    public void Exit_RoundTripsNegativeAndShortPayloadFallsBackToFailure()
    {
        Assert.Equal(-3, TerminalProtocol.DecodeExit(TerminalProtocol.EncodeExit(-3)));
        Assert.Equal(1, TerminalProtocol.DecodeExit(new byte[2]));
    }

    [Fact]
    public void DetachFilter_CtrlBracketThenD_DetachesAndDropsTheRest()
    {
        var f = new DetachFilter();
        var forwarded = f.Filter(new byte[] { (byte)'a', 0x1d, (byte)'d', (byte)'z' }, out var detach);
        Assert.True(detach);
        Assert.Equal(new byte[] { (byte)'a' }, forwarded);
    }

    [Fact]
    public void DetachFilter_ChordSplitAcrossReads_StillDetaches()
    {
        var f = new DetachFilter();
        Assert.Empty(f.Filter(new byte[] { 0x1d }, out var d1));
        Assert.False(d1);
        f.Filter(new byte[] { (byte)'d' }, out var d2);
        Assert.True(d2);
    }

    [Fact]
    public void DetachFilter_DoubleEscape_SendsOneLiteral_AndOtherKeysPassThrough()
    {
        var f = new DetachFilter();
        Assert.Equal(new byte[] { 0x1d }, f.Filter(new byte[] { 0x1d, 0x1d }, out var d));
        Assert.False(d);
        Assert.Equal(new byte[] { 0x1d, (byte)'x' }, f.Filter(new byte[] { 0x1d, (byte)'x' }, out d));
        Assert.False(d);
    }

    [Fact]
    public void TerminalEndpoint_SitsBesideTheHostSocket_AndOverlongPathFailsClearly()
    {
        Assert.EndsWith("host-a-sbuild-t.sock", TerminalBroker.TerminalEndpointFor(Path.Combine("run", "host-a-sbuild.sock")));
        var tooLong = new string('x', 105) + ".sock";
        Assert.Throws<IOException>(() => TerminalBroker.TerminalEndpointFor(tooLong));
    }
}
