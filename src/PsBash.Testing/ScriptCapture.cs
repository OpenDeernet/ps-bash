using System.Diagnostics;
using System.Text.Json;

namespace PsBash.Testing;

/// <summary>
/// Capture mode (<c>PSBASH_ORACLE_CAPTURE=&lt;file&gt;</c>): instead of running bash and ps-bash, each oracle call appends
/// <c>{class, method, script}</c> as a JSON line and returns. <c>tools/absorb-differential.ps1 -Capture</c> turns the file into spec
/// cases, so scripts built by fixture helpers (<c>Tree</c>, <c>WithArchive</c>, ...) are taken exactly as the test would run them.
/// </summary>
public static class ScriptCapture
{
    private static readonly object Gate = new();

    public static bool TryCapture(string script, bool liveOnly)
    {
        if (Environment.GetEnvironmentVariable("PSBASH_ORACLE_CAPTURE") is not { Length: > 0 } file) return false;
        var (cls, method) = Caller();
        var line = JsonSerializer.Serialize(new { @class = cls, method, script, liveOnly });
        lock (Gate) File.AppendAllText(file, line + "\n");
        return true;
    }

    private static (string Class, string Method) Caller()
    {
        foreach (var frame in new StackTrace().GetFrames())
        {
            var m = frame.GetMethod();
            var t = m?.DeclaringType;
            if (t is null || t.Namespace is null || !t.Namespace.EndsWith(".Tests", StringComparison.Ordinal)) continue;
            // An async test or lambda lives in a compiler-generated type nested in the test class: <Name>d__N, <>c__DisplayClass.
            if (t.Name.StartsWith('<')) { var end = t.Name.IndexOf('>'); if (end > 1) return (t.DeclaringType?.Name ?? t.Name, t.Name[1..end]); continue; }
            if (m!.Name.StartsWith('<') || m.Name == "MoveNext") continue;
            return (t.Name, m.Name);
        }
        return ("Unknown", "Unknown");
    }
}
