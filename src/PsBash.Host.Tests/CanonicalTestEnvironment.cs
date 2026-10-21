using System.Runtime.CompilerServices;
using PsBash.Core.Runtime.Ipc;

namespace PsBash.Host.Tests;

/// <summary>
/// Makes the suite runnable from inside ps-bash itself (the agent's Bash tool, a nested shell).
/// A launcher run by a host-executed command inherits <c>PSBASH_INSIDE_HOST</c>/<c>PSBASH_NEST_DEPTH</c>;
/// <see cref="PsBash.Core.Runtime.IpcWorker"/> then treats every in-process test as a nested call and
/// spawns a private host, so the lifecycle tests that expect to reuse their own daemon never reach it.
/// The tests that need the nested state set it themselves inside a try/finally.
/// </summary>
internal static class CanonicalTestEnvironment
{
    [ModuleInitializer]
    internal static void Initialize()
    {
        Environment.SetEnvironmentVariable(IpcTransportFactory.InsideHostEnvVar, null);
        Environment.SetEnvironmentVariable(IpcTransportFactory.NestDepthEnvVar, null);
    }
}
