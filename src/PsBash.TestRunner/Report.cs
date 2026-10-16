namespace PsBash.TestRunner;

/// <summary>
/// What the runner prints: one line per failure, worst news first, then counts. Built to be read
/// by an agent: the classification decides what to do (fix the code, or fix the isolation).
/// </summary>
internal static class Report
{
    public static void PrintAssembly(AssemblyResult r, TextWriter w)
    {
        foreach (var t in r.Tests.Where(t => t.Outcome == Outcome.Failed))
            w.WriteLine($"FAIL {t.Name}\n{Indent(t.Message)}");
        foreach (var e in r.Errors) w.WriteLine($"ERROR {Indent(e)}");
        var ran = r.Tests.Where(t => t.Outcome != Outcome.Skipped).ToList();
        w.WriteLine($"slowest: {string.Join(", ", ran.OrderByDescending(t => t.Seconds).Take(5).Select(t => $"{t.Name} {t.Seconds:0.0}s"))}");
        w.WriteLine($"{r.Assembly}: passed={r.Passed} failed={r.Failed} skipped={r.Skipped} wall={r.WallSeconds:0.0}s test-time={ran.Sum(t => t.Seconds):0}s");
    }

    public static void PrintSuite(
        SuiteRun.SuiteSummary s, Dictionary<string, AssemblyResult?> fast, double fastWall, double totalWall, TextWriter w)
    {
        w.WriteLine();
        foreach (var c in s.Crashed) w.WriteLine($"CRASHED {c}");
        foreach (var f in s.RealFailures)
            w.WriteLine($"FAIL {f.Assembly} {f.Test}\n{Indent(f.StrictMessage ?? f.FastMessage)}");
        foreach (var f in s.FastOnlyFailures)
            w.WriteLine($"FAST-ONLY {f.Assembly} {f.Test} (failed in the fast pass, passed strict: contention or isolation)\n{Indent(f.FastMessage)}");
        int passed = fast.Values.Sum(r => r?.Passed ?? 0), skipped = fast.Values.Sum(r => r?.Skipped ?? 0);
        w.WriteLine($"suite: passed={passed} failed={s.RealFailures.Count} fast-only={s.FastOnlyFailures.Count} crashed={s.Crashed.Count} " +
                    $"skipped={skipped} fast-pass={fastWall:0}s total={totalWall:0}s{(s.StrictRan ? "" : " (strict pass skipped)")}");
    }

    private static string Indent(string? s)
        => s is null ? "" : string.Join("\n", s.Split('\n').Select(l => "    " + l));
}
