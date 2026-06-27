# Nickel Playground

A tiny sandbox for experimenting with the [Nickel](https://nickel-lang.org/) configuration language.

## Hello World

Run the example as a Nickel value:

```sh
nickel eval source.ncl
```

## Live Evaluation

Run a watcher that updates an evaluated Nickel file whenever the source changes:

```sh
scripts/watch-eval.sh source.ncl output.ncl
```

The watcher evaluates once immediately, then checks for saved changes every 0.1 seconds. It writes through a temporary file, so `output.ncl` is only replaced after a successful `nickel eval`.

If you are timing from an editor change, make sure the file is being saved immediately. VS Code auto-save delays are included in that stopwatch time because the watcher only sees changes after they hit disk. For a snappier loop, enable Auto Save and lower the delay:

```json
{
  "files.autoSave": "afterDelay",
  "files.autoSaveDelay": 100
}
```

To check more or less often, set `NICKEL_WATCH_INTERVAL`:

```sh
NICKEL_WATCH_INTERVAL=0.25 scripts/watch-eval.sh source.ncl output.ncl
```

## To use scratch while not tracking in Git

Make a `scratch/source.ncl` file, then run:

```sh
scripts/watch-eval.sh scratch/source.ncl scratch/output.ncl
```

When this repository is opened in the VS Code dev container, that scratch watcher
starts automatically via `.devcontainer/devcontainer.json`. Its output is written
to `/tmp/nickel-scratch-watch.log`, and a lock file prevents duplicate watcher
processes if VS Code attaches more than once.
