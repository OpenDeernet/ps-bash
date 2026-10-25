using PsBash.Spec;

namespace PsBash.Spec.Tests;

public class SpecParserTests
{
    private const string Sample = """
        ## header line

        #### echo prints
        echo hi
        ## stdout: hi

        #### multi
        printf 'a\nb\n'
        echo $?
        ## STDOUT:
        a
        b
        0
        ## END

        #### status only
        false
        ## status: 1

        #### shell diff
        echo $BASH_VERSINFO
        ## stdout: 5
        ## OK bash stdout: 4
        ## N-I dash stdout: nothing

        #### known gap
        declare -n r=x
        ## stdout: ok
        ## XFAIL ps-bash nameref declare -n unsupported
        """;

    [Fact]
    public void Parses_cases_and_expectations()
    {
        var f = SpecParser.Parse("t.spec.sh", Sample);
        Assert.Equal(5, f.Cases.Count);
        Assert.Equal("echo prints", f.Cases[0].Name);
        Assert.Equal("echo hi\n", f.Cases[0].Script);
        Assert.Equal("hi\n", f.Cases[0].Primary.Stdout);
        Assert.Equal("a\nb\n0\n", f.Cases[1].Primary.Stdout);
        Assert.Equal(1, f.Cases[2].Primary.Status);
        Assert.Null(f.Cases[2].Primary.Stdout);
    }

    [Fact]
    public void Collects_bash_alternative_and_ignores_other_shells()
    {
        var c = SpecParser.Parse("t.spec.sh", Sample).Cases[3];
        Assert.Equal("5\n", c.Primary.Stdout);
        Assert.Single(c.Alternatives);
        Assert.Equal("4\n", c.Alternatives[0].Stdout);
    }

    [Fact]
    public void Reads_xfail_mark()
    {
        var c = SpecParser.Parse("t.spec.sh", Sample).Cases[4];
        Assert.NotNull(c.Xfail);
        Assert.Equal("nameref", c.Xfail!.Id);
    }

    [Fact]
    public void Format_then_parse_round_trips()
    {
        var f = SpecParser.Parse("t.spec.sh", Sample);
        var g = SpecParser.Parse("t.spec.sh", SpecParser.Format(f));
        Assert.Equal(f.Cases.Count, g.Cases.Count);
        for (int i = 0; i < f.Cases.Count; i++)
        {
            Assert.Equal(f.Cases[i].Name, g.Cases[i].Name);
            Assert.Equal(f.Cases[i].Script, g.Cases[i].Script);
            Assert.Equal(f.Cases[i].Primary.Stdout, g.Cases[i].Primary.Stdout);
            Assert.Equal(f.Cases[i].Primary.Status, g.Cases[i].Primary.Status);
            Assert.Equal(f.Cases[i].Xfail?.Id, g.Cases[i].Xfail?.Id);
        }
    }
}

public class SpecRunnerTests
{
    private static SpecCase Case(string stdout, int? status = null, XfailMark? x = null)
        => new("c", "x\n", new Expectation(stdout, status, null), Array.Empty<Expectation>(), x, null, false);

    [Fact]
    public void Pass_fail_xfail_xpass()
    {
        var ok = new ExecResult(0, "hi\r\n", "", 1);
        Assert.Equal(Verdict.Pass, SpecRunner.Judge(Case("hi\n", 0), ok).Verdict);
        Assert.Equal(Verdict.Fail, SpecRunner.Judge(Case("no\n", 0), ok).Verdict);
        Assert.Equal(Verdict.Fail, SpecRunner.Judge(Case("hi\n", 1), ok).Verdict);
        Assert.Equal(Verdict.XFail, SpecRunner.Judge(Case("no\n", 0, new XfailMark("g", "r")), ok).Verdict);
        Assert.Equal(Verdict.XPass, SpecRunner.Judge(Case("hi\n", 0, new XfailMark("g", "r")), ok).Verdict);
    }

    [Fact]
    public void Alternative_expectation_passes()
    {
        var c = Case("5\n") with { Alternatives = new[] { new Expectation("4\n", null, null) } };
        Assert.Equal(Verdict.Pass, SpecRunner.Judge(c, new ExecResult(0, "4\n", "", 1)).Verdict);
    }

    [Fact]
    public void Unspecified_fields_are_not_compared()
    {
        var c = Case(null!, 3);
        Assert.Equal(Verdict.Pass, SpecRunner.Judge(c, new ExecResult(3, "anything", "", 1)).Verdict);
    }

    [Fact]
    public void Stderr_shell_prefix_is_normalized()
    {
        Assert.Equal("boom\n", SpecRunner.NormalizeStderr("bash: line 3: boom\n"));
        Assert.Equal("boom\n", SpecRunner.NormalizeStderr("ps-bash: boom\n"));
    }
}

public class SpecParserWhitespaceTests
{
    [Fact]
    public void Inline_stdout_keeps_inner_spacing()
    {
        var f = SpecParser.Parse("t", "#### w\necho x\n## stdout: a  b\n## OK bash stdout: c   d\n");
        Assert.Equal("a  b\n", f.Cases[0].Primary.Stdout);
        Assert.Equal("c   d\n", f.Cases[0].Alternatives[0].Stdout);
    }
}

public class SpecParserNoTrailingNewlineTests
{
    // Oracle note: the spec file format is ps-bash's own; a round trip is the contract, so this asserts directly.
    [Theory]
    [InlineData("twoXoneX")]
    [InlineData("a\nb")]
    [InlineData("tab\there \"q\" \\")]
    public void Output_without_a_final_newline_survives_a_write_and_read(string stdout)
    {
        var c = new SpecCase("n", "echo\n", new Expectation(stdout, 0), Array.Empty<Expectation>(), null, null, false);
        var back = SpecParser.Parse("t", SpecParser.Format(new SpecFile("t", "", new[] { c })));
        Assert.Equal(stdout, back.Cases[0].Primary.Stdout);
    }

    [Fact]
    public void Stdout_json_is_read_as_a_json_string()
    {
        var f = SpecParser.Parse("t", "#### j\nprintf x\n## stdout-json: \"x\"\n");
        Assert.Equal("x", f.Cases[0].Primary.Stdout);
    }
}


public class SpecRunnerTimeoutTests
{
    private static SpecCase Case(XfailMark? xfail, TimeSpan? timeout)
        => new("c", "echo", new Expectation(null, null, null), Array.Empty<Expectation>(), xfail, timeout, false);

    [Fact]
    public void A_known_gap_gets_a_short_timeout_so_a_hang_does_not_cost_the_full_limit()
        => Assert.Equal(SpecRunner.KnownGapTimeout, SpecRunner.TimeoutFor(Case(new XfailMark("g", "r"), TimeSpan.FromSeconds(10))));

    [Fact]
    public void A_case_expected_to_pass_keeps_its_own_timeout()
        => Assert.Equal(TimeSpan.FromSeconds(10), SpecRunner.TimeoutFor(Case(null, TimeSpan.FromSeconds(10))));
}