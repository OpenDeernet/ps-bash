using System.Collections.Concurrent;
using System.Runtime.InteropServices;

namespace PsBash.Cmdlets;

/// <summary>
/// stat(2) for Linux in-process: <c>statx</c> (glibc 2.28+, one layout on every architecture, unlike
/// <c>struct stat</c>) and the owner/group names via <c>getpwuid_r</c>/<c>getgrgid_r</c>. Replaces one
/// <c>stat -c</c> child process per file in <c>find</c> and <c>ls -l</c>: a spawn per entry cost
/// milliseconds each, and when one failed under load every field silently kept its default, so
/// <c>-nouser</c> matched a file that has an owner.
/// </summary>
[System.Runtime.Versioning.SupportedOSPlatform("linux")]
internal static class LinuxStat
{
    internal readonly record struct Info(
        int Mode, uint Uid, uint Gid, ulong Inode, uint Nlink, ulong Blocks512,
        long CtimeSeconds, uint CtimeNanoseconds, ulong Device);

    private const int AtFdCwd = -100;
    private const int AtSymlinkNoFollow = 0x100;
    private const uint StatxBasicStats = 0x7ff;

    [StructLayout(LayoutKind.Sequential)]
    private struct StatxTimestamp { public long Seconds; public uint Nanoseconds; public int Reserved; }

    // include/uapi/linux/stat.h; the kernel ABI pads it to 256 bytes.
    [StructLayout(LayoutKind.Sequential, Size = 256)]
    private struct Statx
    {
        public uint Mask, BlockSize;
        public ulong Attributes;
        public uint Nlink, Uid, Gid;
        public ushort Mode, Spare0;
        public ulong Inode, Size, Blocks, AttributesMask;
        public StatxTimestamp Atime, Btime, Ctime, Mtime;
        public uint RdevMajor, RdevMinor, DevMajor, DevMinor;
    }

    [DllImport("libc", EntryPoint = "statx", SetLastError = true)]
    private static extern int StatxNative(int dirFd, [MarshalAs(UnmanagedType.LPUTF8Str)] string path, int flags, uint mask, out Statx buf);

    [DllImport("libc", EntryPoint = "getpwuid_r")]
    private static extern int GetPwUidR(uint uid, IntPtr pwd, IntPtr buf, nuint bufLen, out IntPtr result);

    [DllImport("libc", EntryPoint = "getgrgid_r")]
    private static extern int GetGrGidR(uint gid, IntPtr grp, IntPtr buf, nuint bufLen, out IntPtr result);

    /// <summary>stat (<paramref name="follow"/>) or lstat of <paramref name="path"/>; false when it cannot be read.</summary>
    internal static bool TryRead(string path, bool follow, out Info info)
    {
        info = default;
        if (StatxNative(AtFdCwd, path, follow ? 0 : AtSymlinkNoFollow, StatxBasicStats, out var s) != 0) return false;
        info = new Info(
            s.Mode, s.Uid, s.Gid, s.Inode, s.Nlink, s.Blocks,
            s.Ctime.Seconds, s.Ctime.Nanoseconds, MakeDev(s.DevMajor, s.DevMinor));
        return true;
    }

    /// <summary>glibc <c>makedev</c>: the st_dev number <c>stat %d</c> prints.</summary>
    internal static ulong MakeDev(uint major, uint minor)
        => ((ulong)(major & 0xfffff000) << 32) | ((ulong)(major & 0xfff) << 8)
         | ((ulong)(minor & 0xffffff00) << 12) | (minor & 0xff);

    // Names that resolved; an unknown id is asked again next time (an account can be added mid-run).
    private static readonly ConcurrentDictionary<uint, string> UserNames = new();
    private static readonly ConcurrentDictionary<uint, string> GroupNames = new();

    internal static string? UserName(uint uid) => Lookup(UserNames, uid, isUser: true);

    internal static string? GroupName(uint gid) => Lookup(GroupNames, gid, isUser: false);

    private static string? Lookup(ConcurrentDictionary<uint, string> cache, uint id, bool isUser)
    {
        if (cache.TryGetValue(id, out var hit)) return hit;
        var name = ResolveName(id, isUser);
        if (name is not null) cache[id] = name;
        return name;
    }

    /// <summary>The first field of <c>struct passwd</c> / <c>struct group</c> is the name.</summary>
    private static string? ResolveName(uint id, bool isUser)
    {
        const int ERANGE = 34;
        const int RecordBytes = 128; // struct passwd is 48 bytes, struct group 32, on 64-bit glibc
        for (nuint bufLen = 1024; bufLen <= 1 << 20; bufLen *= 4)
        {
            IntPtr record = Marshal.AllocHGlobal(RecordBytes), buf = Marshal.AllocHGlobal((nint)bufLen);
            try
            {
                int rc = isUser
                    ? GetPwUidR(id, record, buf, bufLen, out var result)
                    : GetGrGidR(id, record, buf, bufLen, out result);
                if (rc == ERANGE) continue;
                if (rc != 0 || result == IntPtr.Zero) return null;
                return Marshal.PtrToStringUTF8(Marshal.ReadIntPtr(result));
            }
            finally
            {
                Marshal.FreeHGlobal(buf);
                Marshal.FreeHGlobal(record);
            }
        }
        return null;
    }
}
