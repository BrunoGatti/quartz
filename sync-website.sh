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

SHA="$(git rev-parse HEAD)"
echo "Pushed $SHA — waiting for the deploy run to register..."

if ! command -v gh &>/dev/null; then
  echo "gh CLI not found — watch progress manually at https://github.com/BrunoGatti/quartz/actions"
  exit 0
fi

RUN_ID=""
for _ in $(seq 1 15); do
  RUN_ID="$(gh run list --workflow "Deploy Quartz site to GitHub Pages" --commit "$SHA" \
    --json databaseId --jq '.[0].databaseId' 2>/dev/null || true)"
  [ -n "$RUN_ID" ] && break
  sleep 2
done

if [ -z "$RUN_ID" ]; then
  echo "Run didn't register in time — check manually at https://github.com/BrunoGatti/quartz/actions"
  exit 0
fi

gh run watch "$RUN_ID" --exit-status
