# Named sessions

A named session is a durable `ps-bash-host` that you address by name instead of by the
launcher that happened to start it. It is the building block for remote and agent use
(B06/B07 in the [production review](production-readiness-review-2026-10-18.md)).

```bash
ps-bash session start build --idle-secs 3600   # create or reuse; stays up for 1 h of silence
PSBASH_SESSION=build ps-bash -c 'cd /src && make'   # attach from any launcher, any time
PSBASH_SESSION=build ps-bash -c 'pwd'               # same host, same runspace pool
ps-bash session list                                # named sessions: name, state, pid, start time
ps-bash session status build
ps-bash session stop build
```

## Guarantees

- **Outlives launchers.** An unnamed host ends with the shell session that spawned it. A named
  host has no such owner; only `session stop` or its idle window ends it. The default idle
  window is 24 h (`--idle-secs N` overrides; `PSBASH_HOST_IDLE_SECS` is honoured if already set).
- **Concurrent across sessions.** Each session is its own host process. Execution inside one
  host is still serialized (cwd and `$env:` are process-global), but two sessions never wait
  on each other. Use one session per independent workload or agent.
- **Name safety.** Names are 1-32 characters of `A-Z a-z 0-9 _ -`; the name becomes part of a
  socket/pipe path, so anything else is refused.
- **Per-user.** Sessions are scoped to the OS user and live under the 0700 runtime directory.

## Stateful by default

`session start` pins ONE runspace for the session's life, so shell variables, functions,
aliases, `export`s and the working directory carry from one `-c` call to the next:

```bash
PSBASH_SESSION=build ps-bash -c 'x=5; cd /src'
PSBASH_SESSION=build ps-bash -c 'echo $x; pwd'     # 5, /src
```

- The launcher does not re-impose its own cwd or environment on a stateful session (it would
  undo the session's `cd`/`export`); only `PSBASH_*` control variables are forwarded.
- A command that faults does not end the session: the pinned runspace is dropped and the next
  call builds a clean one.
- `session start NAME --stateless` gives the older model: a fresh pooled runspace per command.
  `start` refuses to switch a running session between modes; `session stop` it first.
  `session list` shows each session's mode.

## Reattachable terminal

```bash
ps-bash session attach build            # start (or rejoin) the session's shell; Ctrl-] d detaches
ps-bash session attach build --read-only
ssh -t devbox ps-bash session attach build      # remote: a dropped connection loses nothing
```

`attach` starts a detached **terminal broker** (`ps-bash session serve build`, hidden) the first time.
The broker owns a PTY and the interactive shell on it, so the shell, its running programs and its
screen outlive every client. A new client gets the last 1 MiB of output replayed and the shell is nudged
to redraw (a one-row resize and back), so a full-screen program repaints. Several clients may attach at
once; `--read-only` ones watch but cannot type or resize. The broker ends when the shell exits, when
`session stop` is run, or after the idle window with nobody attached (`PSBASH_HOST_IDLE_SECS`, default 24 h).
It ignores SIGHUP, so closing the terminal that started it does not end the session. Diagnostics go to
`terminal-broker.log` in the runtime directory.

The terminal broker is independent of the command host above: `-c` calls run in the stateful runspace,
the terminal runs an interactive shell. They share a name and a lifetime (`session stop` ends both),
not a runspace.

On Windows the broker runs the shell under ConPTY and is covered by the same end-to-end tests as on
Linux; the `attach` client was checked by hand on a Windows console.

## Client contract for front ends (BeagleTerm)

A client needs only: resolve the endpoint (`PSBASH_SESSION=NAME`, same rule as the launcher,
see `IpcTransportFactory.ResolveEndpoint`), speak `HostProtocol` (Health, Shutdown, command
requests), and honour the host's metadata sidecar (`<endpoint>.host.json`) for liveness.

### Terminal protocol

`<endpoint minus .sock>-t.sock`, one AF_UNIX stream, frames `[type:1][length:4 big-endian][payload]`,
payload at most 1 MiB. Client to broker: `H` hello (flags byte, bit 0 = read-only; must be first),
`I` input bytes, `R` resize (cols:2, rows:2), `Q` end the shell. Broker to client: `O` output bytes
(the first frames after hello replay the scrollback), `X` shell exited (exit code:4). Detach = close the
socket. Reference implementation: `src/PsBash.Shell/Sessions/`.
