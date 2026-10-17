using System.Management.Automation;
using PsBash.Core;

namespace PsBash.Cmdlets;

/// <summary>
/// <c>… | ConvertTo-BashNativeStdin NAME | NAME args</c>: what a pipe, a <c>&lt; file</c>, a heredoc or a
/// here-string feeds a program, as the BYTES bash would write.
/// <para>
/// PowerShell hands a native program one formatted STRING per pipeline object and ends each with
/// <c>\r\n</c> — so every <c>\n</c> became <c>\r\n</c> (<c>ssh host 'bash -s' &lt; script</c> failed with
/// <c>$'hostname\r'</c>), an unterminated last line gained a newline, and bytes that are not UTF-8 were
/// re-encoded. A <c>byte[]</c> object is the one thing it writes raw (and streams), so when NAME resolves to
/// a real program every record becomes its exact bytes (<see cref="NativeStdinBridge.RecordBytes"/>: the text,
/// plus a <c>\n</c> unless the record is unterminated).
/// </para>
/// <para>
/// When NAME is a function, alias or cmdlet (which PowerShell would run instead) it must keep receiving what
/// it always did — the record's TEXT — so only a resolved application gets bytes. Resolution is at run time,
/// exactly as <see cref="EnterBashNativeStdinCommand"/> does it, because the emitter cannot know what a name
/// resolves to.
/// </para>
/// </summary>
[Cmdlet(VerbsData.ConvertTo, "BashNativeStdin")]
[OutputType(typeof(byte[]), typeof(string))]
public sealed class ConvertToBashNativeStdinCommand : PSCmdlet
{
    [Parameter(Mandatory = true, Position = 0)]
    public string Name { get; set; } = "";

    [Parameter(ValueFromPipeline = true)]
    [AllowNull]
    [AllowEmptyString]
    public object? InputObject { get; set; }

    private bool _native;

    protected override void BeginProcessing() => _native = EnterBashNativeStdinCommand.ResolvesToApplication(this, Name);

    protected override void ProcessRecord()
    {
        if (!_native)
        {
            WriteObject(BashRuntime.GetBashText(InputObject));
            return;
        }

        var bytes = NativeStdinBridge.RecordBytes(InputObject);
        if (bytes.Length > 0) WriteObject(bytes, enumerateCollection: false);
    }
}
