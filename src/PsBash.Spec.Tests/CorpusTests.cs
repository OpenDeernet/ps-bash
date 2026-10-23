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
        => Directory.GetFiles(SpecDir(), "*.spec.sh").OrderBy(p => p).Select(p => new object[] { Path.GetFileName(p) });

    [Theory]
    [MemberData(nameof(Files))]
    public async Task Spec_file_conforms(string name)
    {
        string path = Path.Combine(SpecDir(), name);
        var file = SpecParser.Parse(name, File.ReadAllText(path));
        if (Environment.GetEnvironmentVariable("PSBASH_SPEC_RECORD") == "1")
        {
            // Fill cases that have no expectation yet from real bash (WSL); existing expectations are kept.
            file = await SpecRecorder.RecordAsync(file, new WslBashExecutor(), all: false);
            File.WriteAllText(path, SpecParser.Format(file));
        }
        var results = await SpecRunner.RunAsync(file, new PsBashExecutor(), parallelism: 3);
        var bad = results.Where(r => r.Verdict is Verdict.Fail or Verdict.XPass).ToList();
        Assert.True(bad.Count == 0, SpecRunner.Summarize(file, results) + "\n\n" +
            string.Join("\n---\n", bad.Select(b => $"[{b.Verdict}] {b.Diff}")));
    }
}
