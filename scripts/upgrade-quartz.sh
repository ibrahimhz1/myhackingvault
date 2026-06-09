#!/usr/bin/env bash
# scripts/upgrade-quartz.sh
# ─────────────────────────────────────────────────────────────
# Safely upgrades Quartz to the latest upstream version.
#
# Usage:
#   chmod +x scripts/upgrade-quartz.sh
#   ./scripts/upgrade-quartz.sh
#
# What it does:
#   1. Stashes your content (submodule) to avoid merge conflicts
#   2. Pulls latest changes from jackyzha0/quartz upstream
#   3. Reinstalls npm dependencies
#   4. Reinstalls Quartz plugins
#   5. Does a local test build
#
# Your customizations (quartz.config.ts, quartz.layout.ts,
# custom/) are isolated — conflicts are rare and contained.
# ─────────────────────────────────────────────────────────────

set -e

UPSTREAM_REMOTE="upstream"
UPSTREAM_URL="https://github.com/jackyzha0/quartz.git"

echo "╔══════════════════════════════════════╗"
echo "║     Quartz upgrade helper            ║"
echo "╚══════════════════════════════════════╝"

# 1. Ensure upstream remote exists
if ! git remote get-url "$UPSTREAM_REMOTE" &>/dev/null; then
  echo "➕ Adding upstream remote..."
  git remote add "$UPSTREAM_REMOTE" "$UPSTREAM_URL"
fi

# 2. Fetch latest
echo "🔄 Fetching upstream..."
git fetch "$UPSTREAM_REMOTE"

# 3. Show what's changed
echo ""
echo "📋 Changes since your last sync:"
git log HEAD..upstream/main --oneline --no-merges | head -20
echo ""
read -p "Continue with upgrade? (y/N) " -n 1 -r
echo ""
[[ $REPLY =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }

# 4. Cache content (Quartz built-in)
echo "💾 Caching content..."
npx quartz cache || true

# 5. Merge upstream
echo "⬆️  Merging upstream/main..."
if ! git merge "$UPSTREAM_REMOTE/main" --no-edit; then
  echo ""
  echo "⚠️  Merge conflict detected."
  echo "   Conflicts are almost always in quartz.config.ts or quartz.layout.ts."
  echo "   Fix them in your editor, then run:"
  echo "     git add . && git commit"
  echo "   Or to restore your content from cache:"
  echo "     npx quartz restore"
  exit 1
fi

# 6. Reinstall dependencies
echo "📦 Reinstalling npm dependencies..."
npm ci

# 7. Reinstall plugins
echo "🔌 Reinstalling Quartz plugins..."
npx quartz plugin install --from-config

# 8. Test build
echo "🔨 Running test build..."
npx quartz build

echo ""
echo "✅ Upgrade complete! Review the output above, then:"
echo "   git push origin main"
echo "   (GitHub Actions will deploy automatically)"
