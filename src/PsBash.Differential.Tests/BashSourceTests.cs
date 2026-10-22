using PsBash.Testing;
using Xunit;

namespace PsBash.Differential.Tests;

/// <summary>
/// BASH_SOURCE: scripts find their own directory with <c>${BASH_SOURCE[0]}</c> and source siblings from it.
/// Hand-written asserts (expected values checked against Ubuntu bash): the oracle fixture's script path differs
/// between bash and ps-bash, so the assertions compare BASH_SOURCE with $0 and the file layout rather than a path.
/// </summary>
public class BashSourceTests
{
    /// <summary>Runs <paramref name="script"/> as a FILE (<c>ps-bash script.sh</c>): BASH_SOURCE is empty under <c>-c</c>.</summary>
    private static async Task<SpawnResult> RunAsync(string script, PsBashMode mode = PsBashMode.M3_FileArg)
    {
        var runner = PsBashRunner.Create().WithTimeout(60).WithMode(mode);
        Skip.If(runner.TryResolveBinary() is null, "ps-bash binary not found -- build PsBash.Shell first");
        return await runner.RunScriptAsync(script);
    }

    [SkippableFact]
    public async Task BashSource_UnderDashC_IsEmptyAsInBash()
    {
        var r = await RunAsync("echo \"n=${#BASH_SOURCE[@]} [${BASH_SOURCE[0]}] fb=[${BASH_SOURCE[0]:-$0}]\"", PsBashMode.M1_CFlag);
        Assert.Equal("n=0 [] fb=[bash]\n", r.Stdout.Replace("\r\n", "\n"));
    }

    [SkippableFact]
    public async Task BashSource_InAScript_IsTheScriptItself()
    {
        var r = await RunAsync(
            "echo \"n=${#BASH_SOURCE[@]}\"; [ \"${BASH_SOURCE[0]}\" = \"$0\" ] && echo same || echo different");
        Assert.Equal("n=1\nsame\n", r.Stdout.Replace("\r\n", "\n"));
    }

    [SkippableFact]
    public async Task BashSource_OwnDirectoryIdiom_LetsAScriptSourceItsSibling()
    {
        var r = await RunAsync(
            "DIR=\"$(cd \"$(dirname \"${BASH_SOURCE[0]}\")\" && pwd)\"\n" +
            "printf 'echo \"in-lib n=${#BASH_SOURCE[@]}\"\\n[ \"${BASH_SOURCE[1]}\" = \"$0\" ] && echo caller-ok\\n' > \"$DIR/psb-lib-$$.sh\"\n" +
            "source \"$DIR/psb-lib-$$.sh\"; rc=$?; rm -f \"$DIR/psb-lib-$$.sh\"\n" +
            "echo \"rc=$rc after n=${#BASH_SOURCE[@]}\"");
        Assert.Equal("in-lib n=2\ncaller-ok\nrc=0 after n=1\n", r.Stdout.Replace("\r\n", "\n"));
        Assert.Equal("", r.Stderr);
    }

    [SkippableFact]
    public async Task BashSource_FallbackToZero_StillGivesTheScript()
    {
        var r = await RunAsync("[ \"${BASH_SOURCE[0]:-$0}\" = \"$0\" ] && echo ok");
        Assert.Equal("ok\n", r.Stdout.Replace("\r\n", "\n"));
    }
}
