using System.Management.Automation;

namespace PsBash.Cmdlets;

/// <summary>
/// <c>exec N&lt;file</c>, <c>exec N&gt;file</c>, <c>exec N&gt;&gt;file</c>, <c>exec N&gt;&amp;M</c>, <c>exec N&lt;&amp;M</c>,
/// <c>exec N&lt;&amp;-</c> / <c>exec N&gt;&amp;-</c>: one redirection of a command-less <c>exec</c>, emitted by the
/// transpiler as <c>Invoke-BashExecFd N 'op' target</c>. Opens, duplicates or closes a numbered descriptor in
/// <see cref="BashFdTable"/>; exit status 1 with a bash-style message when it cannot.
/// </summary>
[Cmdlet(VerbsLifecycle.Invoke, "BashExecFd")]
public sealed class InvokeBashExecFdCommand : PSCmdlet
{
    [Parameter(Position = 0, Mandatory = true)]
    public int Descriptor { get; set; }

    [Parameter(Position = 1, Mandatory = true)]
    public string Operator { get; set; } = "";

    [Parameter(Position = 2)]
    public string? Target { get; set; }

    protected override void EndProcessing()
    {
        string? error;
        if (Operator is ">&" or "<&")
        {
            if (Target == "-")
            {
                BashFdTable.Close(Descriptor);
                FileSystemHelpers.SetLastExitCode(this, 0);
                return;
            }
            error = int.TryParse(Target, out var from)
                ? BashFdTable.Dup(Descriptor, from)
                : $"{Target}: ambiguous redirect";
        }
        else
        {
            error = BashFdTable.Open(Descriptor, FileSystemHelpers.ProviderPath(this, Target ?? ""), Operator);
        }

        if (error is not null)
        {
            FileSystemHelpers.WriteBashError(this, $"exec: {error}");
            FileSystemHelpers.SetLastExitCode(this, 1);
            return;
        }
        FileSystemHelpers.SetLastExitCode(this, 0);
    }
}

/// <summary>Close every descriptor opened by <c>exec</c>: the host runs this when a new invocation starts.</summary>
[Cmdlet(VerbsCommon.Clear, "BashFd")]
public sealed class ClearBashFdCommand : PSCmdlet
{
    protected override void EndProcessing() => BashFdTable.CloseAll();
}

/// <summary><c>cmd &gt;&amp;N</c>: the command's output goes to descriptor N (a pipeline sink).</summary>
[Cmdlet(VerbsCommunications.Write, "BashFd")]
public sealed class WriteBashFdCommand : PSCmdlet
{
    [Parameter(Position = 0, Mandatory = true)]
    public int Descriptor { get; set; }

    [Parameter(ValueFromPipeline = true)]
    public PSObject? InputObject { get; set; }

    protected override void ProcessRecord()
    {
        if (InputObject is null) return;
        var text = BashRuntime.GetBashText(InputObject);
        try
        {
            int std = BashFdTable.Write(Descriptor, BashRuntime.IsUnterminated(InputObject) ? text : text + "\n");
            if (std == 1)
                WriteObject(InputObject);   // a duplicate of stdout: the record just continues down the pipeline
            else if (std == 2)
                InvokeCommand.InvokeScript("param($o) $o | Write-BashHostStderr", InputObject);
        }
        catch (InvalidOperationException ex)
        {
            FileSystemHelpers.WriteBashError(this, ex.Message);
            FileSystemHelpers.SetLastExitCode(this, 1);
        }
    }
}

/// <summary><c>cmd &lt;&amp;N</c>: the rest of descriptor N, one record per line, as the command's stdin.</summary>
[Cmdlet(VerbsCommunications.Read, "BashFd")]
public sealed class ReadBashFdCommand : PSCmdlet
{
    [Parameter(Position = 0, Mandatory = true)]
    public int Descriptor { get; set; }

    protected override void EndProcessing()
    {
        try
        {
            string? line;
            while ((line = BashFdTable.ReadLine(Descriptor)) is not null)
                WriteObject(line);
        }
        catch (InvalidOperationException ex)
        {
            FileSystemHelpers.WriteBashError(this, ex.Message);
            FileSystemHelpers.SetLastExitCode(this, 1);
        }
    }
}
