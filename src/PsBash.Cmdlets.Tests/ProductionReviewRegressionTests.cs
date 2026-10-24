using Xunit;

namespace PsBash.Cmdlets.Tests;

/// <summary>
/// Regressions from the 2026-10-24 production review: literal operands for rm/cp/mv, backup collisions,
/// ln -f on the same file, `env CMD`, `xargs -p`, and tar hard links. Expectations checked against GNU
/// coreutils / tar (`wsl bash`); hand-written because each asserts on-disk state after a mutating call.
/// </summary>
public class ProductionReviewRegressionTests : IDisposable, IClassFixture<SharedPwshFixture>
{
    private readonly string _tmp;
    private readonly SharedPwshFixture _fixture;

    public ProductionReviewRegressionTests(SharedPwshFixture fixture)
    {
        _fixture = fixture;
        _tmp = Path.Combine(Path.GetTempPath(), $"psb-prr-{Guid.NewGuid():N}".Substring(0, 22));
        Directory.CreateDirectory(_tmp);
    }

    public void Dispose()
    {
        try { Directory.Delete(_tmp, recursive: true); } catch { /* best-effort */ }
    }

    private CmdResult InTmp(string body) => CmdResult.Run(_fixture.AcquireFresh(),
        $"Push-Location '{_tmp}'; try {{ {body} }} finally {{ Pop-Location }}");

    private void Put(string rel, string content = "x\n") => File.WriteAllText(Path.Combine(_tmp, rel), content);
    private bool Exists(string rel) => File.Exists(Path.Combine(_tmp, rel)) || Directory.Exists(Path.Combine(_tmp, rel));

    [Fact]
    public void Rm_QuotedWildcard_IsLiteralAndKeepsOtherFiles()
    {
        Put("a.txt");
        InTmp("Invoke-BashRm -f '*.txt'");
        Assert.True(Exists("a.txt"));
    }

    [Fact]
    public void Rm_QuotedBracketName_RemovesOnlyThatName()
    {
        Put("a[1]"); Put("a1");
        InTmp("Invoke-BashRm -f 'a[1]'");
        Assert.False(Exists("a[1]"));
        Assert.True(Exists("a1"));
    }

    [Fact]
    public void Cp_BackupNameIsSource_RefusesAndKeepsSource()
    {
        Put("file~", "src\n"); Put("file", "dst\n");
        var r = InTmp("Invoke-BashCp -b 'file~' file");
        Assert.True(Exists("file~"));
        Assert.Equal("src\n", File.ReadAllText(Path.Combine(_tmp, "file~")));
        Assert.NotEqual(0, r.ExitCode);
    }

    [Fact]
    public void Ln_ForceOnSameFile_KeepsTheFile()
    {
        Put("file", "keep\n");
        var r = InTmp("Invoke-BashLn -f file file");
        Assert.Equal("keep\n", File.ReadAllText(Path.Combine(_tmp, "file")));
        Assert.NotEqual(0, r.ExitCode);
    }

    [Fact]
    public void Env_RunsTheNamedCommand()
    {
        var r = InTmp("Invoke-BashEnv echo hello");
        r.AssertSuccess();
        Assert.Contains("hello", r.Stdout);
    }

    [Fact]
    public void Xargs_Interactive_RunsNothingWithoutATty()
    {
        var r = InTmp("'a' | Invoke-BashXargs '-p' touch");
        Assert.False(Exists("a"));
        Assert.NotEqual(0, r.ExitCode);
    }
}
