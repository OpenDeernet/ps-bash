using System.Runtime.Loader;

namespace PsBash.TestRunner;

internal static class Program
{
    // `run` executes inside a test assembly's deps.json, which does not list the runner's own
    // dependency (xunit.runner.utility): resolve it from the runner's directory. Registered before
    // any of its types are touched.
    private static int Main(string[] args)
    {
        var runnerDir = Path.GetDirectoryName(typeof(Program).Assembly.Location)!;
        AssemblyLoadContext.Default.Resolving += (ctx, name) =>
        {
            var candidate = Path.Combine(runnerDir, name.Name + ".dll");
            return File.Exists(candidate) ? ctx.LoadFromAssemblyPath(candidate) : null;
        };
        return args.FirstOrDefault() switch
        {
            "run" => AssemblyRun.Execute(args[1..]),
            "suite" => SuiteRun.Execute(args[1..]),
            _ => Usage(),
        };
    }

    private static int Usage()
    {
        Console.Error.WriteLine("usage: PsBash.TestRunner suite [--concurrency N] [--out <dir>] [--no-strict] [<test.dll> ...]");
        Console.Error.WriteLine("       PsBash.TestRunner run <test.dll> [--only <names-file>] [--threads N] [--json <out>]");
        return 2;
    }
}
