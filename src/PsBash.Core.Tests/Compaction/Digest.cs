using System.Text.RegularExpressions;
using Xunit;

namespace PsBash.Core.Tests.Compaction;

/// <summary>
/// Parses and validates the compact-output digest format
/// (<c>docs/specs/compact-output.md</c> §2) so tests assert structure, not substrings.
/// </summary>
internal sealed record Digest(DigestHeader? Header, IReadOnlyList<DigestLine> Body)
{
    private static readonly Regex HeaderPattern = new(
        "^ps-bash compact-output: exit=(?<exit>-?\\d+)(?<timeout> timeout=true)?"
        + " stdout_lines=(?<out>\\d+) stderr_lines=(?<err>\\d+) command=\"(?<cmd>.*)\"$",
        RegexOptions.Compiled | RegexOptions.CultureInvariant);

    /// <summary>
    /// Parse a digest. Fails the test if any line is neither the header (first line only) nor a
    /// <c>[out] </c>/<c>[err] </c> body line, or if lines mix newline styles.
    /// </summary>
    public static Digest Parse(string text)
    {
        Assert.NotNull(text);
        var hasCr = text.Contains('\r');
        if (hasCr)
        {
            // Header and body must share one newline convention (AppendLine on both).
            var bareLf = Regex.Matches(text, "(?<!\r)\n").Count;
            Assert.True(bareLf == 0, "digest mixes CRLF and bare LF line endings");
        }

        Assert.True(text.Length == 0 || text.EndsWith('\n'), "digest must end with a newline");
        var rows = text.Length == 0
            ? []
            : text.Replace("\r\n", "\n")[..^1].Split('\n');

        DigestHeader? header = null;
        var body = new List<DigestLine>();
        for (var i = 0; i < rows.Length; i++)
        {
            var row = rows[i];
            if (i == 0 && row.StartsWith("ps-bash compact-output:", StringComparison.Ordinal))
            {
                var m = HeaderPattern.Match(row);
                Assert.True(m.Success, $"malformed digest header: {row}");
                header = new DigestHeader(
                    int.Parse(m.Groups["exit"].Value),
                    m.Groups["timeout"].Success,
                    int.Parse(m.Groups["out"].Value),
                    int.Parse(m.Groups["err"].Value),
                    m.Groups["cmd"].Value);
            }
            else if (row.StartsWith("[out] ", StringComparison.Ordinal))
                body.Add(new DigestLine(false, row[6..]));
            else if (row.StartsWith("[err] ", StringComparison.Ordinal))
                body.Add(new DigestLine(true, row[6..]));
            else
                Assert.Fail($"digest line {i + 1} has neither header nor stream prefix: {row}");
        }
        return new Digest(header, body);
    }

    /// <summary>The digest has a header with exactly these values.</summary>
    public Digest AssertHeader(int exit, int stdoutLines, int stderrLines, string? command = null, bool timeout = false)
    {
        Assert.NotNull(Header);
        Assert.Equal(exit, Header!.Exit);
        Assert.Equal(timeout, Header.TimedOut);
        Assert.Equal(stdoutLines, Header.StdoutLines);
        Assert.Equal(stderrLines, Header.StderrLines);
        if (command is not null) Assert.Equal(command, Header.Command);
        return this;
    }

    /// <summary>
    /// A lossless digest carries no header: the body is the complete output, one prefixed line each.
    /// </summary>
    public Digest AssertNoHeader()
    {
        Assert.Null(Header);
        return this;
    }

    /// <summary>Body lines, in order, as <c>[out] text</c> / <c>[err] text</c>.</summary>
    public Digest AssertBody(params string[] expected)
    {
        Assert.Equal(expected, Body.Select(l => (l.IsStderr ? "[err] " : "[out] ") + l.Text));
        return this;
    }
}

internal sealed record DigestHeader(int Exit, bool TimedOut, int StdoutLines, int StderrLines, string Command);

internal sealed record DigestLine(bool IsStderr, string Text);
