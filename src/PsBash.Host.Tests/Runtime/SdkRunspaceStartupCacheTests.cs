using System.Management.Automation;
using PsBash.Host.Runtime;
using Xunit;

namespace PsBash.Host.Tests.Runtime;

/// <summary>
/// The daemon builds a fresh runspace per command, so <see cref="SdkRunspace.Create"/> compiles its
/// startup scripts (setup script, the 160 KB psm1) once per process and dot-sources the same compiled
/// block into each new runspace. These pin what that must not change: each runspace still gets its
/// own complete state, built concurrently by the warm pool, with nothing extra left in the global
/// scope and the literal-argument proxies still dropped.
///
/// Oracle note (Directive 1): host-internal, no bash equivalent; hand-written asserts.
/// </summary>
[Collection("SdkHost")]
public class SdkRunspaceStartupCacheTests
{
    // Functions, aliases, global variables, a module command, and what grep resolves to: a runspace
    // missing any part of the startup state shows up as a different line.
    private const string StateProbe =
        "'{0}|{1}|{2}|{3}|{4}|{5}' -f (Get-ChildItem Function:).Count, (Get-ChildItem Alias:).Count, " +
        "(Get-Variable -Scope Global).Count, ((echo hi) -join ''), " +
        "(Get-Command Invoke-BashGrep).CommandType, (Get-Command Invoke-BashSed).CommandType";

    private static string Probe(SdkRunspace rs, string script)
    {
        using var ps = PowerShell.Create();
        ps.Runspace = rs.Runspace;
        return string.Join("\n", ps.AddScript(script).Invoke().Select(o => o?.ToString()));
    }

    [Fact]
    public async Task Create_Rebuilt_CompilesStartupScriptsOnlyOnce()
    {
        await (SdkRunspace.Create()).DisposeAsync();
        int before = SdkRunspace.StartupScriptCompileCount;
        for (int i = 0; i < 3; i++) await (SdkRunspace.Create()).DisposeAsync();
        Assert.Equal(before, SdkRunspace.StartupScriptCompileCount);
    }

    [Fact]
    public async Task Create_LiteralArgumentProxies_ResolveToTheCmdlets()
    {
        var rs = SdkRunspace.Create();
        try
        {
            Assert.Equal("Cmdlet\nCmdlet", Probe(rs, "(Get-Command Invoke-BashGrep).CommandType; (Get-Command Invoke-BashSed).CommandType"));
        }
        finally { await rs.DisposeAsync(); }
    }

    [Fact]
    public async Task Create_StartupBlockVariable_IsNotLeftInTheRunspace()
    {
        var rs = SdkRunspace.Create();
        try
        {
            Assert.Equal("False", Probe(rs, "[bool](Get-Variable -Name __PsBashStartupBlock -Scope Global -ErrorAction SilentlyContinue)"));
        }
        finally { await rs.DisposeAsync(); }
    }

    [Fact]
    public async Task Create_Concurrently_EveryRunspaceGetsTheSameCompleteState()
    {
        var reference = SdkRunspace.Create();
        string expected;
        try { expected = Probe(reference, StateProbe); }
        finally { await reference.DisposeAsync(); }
        Assert.EndsWith("|hi|Cmdlet|Cmdlet", expected);

        // The warm pool builds runspaces on dedicated threads at the same time, all from the one block.
        var got = new System.Collections.Concurrent.ConcurrentBag<string>();
        for (int round = 0; round < 3; round++)
        {
            var threads = Enumerable.Range(0, 4).Select(_ => new Thread(() =>
            {
                var rs = SdkRunspace.Create();
                try { got.Add(Probe(rs, StateProbe)); }
                finally { rs.DisposeAsync().AsTask().GetAwaiter().GetResult(); }
            })).ToList();
            threads.ForEach(t => t.Start());
            threads.ForEach(t => t.Join());
        }
        Assert.Equal(12, got.Count);
        Assert.All(got, g => Assert.Equal(expected, g));
    }
}
