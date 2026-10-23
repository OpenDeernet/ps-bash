using PsBash.Differential.Tests.Oracle;
using Xunit;

namespace PsBash.Differential.Tests;

/// <summary>
/// errexit inside <c>eval</c> / <c>source</c>. Both transpile in the Eval context, where a bare <c>false</c> under
/// <c>set -e</c> threw <c>PsBash.FalseErrexit</c> even as a member of an <c>&amp;&amp;</c>/<c>||</c> list, which bash
/// exempts: the throw escaped as an unhandled error and killed the whole shell ("ps-bash: PsBash.FalseErrexit").
/// A bare <c>false</c> under a caller's <c>set -e</c> no longer throws either; eval'd code runs without per-statement\n/// checks (docs/specs/intentional-differences.md), so it is not compared with bash here.
/// </summary>
public class ErrexitEvalSourceTests
{
    private static readonly TimeSpan Limit = TimeSpan.FromSeconds(60);

    [SkippableFact]
    public Task Eval_FalseOrTrue_UnderErrexit_IsExemptAndContinues()
        => AssertOracle.EqualAsync("( set -e; eval 'false || true; echo yes' ); echo \"rc=$?\"", timeout: Limit);

    [SkippableFact]
    public Task Eval_FalseAndAnything_UnderErrexit_IsExemptAndContinues()
        => AssertOracle.EqualAsync("( set -e; eval 'false && echo no; echo yes' ); echo \"rc=$?\"", timeout: Limit);

    [SkippableFact]
    public Task Eval_IfFalse_UnderErrexit_IsExempt()
        => AssertOracle.EqualAsync("( set -e; eval 'if false; then echo no; fi; echo yes' ); echo \"rc=$?\"", timeout: Limit);

    [SkippableFact]
    public Task Source_FileWithSetEFalseOrTrue_DoesNotEscapeTheShell()
        => AssertOracle.EqualAsync(
            "d=$(mktemp -d); echo '( set -e; false || true; echo yes )' > $d/f.sh; . $d/f.sh; echo \"after rc=$?\"",
            timeout: Limit);
}
