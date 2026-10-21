using PsBash.Shell.Pty;
using PsBash.Shell.Sessions;
using Xunit;

namespace PsBash.Shell.Tests.Sessions;

public sealed class TerminalBrokerBackpressureTests
{
    // An adversarial stream makes backpressure deterministic on every OS; a local
    // socket may buffer the entire replay without ever blocking the writer.
    [Fact]
    public async Task StalledInitialReplay_IsDroppedAndReleasesFanoutForHealthyClient()
    {
        var history = new ScrollbackBuffer(TerminalBroker.ScrollbackBytes);
        history.Append(new byte[TerminalBroker.ScrollbackBytes]);
        await using var pty = new StubPty();
        var broker = new TerminalBroker(pty, 80, 24, history);
        using var lifetime = new CancellationTokenSource(TimeSpan.FromSeconds(15));
        using var stalled = await ClientStream.CreateAsync(stallWrites: true);
        using var healthy = await ClientStream.CreateAsync(stallWrites: false);
        var blocked = broker.HandleClientAsync(stalled, lifetime.Token);
        Task? following = null;
        try
        {
            await stalled.WriteStarted.Task.WaitAsync(TimeSpan.FromSeconds(3));
            following = broker.HandleClientAsync(healthy, lifetime.Token);
            await following.WaitAsync(TimeSpan.FromSeconds(8));
            await blocked.WaitAsync(TimeSpan.FromSeconds(1));

            Assert.True(stalled.Disposed);
            using var received = new MemoryStream(healthy.Written.ToArray());
            var replay = await TerminalProtocol.ReadAsync(received, lifetime.Token);
            Assert.Equal(TerminalProtocol.Output, replay!.Value.Type);
            Assert.Equal(TerminalBroker.ScrollbackBytes, replay.Value.Payload.Length);
        }
        finally
        {
            lifetime.Cancel();
            await blocked;
            if (following is not null) await following;
        }
    }

    private sealed class StubPty : IPty
    {
        public Stream Input { get; } = new MemoryStream();
        public Stream Output => Stream.Null;
        public IntPtr SlaveHandle => IntPtr.Zero;
        public int SlaveFileDescriptor => -1;
        public string? SlaveName => null;
        public void Resize(short cols, short rows) { }
        public ValueTask DisposeAsync() => Input.DisposeAsync();
    }

    private sealed class ClientStream(MemoryStream input, bool stallWrites) : Stream
    {
        public MemoryStream Written { get; } = new();
        public TaskCompletionSource WriteStarted { get; } = new(TaskCreationOptions.RunContinuationsAsynchronously);
        public bool Disposed { get; private set; }
        private readonly TaskCompletionSource _neverWritable = new(TaskCreationOptions.RunContinuationsAsynchronously);

        public static async Task<ClientStream> CreateAsync(bool stallWrites)
        {
            var input = new MemoryStream();
            await TerminalProtocol.WriteAsync(input, TerminalProtocol.Hello, new byte[] { 0 }, default);
            input.Position = 0;
            return new(input, stallWrites);
        }
        public override ValueTask<int> ReadAsync(Memory<byte> buffer, CancellationToken ct = default) => input.ReadAsync(buffer, ct);
        public override async ValueTask WriteAsync(ReadOnlyMemory<byte> buffer, CancellationToken ct = default)
        {
            WriteStarted.TrySetResult();
            if (stallWrites) await _neverWritable.Task.WaitAsync(ct);
            else await Written.WriteAsync(buffer, ct);
        }
        public override Task FlushAsync(CancellationToken ct) => Task.CompletedTask;
        public override void Flush() { }
        public override bool CanRead => true;
        public override bool CanWrite => true;
        public override bool CanSeek => false;
        public override long Length => throw new NotSupportedException();
        public override long Position { get => throw new NotSupportedException(); set => throw new NotSupportedException(); }
        public override int Read(byte[] buffer, int offset, int count) => input.Read(buffer, offset, count);
        public override void Write(byte[] buffer, int offset, int count) => throw new NotSupportedException();
        public override long Seek(long offset, SeekOrigin origin) => throw new NotSupportedException();
        public override void SetLength(long value) => throw new NotSupportedException();
        protected override void Dispose(bool disposing)
        {
            Disposed = true;
            if (disposing) input.Dispose();
            base.Dispose(disposing);
        }
    }
}
