using PsBash.Core.Runtime.Compaction;
using PsBash.Core.Runtime.Ipc;
using PsBash.Core.Tests.Compaction;
using Xunit;

namespace PsBash.Core.Tests.Runtime;

public class OutputCompactorTests
{
    [Fact]
    public void CompactCommandOutput_CollapsesRepeatedLines()
    {
        var frames = Enumerable.Repeat(new OutputFrame(StreamTag.Stdout, "restore ok\n"), 25).ToArray();

        var compacted = OutputCompactor.CompactCommandOutput("dotnet build", 0, false, frames);

        // Collapsing drops lines, so the header must say how many there were.
        Digest.Parse(compacted)
            .AssertHeader(exit: 0, stdoutLines: 25, stderrLines: 0, command: "dotnet build")
            .AssertBody("[out] restore ok", "[out] ... repeated 24 more times: restore ok");
        Assert.True(compacted.Length < string.Concat(frames.Select(f => f.Text)).Length);
    }

    [Fact]
    public void CompactCommandOutput_KeepsErrorsAndFileLocations()
    {
        var frames = new[]
        {
            new OutputFrame(StreamTag.Stdout, "line 1\nline 2\nline 3\n"),
            new OutputFrame(StreamTag.Stderr, "src/App.cs:42: error CS1002: ; expected\n"),
            new OutputFrame(StreamTag.Stdout, "tail context\n"),
        };

        var compacted = OutputCompactor.CompactCommandOutput("dotnet test", 1, false, frames, maxLines: 4);

        var digest = Digest.Parse(compacted).AssertHeader(exit: 1, stdoutLines: 4, stderrLines: 1);
        Assert.Contains(digest.Body, l => l.IsStderr && l.Text == "src/App.cs:42: error CS1002: ; expected");
        Assert.Contains(digest.Body, l => !l.IsStderr && l.Text == "tail context");
    }

    [Fact]
    public void CompactCommandOutput_DistinguishesMixedStdoutAndStderr()
    {
        var frames = new[]
        {
            new OutputFrame(StreamTag.Stdout, "normal output\n"),
            new OutputFrame(StreamTag.Stderr, "warning: noisy stderr\n"),
        };

        var compacted = OutputCompactor.CompactCommandOutput("tool", 0, false, frames);

        // Nothing dropped and exit 0: the prefixes carry the stream split, no header needed.
        Digest.Parse(compacted)
            .AssertNoHeader()
            .AssertBody("[out] normal output", "[err] warning: noisy stderr");
    }

    [Fact]
    public void CompactCommandOutput_RecordsTimeout()
    {
        var compacted = OutputCompactor.CompactCommandOutput("sleep 99", 124, true, []);

        Digest.Parse(compacted).AssertHeader(exit: 124, stdoutLines: 0, stderrLines: 0, "sleep 99", timeout: true);
    }

    // ---- Header only when the body leaves something out ----

    [Fact]
    public void CompactCommandOutput_CleanShortOutput_HasNoHeader()
    {
        var compacted = OutputCompactor.CompactCommandOutput(
            "echo hi", 0, false, [new OutputFrame(StreamTag.Stdout, "hi\n")]);

        Digest.Parse(compacted).AssertNoHeader().AssertBody("[out] hi");
    }

    [Fact]
    public void CompactCommandOutput_CleanEmptyOutput_IsEmpty()
    {
        Assert.Equal("", OutputCompactor.CompactCommandOutput("true", 0, false, []));
    }

    [Fact]
    public void CompactCommandOutput_CleanOutputExactlyAtCap_HasNoHeader()
    {
        var frames = Enumerable.Range(0, 5).Select(i => new OutputFrame(StreamTag.Stdout, $"row {i}\n")).ToArray();

        var compacted = OutputCompactor.CompactCommandOutput("ls", 0, false, frames, maxLines: 5);

        Digest.Parse(compacted).AssertNoHeader();
    }

    [Fact]
    public void CompactCommandOutput_CleanOutputOverCap_KeepsHeaderAndOmissionMarker()
    {
        var frames = Enumerable.Range(0, 40).Select(i => new OutputFrame(StreamTag.Stdout, $"row {i}\n")).ToArray();

        var compacted = OutputCompactor.CompactCommandOutput("ls", 0, false, frames, maxLines: 20);

        var digest = Digest.Parse(compacted).AssertHeader(exit: 0, stdoutLines: 40, stderrLines: 0);
        Assert.Contains(digest.Body, l => l.Text.StartsWith("... omitted ", StringComparison.Ordinal));
    }

    [Fact]
    public void CompactCommandOutput_NonZeroExit_KeepsHeaderEvenWhenNothingDropped()
    {
        var compacted = OutputCompactor.CompactCommandOutput(
            "grep x f", 1, false, [new OutputFrame(StreamTag.Stdout, "only line\n")]);

        // The exit status is information the body alone does not carry.
        Digest.Parse(compacted)
            .AssertHeader(exit: 1, stdoutLines: 1, stderrLines: 0)
            .AssertBody("[out] only line");
    }

    [Fact]
    public void CompactCommandOutput_TwoDistinctRepeatsAreNotCollapsedAcrossStreams()
    {
        var frames = new[]
        {
            new OutputFrame(StreamTag.Stdout, "same\n"),
            new OutputFrame(StreamTag.Stderr, "same\n"),
        };

        // Identical text on different streams is not a run: still lossless, still headerless.
        Digest.Parse(OutputCompactor.CompactCommandOutput("t", 0, false, frames))
            .AssertNoHeader()
            .AssertBody("[out] same", "[err] same");
    }

    // ---- The format helper itself must reject malformed digests ----

    [Theory]
    [InlineData("plain line without prefix\n")]
    [InlineData("[out] ok\nstray\n")]
    [InlineData("[out] missing trailing newline")]
    [InlineData("[out] a\nps-bash compact-output: exit=0 stdout_lines=1 stderr_lines=0 command=\"x\"\n")]
    [InlineData("ps-bash compact-output: exit=zero stdout_lines=1 stderr_lines=0 command=\"x\"\n")]
    [InlineData("ps-bash compact-output: exit=0 stdout_lines=1 stderr_lines=0 command=\"x\"\r\n[out] a\n")]
    public void DigestParse_RejectsMalformedDigests(string text)
    {
        Assert.ThrowsAny<Exception>(() => Digest.Parse(text));
    }

    [Fact]
    public void CompactCommandOutput_ReducesRepresentativeNoisyFailureFixture()
    {
        var frames = new List<OutputFrame>();
        for (var i = 0; i < 80; i++)
            frames.Add(new OutputFrame(StreamTag.Stdout, "Determining projects to restore...\n"));
        frames.Add(new OutputFrame(StreamTag.Stdout, "src/App.cs:42: warning CS0168: unused variable\n"));
        frames.Add(new OutputFrame(StreamTag.Stderr, "src/App.cs:99: error CS1002: ; expected\n"));
        frames.Add(new OutputFrame(StreamTag.Stdout, "Build FAILED.\n"));
        frames.Add(new OutputFrame(StreamTag.Stdout, "Time Elapsed 00:00:12.34\n"));

        var raw = string.Concat(frames.Select(f => f.Text));
        var compacted = OutputCompactor.CompactCommandOutput("dotnet build", 1, false, frames);

        Assert.True(compacted.Length < raw.Length / 2);
        Assert.True(EstimateTokens(compacted) < EstimateTokens(raw) / 2);
        var digest = Digest.Parse(compacted).AssertHeader(exit: 1, stdoutLines: 83, stderrLines: 1);
        Assert.Contains(digest.Body, l => l.IsStderr && l.Text == "src/App.cs:99: error CS1002: ; expected");
        Assert.Contains(digest.Body, l => !l.IsStderr && l.Text == "src/App.cs:42: warning CS0168: unused variable");
        Assert.Contains(digest.Body, l => !l.IsStderr && l.Text == "Build FAILED.");
        Assert.Contains(digest.Body, l => l.Text.StartsWith("... repeated 79 more times", StringComparison.Ordinal));
    }

    private static int EstimateTokens(string value)
        => value.Split((char[]?)null, StringSplitOptions.RemoveEmptyEntries).Length;
}
