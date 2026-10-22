using PsBash.Testing;
using Xunit;

namespace PsBash.Differential.Tests;

/// <summary>
/// <c>exec N&lt;file</c> and friends (docs/specs/shell-fds-and-bash-source.md). Hand-written asserts, expected values
/// taken from Ubuntu bash running the same scripts: stderr text differs by the "script: line N:" prefix, so the
/// negative cases assert the status and the message body, not the whole line.
/// </summary>
public class ExecFdTests
{
    private static async Task<SpawnResult> RunAsync(string script)
    {
        var runner = PsBashRunner.Create().WithTimeout(60).WithMode(PsBashMode.M3_FileArg);
        Skip.If(runner.TryResolveBinary() is null, "ps-bash binary not found -- build PsBash.Shell first");
        return await runner.RunScriptAsync(script);
    }

    private const string Work = "W=\"$(mktemp -d)\"; cd \"$W\"; ";

    [SkippableFact]
    public async Task ExecRead_ReadUReadsLinesInOrder_ThenCatGetsTheRest()
    {
        var r = await RunAsync(Work +
            "printf 'one\\ntwo\\nthree\\n' > data.txt; exec 7< data.txt; read -u 7 a; read -u 7 b; echo \"a=$a b=$b\"; cat <&7; " +
            "exec 7<&-; cd /; rm -rf \"$W\"");
        Assert.Equal("a=one b=two\nthree\n", r.Stdout.Replace("\r\n", "\n"));
        Assert.Equal(0, r.ExitCode);
    }

    [SkippableFact]
    public async Task ExecRead_AtEndOfFile_ReadFailsWithStatus1()
    {
        var r = await RunAsync(Work +
            "printf 'x\\n' > d; exec 6< d; read -u 6 l; read -u 6 l2; echo \"rc=$? l=$l l2=[$l2]\"; exec 6<&-; cd /; rm -rf \"$W\"");
        Assert.Equal("rc=1 l=x l2=[]\n", r.Stdout.Replace("\r\n", "\n"));
    }

    [SkippableFact]
    public async Task ExecRead_AfterClose_IsBadFileDescriptor()
    {
        var r = await RunAsync(Work +
            "printf 'x\\n' > d; exec 6< d; exec 6<&-; read -u 6 l 2>/dev/null; echo \"rc=$?\"; cd /; rm -rf \"$W\"");
        Assert.Equal("rc=1\n", r.Stdout.Replace("\r\n", "\n"));
    }

    [SkippableFact]
    public async Task ExecWrite_RedirectToTheDescriptor_CreatesThenAppends()
    {
        var r = await RunAsync(Work +
            "exec 8> out.txt; echo via8 >&8; echo more >&8; exec 8>&-; cat out.txt; " +
            "exec 9>> out.txt; echo appended >&9; exec 9>&-; cat out.txt; cd /; rm -rf \"$W\"");
        Assert.Equal("via8\nmore\nvia8\nmore\nappended\n", r.Stdout.Replace("\r\n", "\n"));
    }

    [SkippableFact]
    public async Task ExecDupOfStdout_RedirectToTheDuplicateStillReachesStdout()
    {
        // The `exec 3>&1` + `>&3` logging idiom (dotnet-install.sh).
        var r = await RunAsync("exec 3>&1; echo to-three >&3; echo plain; exec 3>&-");
        Assert.Equal("to-three\nplain\n", r.Stdout.Replace("\r\n", "\n"));
    }

    [SkippableFact]
    public async Task ExecDupOfStderr_RedirectToTheDuplicateReachesStderr()
    {
        var r = await RunAsync("exec 4>&2; echo to-err >&4; echo out; exec 4>&-");
        Assert.Equal("out\n", r.Stdout.Replace("\r\n", "\n"));
        Assert.Equal("to-err", r.Stderr.Trim());
    }

    [SkippableFact]
    public async Task ExecWrite_ToADescriptorThatIsNotOpen_IsBadFileDescriptor()
    {
        var r = await RunAsync("echo lost >&5; echo \"rc=$?\"");
        Assert.DoesNotContain("lost", r.Stdout);
        Assert.Contains("Bad file descriptor", r.Stderr);
    }

    [SkippableFact]
    public async Task ExecOpen_MissingFile_FailsWithStatus1AndTheScriptContinues()
    {
        var r = await RunAsync("exec 3< /definitely/not/here; echo \"rc=$?\"");
        Assert.Equal("rc=1\n", r.Stdout.Replace("\r\n", "\n"));
        Assert.Contains("No such file or directory", r.Stderr);
    }

    [SkippableFact]
    public async Task ExecCommand_RunsItThenLeavesTheShell()
    {
        var r = await RunAsync("exec printf 'bye\\n'; echo notreached");
        Assert.Equal("bye\n", r.Stdout.Replace("\r\n", "\n"));
        Assert.Equal(0, r.ExitCode);
    }

    [SkippableFact]
    public async Task ExecCommand_PropagatesItsExitStatus()
    {
        var r = await RunAsync("exec false; echo notreached");
        Assert.DoesNotContain("notreached", r.Stdout);
        Assert.Equal(1, r.ExitCode);
    }

    [SkippableFact]
    public async Task ExecFd_ADescriptorDoesNotFeedTheCommandAsStdin()
    {
        // `cmd 7<file` opens fd 7 for cmd; it used to be treated as `cmd <file` (stdin).
        var r = await RunAsync(Work + "printf 'FROM-FILE\\n' > d; echo stdin-text | cat 7< d; cd /; rm -rf \"$W\"");
        Assert.Equal("stdin-text\n", r.Stdout.Replace("\r\n", "\n"));
    }
}
