#!/bin/sh
git log --graph --date-order --color=always --abbrev-commit --decorate \
  --format='%C(bold blue)%h%C(reset) %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- @@%an@@%C(reset)%C(auto)%d%C(reset)' \
  --all "$@" | sed -E \
  -e 's/\(([0-9]+) seconds? ago\)/\1s/' \
  -e 's/\(([0-9]+) minutes? ago\)/\1m/' \
  -e 's/\(([0-9]+) hours? ago\)/\1h/' \
  -e 's/\(([0-9]+) days? ago\)/\1d/' \
  -e 's/\(([0-9]+) weeks? ago\)/\1w/' \
  -e 's/\(([0-9]+) months? ago\)/\1mo/' \
  -e 's/\(([0-9]+) years? ago\)/\1y/' \
  | perl "$(dirname "$0")/branch-log.pl"
