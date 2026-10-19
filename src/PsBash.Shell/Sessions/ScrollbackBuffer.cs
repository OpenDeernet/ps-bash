namespace PsBash.Shell.Sessions;

/// <summary>
/// Fixed-size ring of the most recent terminal output, replayed to a client that attaches. Raw bytes
/// (escape sequences included): replaying them through the client's terminal reproduces the screen
/// as far back as the ring reaches.
/// </summary>
internal sealed class ScrollbackBuffer
{
    private readonly byte[] _ring;
    private long _total; // bytes ever appended
    private readonly object _gate = new();

    public ScrollbackBuffer(int capacity)
    {
        ArgumentOutOfRangeException.ThrowIfLessThan(capacity, 1);
        _ring = new byte[capacity];
    }

    public int Capacity => _ring.Length;

    public void Append(ReadOnlySpan<byte> data)
    {
        lock (_gate)
        {
            // Only the last Capacity bytes can survive; skip the rest without copying.
            if (data.Length > _ring.Length)
            {
                _total += data.Length - _ring.Length;
                data = data[^_ring.Length..];
            }
            int pos = (int)(_total % _ring.Length);
            int first = Math.Min(data.Length, _ring.Length - pos);
            data[..first].CopyTo(_ring.AsSpan(pos));
            data[first..].CopyTo(_ring);
            _total += data.Length;
        }
    }

    /// <summary>The retained output, oldest byte first.</summary>
    public byte[] Snapshot()
    {
        lock (_gate)
        {
            int len = (int)Math.Min(_total, _ring.Length);
            var result = new byte[len];
            int start = _total <= _ring.Length ? 0 : (int)(_total % _ring.Length);
            int first = Math.Min(len, _ring.Length - start);
            _ring.AsSpan(start, first).CopyTo(result);
            _ring.AsSpan(0, len - first).CopyTo(result.AsSpan(first));
            return result;
        }
    }
}
