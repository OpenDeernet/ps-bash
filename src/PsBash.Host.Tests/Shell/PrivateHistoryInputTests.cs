using PsBash.Host.Shell;
using Xunit;

namespace PsBash.Host.Tests.Shell;

// Not parallel-safe with other env-mutating tests: PSBASH_HISTORY_PRIVATE is process-global.
[Collection("EnvMutation")]
public class PrivateHistoryInputTests
{
    [Fact]
    public void LeadingSpace_IsPrivate()
    {
        Assert.True(InteractiveShell.IsPrivateInput(" export TOKEN=abc"));
    }

    [Theory]
    [InlineData("ls -la")]
    [InlineData("echo ' not leading'")]
    [InlineData("")]
    public void OrdinaryInput_IsRecorded(string command)
    {
        Assert.False(InteractiveShell.IsPrivateInput(command));
    }

    [Fact]
    public void PrivateEnvFlag_MakesEveryLinePrivate()
    {
        var prior = Environment.GetEnvironmentVariable("PSBASH_HISTORY_PRIVATE");
        try
        {
            Environment.SetEnvironmentVariable("PSBASH_HISTORY_PRIVATE", "1");
            Assert.True(InteractiveShell.IsPrivateInput("ls"));
        }
        finally
        {
            Environment.SetEnvironmentVariable("PSBASH_HISTORY_PRIVATE", prior);
        }
        Assert.False(InteractiveShell.IsPrivateInput("ls"));
    }
}
