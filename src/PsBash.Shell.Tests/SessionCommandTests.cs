using Xunit;

namespace PsBash.Shell.Tests;

public sealed class SessionCommandTests
{
    [Theory]
    [InlineData("build")]
    [InlineData("agent_1-a")]
    [InlineData("x")]
    public void IsValidName_AcceptsPathSafeNames(string name)
        => Assert.True(SessionCommands.IsValidName(name));

    [Theory]
    [InlineData("")]
    [InlineData("has space")]
    [InlineData("a/b")]
    [InlineData("..")]
    [InlineData("a;rm")]
    [InlineData("name-that-is-way-too-long-to-be-a-session")]
    public void IsValidName_RejectsAnythingThatCouldEscapeAnEndpointName(string name)
        => Assert.False(SessionCommands.IsValidName(name));

    [Theory]
    [InlineData("host-andy-sbuild.sock.host.json", "andy", "build")]
    [InlineData("host-andy-s123-456.sock.host.json", "andy", "123-456")]
    public void TokenFromSidecarName_ExtractsTheSessionToken(string file, string user, string expected)
        => Assert.Equal(expected, SessionCommands.TokenFromSidecarName(file, user));

    [Theory]
    [InlineData("host-other-sbuild.sock.host.json")]      // another user's session
    [InlineData("host-andy.sock.host.json")]               // per-user endpoint, no session
    [InlineData("host-andy-s.sock.host.json")]             // empty token
    [InlineData("host-.sock.host.json")]
    [InlineData("module-0.12.0.0.json")]
    [InlineData("spawn-unix-abc.lock")]
    public void TokenFromSidecarName_IgnoresEverythingElse(string file)
        => Assert.Null(SessionCommands.TokenFromSidecarName(file, "andy"));

    [Theory]
    [InlineData("4242-639279814259006900", true)]   // launcher-anchored: pid-startTicks
    [InlineData("build", false)]
    [InlineData("2024-release", false)]
    public void IsAnchorToken_SeparatesEphemeralFromNamedSessions(string token, bool anchored)
        => Assert.Equal(anchored, SessionCommands.IsAnchorToken(token));
}
