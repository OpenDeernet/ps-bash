using PsBash.Differential.Tests.Oracle;
using Xunit;

namespace PsBash.Differential.Tests;

/// <summary>
/// <c>let</c> assigned PowerShell variables the emitted <c>$env:</c> reads never saw; <c>${!name}</c> was taken for the
/// array-keys form; <c>eval echo \$$a</c> emitted unparseable PowerShell (a bare <c>echo</c> in an array literal).
/// </summary>
public class LetIndirectEvalTests
{
    [Theory]
    [InlineData("let \"a = 3 * 4\"; echo $a")]
    [InlineData("let a=3*4 b=2; echo $a $b")]
    [InlineData("let a=5; let a++; echo $a")]
    [InlineData("let \"x=0\"; echo rc=$?")]
    [InlineData("let \"x=2\"; echo rc=$?")]
    [InlineData("i=1; let i+=2 \"j=i*2\"; echo $i $j")]
    [InlineData("a=b; b=val; echo ${!a}")]
    [InlineData("a=b; b=val; echo \"[${!a}]\"; x=zz; echo \"[${!x}]\"")]
    [InlineData("a=(p q); echo ${!a[@]}")]
    [InlineData("a=b; b=c; eval echo \\$$a")]
    [InlineData("a=b; b=c; eval echo $a")]
    [InlineData("x=1; eval echo $x \\$x")]
    [InlineData("eval echo a\\ b")]
    public Task Matches_Bash(string script) => AssertOracle.EqualAsync(script);
}
