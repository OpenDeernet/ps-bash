using System;
using System.IO;
using System.IO.Compression;

namespace PsBash.Cmdlets;

/// <summary>
/// Truncated-gzip detection that does not depend on who initialised compression first.
/// .NET's <see cref="GZipStream"/> skips footer (CRC32/ISIZE) validation unless the
/// <c>System.IO.Compression.UseStrictValidation</c> switch is on, and the runtime caches that switch
/// on first use. The standalone host sets it in its runtimeconfig; an imported module cannot, so
/// <see cref="OpenDecoder"/> asks the runtime whether strict mode really took effect and, if not,
/// checks the trailer itself and fails closed.
/// </summary>
internal static class GzipIntegrity
{
    private const string SwitchName = "System.IO.Compression.UseStrictValidation";

    private static readonly Lazy<bool> StrictActive = new(ProbeStrict);

    static GzipIntegrity()
    {
        // Wins only if nothing in this process has touched compression yet; the probe reports the outcome.
        AppContext.SetSwitch(SwitchName, true);
    }

    /// <summary>Decoder for <paramref name="input"/> that rejects a stream missing its footer.</summary>
    public static Stream OpenDecoder(Stream input)
    {
        var gs = new GZipStream(input, CompressionMode.Decompress);
        return StrictActive.Value || !input.CanSeek ? gs : new TrailerCheckingStream(gs, input);
    }

    /// <summary>The trailer-checking decoder regardless of the runtime switch (test seam).</summary>
    internal static Stream OpenCheckedDecoder(Stream input)
        => new TrailerCheckingStream(new GZipStream(input, CompressionMode.Decompress), input);

    private static bool ProbeStrict()
    {
        try
        {
            // A real member with its last four footer bytes removed: strict mode throws, lax mode returns the data.
            var member = new MemoryStream();
            using (var gz = new GZipStream(member, CompressionLevel.Fastest, leaveOpen: true))
                gz.Write("probe"u8);
            member.SetLength(member.Length - 4);
            member.Position = 0;
            using var gs = new GZipStream(member, CompressionMode.Decompress);
            gs.CopyTo(Stream.Null);
            return false;
        }
        catch (InvalidDataException)
        {
            return true;
        }
    }

    /// <summary>
    /// Fallback when strict validation is unavailable: CRC32 and length of everything decoded must match the
    /// last 8 bytes of the file. A multi-member archive cannot match (the footer covers only its last
    /// member), so it is rejected rather than risk accepting a truncated one.
    /// </summary>
    private sealed class TrailerCheckingStream(Stream decoder, Stream source) : Stream
    {
        private static readonly uint[] Table = BuildTable();
        private uint _crc = 0xFFFFFFFF;
        private long _length;
        private bool _verified;

        public override int Read(byte[] buffer, int offset, int count) => Read(buffer.AsSpan(offset, count));

        public override int Read(Span<byte> buffer)
        {
            int n = decoder.Read(buffer);
            if (n > 0)
            {
                uint c = _crc;
                for (int i = 0; i < n; i++) c = Table[(c ^ buffer[i]) & 0xFF] ^ (c >> 8);
                _crc = c;
                _length += n;
            }
            else if (buffer.Length > 0 && !_verified)
            {
                _verified = true;
                VerifyTrailer();
            }
            return n;
        }

        private void VerifyTrailer()
        {
            long saved = source.Position;
            try
            {
                if (source.Length < 18) throw new InvalidDataException("unexpected end of file");
                Span<byte> tail = stackalloc byte[8];
                source.Position = source.Length - 8;
                source.ReadExactly(tail);
                uint crc = BitConverter.ToUInt32(tail[..4]);
                uint isize = BitConverter.ToUInt32(tail[4..]);
                if (crc != ~_crc || isize != (uint)_length)
                    throw new InvalidDataException("unexpected end of file");
            }
            finally { source.Position = saved; }
        }

        private static uint[] BuildTable()
        {
            var t = new uint[256];
            for (uint n = 0; n < 256; n++)
            {
                uint c = n;
                for (int k = 0; k < 8; k++) c = (c & 1) != 0 ? 0xEDB88320 ^ (c >> 1) : c >> 1;
                t[n] = c;
            }
            return t;
        }

        public override bool CanRead => true;
        public override bool CanSeek => false;
        public override bool CanWrite => false;
        public override long Length => throw new NotSupportedException();
        public override long Position { get => throw new NotSupportedException(); set => throw new NotSupportedException(); }
        public override void Flush() { }
        public override long Seek(long offset, SeekOrigin origin) => throw new NotSupportedException();
        public override void SetLength(long value) => throw new NotSupportedException();
        public override void Write(byte[] buffer, int offset, int count) => throw new NotSupportedException();

        protected override void Dispose(bool disposing)
        {
            if (disposing) decoder.Dispose();
            base.Dispose(disposing);
        }
    }
}
