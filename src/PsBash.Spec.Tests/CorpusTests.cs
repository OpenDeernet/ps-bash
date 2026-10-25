using PsBash.Spec;

namespace PsBash.Spec.Tests;

/// <summary>Runs every <c>spec/*.spec.sh</c> case against ps-bash; an XFAIL case that passes is an error (XPASS).</summary>
public class CorpusTests
{
    private static string SpecDir()
    {
        var d = new DirectoryInfo(AppContext.BaseDirectory);
        while (d is not null && !Directory.Exists(Path.Combine(d.FullName, "spec"))) d = d.Parent;
        return d is null ? throw new DirectoryNotFoundException("spec/ not found above " + AppContext.BaseDirectory) : Path.Combine(d.FullName, "spec");
    }

    public static IEnumerable<object[]> Files()
        => Directory.GetFiles(SpecDir(), "*.spec.sh", SearchOption.AllDirectories).OrderBy(p => p)
            .Select(p => new object[] { Path.GetRelativePath(SpecDir(), p).Replace('\\', '/') });

    private static int SpecParallelism()
        => int.TryParse(Environment.GetEnvironmentVariable("PSBASH_SPEC_PAR"), out var n) && n > 0 ? n : 3;

    /// <summary>Appends <c>mode par file cases ms</c> to PSBASH_SPEC_TIMING so runs can be compared.</summary>
    private static void LogTiming(string name, int cases, long ms)
    {
        if (Environment.GetEnvironmentVariable("PSBASH_SPEC_TIMING") is not { Length: > 0 } log) return;
        lock (typeof(CorpusTests))
            File.AppendAllText(log, $"{PsBashExecutor.Mode} par={SpecParallelism()} {name} cases={cases} ms={ms}\n");
    }

    [Theory]
    [MemberData(nameof(Files))]
    public async Task Spec_file_conforms(string name)
    {
        string path = Path.Combine(SpecDir(), name);
        var file = SpecParser.Parse(name, File.ReadAllText(path));
        // Import: PSBASH_SPEC_IMPORT=<oils spec file>, run once with --filter on a (new, empty) spec/oils/NAME.spec.sh.
        if (Environment.GetEnvironmentVariable("PSBASH_SPEC_IMPORT") is { Length: > 0 } src && file.Cases.Count == 0)
        {
            file = SpecImporter.Import(path, File.ReadAllText(src), Path.GetFileName(src));
            File.WriteAllText(path, SpecParser.Format(file));
        }
        bool triage = Environment.GetEnvironmentVariable("PSBASH_SPEC_TRIAGE") == "1";
        if (Environment.GetEnvironmentVariable("PSBASH_SPEC_RECORD") == "1")
        {
            // Fill cases that have no expectation yet from real bash (WSL); existing expectations are kept.
            file = await SpecRecorder.RecordAsync(file, new WslBashExecutor(), all: false);
            File.WriteAllText(path, SpecParser.Format(file));
        }
        var sw = System.Diagnostics.Stopwatch.StartNew();
        var results = await SpecRunner.RunAsync(file, new PsBashExecutor(), parallelism: SpecParallelism());
        LogTiming(name, file.Cases.Count, sw.ElapsedMilliseconds);
        if (triage)
        {
            // Mark every failing case as a known gap, and unmark any that now pass, so the file records the true state.
            var marked = file.Cases.Select((c, i) => results[i].Verdict switch
            {
                Verdict.Fail => c with { Xfail = new XfailMark("triage", "differs from bash 5.2 (auto-marked; investigate)") },
                Verdict.XPass => c with { Xfail = null },
                _ => c,
            }).ToList();
            File.WriteAllText(path, SpecParser.Format(file with { Cases = marked }));
            return;
        }
        var bad = results.Where(r => r.Verdict is Verdict.Fail or Verdict.XPass).ToList();
        Assert.True(bad.Count == 0, SpecRunner.Summarize(file, results) + "\n\n" +
            string.Join("\n---\n", bad.Select(b => $"[{b.Verdict}] {b.Diff}")));
    }
}
