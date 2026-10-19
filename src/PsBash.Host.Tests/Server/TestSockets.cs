namespace PsBash.Host.Tests.Server;

/// <summary>Short, unique AF_UNIX socket paths for in-process server tests.</summary>
internal static class TestSockets
{
    /// <summary>
    /// A fresh socket path under the runtime temp dir. Kept short: a macOS socket path is capped
    /// at 104 chars and <c>$TMPDIR</c> already takes ~49 of them.
    /// </summary>
    public static string New(string label)
    {
        var dir = Path.Combine(Path.GetTempPath(), "ps-bash");
        Directory.CreateDirectory(dir);
        return Path.Combine(dir, $"t-{label}-{Guid.NewGuid().ToString("N")[..8]}.sock");
    }
}
