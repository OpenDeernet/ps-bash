namespace PsBash.Spec;

/// <summary>A fresh scratch directory (holding an empty <c>_tmp</c>, the Oils harness convention) per case, so cases never see each other's files.</summary>
public sealed class CaseDir : IDisposable
{
    public string Path { get; }

    /// <param name="script">The case's script; <c>_tmp</c> is created only when it mentions one (an extra entry would show up in <c>ls</c> output).</param>
    public CaseDir(string script)
    {
        Path = System.IO.Path.Combine(System.IO.Path.GetTempPath(), "ps-bash", "spec-run", Guid.NewGuid().ToString("N"));
        Directory.CreateDirectory(script.Contains("_tmp", StringComparison.Ordinal) ? System.IO.Path.Combine(Path, "_tmp") : Path);
    }

    public void Dispose()
    {
        try { Directory.Delete(Path, recursive: true); } catch { /* best effort: read-only files or a lingering handle */ }
    }
}
