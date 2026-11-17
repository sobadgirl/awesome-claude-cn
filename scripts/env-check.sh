#!/usr/bin/env bash
# Claude 本地网络与基础环境只读自检脚本 (macOS / Linux)
# 说明：本脚本纯只读运行，不修改任何系统配置，仅请求公开的 ipinfo.io 接口核对当前终端出口与本机时区。
# 来源：https://github.com/sobadgirl/awesome-claude-cn

set -u

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

WARN_COUNT=0

echo ""
echo -e "${CYAN}======================================================${NC}"
echo -e "${CYAN}   Claude 本地环境快速自检工具 (只读安全模式)${NC}"
echo -e "${CYAN}======================================================${NC}"
echo ""

# 1. 检查当前终端出口 IP 与地理位置
echo "▶ [1/4] 正在检测当前终端公网出口 (ipinfo.io) ..."
IP_JSON=$(curl -s --max-time 8 https://ipinfo.io/json || true)

if [ -z "$IP_JSON" ]; then
  echo -e "  ${RED}[异常] 无法连接 ipinfo.io，请检查当前网络或终端是否配置了代理通道。${NC}"
  WARN_COUNT=$((WARN_COUNT + 1))
  IP_COUNTRY=""
  IP_TZ=""
  IP_ORG=""
else
  IP_ADDR=$(printf '%s' "$IP_JSON" | sed -n 's/.*"ip":[[:space:]]*"\([^"]*\)".*/\1/p')
  IP_COUNTRY=$(printf '%s' "$IP_JSON" | sed -n 's/.*"country":[[:space:]]*"\([^"]*\)".*/\1/p')
  IP_CITY=$(printf '%s' "$IP_JSON" | sed -n 's/.*"city":[[:space:]]*"\([^"]*\)".*/\1/p')
  IP_REGION=$(printf '%s' "$IP_JSON" | sed -n 's/.*"region":[[:space:]]*"\([^"]*\)".*/\1/p')
  IP_ORG=$(printf '%s' "$IP_JSON" | sed -n 's/.*"org":[[:space:]]*"\([^"]*\)".*/\1/p')
  IP_TZ=$(printf '%s' "$IP_JSON" | sed -n 's/.*"timezone":[[:space:]]*"\([^"]*\)".*/\1/p')

  # 对 IP 末段做打码显示，保护截屏隐私
  MASKED_IP=$(printf '%s' "$IP_ADDR" | sed -E 's/\.[0-9]+$/.***/')
  echo "  当前终端出口: ${MASKED_IP} (${IP_COUNTRY} - ${IP_REGION} - ${IP_CITY})"
  echo "  运营商 / ASN: ${IP_ORG}"

  if [ "$IP_COUNTRY" = "CN" ] || [ "$IP_COUNTRY" = "HK" ] || [ "$IP_COUNTRY" = "MO" ]; then
    echo -e "  ${RED}[高危] 当前终端出口位于受限地区 (${IP_COUNTRY})！终端默认未走跨境代理，直接运行 Claude Code 极易报错或触发风控。${NC}"
    WARN_COUNT=$((WARN_COUNT + 1))
  else
    echo -e "  ${GREEN}[通过] 出口国家/地区不在直接受限列表 (${IP_COUNTRY})。${NC}"
  fi

  # 常见商业云机房关键字初筛
  if printf '%s' "$IP_ORG" | grep -Eiq "Amazon|AWS|Google|Microsoft|DigitalOcean|Vultr|Choopa|Linode|Akamai|Cloudflare|Alibaba|Tencent|Oracle|Hetzner|OVH|Datacamp|Cogent|Leaseweb|M247"; then
    echo -e "  ${YELLOW}[提醒] 当前 ASN 疑似常见云厂商/商业机房网段 (${IP_ORG})，共享度高时容易受同网段连坐影响，长期主力建议使用独享静态住宅 ISP。${NC}"
    WARN_COUNT=$((WARN_COUNT + 1))
  else
    echo -e "  ${GREEN}[通过] 未命中常见大型公有云机房关键字（建议再打开 ping0.cc 复核是否为原生住宅 ISP）。${NC}"
  fi
fi

echo ""

# 2. 检查系统时区与出口 IP 时区是否一致
echo "▶ [2/4] 正在核对本机系统时区一致性 ..."
LOCAL_TZ=""
if [ -L /etc/localtime ]; then
  LOCAL_TZ=$(readlink /etc/localtime | sed 's|.*/zoneinfo/||')
elif command -v timedatectl >/dev/null 2>&1; then
  LOCAL_TZ=$(timedatectl 2>/dev/null | sed -n 's/.*Time zone:[[:space:]]*\([^[:space:]]*\).*/\1/p')
fi
[ -z "$LOCAL_TZ" ] && LOCAL_TZ=$(date +%Z)

echo "  本机系统时区: ${LOCAL_TZ}"
[ -n "${IP_TZ:-}" ] && echo "  出口 IP 时区: ${IP_TZ}"

if [ "$LOCAL_TZ" = "Asia/Shanghai" ] || [ "$LOCAL_TZ" = "Asia/Chongqing" ] || [ "$LOCAL_TZ" = "CST" ]; then
  echo -e "  ${YELLOW}[提醒] 本机时区仍为东八区 (${LOCAL_TZ})。若挂海外节点登录 Claude，时区与 IP 归属地冲突属于常见风控信号。${NC}"
  WARN_COUNT=$((WARN_COUNT + 1))
elif [ -n "${IP_TZ:-}" ] && [ "$LOCAL_TZ" != "$IP_TZ" ]; then
  echo -e "  ${YELLOW}[提醒] 本机时区 (${LOCAL_TZ}) 与出口 IP 所在时区 (${IP_TZ}) 不完全一致，建议对齐。${NC}"
  WARN_COUNT=$((WARN_COUNT + 1))
else
  echo -e "  ${GREEN}[通过] 本机时区与海外出口匹配。${NC}"
fi

echo ""

# 3. 检查本机是否存在历史客户端目录（针对曾被封号重开用户）
echo "▶ [3/4] 正在扫描本机 Claude 本地目录状态（只读不修改）..."
FOUND_CACHE=0
for p in "$HOME/Library/Application Support/Claude" "$HOME/.claude" "$HOME/.claude.json"; do
  if [ -e "$p" ]; then
    echo "  发现本地目录/配置: $p"
    FOUND_CACHE=1
  fi
done

if [ "$FOUND_CACHE" -eq 1 ]; then
  echo -e "  ${CYAN}[提示] 若当前账号正常使用请忽略；但若这台电脑此前曾有账号被封，重开新号前务必先彻底清理旧缓存目录以防设备连坐。${NC}"
else
  echo -e "  ${GREEN}[干净] 未发现历史 Claude 客户端默认目录。${NC}"
fi

echo ""

# 4. 检查 Node.js 与 Claude Code CLI 环境
echo "▶ [4/4] 正在检查本地 Node.js 与 Claude Code 终端环境 ..."
if command -v node >/dev/null 2>&1; then
  echo -e "  ${GREEN}[已装] Node.js 版本: $(node -v)${NC}"
else
  echo "  [未装] 未检测到 Node.js（如仅使用桌面版/网页版可忽略；使用 Claude Code 需 Node 18+）。"
fi

if command -v claude >/dev/null 2>&1; then
  echo -e "  ${GREEN}[已装] 检测到 claude 命令行工具。${NC}"
else
  echo "  [未装] 未检测到 claude 命令行工具。"
fi

echo ""
echo -e "${CYAN}======================================================${NC}"
if [ "$WARN_COUNT" -eq 0 ]; then
  echo -e "${GREEN}自检完成：未发现明显环境冲突！建议再配合浏览器测一下 WebRTC 与 DNS 泄漏。${NC}"
else
  echo -e "${YELLOW}自检完成：共发现 ${WARN_COUNT} 项潜在环境风险点，建议在注册或充值前先处理完毕。${NC}"
  echo "  • 自己动手排错教程：https://github.com/sobadgirl/use-claude-in-china"
  echo "  • 风控原因深度排查：https://github.com/sobadgirl/claude-fangfen"
  echo "  • 不想折腾？1对1本机原生环境部署（6个月封号全退）：https://github.com/sobadgirl/get-claude-in-china （微信：cjdb2026）"
fi
echo -e "${CYAN}======================================================${NC}"
echo ""
