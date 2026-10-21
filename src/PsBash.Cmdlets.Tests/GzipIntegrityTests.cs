using System.IO.Compression;
using System.Text;
using Xunit;

namespace PsBash.Cmdlets.Tests;

/// <summary>
/// The trailer-checking fallback used when the runtime's strict gzip validation could not be enabled
/// (imported-module mode: another caller initialised compression first). Hand-written asserts: there is
/// no bash oracle for a .NET runtime switch.
/// </summary>
public class GzipIntegrityTests
{
    private static byte[] Member(string text)
    {
        var ms = new MemoryStream();
        using (var gz = new GZipStream(ms, CompressionLevel.Optimal, leaveOpen: true))
            gz.Write(Encoding.UTF8.GetBytes(text));
        return ms.ToArray();
    }

    private static string Drain(Stream decoder)
    {
        using var reader = new MemoryStream();
        decoder.CopyTo(reader);
        return Encoding.UTF8.GetString(reader.ToArray());
    }

    [Fact]
    public void CheckedDecoder_CompleteMember_DecodesInFull()
    {
        var data = Member(new string('a', 5000));
        using var d = GzipIntegrity.OpenCheckedDecoder(new MemoryStream(data));
        Assert.Equal(new string('a', 5000), Drain(d));
    }

    [Theory]
    [InlineData(1)]
    [InlineData(4)]
    [InlineData(8)]
    public void CheckedDecoder_FooterTruncated_Throws(int removed)
    {
        var data = Member("payload that needs a footer");
        var cut = data[..^removed];
        using var d = GzipIntegrity.OpenCheckedDecoder(new MemoryStream(cut));
        Assert.Throws<InvalidDataException>(() => Drain(d));
    }

    [Fact]
    public void CheckedDecoder_CorruptedFooterCrc_Throws()
    {
        var data = Member("payload that needs a footer");
        data[^8] ^= 0xFF;
        using var d = GzipIntegrity.OpenCheckedDecoder(new MemoryStream(data));
        Assert.Throws<InvalidDataException>(() => Drain(d));
    }

    [Fact]
    public void CheckedDecoder_ConcatenatedMembers_FailClosed()
    {
        var data = Member("first ").Concat(Member("second")).ToArray();
        using var d = GzipIntegrity.OpenCheckedDecoder(new MemoryStream(data));
        Assert.Throws<InvalidDataException>(() => Drain(d));
    }

    [Fact]
    public void OpenDecoder_TruncatedFooter_Throws_WhicheverModeTheProcessIsIn()
    {
        var cut = Member("payload that needs a footer")[..^4];
        using var d = GzipIntegrity.OpenDecoder(new MemoryStream(cut));
        Assert.Throws<InvalidDataException>(() => Drain(d));
    }
}
