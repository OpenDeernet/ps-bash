namespace PsBash.Host.Shell;

/// <summary>
/// The interactive <c>history</c> builtin: list, delete one entry, or clear everything.
/// Pure over its inputs (store + writers) so it is testable without a terminal.
/// <code>
/// history [N]      show the last N entries (default 50)
/// history -d ID    delete the entry with that id
/// history -c       delete ALL persisted history (and this session's !! list)
/// </code>
/// </summary>
internal static class HistoryBuiltin
{
    private const int DefaultCount = 50;

    public static bool IsHistoryCommand(string trimmed) =>
        trimmed == "history" || trimmed.StartsWith("history ", StringComparison.Ordinal);

    /// <returns>Process-style exit status (0 ok, 1 failure, 2 usage).</returns>
    public static async Task<int> RunAsync(
        string trimmed,
        IHistoryStore store,
        List<string> sessionHistory,
        TextWriter stdout,
        TextWriter stderr,
        Func<Task>? afterMutation = null)
    {
        var args = trimmed.Split((char[]?)null, StringSplitOptions.RemoveEmptyEntries).Skip(1).ToArray();

        if (args.Length == 0) return await ListAsync(DefaultCount, store, stdout);

        switch (args[0])
        {
            case "-c":
                if (args.Length != 1) return Usage(stderr);
                int removed = await store.ClearAsync();
                sessionHistory.Clear();
                if (afterMutation is not null) await afterMutation();
                stdout.WriteLine($"history: removed {removed} {(removed == 1 ? "entry" : "entries")}");
                return 0;

            case "-d":
                if (args.Length != 2 || !long.TryParse(args[1], out long id)) return Usage(stderr);
                if (!await store.DeleteAsync(id))
                {
                    stderr.WriteLine($"history: {args[1]}: history position out of range");
                    return 1;
                }
                if (afterMutation is not null) await afterMutation();
                return 0;

            default:
                if (args.Length == 1 && int.TryParse(args[0], out int n) && n >= 0)
                    return await ListAsync(n, store, stdout);
                if (args[0].StartsWith('-'))
                {
                    stderr.WriteLine($"history: {args[0]}: invalid option");
                    return Usage(stderr);
                }
                stderr.WriteLine($"history: {args[0]}: numeric argument required");
                return 2;
        }
    }

    private static async Task<int> ListAsync(int count, IHistoryStore store, TextWriter stdout)
    {
        if (count == 0) return 0;
        // Newest-first from the store; show oldest-first like bash, ids so `-d` can address them.
        var entries = await store.SearchAsync(new HistoryQuery { Limit = count });
        foreach (var e in entries.Reverse())
            stdout.WriteLine($"{e.Id,6}  {e.Command}");
        return 0;
    }

    private static int Usage(TextWriter stderr)
    {
        stderr.WriteLine("history: usage: history [N] | history -d ID | history -c");
        return 2;
    }
}
