using System.Buffers.Binary;

namespace PsBash.Shell.Sessions;

/// <summary>
/// Wire format between a terminal client (<c>ps-bash session attach</c>, BeagleTerm, ...) and the
/// session's terminal broker. One AF_UNIX stream, frames of <c>[type:1][length:4 big-endian][payload]</c>.
/// <list type="bullet">
///   <item>client → broker: <c>H</c> hello (flags:1, bit0 = read-only), <c>I</c> input bytes,
///   <c>R</c> resize (cols:2, rows:2 big-endian), <c>Q</c> end the shell</item>
///   <item>broker → client: <c>O</c> output bytes (the first frames after hello replay the scrollback),
///   <c>X</c> the shell exited (exit code:4 big-endian)</item>
/// </list>
/// Detach is just closing the socket; the shell keeps running. Spec: <c>docs/sessions.md</c>.
/// </summary>
internal static class TerminalProtocol
{
    public const byte Hello = (byte)'H';
    public const byte Input = (byte)'I';
    public const byte Resize = (byte)'R';
    /// <summary>client → broker: end the shell (what <c>session stop</c> sends); ignored from read-only clients.</summary>
    public const byte Quit = (byte)'Q';
    public const byte Output = (byte)'O';
    public const byte Exit = (byte)'X';

    public const byte HelloReadOnly = 1;

    /// <summary>Largest payload either side accepts; a longer frame is a protocol violation.</summary>
    public const int MaxPayload = 1 << 20;

    private const int HeaderSize = 5;

    public static async Task WriteAsync(Stream stream, byte type, ReadOnlyMemory<byte> payload, CancellationToken ct)
    {
        if (payload.Length > MaxPayload)
            throw new ArgumentException("terminal frame payload too large", nameof(payload));
        var frame = new byte[HeaderSize + payload.Length];
        frame[0] = type;
        BinaryPrimitives.WriteInt32BigEndian(frame.AsSpan(1, 4), payload.Length);
        payload.CopyTo(frame.AsMemory(HeaderSize));
        await stream.WriteAsync(frame, ct).ConfigureAwait(false);
        await stream.FlushAsync(ct).ConfigureAwait(false);
    }

    /// <summary>One frame, or <c>null</c> on a clean end of stream. Throws <see cref="InvalidDataException"/> on a bad length.</summary>
    public static async Task<(byte Type, byte[] Payload)?> ReadAsync(Stream stream, CancellationToken ct)
    {
        var header = new byte[HeaderSize];
        if (!await ReadFullAsync(stream, header, ct).ConfigureAwait(false)) return null;
        int length = BinaryPrimitives.ReadInt32BigEndian(header.AsSpan(1, 4));
        if (length < 0 || length > MaxPayload)
            throw new InvalidDataException($"terminal frame length {length} out of range");
        var payload = new byte[length];
        if (length > 0 && !await ReadFullAsync(stream, payload, ct).ConfigureAwait(false))
            throw new EndOfStreamException("terminal frame truncated");
        return (header[0], payload);
    }

    public static byte[] EncodeResize(int cols, int rows)
    {
        var p = new byte[4];
        BinaryPrimitives.WriteUInt16BigEndian(p.AsSpan(0, 2), (ushort)Math.Clamp(cols, 1, ushort.MaxValue));
        BinaryPrimitives.WriteUInt16BigEndian(p.AsSpan(2, 2), (ushort)Math.Clamp(rows, 1, ushort.MaxValue));
        return p;
    }

    public static bool TryDecodeResize(ReadOnlySpan<byte> payload, out short cols, out short rows)
    {
        cols = rows = 0;
        if (payload.Length != 4) return false;
        int c = BinaryPrimitives.ReadUInt16BigEndian(payload[..2]);
        int r = BinaryPrimitives.ReadUInt16BigEndian(payload[2..]);
        if (c == 0 || r == 0 || c > short.MaxValue || r > short.MaxValue) return false;
        cols = (short)c;
        rows = (short)r;
        return true;
    }

    public static byte[] EncodeExit(int code)
    {
        var p = new byte[4];
        BinaryPrimitives.WriteInt32BigEndian(p, code);
        return p;
    }

    public static int DecodeExit(ReadOnlySpan<byte> payload)
        => payload.Length == 4 ? BinaryPrimitives.ReadInt32BigEndian(payload) : 1;

    private static async Task<bool> ReadFullAsync(Stream stream, byte[] buffer, CancellationToken ct)
    {
        int read = 0;
        while (read < buffer.Length)
        {
            int n = await stream.ReadAsync(buffer.AsMemory(read), ct).ConfigureAwait(false);
            if (n == 0) return read == 0 ? false : throw new EndOfStreamException("terminal frame truncated");
            read += n;
        }
        return true;
    }
}
