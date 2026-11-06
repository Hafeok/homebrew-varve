#!/usr/bin/env bash
# The release the formula follows (Varve ADR 0226 point 3, H1): the newest
# release of Hafeok/Varve, prereleases included, until a release 1.0.0 or
# later exists; from then on, the newest stable release. Drafts never count.
#
#   script/pick-release.sh [owner/name]     prints the tag
#
# Needs gh, signed in with any token that reads public repositories.
set -euo pipefail
repository="${1:-Hafeok/Varve}"
releases=$(gh api --paginate "repos/$repository/releases?per_page=100" \
  --jq '.[] | select(.draft == false) | [.tag_name, .prerelease, .published_at] | @tsv')
if [ -z "$releases" ]; then echo "no release of $repository" >&2; exit 1; fi
stable=$(printf '%s\n' "$releases" | awk -F '\t' '$2 == "false" && $1 ~ /^v[1-9][0-9]*\.[0-9]+\.[0-9]+$/' | sort -t $'\t' -k3 | tail -1 | cut -f1)
if [ -n "$stable" ]; then
  echo "$stable"
else
  printf '%s\n' "$releases" | sort -t $'\t' -k3 | tail -1 | cut -f1
fi
