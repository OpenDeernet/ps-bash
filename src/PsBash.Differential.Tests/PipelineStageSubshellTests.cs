using PsBash.Differential.Tests.Oracle;
using Xunit;

namespace PsBash.Differential.Tests;

/// <summary>
/// bash runs every stage of a multi-stage pipeline in a subshell, so a compound stage cannot change the
/// parent's variables: <c>{ x=2; } | cat</c> leaves <c>x</c> alone. ps-bash runs the stage in the same
/// runspace, so the emitter scopes it like a <c>( )</c> subshell (<c>EmitCompoundStage</c>).
/// Negative cases first: the leak, in each compound kind and at each position.
/// </summary>
public class PipelineStageSubshellTests
{
    private static readonly TimeSpan Timeout = TimeSpan.FromSeconds(30);

    [SkippableFact]
    public async Task Differential_BraceGroupStage_DoesNotLeakAssignment()
        => await AssertOracle.EqualAsync("x=1; { x=2; echo out; } | cat; echo \"x=$x\"", timeout: Timeout);

    [SkippableFact]
    public async Task Differential_FirstStageBraceGroup_DoesNotLeakAssignment()
        => await AssertOracle.EqualAsync("x=1; { x=2; echo a; echo b; } | sort; echo \"x=$x\"", timeout: Timeout);

    [SkippableFact]
    public async Task Differential_WhileReadStage_DoesNotLeakLoopVariable()
        => await AssertOracle.EqualAsync("y=none; printf 'a\\nb\\n' | while read l; do y=$l; done; echo \"y=$y\"", timeout: Timeout);

    [SkippableFact]
    public async Task Differential_ForLoopStage_DoesNotLeakVariable()
        => await AssertOracle.EqualAsync("n=0; for i in 1 2 3; do n=$i; echo $i; done | cat; echo \"n=$n\"", timeout: Timeout);

    [SkippableFact]
    public async Task Differential_IfStage_DoesNotLeakVariable()
        => await AssertOracle.EqualAsync("z=0; if true; then z=9; echo hit; fi | cat; echo \"z=$z\"", timeout: Timeout);

    [SkippableFact]
    public async Task Differential_BraceGroupStage_StillWritesItsOutputThroughThePipe()
        => await AssertOracle.EqualAsync("{ echo one; echo two; } | grep two", timeout: Timeout);
}
