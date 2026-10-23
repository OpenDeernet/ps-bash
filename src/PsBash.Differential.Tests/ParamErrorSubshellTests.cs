using PsBash.Differential.Tests.Oracle;
using Xunit;

namespace PsBash.Differential.Tests;

/// <summary><c>${x:?msg}</c> in a subshell threw out of the whole shell; bash ends only the subshell (status 1).</summary>
public class ParamErrorSubshellTests
{
    [Fact]
    public Task Subshell_EndsOnlyTheSubshell() => AssertOracle.EqualAsync(
        "( echo ${x:?missing} ) 2>/dev/null; echo \"after rc=$?\"");

    [Fact]
    public Task Subshell_SetVariable_PassesThrough() => AssertOracle.EqualAsync(
        "z=ok; ( echo ${z:?never} ); echo \"rc=$?\"");

    [Fact]
    public Task Subshell_EmptyAndColonless() => AssertOracle.EqualAsync(
        "e=''; ( echo ${e:?empty} ) 2>/dev/null; echo \"a=$?\"; ( echo [${e?set-but-empty}] ) 2>/dev/null; echo \"b=$?\"; ( echo ${u?unset} ) 2>/dev/null; echo \"c=$?\"");

    [Fact]
    public Task Subshell_OutputBeforeTheError_IsKept() => AssertOracle.EqualAsync(
        "( echo one; echo ${x:?two}; echo three ) 2>/dev/null; echo \"rc=$?\"");
}
