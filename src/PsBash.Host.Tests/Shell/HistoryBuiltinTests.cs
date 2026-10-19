using PsBash.Host.Shell;
using Xunit;

namespace PsBash.Host.Tests.Shell;

public sealed class HistoryBuiltinTests : IDisposable
{
    private readonly string _dir = Path.Combine(Path.GetTempPath(), "psb-hist-" + Guid.NewGuid().ToString("N"));
    private readonly SqliteHistoryStore _store;
    private readonly StringWriter _out = new();
    private readonly StringWriter _err = new();
    private readonly List<string> _session = new() { "one", "two" };

    public HistoryBuiltinTests()
    {
        Directory.CreateDirectory(_dir);
        _store = new SqliteHistoryStore(Path.Combine(_dir, "history.db"));
    }

    public void Dispose()
    {
        _store.Dispose();
        Microsoft.Data.Sqlite.SqliteConnection.ClearAllPools();
        try { Directory.Delete(_dir, true); } catch (IOException) { /* temp cleanup is best-effort */ }
    }

    private Task Add(string command) => _store.RecordAsync(new HistoryEntry
    {
        Command = command, Cwd = "/", Timestamp = DateTime.UtcNow, SessionId = "s",
    });

    private Task<int> Run(string line, Func<Task>? after = null) =>
        HistoryBuiltin.RunAsync(line, _store, _session, _out, _err, after);

    [Fact]
    public async Task List_ShowsIdsAndCommands_OldestFirst()
    {
        await Add("alpha"); await Add("beta");

        Assert.Equal(0, await Run("history"));

        var lines = _out.ToString().Split('\n', StringSplitOptions.RemoveEmptyEntries);
        Assert.Equal(2, lines.Length);
        Assert.EndsWith("alpha", lines[0].TrimEnd('\r'));
        Assert.EndsWith("beta", lines[1].TrimEnd('\r'));
    }

    [Fact]
    public async Task Clear_RemovesStoreAndSessionListAndNotifies()
    {
        await Add("secret-token-abc123"); await Add("other");
        int notified = 0;

        Assert.Equal(0, await Run("history -c", () => { notified++; return Task.CompletedTask; }));

        Assert.Empty(await _store.SearchAsync(new HistoryQuery { Limit = 10 }));
        Assert.Empty(_session);
        Assert.Equal(1, notified);
        Assert.Contains("removed 2 entries", _out.ToString());
    }

    [Fact]
    public async Task Clear_LeavesNoCommandTextInTheDatabaseFiles()
    {
        await Add("secret-token-abc123");

        await Run("history -c");
        _store.Dispose();
        Microsoft.Data.Sqlite.SqliteConnection.ClearAllPools();

        foreach (var file in Directory.GetFiles(_dir))
            Assert.DoesNotContain("secret-token-abc123", System.Text.Encoding.UTF8.GetString(File.ReadAllBytes(file)));
    }

    [Fact]
    public async Task DeleteById_RemovesOnlyThatEntry()
    {
        await Add("keep"); await Add("drop");
        var drop = (await _store.SearchAsync(new HistoryQuery { Limit = 10 })).Single(e => e.Command == "drop");

        Assert.Equal(0, await Run($"history -d {drop.Id}"));

        var left = await _store.SearchAsync(new HistoryQuery { Limit = 10 });
        Assert.Equal(new[] { "keep" }, left.Select(e => e.Command).ToArray());
    }

    [Theory]
    [InlineData("history -d")]
    [InlineData("history -d abc")]
    [InlineData("history -c extra")]
    [InlineData("history -z")]
    public async Task BadUsage_Exits2_AndDeletesNothing(string line)
    {
        await Add("keep");

        Assert.Equal(2, await Run(line));

        Assert.Single(await _store.SearchAsync(new HistoryQuery { Limit = 10 }));
        Assert.NotEmpty(_err.ToString());
    }

    [Fact]
    public async Task DeleteMissingId_Exits1()
    {
        Assert.Equal(1, await Run("history -d 99999"));
        Assert.Contains("out of range", _err.ToString());
    }

    [Theory]
    [InlineData("history", true)]
    [InlineData("history -c", true)]
    [InlineData("historyx", false)]
    [InlineData("echo history", false)]
    public void IsHistoryCommand_MatchesWholeWordOnly(string line, bool expected)
    {
        Assert.Equal(expected, HistoryBuiltin.IsHistoryCommand(line));
    }
}
