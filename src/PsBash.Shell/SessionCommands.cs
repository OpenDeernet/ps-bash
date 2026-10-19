using System.Text.RegularExpressions;
using PsBash.Core.Runtime;
using PsBash.Core.Runtime.Ipc;

namespace PsBash.Shell;

/// <summary>
/// <c>ps-bash session</c>: named, durable sessions. A named session is the per-session
/// daemon (<see cref="IpcTransportFactory.SessionEnvVar"/>) given a stable name instead of
/// the launcher-derived anchor, so it
/// <list type="bullet">
///   <item>outlives every launcher that attaches to it (no anchor watcher ends it),</item>
///   <item>keeps its shell state (cwd, variables) between attachments, and</item>
///   <item>runs concurrently with every other session — each is its own host process, so the
///   per-process exec gate never serializes two sessions against each other.</item>
/// </list>
/// Attach with <c>PSBASH_SESSION=NAME ps-bash -c '…'</c>. This command only manages lifetime;
/// it never changes how commands run.
/// </summary>
internal static partial class SessionCommands
{
    /// <summary>A managed session is kept for a day of silence unless the caller says otherwise.</summary>
    internal const int DefaultIdleSecs = 24 * 60 * 60;

    public static bool IsSessionCommand(string[] args)
        => args.Length >= 1 && args[0] == "session";

    [GeneratedRegex("^[A-Za-z0-9_-]{1,32}$")]
    private static partial Regex NameRegex();

    [GeneratedRegex(@"^\d+-\d+$")]
    private static partial Regex AnchorTokenRegex();

    internal static bool IsValidName(string name) => NameRegex().IsMatch(name);

    /// <summary>A token of the form <c>pid-startTicks</c> is a launcher-anchored (ephemeral) session.</summary>
    internal static bool IsAnchorToken(string token) => AnchorTokenRegex().IsMatch(token);

    /// <summary>
    /// The session token inside a metadata sidecar file name (<c>host-USER-sTOKEN.sock.host.json</c>),
    /// or null if the file belongs to another user or is not a per-session endpoint.
    /// </summary>
    internal static string? TokenFromSidecarName(string fileName, string sanitizedUser)
    {
        const string head = "host-", tail = ".sock.host.json";
        if (!fileName.StartsWith(head, StringComparison.Ordinal)
            || !fileName.EndsWith(tail, StringComparison.Ordinal)
            || fileName.Length < head.Length + tail.Length)
            return null;

        var stem = fileName[head.Length..^tail.Length];
        var prefix = sanitizedUser + "-s";
        return stem.StartsWith(prefix, StringComparison.Ordinal) && stem.Length > prefix.Length
            ? stem[prefix.Length..]
            : null;
    }

    public static async Task<int> RunAsync(string[] args, CancellationToken ct = default)
    {
        if (args.Length < 2 || args[1] is "-h" or "--help" or "help")
        {
            PrintUsage();
            return args.Length < 2 ? 2 : 0;
        }

        if (args[1] == "list") return List();

        if (args[1] is not ("start" or "status" or "stop"))
        {
            Console.Error.WriteLine($"ps-bash: unknown session command '{args[1]}'");
            PrintUsage();
            return 2;
        }

        if (args.Length < 3 || !IsValidName(args[2]))
        {
            Console.Error.WriteLine("ps-bash session: NAME is required (1-32 of A-Z a-z 0-9 _ -)");
            return 2;
        }

        Environment.SetEnvironmentVariable(IpcTransportFactory.SessionEnvVar, args[2]);

        switch (args[1])
        {
            case "start":
                if (!TryParseIdle(args.AsSpan(3), out var idle))
                {
                    Console.Error.WriteLine("ps-bash session start: --idle-secs needs a positive integer");
                    return 2;
                }
                // The host reads its idle window from the environment it is spawned with.
                if (idle > 0 || Environment.GetEnvironmentVariable("PSBASH_HOST_IDLE_SECS") is null)
                    Environment.SetEnvironmentVariable(
                        "PSBASH_HOST_IDLE_SECS", (idle > 0 ? idle : DefaultIdleSecs).ToString());
                return await HostCommands.RunAsync(["host", "start"], ct).ConfigureAwait(false);
            case "status":
                return await HostCommands.RunAsync(["host", "status"], ct).ConfigureAwait(false);
            default:
                return await HostCommands.RunAsync(["host", "shutdown"], ct).ConfigureAwait(false);
        }
    }

    private static bool TryParseIdle(ReadOnlySpan<string> args, out int idle)
    {
        idle = 0;
        for (var i = 0; i < args.Length; i++)
        {
            if (args[i] != "--idle-secs") continue;
            return i + 1 < args.Length && int.TryParse(args[i + 1], out idle) && idle > 0;
        }
        return true;
    }

    private static int List()
    {
        var dir = PsBashRuntimeDirectory.GetPath();
        if (!Directory.Exists(dir)) return 0;

        var user = new string(Environment.UserName
            .Select(c => char.IsLetterOrDigit(c) || c == '-' || c == '_' ? c : '_').ToArray());

        foreach (var file in Directory.EnumerateFiles(dir, "*.host.json").OrderBy(f => f, StringComparer.Ordinal))
        {
            var token = TokenFromSidecarName(Path.GetFileName(file), user);
            if (token is null || IsAnchorToken(token)) continue;

            var meta = TryReadSidecar(file);
            var alive = meta is not null && HostOwnership.ProbeProcess(meta.Pid).Alive;
            Console.WriteLine(meta is null
                ? $"{token}\tunknown"
                : $"{token}\t{(alive ? "running" : "stale")}\tpid={meta.Pid}\tstarted={meta.StartedAt:O}");
        }
        return 0;
    }

    private static HostMetadata? TryReadSidecar(string file)
    {
        return HostMetadata.TryRead("unix", file[..^".host.json".Length]);
    }

    private static void PrintUsage()
    {
        Console.Error.WriteLine("usage: ps-bash session start NAME [--idle-secs N]   # create/warm a durable session (default idle: 24h)");
        Console.Error.WriteLine("       ps-bash session status NAME");
        Console.Error.WriteLine("       ps-bash session stop NAME");
        Console.Error.WriteLine("       ps-bash session list                         # named sessions only");
        Console.Error.WriteLine("attach: PSBASH_SESSION=NAME ps-bash -c '...'");
    }
}
