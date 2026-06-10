#!/usr/bin/env bash
# scripts/upgrade-quartz.sh
# ════════════════════════════════════════════════════════════
# Safely upgrades Quartz v5 to the latest upstream version.
#
# Usage:
#   chmod +x scripts/upgrade-quartz.sh
#   ./scripts/upgrade-quartz.sh
#
# What it does:
#   1. Adds upstream remote if missing
#   2. Fetches latest changes from jackyzha0/quartz
#   3. Shows what changed
#   4. Caches content (Quartz built-in restore point)
#   5. Merges — conflicts will be in quartz.config.yaml ONLY
#   6. Reinstalls npm + plugins
#   7. Test build locally
# ════════════════════════════════════════════════════════════

set -e

UPSTREAM_REMOTE="upstream"
UPSTREAM_URL="https://github.com/jackyzha0/quartz.git"

echo ""
echo "╔══════════════════════════════════════╗"
echo "║    Quartz v5 upgrade helper          ║"
echo "╚══════════════════════════════════════╝"
echo ""

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
echo "📋 Commits since your last sync:"
git log HEAD..upstream/main --oneline --no-merges | head -20
echo ""
read -p "Continue with upgrade? (y/N) " -n 1 -r
echo ""
[[ $REPLY =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }

# 4. Cache content (Quartz built-in)
echo "💾 Caching content..."
npx quartz cache 2>/dev/null || true

# 5. Merge upstream
echo "⬆️  Merging upstream/main..."
if ! git merge "$UPSTREAM_REMOTE/main" --no-edit; then
  echo ""
  echo "⚠️  Merge conflict."
  echo "   Conflicts are almost always in quartz.config.yaml"
  echo "   Fix in your editor, then: git add . && git commit"
  echo "   Or restore content: npx quartz restore"
  exit 1
fi

# 6. Reinstall
echo "📦 Reinstalling npm dependencies..."
npm ci

echo "🔌 Reinstalling Quartz plugins..."
npx quartz plugin install

# 7. Test build
echo "🔨 Test build..."
npx quartz build

echo ""
echo "✅ Done! Review output above, then push:"
echo "   git push origin main"
