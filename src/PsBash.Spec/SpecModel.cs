namespace PsBash.Spec;

/// <summary>What one run of a case's script produced.</summary>
public sealed record ExecResult(int ExitCode, string Stdout, string Stderr, long WallMs = 0);

/// <summary>An expected outcome. A null member is "not checked" (the Oils convention).</summary>
public sealed record Expectation(string? Stdout, int? Status, string? Stderr = null);

/// <summary>
/// One case of a spec file. <see cref="Primary"/> is the recorded real-bash outcome; <see cref="Alternatives"/>
/// are further acceptable outcomes (<c>## OK bash ...</c>). <see cref="Xfail"/> marks a known ps-bash gap.
/// </summary>
public sealed record SpecCase(
    string Name,
    string Script,
    Expectation Primary,
    IReadOnlyList<Expectation> Alternatives,
    XfailMark? Xfail,
    TimeSpan? Timeout,
    bool RealLauncher);

/// <summary><c>## XFAIL ps-bash &lt;id&gt; &lt;reason&gt;</c>: <see cref="Id"/> names a heading in intentional-differences.md or a GAP row.</summary>
public sealed record XfailMark(string Id, string Reason);

/// <summary>A parsed spec file: free header text plus its cases.</summary>
public sealed record SpecFile(string Path, string Header, IReadOnlyList<SpecCase> Cases);

public enum Verdict { Pass, Fail, XFail, XPass }

public sealed record CaseResult(SpecCase Case, Verdict Verdict, ExecResult? Actual, string? Diff);
