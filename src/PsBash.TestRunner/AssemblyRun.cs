using System.Collections.Concurrent;
using System.Diagnostics;
using System.Text.Json;
using Xunit.Runners;

namespace PsBash.TestRunner;

/// <summary>
/// One in-process run of one xUnit v2 test assembly (the <c>run</c> verb).
/// Args: <c>&lt;test.dll&gt; [--only &lt;file of test names&gt;] [--threads N] [--json &lt;out&gt;]</c>.
/// <c>--only</c> lines match a test's display name (a theory row) or its Class.Method.
/// Exit 0 only when nothing failed.
/// </summary>
internal static class AssemblyRun
{
    public static int Execute(string[] args)
    {
        if (args.Length == 0) { Console.Error.WriteLine("usage: run <test.dll> [--only <names-file>] [--threads N] [--json <out>]"); return 2; }
        var assembly = Path.GetFullPath(args[0]);
        HashSet<string>? only = null;
        int threads = 0;
        string? jsonPath = null;
        for (int i = 1; i < args.Length; i++)
        {
            switch (args[i])
            {
                case "--only": only = File.ReadAllLines(args[++i]).Where(l => l.Length > 0).ToHashSet(StringComparer.Ordinal); break;
                case "--threads": threads = int.Parse(args[++i]); break;
                case "--json": jsonPath = Path.GetFullPath(args[++i]); break;
                default: Console.Error.WriteLine($"unknown argument {args[i]}"); return 2;
            }
        }

        // `dotnet test` runs a test assembly from its own directory, and tests rely on that
        // (relative fixture paths; run from the repo root, one wrote f.txt there).
        Directory.SetCurrentDirectory(Path.GetDirectoryName(assembly)!);

        var tests = new ConcurrentQueue<TestRecord>();
        var errors = new ConcurrentQueue<string>();
        using var done = new ManualResetEventSlim();
        var sw = Stopwatch.StartNew();

        using var runner = AssemblyRunner.WithoutAppDomain(assembly);
        if (only is not null)
            runner.TestCaseFilter = tc => only.Contains(tc.DisplayName) || only.Contains(MethodName(tc));
        runner.OnTestPassed = info => tests.Enqueue(new TestRecord(
            info.TestDisplayName, $"{info.TypeName}.{info.MethodName}", Outcome.Passed, (double)info.ExecutionTime, null));
        runner.OnTestSkipped = info => tests.Enqueue(new TestRecord(
            info.TestDisplayName, $"{info.TypeName}.{info.MethodName}", Outcome.Skipped, 0, info.SkipReason));
        runner.OnTestFailed = info => tests.Enqueue(new TestRecord(
            info.TestDisplayName, $"{info.TypeName}.{info.MethodName}", Outcome.Failed, (double)info.ExecutionTime,
            Trim(info.ExceptionMessage + "\n" + info.ExceptionStackTrace)));
        runner.OnErrorMessage = info => errors.Enqueue($"{info.MesssageType}: {Trim(info.ExceptionMessage + "\n" + info.ExceptionStackTrace)}");
        runner.OnExecutionComplete = _ => done.Set();

        runner.Start(new AssemblyRunnerStartOptions
        {
            Parallel = true,
            MaxParallelThreads = threads > 0 ? threads : null,
        });
        done.Wait();
        // OnExecutionComplete fires before the runner's own thread is back to Idle, and disposing
        // a busy runner throws. Bounded settle.
        var settleBy = DateTime.UtcNow.AddSeconds(30);
        while (runner.Status != AssemblyRunnerStatus.Idle && DateTime.UtcNow < settleBy) Thread.Sleep(10);

        var result = new AssemblyResult(Path.GetFileName(assembly), sw.Elapsed.TotalSeconds, tests.ToList(), errors.ToList());
        if (jsonPath is not null)
            File.WriteAllText(jsonPath, JsonSerializer.Serialize(result, RunnerJson.Options));
        Report.PrintAssembly(result, Console.Out);
        return result.Failed == 0 && result.Errors.Count == 0 ? 0 : 1;
    }

    private static string MethodName(Xunit.Abstractions.ITestCase tc)
        => tc.TestMethod.TestClass.Class.Name + "." + tc.TestMethod.Method.Name;

    // Enough of a failure to act on without flooding the report: message plus the first frames.
    private static string Trim(string s)
        => string.Join("\n", s.Replace("\r", "").Split('\n').Where(l => l.Trim().Length > 0).Take(12));
}
