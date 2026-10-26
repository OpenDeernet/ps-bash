namespace PsBash.Spec;

/// <summary>
/// Turns an Oils/OSH spec-test file into ps-bash cases (docs/specs/spec-suite.md section 7, Oils import). Only the case names
/// and scripts are taken: the Oils expectations are for bash 4.4 or other shells, so they are discarded and re-recorded from the
/// bash 5.2 oracle like every other case. A case that runs another shell, or uses the Oils harness, cannot run unchanged and is left out.
/// </summary>
public static class SpecImporter
{
    // Harness features with no stand-in here: they stay out. `$SH` is NOT one of them: the executors define it
    // (bash for the oracle, the launcher under test for ps-bash), and such a case is marked `## real-launcher`.
    private static readonly string[] HarnessMarkers =
    [
        "$REPO_ROOT", "$TMP", "$(dirname", "$[", "spec/testdata", "$ASAN", "bin/osh", "oils-for-unix", "ysh",
        "shopt -s ysh", "test/spec",
    ];

    /// <summary>True when the script runs "the shell under test" through the Oils <c>$SH</c> variable.</summary>
    public static bool UsesShellVariable(string script)
        => script.Contains("$SH", StringComparison.Ordinal) || script.Contains("${SH}", StringComparison.Ordinal);

    public static SpecFile Import(string path, string text, string sourceName)
    {
        var parsed = SpecParser.Parse(path, text);
        var cases = parsed.Cases
            .Where(c => !HarnessMarkers.Any(m => c.Script.Contains(m, StringComparison.Ordinal)))
            .Select(c => c with
            {
                Primary = new Expectation(null, null, null), Alternatives = Array.Empty<Expectation>(), Xfail = null,
                Timeout = c.Timeout ?? TimeSpan.FromSeconds(10), RealLauncher = UsesShellVariable(c.Script),
            })
            .ToList();
        string header = $"## Imported from the Oils spec tests ({sourceName}, Apache-2.0, https://github.com/oils-for-unix/oils).\n"
                      + "## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.\n"
                      + "## Cases needing the rest of the Oils harness ($REPO_ROOT, ysh, ...) are omitted; `$SH` cases run on the real launcher.\n";
        return new SpecFile(path, header, cases);
    }

    /// <summary>Adds the imported cases whose name the existing file does not have yet; existing cases (and their recorded expectations) are kept.</summary>
    public static SpecFile Merge(SpecFile existing, SpecFile imported)
    {
        var have = new HashSet<string>(existing.Cases.Select(c => c.Name), StringComparer.Ordinal);
        var added = imported.Cases.Where(c => have.Add(c.Name)).ToList();
        return added.Count == 0 ? existing : existing with { Cases = [.. existing.Cases, .. added] };
    }
}
