using PsBash.Core.Runtime.Ipc;
using Xunit;

namespace PsBash.Core.Tests.Runtime.Ipc;

/// <summary>
/// Linux <c>/proc/&lt;pid&gt;/stat</c> parsing: the state (a SIGKILLed host that is not our child is
/// a zombie .NET still reports as running) and the start time (the cross-process-stable stamp
/// that keys a session's daemon). Oracle note (Directive 1): no bash oracle — kernel file format.
/// </summary>
public class ProcStatTests
{
    // Fields 3..22 after the comm: state, ppid, pgrp, session, tty, tpgid, flags, minflt, cminflt,
    // majflt, cmajflt, utime, stime, cutime, cstime, priority, nice, threads, itrealvalue, starttime.
    private const string Tail = "1 4242 4242 0 -1 4194560 100 0 0 0 5 3 0 0 20 0 7 0 7034578 1000 50";

    [Theory]
    [InlineData("4242 (ps-bash-host) Z " + Tail, 'Z')]
    [InlineData("4242 (ps-bash-host) X " + Tail, 'X')]
    [InlineData("4242 (ps-bash-host) S " + Tail, 'S')]
    [InlineData("4242 (odd) name) R " + Tail, 'R')]
    [InlineData("4242 (odd) Z name) S " + Tail, 'S')]
    public void TryParse_ReadsStateAndStartTimeAfterTheLastParen(string stat, char state)
    {
        Assert.True(ProcStat.TryParse(stat, out var parsedState, out var startTime));
        Assert.Equal(state, parsedState);
        Assert.Equal(7034578, startTime);
    }

    [Theory]
    [InlineData("garbage")]
    [InlineData("4242 (x)")]
    [InlineData("4242 (x) S 1 2 3")]
    [InlineData("4242 (x) S " + "1 4242 4242 0 -1 4194560 100 0 0 0 5 3 0 0 20 0 7 0 notanumber 1000")]
    public void TryParse_Malformed_ReturnsFalse(string stat)
        => Assert.False(ProcStat.TryParse(stat, out _, out _));

    [Theory]
    [InlineData('Z', true)]
    [InlineData('X', true)]
    [InlineData('S', false)]
    [InlineData('R', false)]
    [InlineData('D', false)]
    public void IsDead_OnlyZombieAndDead(char state, bool dead)
        => Assert.Equal(dead, ProcStat.IsDead(state));
}
