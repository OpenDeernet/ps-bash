using Xunit;
using PsBash.Core.Parser;

namespace PsBash.Core.Tests.Parser;

/// <summary>
/// A pipe, <c>&lt; file</c>, heredoc or here-string that feeds a NATIVE program goes through
/// <c>ConvertTo-BashNativeStdin 'prog'</c>: PowerShell's own native pipe appends <c>\r\n</c> to every record
/// (so <c>ssh host 'bash -s' &lt; script</c> saw <c>$'hostname\r'</c>), adds a newline to an unterminated last
/// line and re-encodes non-UTF-8 bytes. A mapped command or a builtin keeps its old feed.
/// </summary>
public class NativeStdinFeedEmitterTests
{
    private static string T(string bash) => PsEmitter.Transpile(bash)!;

    private const string Feed = "ConvertTo-BashNativeStdin 'ssh' | ";

    [Theory]
    [InlineData("printf 'a\\n' | ssh host bash -s")]
    [InlineData("cat f | ssh host bash -s")]
    [InlineData("echo a | b | ssh host bash -s")]
    [InlineData("ssh host bash -s < script.sh")]
    [InlineData("ssh host bash -s <<< hi")]
    [InlineData("ssh host bash -s <<EOF\nhi\nEOF\n")]
    [InlineData("ssh host bash -s <<'EOF'\n$x\nEOF\n")]
    [InlineData("printf 'a\\n' | ssh host bash -s 2>&1")]
    public void Transpile_InputIntoNativeProgram_FeedsExactBytes(string bash)
    {
        var ps = T(bash);

        Assert.Contains(Feed, ps);
        Assert.DoesNotContain("ForEach-Object { Get-BashText $_ } | ssh", ps);
    }

    [Theory]
    [InlineData("printf 'a\\n' | wc -l")]                    // mapped: records as they are
    [InlineData("printf 'a\\n' | sort")]
    [InlineData("wc -l < f")]
    [InlineData("wc -l <<< hi")]
    [InlineData("grep a <<EOF\na\nEOF\n")]
    [InlineData("printf 'a\\n' | read x")]                   // builtin: no program to hand bytes to
    public void Transpile_InputIntoMappedOrBuiltin_HasNoNativeFeed(string bash) =>
        Assert.DoesNotContain("ConvertTo-BashNativeStdin", T(bash));

    [Fact]
    public void Transpile_ComputedCommandWord_KeepsTextConversion()
    {
        // `$cmd` cannot be classified at emit time: keep the text conversion it always had.
        var ps = T("printf 'a\\n' | $cmd");

        Assert.DoesNotContain("ConvertTo-BashNativeStdin", ps);
        Assert.Contains("ForEach-Object { Get-BashText $_ } | ", ps);
    }

    [Fact]
    public void Transpile_FileRedirectIntoNative_KeepsExactRecordsNotText()
    {
        // `Invoke-BashCat f` records carry the missing-final-newline flag; the old `ForEach-Object { Get-BashText }`
        // stripped it before the program saw them.
        var ps = T("ssh host bash -s < script.sh");

        Assert.Contains("Invoke-BashCat", ps);
        Assert.DoesNotContain("Get-BashText", ps);
    }
}
