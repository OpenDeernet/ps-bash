using Xunit;
using PsBash.Core.Transpiler;

namespace PsBash.Core.Tests.Transpiler;

/// <summary>
/// <c>false</c> in the Eval context (<c>eval</c>, <c>source</c>) must never throw <c>PsBash.FalseErrexit</c>:
/// the throw escaped the eval cmdlet and killed the whole shell, even for a member of an <c>||</c> list.
/// </summary>
public class EvalContextFalseTests
{
    [Theory]
    [InlineData("false")]
    [InlineData("false || true")]
    [InlineData("false && echo no")]
    [InlineData("set -e; false || true; echo yes")]
    [InlineData("set -e; false; echo after")]
    public void Eval_False_NeverEmitsTheErrexitThrow(string bash)
    {
        var ps = BashTranspiler.Transpile(bash, TranspileContext.Eval);

        Assert.DoesNotContain("PsBash.FalseErrexit", ps);
    }

    [Fact]
    public void Eval_False_StillFlipsTheStatusForAChain()
    {
        var ps = BashTranspiler.Transpile("false || echo caught", TranspileContext.Eval);

        Assert.Contains("$global:LASTEXITCODE = 1", ps);
    }
}
