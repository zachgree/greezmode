# greezmode

tmux **grids** for parallel agent work: each grid is 2 windows ("pages") × 4 panes,
with a live TUI on top that shows what every grid, window and pane is actually
doing — CPU and memory for the whole process tree, refreshed every couple of
seconds, with a sparkline of where each one has been.

```
Page 1 (window "agents"):   claude | opencode | opencode | plain shell
Page 2 (window "scratch"):  four plain shells, nothing typed
```

## Install

```bash
git clone https://github.com/<you>/greezmode.git
cd greezmode
./install.sh            # -> ~/.local/bin  (or pass a dir: ./install.sh /usr/local/bin)
```

This installs `greezmode` and links `r-greezmode` next to it. Make sure the
target dir is on your `PATH`.

**Requires** `tmux`. The live monitor reads `/proc`, so CPU/memory columns are
Linux-only — everything else (building, resuming and closing grids) works
anywhere tmux does.

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

## Naming

A grid is named after its project directory, so `~/code/api` becomes `api`.
greezmode never reuses a name: if it is taken, the grid becomes `api-2`,
`api-3`, and so on.

`r-greezmode` always reattaches to a live grid, and only builds a new one (with
agents resuming their last conversation) when there is nothing left to attach to.

## Environment overrides

| var | meaning |
| --- | --- |
| `GREEZ_SESSION` | session name to use |
| `GREEZ_CLAUDE` | command for the claude pane (default `claude`) |
| `GREEZ_OPENCODE` | command for the opencode panes (default `opencode`) |
| `GREEZ_REFRESH` | seconds between live samples (default `2`) |
| `GREEZ_MON` | monitor columns on/off (`1`/`0`) |
| `GREEZ_PANES` | per-pane rows on/off (`1`/`0`) |

## License

MIT — see [LICENSE](LICENSE).
