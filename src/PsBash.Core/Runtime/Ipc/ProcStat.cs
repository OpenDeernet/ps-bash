using System.Globalization;

namespace PsBash.Core.Runtime.Ipc;

/// <summary>
/// Reads Linux <c>/proc/&lt;pid&gt;/stat</c>: the process state and its start time in clock ticks
/// since boot. The fields are counted from the LAST ')', because the command name in parentheses
/// may itself contain ')' or spaces.
/// </summary>
internal static class ProcStat
{
    /// <summary>Field 3 (state) and field 22 (starttime) of a stat line; false when malformed.</summary>
    public static bool TryParse(string stat, out char state, out long startTime)
    {
        state = default;
        startTime = 0;
        int close = stat.LastIndexOf(')');
        if (close < 0 || close + 2 >= stat.Length) return false;
        var fields = stat[(close + 2)..].Split(' ');
        // fields[0] is field 3 (state), so field 22 (starttime) is fields[19].
        if (fields.Length < 20 || fields[0].Length != 1) return false;
        if (!long.TryParse(fields[19], NumberStyles.None, CultureInfo.InvariantCulture, out startTime)) return false;
        state = fields[0][0];
        return true;
    }

    /// <summary>Reads and parses <c>/proc/&lt;pid&gt;/stat</c>; false when the process is gone or unreadable.</summary>
    public static bool TryRead(int pid, out char state, out long startTime)
    {
        state = default;
        startTime = 0;
        string stat;
        try { stat = File.ReadAllText($"/proc/{pid}/stat"); }
        catch (IOException) { return false; }
        catch (UnauthorizedAccessException) { return false; }
        return TryParse(stat, out state, out startTime);
    }

    /// <summary>Z (zombie) or X (dead): exited, though .NET still reports the pid as running.</summary>
    public static bool IsDead(char state) => state is 'Z' or 'X';
}
