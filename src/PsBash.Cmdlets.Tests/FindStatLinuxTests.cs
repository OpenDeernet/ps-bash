using System.Diagnostics;
using System.Globalization;
using Xunit;

namespace PsBash.Cmdlets.Tests;

/// <summary>
/// <see cref="FindStat"/> on Linux reads stat(2) in-process (<see cref="LinuxStat"/>), no longer one
/// <c>stat -c</c> child per file (a spawn per entry in find/ls -l, and a failed spawn under load left
/// every field at its default, so <c>-nouser</c> matched an owned file). Oracle: coreutils
/// <c>stat</c> on the same paths, every field find uses, ctime to the nanosecond.
/// </summary>
public class FindStatLinuxTests : IDisposable
{
    private readonly string _dir = Directory.CreateTempSubdirectory("psbash-findstat-").FullName;

    public void Dispose()
    {
        try { Directory.Delete(_dir, recursive: true); } catch { /* best effort */ }
    }

    private static string CoreutilsStat(string path, bool follow)
    {
        var psi = new ProcessStartInfo("stat") { RedirectStandardOutput = true, UseShellExecute = false };
        foreach (var a in new[] { "-c", "%f|%u|%g|%U|%G|%i|%h|%b|%.9Z|%d" }) psi.ArgumentList.Add(a);
        if (follow) psi.ArgumentList.Add("-L");
        psi.ArgumentList.Add("--");
        psi.ArgumentList.Add(path);
        using var p = Process.Start(psi)!;
        var text = p.StandardOutput.ReadToEnd().Trim();
        p.WaitForExit();
        Assert.Equal(0, p.ExitCode);
        return text;
    }

    private static string Fields(FindStat s)
    {
        int typeBits = s.TypeChar switch { 'd' => 0x4000, 'l' => 0xA000, 'p' => 0x1000, 's' => 0xC000, 'c' => 0x2000, 'b' => 0x6000, _ => 0x8000 };
        long ns = (s.Ctime.ToUniversalTime() - DateTime.UnixEpoch).Ticks * 100;
        return string.Join("|",
            (typeBits | s.Mode).ToString("x", CultureInfo.InvariantCulture), s.Uid, s.Gid, s.User, s.Group,
            s.Inode, s.Nlink, s.Blocks512, $"{ns / 1_000_000_000}.{ns % 1_000_000_000:D9}", s.Device);
    }

    /// <summary>DateTime holds 100 ns ticks: the last two digits of stat's nanoseconds are below its resolution.</summary>
    private static string TruncateToTicks(string statFields)
    {
        var f = statFields.Split('|');
        f[8] = f[8][..^2] + "00";
        return string.Join("|", f);
    }

    [SkippableFact]
    public void Read_FileDirAndSymlink_MatchCoreutilsStat()
    {
        Skip.IfNot(OperatingSystem.IsLinux(), "LinuxStat is the Linux path; macOS/Windows keep their own readers.");
        var file = Path.Combine(_dir, "a.txt");
        File.WriteAllText(file, new string('x', 5000));
        var link = Path.Combine(_dir, "to-a");
        File.CreateSymbolicLink(link, file);

        var fileInfo = new FileInfo(file);
        var dirInfo = new DirectoryInfo(_dir);
        var linkInfo = new FileInfo(link);

        Assert.Equal(TruncateToTicks(CoreutilsStat(file, follow: false)), Fields(FindStat.Read(fileInfo, fileInfo, following: false)));
        Assert.Equal(TruncateToTicks(CoreutilsStat(_dir, follow: false)), Fields(FindStat.Read(dirInfo, dirInfo, following: false)));
        Assert.Equal(TruncateToTicks(CoreutilsStat(link, follow: false)), Fields(FindStat.Read(linkInfo, linkInfo, following: false)));
        Assert.Equal(TruncateToTicks(CoreutilsStat(link, follow: true)), Fields(FindStat.Read(linkInfo, fileInfo, following: true)));
    }

    [SkippableFact]
    public void Read_OwnedFile_KnowsItsOwnerAndGroup()
    {
        Skip.IfNot(OperatingSystem.IsLinux(), "LinuxStat is the Linux path.");
        var info = new DirectoryInfo(_dir);
        var s = FindStat.Read(info, info, following: false);
        Assert.True(s.UserKnown, "the test's own temp dir has an owner with a passwd entry");
        Assert.True(s.GroupKnown);
        Assert.Equal(Environment.UserName, s.UserName);
    }
}
