#!/usr/bin/env bash
# 一键提交 + 推送 + 刷新 jsDelivr CDN 缓存
# 用法：./push.sh "提交说明"      （说明可省略，默认 "update rules"）
set -euo pipefail

cd "$(dirname "$0")"

REPO="snowsky2025/custom_rules"
BRANCH="main"
MSG="${1:-update rules}"

# 无改动直接退出
if [ -z "$(git status --porcelain)" ]; then
  echo "✅ 没有任何改动，无需提交。"
  exit 0
fi

# 1) 收集本次待提交的规则文件（.list / .yaml），换行分隔
CHANGED="$(git status --porcelain | awk '{print $NF}' | grep -E '\.(list|yaml|sgmodule)$' || true)"

# 2) 提交并推送
git add -A
git commit -m "$MSG"
git push origin "$BRANCH"
echo "✅ 已推送：$MSG"

# 3) 刷新 jsDelivr 缓存
if [ -z "$CHANGED" ]; then
  echo "ℹ️  本次没有改动规则文件(.list/.yaml/.sgmodule)，跳过 CDN 刷新。"
  exit 0
fi

echo "🔄 刷新 jsDelivr 缓存："
while IFS= read -r f; do
  [ -z "$f" ] && continue
  url="https://purge.jsdelivr.net/gh/${REPO}@${BRANCH}/${f}"
  if curl -fsS "$url" >/dev/null; then
    echo "   ✔ $f"
  else
    echo "   ✘ $f （purge 失败，可稍后重试或等待自动过期）"
  fi
done <<< "$CHANGED"

echo "🎉 完成。到 Surge / Clash 里「更新资源」即可拉到最新规则。"
