#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/watch-eval.sh INPUT.ncl [OUTPUT.ncl]

Examples:
  scripts/watch-eval.sh hello.ncl
  scripts/watch-eval.sh hello.ncl hello.evaluated.ncl
  NICKEL_WATCH_INTERVAL=0.25 scripts/watch-eval.sh hello.ncl hello.evaluated.ncl
USAGE
}

if [[ $# -lt 1 || $# -gt 2 ]]; then
  usage >&2
  exit 64
fi

input=$1
output=${2:-"${input%.ncl}.evaluated.ncl"}
interval=${NICKEL_WATCH_INTERVAL:-1}

if ! command -v nickel >/dev/null 2>&1; then
  echo "error: nickel CLI was not found on PATH" >&2
  exit 127
fi

if [[ ! -f "$input" ]]; then
  echo "error: input file does not exist: $input" >&2
  exit 66
fi

input_abs=$(realpath "$input")
output_abs=$(realpath -m "$output")

if [[ "$input_abs" == "$output_abs" ]]; then
  echo "error: output file must be different from input file" >&2
  exit 64
fi

mkdir -p "$(dirname "$output")"

checksum() {
  sha256sum "$input" | awk '{ print $1 }'
}

evaluate() {
  local tmp
  tmp=$(mktemp "${output}.tmp.XXXXXX")

  if nickel eval "$input" >"$tmp"; then
    chmod 0644 "$tmp"
    mv "$tmp" "$output"
    printf '[%s] updated %s\n' "$(date +%H:%M:%S)" "$output"
  else
    rm -f "$tmp"
    printf '[%s] eval failed; left %s unchanged\n' "$(date +%H:%M:%S)" "$output" >&2
  fi
}

last_checksum=

printf 'Watching %s -> %s\n' "$input" "$output"
printf 'Press Ctrl-C to stop.\n'

while true; do
  if [[ ! -f "$input" ]]; then
    printf '[%s] waiting for %s to exist again\n' "$(date +%H:%M:%S)" "$input" >&2
    sleep "$interval"
    continue
  fi

  current_checksum=$(checksum)

  if [[ "$current_checksum" != "$last_checksum" ]]; then
    last_checksum=$current_checksum
    evaluate
  fi

  sleep "$interval"
done
