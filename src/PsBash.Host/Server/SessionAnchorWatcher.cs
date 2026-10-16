using PsBash.Core.Runtime.Ipc;

namespace PsBash.Host.Server;

/// <summary>
/// Ties a shared daemon's lifetime to the session that keyed its endpoint. The launcher
/// passes the session anchor (<c>--session-anchor=&lt;pid&gt;:&lt;startTicks&gt;</c>); this
/// watcher polls it and, once that process is gone (or its pid now belongs to a different
/// process), shortens the idle timeout to <see cref="Grace"/>. In-flight commands finish
/// first; the daemon then exits instead of idling for the full timeout.
/// </summary>
/// <remarks>
/// <para>Why this is safe: the endpoint name embeds the anchor's pid AND start time, so once
/// the anchor is gone no new launcher can ever resolve this endpoint. The only remaining work
/// is what is already connected. Contrast <see cref="ParentDeathWatcher"/>, which cancels
/// outright — right for a private host whose one launcher died, wrong for a daemon that may
/// still be serving a command.</para>
/// <para>GH #7: an agent whose per-call shell became the anchor (its own process name is not a
/// recognized session host) got one daemon per call, each idling 600 s.</para>
/// </remarks>
public sealed class SessionAnchorWatcher : IAsyncDisposable
{
    public static readonly TimeSpan PollInterval = TimeSpan.FromSeconds(1);

    /// <summary>Idle time allowed after the anchor is gone, before the daemon exits.</summary>
    public static readonly TimeSpan Grace = TimeSpan.FromSeconds(5);

    private readonly CancellationTokenSource _watcherCts = new();
    private readonly Task _watchTask;

    private SessionAnchorWatcher(Func<bool> isAnchorRunning, IdleShutdown idle, string anchorText, TimeSpan pollInterval, TimeSpan grace)
    {
        _watchTask = WatchAsync(isAnchorRunning, idle, anchorText, pollInterval, grace, _watcherCts.Token);
    }

    /// <summary>
    /// Watch <paramref name="anchor"/>, or return null when there is none (explicit endpoint,
    /// <c>PSBASH_SESSION</c>, per-user or nested daemon: idle timeout only).
    /// </summary>
    /// <param name="isAnchorRunning">Test seam replacing <see cref="ProcessIdentity.IsRunning"/>.</param>
    public static SessionAnchorWatcher? TryCreate(
        ProcessIdentity? anchor,
        IdleShutdown idle,
        TimeSpan? pollInterval = null,
        TimeSpan? grace = null,
        Func<bool>? isAnchorRunning = null)
    {
        if (anchor is not { } id) return null;
        return new SessionAnchorWatcher(
            isAnchorRunning ?? id.IsRunning, idle, id.ToArgumentValue(),
            pollInterval ?? PollInterval, grace ?? Grace);
    }

    private static async Task WatchAsync(
        Func<bool> isAnchorRunning, IdleShutdown idle, string anchorText,
        TimeSpan interval, TimeSpan grace, CancellationToken ct)
    {
        try
        {
            while (!ct.IsCancellationRequested)
            {
                await Task.Delay(interval, ct).ConfigureAwait(false);
                if (isAnchorRunning()) continue;
                HostLog.Write($"session anchor {anchorText} gone; exiting {grace.TotalSeconds:0}s after the last command");
                idle.ShortenTimeout(grace, $"session anchor {anchorText} exited");
                return;
            }
        }
        catch (OperationCanceledException) { }
    }

    public async ValueTask DisposeAsync()
    {
        _watcherCts.Cancel();
        try { await _watchTask.WaitAsync(TimeSpan.FromSeconds(1)).ConfigureAwait(false); } catch { }
        _watcherCts.Dispose();
    }
}
