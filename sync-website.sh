#!/usr/bin/env bash
# Syncs brain/website/ (the markdown source of truth, edited in Obsidian) into
# this repo's content/ folder, commits, and pushes to v4 — which triggers the
# existing GitHub Actions workflow to build and deploy to GitHub Pages.
#
# Content and framework are deliberately kept in separate repos: this repo
# should stay a clean, easy-to-update fork of upstream Quartz, with content/
# fully regenerated (not hand-edited) by this script every time.
set -euo pipefail

BRAIN_DIR="${BRAIN_DIR:-$HOME/brain}"
QUARTZ_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WEBSITE_SRC="$BRAIN_DIR/website"

if [ ! -d "$WEBSITE_SRC" ]; then
  echo "error: $WEBSITE_SRC not found (set BRAIN_DIR if brain isn't at ~/brain)" >&2
  exit 1
fi

rm -rf "$QUARTZ_DIR/content"
mkdir -p "$QUARTZ_DIR/content"
cp -r "$WEBSITE_SRC/." "$QUARTZ_DIR/content/"

cd "$QUARTZ_DIR"
git add content
if git diff --cached --quiet; then
  echo "content/ unchanged, nothing to sync."
  exit 0
fi

git commit -m "Sync content from brain/website ($(date -u +%Y-%m-%dT%H:%M:%SZ))"
git push origin v4
echo "Pushed — build will run at https://github.com/BrunoGatti/quartz/actions"
