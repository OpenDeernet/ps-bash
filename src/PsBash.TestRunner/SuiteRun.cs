using System.Diagnostics;
using System.Runtime.CompilerServices;
using System.Text.Json;

namespace PsBash.TestRunner;

/// <summary>
/// The tiered suite (the <c>suite</c> verb).
///
/// Fast pass: every test assembly at once, each in its own runner process (<c>run</c> verb) with
/// xUnit's normal parallelism inside. Commands serialize per process (bash vars and cwd are
/// process-global), so separate processes are where parallelism comes from; `dotnet test -m:1`
/// ran the projects one after another. Longest assembly first, from the last run's wall times.
///
/// Strict pass: only what failed, afterwards, one assembly at a time and single-threaded on a
/// quiet machine. Fails both: a real failure (exit 1). Fails fast, passes strict: contention or
/// isolation trouble in the fast pass, listed so it gets fixed, but not a product failure.
///
/// Args: <c>[--concurrency N] [--out &lt;dir&gt;] [--no-strict] [&lt;test.dll&gt; ...]</c>. Without
/// assemblies it runs every <c>src/*Tests/bin/Debug/net10.0/&lt;project&gt;.dll</c>.
/// </summary>
internal static class SuiteRun
{
    public static int Execute(string[] args)
    {
        int concurrency = Math.Max(1, Environment.ProcessorCount / 2);
        string? outDir = null;
        bool strict = true;
        var assemblies = new List<string>();
        for (int i = 0; i < args.Length; i++)
        {
            switch (args[i])
            {
                case "--concurrency": concurrency = int.Parse(args[++i]); break;
                case "--out": outDir = Path.GetFullPath(args[++i]); break;
                case "--no-strict": strict = false; break;
                default: assemblies.Add(Path.GetFullPath(args[i])); break;
            }
        }

        var repo = FindRepoRoot();
        outDir ??= Path.Combine(repo, ".tman", "runner");
        Directory.CreateDirectory(outDir);
        if (assemblies.Count == 0) assemblies = DiscoverAssemblies(repo);
        if (assemblies.Count == 0) { Console.Error.WriteLine($"no test assemblies under {repo}/src (build first)"); return 2; }

        var sw = Stopwatch.StartNew();
        var ordered = assemblies.OrderByDescending(a => LastWall(outDir, a)).ToList();
        Console.WriteLine($"fast pass: {ordered.Count} assemblies, {concurrency} at a time (logs: {outDir})");
        var running = new StrongBox<int>();
        var cpu = new CpuSampler(() => Volatile.Read(ref running.Value));
        var fast = RunAll(ordered, concurrency, outDir, "fast", only: null, running);
        var fastWall = sw.Elapsed.TotalSeconds;
        var fastCpu = cpu.Stop();
        if (fastCpu is not null)
            File.WriteAllText(Path.Combine(outDir, "cpu.fast.json"), JsonSerializer.Serialize(fastCpu, RunnerJson.Options));

        var strictResults = new Dictionary<string, AssemblyResult?>();
        if (strict)
        {
            foreach (var (asm, result) in fast)
            {
                if (result is not null && result.Failed == 0) continue;
                // A crashed assembly (no results) reruns whole; otherwise only its failures.
                List<string>? only = result is null ? null : result.Tests.Where(t => t.Outcome == Outcome.Failed).Select(t => t.Name).ToList();
                Console.WriteLine($"strict pass: {Path.GetFileName(asm)} ({(only is null ? "whole assembly" : $"{only.Count} failed")})");
                strictResults[asm] = RunOne(asm, outDir, "strict", only, threads: 1);
            }
        }

        var summary = Classify(fast, strictResults, strict);
        Report.PrintSuite(summary, fast, fastCpu, fastWall, sw.Elapsed.TotalSeconds, Console.Out);
        File.WriteAllText(Path.Combine(outDir, "summary.json"), JsonSerializer.Serialize(summary, RunnerJson.Options));
        return summary.RealFailures.Count == 0 && summary.Crashed.Count == 0 ? 0 : 1;
    }

    internal sealed record SuiteSummary(
        List<FailureRecord> RealFailures, List<FailureRecord> FastOnlyFailures, List<string> Crashed, bool StrictRan);

    internal sealed record FailureRecord(string Assembly, string Test, string? FastMessage, string? StrictMessage);

    private static SuiteSummary Classify(
        Dictionary<string, AssemblyResult?> fast, Dictionary<string, AssemblyResult?> strictResults, bool strictRan)
    {
        var real = new List<FailureRecord>();
        var fastOnly = new List<FailureRecord>();
        var crashed = new List<string>();
        foreach (var (asm, result) in fast)
        {
            var name = Path.GetFileName(asm);
            strictResults.TryGetValue(asm, out var rerun);
            if (result is null)
            {
                // Crashed in the fast pass: only a strict rerun that ran clean clears it.
                if (rerun is null) crashed.Add(name);
                else real.AddRange(rerun.Tests.Where(t => t.Outcome == Outcome.Failed).Select(t => new FailureRecord(name, t.Name, null, t.Message)));
                continue;
            }
            foreach (var failed in result.Tests.Where(t => t.Outcome == Outcome.Failed))
            {
                if (!strictRan) { real.Add(new FailureRecord(name, failed.Name, failed.Message, null)); continue; }
                var again = rerun?.Tests.FirstOrDefault(t => t.Name == failed.Name);
                if (rerun is null) crashed.Add($"{name} (strict rerun)");
                else if (again is { Outcome: Outcome.Passed }) fastOnly.Add(new FailureRecord(name, failed.Name, failed.Message, null));
                else real.Add(new FailureRecord(name, failed.Name, failed.Message, again?.Message ?? "not run in the strict pass"));
            }
        }
        return new SuiteSummary(real, fastOnly, crashed.Distinct().ToList(), strictRan);
    }

    private static Dictionary<string, AssemblyResult?> RunAll(
        List<string> assemblies, int concurrency, string outDir, string tier, List<string>? only, StrongBox<int> running)
    {
        var results = new Dictionary<string, AssemblyResult?>();
        using var gate = new SemaphoreSlim(concurrency);
        var tasks = assemblies.Select(async asm =>
        {
            await gate.WaitAsync();
            Interlocked.Increment(ref running.Value);
            try { return (asm, result: await Task.Run(() => RunOne(asm, outDir, tier, only, threads: 0))); }
            finally { Interlocked.Decrement(ref running.Value); gate.Release(); }
        }).ToList();
        foreach (var t in tasks)
        {
            var (asm, result) = t.GetAwaiter().GetResult();
            results[asm] = result;
        }
        return results;
    }

    /// <summary>Run one assembly in a child runner; null when it produced no results (crashed).</summary>
    private static AssemblyResult? RunOne(string assembly, string outDir, string tier, List<string>? only, int threads)
    {
        var stem = Path.GetFileNameWithoutExtension(assembly);
        var json = Path.Combine(outDir, $"{stem}.{tier}.json");
        var log = Path.Combine(outDir, $"{stem}.{tier}.log");
        File.Delete(json);
        var psi = new ProcessStartInfo("dotnet")
        {
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            UseShellExecute = false,
        };
        var dir = Path.GetDirectoryName(assembly)!;
        foreach (var a in new[]
                 {
                     "exec", "--depsfile", Path.Combine(dir, stem + ".deps.json"),
                     "--runtimeconfig", Path.Combine(dir, stem + ".runtimeconfig.json"),
                     typeof(SuiteRun).Assembly.Location, "run", assembly, "--json", json,
                 })
            psi.ArgumentList.Add(a);
        if (only is not null)
        {
            var list = Path.Combine(outDir, $"{stem}.{tier}.only.txt");
            File.WriteAllLines(list, only);
            psi.ArgumentList.Add("--only");
            psi.ArgumentList.Add(list);
        }
        if (threads > 0) { psi.ArgumentList.Add("--threads"); psi.ArgumentList.Add(threads.ToString()); }

        var sw = Stopwatch.StartNew();
        using (var logWriter = new StreamWriter(log))
        using (var p = Process.Start(psi)!)
        {
            var lockObj = new object();
            void Copy(StreamReader r) { string? line; while ((line = r.ReadLine()) is not null) lock (lockObj) logWriter.WriteLine(line); }
            var o = Task.Run(() => Copy(p.StandardOutput));
            var e = Task.Run(() => Copy(p.StandardError));
            p.WaitForExit();
            Task.WaitAll(o, e);
            logWriter.WriteLine($"[runner] exit={p.ExitCode} wall={sw.Elapsed.TotalSeconds:0.0}s");
        }

        if (!File.Exists(json))
        {
            Console.WriteLine($"  {stem} [{tier}]: CRASHED after {sw.Elapsed.TotalSeconds:0}s, no results (log: {log})");
            return null;
        }
        var result = JsonSerializer.Deserialize<AssemblyResult>(File.ReadAllText(json), RunnerJson.Options)!;
        Console.WriteLine($"  {stem} [{tier}]: passed={result.Passed} failed={result.Failed} skipped={result.Skipped} wall={result.WallSeconds:0}s");
        return result;
    }

    private static double LastWall(string outDir, string assembly)
    {
        var json = Path.Combine(outDir, Path.GetFileNameWithoutExtension(assembly) + ".fast.json");
        try { return JsonSerializer.Deserialize<AssemblyResult>(File.ReadAllText(json), RunnerJson.Options)?.WallSeconds ?? 0; }
        catch { return 0; }
    }

    private static List<string> DiscoverAssemblies(string repo)
        => Directory.EnumerateDirectories(Path.Combine(repo, "src"), "*.Tests")
            .Select(d => Path.Combine(d, "bin", "Debug", "net10.0", Path.GetFileName(d) + ".dll"))
            .Where(File.Exists)
            .ToList();

    private static string FindRepoRoot()
    {
        for (var dir = new DirectoryInfo(AppContext.BaseDirectory); dir is not null; dir = dir.Parent)
            if (File.Exists(Path.Combine(dir.FullName, "ps-bash.sln"))) return dir.FullName;
        throw new InvalidOperationException("ps-bash.sln not found above the runner");
    }
}
