using System.Management.Automation;

namespace PsBash.Cmdlets;

/// <summary>
/// The <c>hash</c> builtin. ps-bash resolves commands on every call, so there is no table to remember:
/// <c>hash -r</c> and <c>hash NAME</c> succeed when the name resolves (127-style failure otherwise), and a bare
/// <c>hash</c> reports the empty table.
/// </summary>
[Cmdlet(VerbsLifecycle.Invoke, "BashHash")]
public sealed class InvokeBashHashCommand : PSCmdlet
{
    [Parameter(ValueFromRemainingArguments = true)]
    public string[]? Arguments { get; set; }

    protected override void EndProcessing()
    {
        var args = Arguments ?? Array.Empty<string>();
        FileSystemHelpers.SetLastExitCode(this, 0);
        if (FileSystemHelpers.TryHandleVersion(this, "hash", args)) return;
        var names = args.Where(a => !a.StartsWith('-')).ToArray();
        if (args.Contains("-r") || names.Length == 0)
        {
            if (names.Length == 0 && !args.Contains("-r")) WriteObject("hash: hash table empty");
            return;
        }
        foreach (var name in names)
        {
            if (!Resolves(name))
            {
                FileSystemHelpers.WriteStderr(this, $"hash: {name}: not found");
                FileSystemHelpers.SetLastExitCode(this, 1);
            }
        }
    }

    private bool Resolves(string name)
    {
        // Parameter-bound, like `type`: the name never becomes script text.
        foreach (var r in InvokeCommand.InvokeScript(
                     "param($n) Get-Command $n -ErrorAction SilentlyContinue", name))
        {
            if (r?.BaseObject is CommandInfo) return true;
        }
        return false;
    }
}
