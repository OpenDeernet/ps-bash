namespace PsBash.Shell.Sessions;

/// <summary>
/// Watches the keystrokes a terminal client forwards for the detach chord <c>Ctrl-]</c> then <c>d</c>
/// (<c>Ctrl-]</c> twice sends one literal <c>Ctrl-]</c>). Any other byte after <c>Ctrl-]</c> is forwarded
/// together with it. Stateful across chunks, since the two keys can arrive in separate reads.
/// </summary>
internal sealed class DetachFilter
{
    private const byte Escape = 0x1d; // Ctrl-]
    private bool _pending;

    /// <summary>
    /// Filter one chunk. Returns the bytes to forward; <paramref name="detach"/> is set when the chord
    /// completed (bytes after it in the chunk are dropped).
    /// </summary>
    public byte[] Filter(ReadOnlySpan<byte> input, out bool detach)
    {
        detach = false;
        var output = new List<byte>(input.Length + 1);
        foreach (var b in input)
        {
            if (_pending)
            {
                _pending = false;
                if (b == (byte)'d') { detach = true; break; }
                output.Add(Escape);
                if (b != Escape) output.Add(b);
                continue;
            }
            if (b == Escape) _pending = true;
            else output.Add(b);
        }
        return output.ToArray();
    }
}
