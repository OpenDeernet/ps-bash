using System.Text.Json;
using System.Text.Json.Serialization;

namespace PsBash.TestRunner;

internal enum Outcome { Passed, Failed, Skipped }

/// <param name="Name">xUnit display name: a theory row carries its arguments.</param>
/// <param name="Method">Class.Method, the --only key for a whole test method.</param>
internal sealed record TestRecord(string Name, string Method, Outcome Outcome, double Seconds, string? Message);

/// <summary>One assembly's run, as the <c>run</c> verb writes it with <c>--json</c>.</summary>
internal sealed record AssemblyResult(string Assembly, double WallSeconds, List<TestRecord> Tests, List<string> Errors)
{
    public int Passed => Tests.Count(t => t.Outcome == Outcome.Passed);
    public int Failed => Tests.Count(t => t.Outcome == Outcome.Failed);
    public int Skipped => Tests.Count(t => t.Outcome == Outcome.Skipped);
}

internal static class RunnerJson
{
    public static readonly JsonSerializerOptions Options = new()
    {
        WriteIndented = true,
        Converters = { new JsonStringEnumConverter() },
    };
}
