#!/usr/bin/env bash
#
# Fallback autobump for formulae that livecheck cannot resolve.
#
# `brew bump` relies on each formula's `livecheck` block. For formulae whose
# upstream cannot be checked that way (livecheck reports "Unable to get
# versions"), this script reads the upstream GitHub tags directly and opens a
# version-bump PR when a newer *stable* tag exists.
#
# It is best-effort: every step tolerates failures so one bad formula never
# aborts the run. Only GitHub-hosted sources can be handled; formulae on lab
# pages / FTP mirrors are skipped (no tags to read).
#
# Requires: HOMEBREW_GITHUB_API_TOKEN (opens the PRs) and GH_TOKEN (gh api).
set -uo pipefail

tap="brewsci/bio"

echo "==> Collecting formulae that livecheck cannot resolve"
mapfile -t blind < <(
  brew livecheck --tap "$tap" --formulae 2>&1 \
    | grep -iE 'unable to get versions|no version information' \
    | grep -oE "$tap/[A-Za-z0-9._@+-]+" \
    | sed "s#$tap/##" \
    | sort -u
)
echo "    ${#blind[@]} livecheck-blind formulae"

bumped=0
for f in "${blind[@]}"; do
  info=$(brew info --json=v2 --formula "$tap/$f" 2>/dev/null) || continue

  cur=$(jq -r '.formulae[0].versions.stable // empty' <<<"$info")
  [ -z "$cur" ] && continue

  # Canonical GitHub "owner/repo" from the stable URL, head URL, or homepage.
  repo=$(jq -r '.formulae[0] | (.urls.stable.url // ""), (.urls.head.url // ""), (.homepage // "")' <<<"$info" \
    | grep -oiE 'github\.com[/:][^/"]+/[^/"[:space:]]+' \
    | head -1 \
    | sed -E 's#.*github\.com[/:]##; s#\.git$##')
  [ -z "$repo" ] && continue

  # Latest stable tag: numeric, no pre-release markers, leading v/V stripped.
  latest=$(gh api "repos/$repo/tags" --paginate --jq '.[].name' 2>/dev/null \
    | grep -iE '^v?[0-9]' \
    | grep -viE 'rc|beta|alpha|-?pre|dev|snapshot|nightly' \
    | sed -E 's/^[vV]//' \
    | sort -V \
    | tail -1)
  [ -z "$latest" ] && continue

  # Only bump when the newest tag is strictly greater than the current version.
  newest=$(printf '%s\n%s\n' "$cur" "$latest" | sort -V | tail -1)
  if [ "$newest" = "$latest" ] && [ "$cur" != "$latest" ]; then
    echo "==> git-direct bump: $f $cur -> $latest ($repo)"
    if brew bump-formula-pr --no-audit --no-browse --version="$latest" "$tap/$f"; then
      bumped=$((bumped + 1))
    else
      echo "    bump failed for $f -> $latest (skipped)"
    fi
  fi
done

echo "==> git-direct opened $bumped PR(s)"
