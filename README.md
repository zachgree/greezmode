# greezmode

tmux **grids** for parallel agent work: each grid is 2 windows ("pages") × 4 panes,
with a live TUI on top that shows what every grid, window and pane is actually
doing — CPU and memory for the whole process tree, refreshed every couple of
seconds, with a sparkline of where each one has been.

```
Page 1 (window "agents"):   agent | agent | agent | plain shell
Page 2 (window "scratch"):  four plain shells, nothing typed
```

Which agent CLI runs in those first three panes is configurable — see
[Choosing your agent CLIs](#choosing-your-agent-clis).

---

## Setup

### 1. Prerequisites

| | |
| --- | --- |
| **tmux** | required — greezmode refuses to start without it |
| **bash 4+** | required (macOS ships bash 3.2; `brew install bash`) |
| your agent CLIs | optional — panes that can't find their command just drop to a shell |

Install tmux:

```bash
sudo apt install tmux        # Debian / Ubuntu
brew install tmux            # macOS
sudo dnf install tmux        # Fedora
```

> **Note:** the live CPU/memory monitor reads `/proc`, so those columns are
> Linux-only. On macOS everything else — building, resuming, listing and
> closing grids — works normally; the monitor columns just stay empty.

### 2. Install

```bash
git clone https://github.com/zachgree/greezmode.git
cd greezmode
./install.sh
```

This copies `greezmode` into `~/.local/bin` and creates the `r-greezmode`
symlink beside it. To install somewhere else, pass the directory:

```bash
./install.sh /usr/local/bin        # may need sudo
```

### 3. Put it on your PATH

`install.sh` tells you if the target directory isn't on your `PATH`. If it
isn't, add it to your shell rc and reload:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc   # or ~/.zshrc
source ~/.bashrc
```

### 4. Verify

```bash
greezmode --help        # prints usage
greezmode --list        # lists grids (empty on a fresh install — that's fine)
```

### 5. First grid

```bash
cd ~/code/some-project
greezmode --new
```

That builds a grid named after the directory and drops you into it. Detach with
`ctrl-b d`, then run `greezmode` on its own to get the TUI over everything.

### Updating

```bash
cd greezmode && git pull && ./install.sh
```

`install.sh` overwrites the installed copy, so if you've edited
`~/.local/bin/greezmode` in place, diff it first:

```bash
diff ~/.local/bin/greezmode ./greezmode
```

### Uninstall

```bash
rm ~/.local/bin/greezmode ~/.local/bin/r-greezmode
```

Grids are just tmux sessions; close any leftovers with `tmux kill-session -t <name>`.

---

## Usage

```bash
greezmode                 # live TUI over every grid: resume, close, build new
greezmode --new [dir]     # skip the TUI, build a new grid (default: current dir)
greezmode -n scratch      # build a new grid named "scratch"
greezmode ~/code/api      # build a new grid there, session named after the dir
greezmode --list          # plain text listing (with cpu/mem), no TUI
greezmode --top           # full-screen monitor only, no grid management
r-greezmode               # resume the grid you were last in, no TUI
r-greezmode ~/code/api    # resume that project's grid
```

### TUI keys

| key | action |
| --- | --- |
| `↑`/`↓` or `j`/`k` | move |
| `enter` | resume |
| `x` | close |
| `n` | new grid |
| `p` | panes on/off |
| `m` | monitor on/off |
| `s` | sort by cpu |
| `+`/`-` | refresh interval |
| `a` | show non-greez tmux sessions too |
| `r` | refresh now |
| `q` | quit |

A grid row resumes or closes the whole grid; an indented window row resumes
straight to that window, or closes just that window.

### Naming

A grid is named after its project directory, so `~/code/api` becomes `api`.
greezmode never reuses a name: if it is taken, the grid becomes `api-2`,
`api-3`, and so on.

`r-greezmode` always reattaches to a live grid, and only builds a new one (with
agents resuming their last conversation) when there is nothing left to attach to.

---

## Choosing your agent CLIs

The three agent panes run whatever commands you point them at. Set these in
your shell rc to use a different tool, or to pass your own flags:

```bash
export GREEZ_CLAUDE="my-agent"          # pane 1
export GREEZ_OPENCODE="another-agent"   # panes 2 and 3
```

Any pane whose command isn't installed falls back to a plain shell, so greezmode
is usable with none of them, one of them, or your own tooling entirely.

### All environment overrides

| var | meaning | default |
| --- | --- | --- |
| `GREEZ_SESSION` | session name to use | derived from directory |
| `GREEZ_CLAUDE` | command for agent pane 1 | `claude` |
| `GREEZ_OPENCODE` | command for agent panes 2 and 3 | `opencode` |
| `GREEZ_REFRESH` | seconds between live samples | `2` |
| `GREEZ_MON` | monitor columns on/off (`1`/`0`) | `1` |
| `GREEZ_PANES` | per-pane rows on/off (`1`/`0`) | `1` |

---

## License

MIT — see [LICENSE](LICENSE).
