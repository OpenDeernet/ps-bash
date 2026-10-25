namespace PsBash.Spec;

/// <summary>A fresh scratch directory (holding an empty <c>_tmp</c>, the Oils harness convention) per case, so cases never see each other's files.</summary>
public sealed class CaseDir : IDisposable
{
    public string Path { get; }

    public CaseDir()
    {
        Path = System.IO.Path.Combine(System.IO.Path.GetTempPath(), "ps-bash", "spec-run", Guid.NewGuid().ToString("N"));
        Directory.CreateDirectory(System.IO.Path.Combine(Path, "_tmp"));
    }

    public void Dispose()
    {
        try { Directory.Delete(Path, recursive: true); } catch { /* best effort: read-only files or a lingering handle */ }
    }
}
