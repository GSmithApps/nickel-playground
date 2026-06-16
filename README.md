# Nickel Playground

A tiny sandbox for experimenting with the [Nickel](https://nickel-lang.org/) configuration language.

## Hello World

Run the example as a Nickel value:

```sh
nickel eval hello.ncl
```

## Live Evaluation

Run a watcher that updates an evaluated Nickel file whenever the source changes:

```sh
scripts/watch-eval.sh hello.ncl hello.evaluated.ncl
```

The watcher evaluates once immediately, then checks for changes every second. It writes through a temporary file, so `hello.evaluated.ncl` is only replaced after a successful `nickel eval`.

To check more often, set `NICKEL_WATCH_INTERVAL`:

```sh
NICKEL_WATCH_INTERVAL=0.25 scripts/watch-eval.sh hello.ncl hello.evaluated.ncl
```
