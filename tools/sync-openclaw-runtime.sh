#!/usr/bin/env bash
set -euo pipefail

# Sync canonical specs from spec/ into the openclaw/ runtime tree.
# This does NOT touch memory/state; it only updates config-style files.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

cp spec/SOUL.md        openclaw/SOUL.md
cp spec/USER.md        openclaw/USER.md
cp spec/USER-ROLE.md   openclaw/USER-ROLE.md
cp spec/AGENTS.md      openclaw/AGENTS.md
cp spec/ENGINEERING.md openclaw/ENGINEERING.md
cp spec/IDENTITY.md    openclaw/IDENTITY.md
cp spec/HEARTBEAT.md   openclaw/HEARTBEAT.md
cp spec/TOOLS.md       openclaw/TOOLS.md

echo "Synced spec/ → openclaw/ runtime files."