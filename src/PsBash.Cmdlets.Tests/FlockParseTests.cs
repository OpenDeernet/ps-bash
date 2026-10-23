using Xunit;
using PsBash.Cmdlets;

namespace PsBash.Cmdlets.Tests;

public class FlockParseTests
{
    [Fact]
    public void File_and_command_are_split_after_the_options()
    {
        Assert.True(InvokeBashFlockCommand.Parse(new[] { "-n", "-w", "2.5", "/tmp/l", "echo", "-n", "hi" }, out var o, out _));
        Assert.Equal("/tmp/l", o.File);
        Assert.Equal(new[] { "echo", "-n", "hi" }, o.Command);
        Assert.Equal(TimeSpan.Zero, o.Wait); // -n wins over -w
        Assert.False(o.Shared);
    }

    [Fact]
    public void Command_string_and_conflict_code()
    {
        Assert.True(InvokeBashFlockCommand.Parse(new[] { "-s", "-E", "9", "f", "-c", "echo hi" }, out var o, out _));
        Assert.Equal("echo hi", o.CommandString);
        Assert.Equal(9, o.ConflictCode);
        Assert.True(o.Shared);
        Assert.Empty(o.Command);
    }

    [Fact]
    public void Timeout_is_seconds()
    {
        Assert.True(InvokeBashFlockCommand.Parse(new[] { "-w", "1.5", "f", "true" }, out var o, out _));
        Assert.Equal(TimeSpan.FromSeconds(1.5), o.Wait);
    }

    [Theory]
    [InlineData("-w")]
    [InlineData("-w", "x", "f", "true")]
    [InlineData("--bogus", "f", "true")]
    [InlineData("-n")]
    public void Bad_usage_is_rejected(params string[] args)
    {
        Assert.False(InvokeBashFlockCommand.Parse(args, out _, out var error));
        Assert.NotEqual("", error);
    }
}
