namespace PsBash.Spec;

/// <summary>Fills a spec file's expectations from the oracle (docs/specs/spec-suite.md section 2: never hand-written).</summary>
public static class SpecRecorder
{
    /// <summary>Re-records every case lacking an expectation (or every case when <paramref name="all"/>), keeping annotations.</summary>
    public static async Task<SpecFile> RecordAsync(SpecFile file, IScriptExecutor oracle, bool all, int parallelism = 4, CancellationToken cancel = default)
    {
        using var gate = new SemaphoreSlim(Math.Max(1, parallelism));
        var cases = await Task.WhenAll(file.Cases.Select(async c =>
        {
            bool has = c.Primary.Stdout is not null || c.Primary.Status is not null;
            if (has && !all) return c;
            await gate.WaitAsync(cancel);
            try
            {
                var r = await oracle.RunAsync(c.Script, c.Timeout ?? SpecRunner.DefaultTimeout, cancel);
                return c with { Primary = new Expectation(SpecRunner.Normalize(r.Stdout), r.ExitCode) };
            }
            finally { gate.Release(); }
        }));
        return file with { Cases = cases };
    }
}
