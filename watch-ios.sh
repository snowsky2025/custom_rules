#!/usr/bin/env bash
# 通过 Mac 的 surge-cli 远程监控 iOS Surge 的实时请求
# 连接信息放在同目录、不提交的 .surge-ios 文件里：
#     REMOTE=密钥@iPhoneIP:端口        例如 REMOTE=abc123@192.168.1.5:6171
# 用法：
#     ./watch-ios.sh            # 实时监控，默认高亮过滤 UC 相关域名
#     ./watch-ios.sh uc.cn      # 自定义过滤关键词
#     ./watch-ios.sh -          # 不过滤，输出全部请求
#     ./watch-ios.sh --recent   # 拉取最近请求(一次性，非流式)
set -uo pipefail
cd "$(dirname "$0")"

SC="/Applications/Surge.app/Contents/Applications/surge-cli"
[ -x "$SC" ] || SC="$(command -v surge-cli)"
[ -x "$SC" ] || { echo "❌ 找不到 surge-cli"; exit 1; }

# 读取连接信息
if [ -f .surge-ios ]; then
  # shellcheck disable=SC1091
  source .surge-ios
fi
REMOTE="${REMOTE:-${SURGE_IOS_REMOTE:-}}"
if [ -z "$REMOTE" ]; then
  echo "❌ 缺少连接信息。请在 ~/custom_rules/.surge-ios 写入一行："
  echo "   REMOTE=密钥@iPhoneIP:端口   （如 REMOTE=abc123@192.168.1.5:6171）"
  exit 1
fi

# 默认过滤关键词：UC 浏览器相关
FILTER="${1:-uc.cn|ucweb|sm\\.cn|uczzd|9apps}"

# --recent：一次性拉最近请求
if [ "${1:-}" = "--recent" ]; then
  echo "📥 最近请求（远程 iOS）："
  "$SC" --remote "$REMOTE" --raw dump recent
  exit 0
fi

echo "🔗 连接 iOS Surge：$REMOTE"
echo "👀 实时监控请求中，过滤关键词：${FILTER}（Ctrl+C 退出）"
echo "   现在去 iPhone 上杀掉 UC 后台再重新打开，触发开屏广告……"
echo "------------------------------------------------------------"

if [ "$FILTER" = "-" ]; then
  "$SC" --remote "$REMOTE" --raw watch request
else
  "$SC" --remote "$REMOTE" --raw watch request | grep --line-buffered -iE "$FILTER"
fi
