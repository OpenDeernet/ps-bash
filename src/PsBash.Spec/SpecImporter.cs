namespace PsBash.Spec;

/// <summary>
/// Turns an Oils/OSH spec-test file into ps-bash cases (docs/specs/spec-suite.md section 7, Oils import). Only the case names
/// and scripts are taken: the Oils expectations are for bash 4.4 or other shells, so they are discarded and re-recorded from the
/// bash 5.2 oracle like every other case. A case that runs another shell, or uses the Oils harness, cannot run unchanged and is left out.
/// </summary>
public static class SpecImporter
{
    private static readonly string[] HarnessMarkers =
    [
        "$SH", "${SH}", "$REPO_ROOT", "$TMP", "$(dirname", "$[", "spec/testdata", "$ASAN", "bin/osh", "oils-for-unix", "ysh", "$[",
        "shopt -s ysh", "\\$SH", "test/spec",
    ];

    public static SpecFile Import(string path, string text, string sourceName)
    {
        var parsed = SpecParser.Parse(path, text);
        var cases = parsed.Cases
            .Where(c => !HarnessMarkers.Any(m => c.Script.Contains(m, StringComparison.Ordinal)))
            .Select(c => c with { Primary = new Expectation(null, null, null), Alternatives = Array.Empty<Expectation>(), Xfail = null, Timeout = c.Timeout ?? TimeSpan.FromSeconds(10) })
            .ToList();
        string header = $"## Imported from the Oils spec tests ({sourceName}, Apache-2.0, https://github.com/oils-for-unix/oils).\n"
                      + "## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.\n"
                      + "## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.\n";
        return new SpecFile(path, header, cases);
    }
}
