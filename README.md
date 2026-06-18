# minimax

Installs a global `mmxcode` command that launches Claude Code with MiniMax as the backend.

It uses MiniMax's Anthropic-compatible endpoint, so no proxy or translation layer is required.

## Requirements

- macOS / Linux with `bash`
- `make`
- [Claude Code](https://docs.anthropic.com/claude-code) (`claude` must be on your PATH)
- A MiniMax API key (issue one at [minimax.io](https://www.minimax.io/platform))

## Setup

```bash
make install
```

This will:

1. Copy `.env.example` to `.env` if it doesn't exist (with `chmod 600`)
2. Generate `~/.local/bin/mmxcode`, with the absolute path to *this directory's* `.env` baked in
3. Warn you if `~/.local/bin` is not on your PATH

After install, open `.env` and fill in your API key.

## `.env` variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `MINIMAX_API_KEY` | yes | — | Your MiniMax API key (`sk-cp-...`) |
| `ANTHROPIC_MODEL` | no | `MiniMax-M3` | Primary model |
| `ANTHROPIC_DEFAULT_OPUS_MODEL` | no | `MiniMax-M3` | Model for the Opus slot |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | no | `MiniMax-M3` | Model for the Sonnet slot |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | no | `MiniMax-M3` | Model for the Haiku slot |
| `API_TIMEOUT_MS` | no | `3000000` | API request timeout in milliseconds |
| `CLAUDE_CODE_AUTO_COMPACT_WINDOW` | no | `512000` | Token window before auto-compaction |

The minimum viable `.env` is just:

```dotenv
MINIMAX_API_KEY=sk-cp-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

## Usage

From any directory:

```bash
mmxcode
```

This loads this repo's `.env` and starts Claude Code with MiniMax as the backend.

Arguments are passed through to `claude` verbatim:

```bash
mmxcode --help
mmxcode -p "Review my TypeScript type definitions"
```

## How it works

The `mmxcode` command is a thin shell script. At install time, the absolute path to this directory's `.env`
is baked in. At runtime, it sources that `.env` and exports the Anthropic-compatible variables before
`exec`-ing `claude`:

- `ANTHROPIC_BASE_URL=https://api.minimax.io/anthropic`
- `ANTHROPIC_AUTH_TOKEN=$MINIMAX_API_KEY`
- The model and runtime overrides listed above

If `ANTHROPIC_API_KEY` is set in your environment it would shadow `AUTH_TOKEN`, so the script `unset`s it
before launching `claude`.

## Uninstall

```bash
make uninstall
```

This removes `~/.local/bin/mmxcode`. The `.env` file is left in place — delete it manually if you no
longer need it.

## Troubleshooting

**`mmxcode: command not found`**
`~/.local/bin` is not on your PATH. Add this to your shell rc (e.g. `~/.zshrc`):
```bash
export PATH="$HOME/.local/bin:$PATH"
```

**`mmxcode: MINIMAX_API_KEY is empty`**
The right-hand side of `MINIMAX_API_KEY=` in `.env` is blank. Fill it in.

**You moved the project to a different directory**
The script has the old absolute path baked in. Re-run `make install` from the new location.

**You want a different install prefix**
```bash
make install PREFIX=/opt/local
```
This installs to `/opt/local/bin/mmxcode` instead.
