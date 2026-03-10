#!/usr/bin/env bash
# @author TomDiary
# @lastTime 2026-03-10
# @version 0.1.0
# 使用 nexttrace 回程脚本（从指定节点 trace 回本机）

# 字体颜色
FONT_BLACK="\033[30m"
FONT_RED="\033[31m"
FONT_GREEN="\033[32m"
FONT_YELLOW="\033[33m"
FONT_BLUE="\033[34m"
FONT_PURPLE="\033[35m"
FONT_SKYBLUE="\033[36m"
FONT_WHITE="\033[37m"
FONT_SUFFIX="\033[0m"

# 背景色（用于节点标题）
BG_BLUE="\033[44m"
BG_CYAN="\033[46m"
NODE_TITLE="${BG_BLUE}${FONT_WHITE}"

# 输出语句颜色
MSG_INFO="${FONT_BLUE} [Info] ${FONT_SUFFIX}"
MSG_WARNING="${FONT_YELLOW} [Warning] ${FONT_SUFFIX}"
MSG_DEG="${FONT_PURPLE} [Debug] ${FONT_SUFFIX}"
MSG_ERROR="${FONT_RED} [Error] ${FONT_SUFFIX}"
MSG_SUCCESS="${FONT_GREEN} [Success] ${FONT_SUFFIX}"
MSG_FAIL="${FONT_SKYBLUE} [Failed] ${FONT_SUFFIX}"

set -e

# 回程IP：4-IPv4，6-IPv6，默认IPv4
TRACE_IPVER=4
# 回程语言：cn-中文，en-英文，默认中文
TRACE_LANG=cn
# IPv4 回程节点列表
NODES_IPV4=(
  "北京电信|163 AS4134|ipv4.pek-4134.endpoint.nxtrace.org"
  "上海电信|163 AS4134|ipv4.sha-4134.endpoint.nxtrace.org"
  # "上海电信|CN2 AS4809|ipv4.sha-4809.endpoint.nxtrace.org"
  # "杭州电信|163 AS4134|ipv4.hgh-4134.endpoint.nxtrace.org"
  "广州电信|163 AS4134|ipv4.can-4134.endpoint.nxtrace.org"
  "北京联通|169 AS4837|ipv4.pek-4837.endpoint.nxtrace.org"
  # "北京联通|A网 AS9929|ipv4.pek-9929.endpoint.nxtrace.org"
  "上海联通|169 AS4837|ipv4.sha-4837.endpoint.nxtrace.org"
  # "杭州联通|169 AS4837|ipv4.hgh-4837.endpoint.nxtrace.org"
  "广州联通|169 AS4837|ipv4.can-4837.endpoint.nxtrace.org"
  "北京移动|骨干网 AS9808|ipv4.pek-9808.endpoint.nxtrace.org"
  # "北京移动|CMIN2 AS58807|ipv4.pek-58807.endpoint.nxtrace.org"
  "上海移动|骨干网 AS9808|ipv4.sha-9808.endpoint.nxtrace.org"
  # "上海移动|CMIN2 AS58807|ipv4.sha-58807.endpoint.nxtrace.org"
  # "杭州移动|骨干网 AS9808|ipv4.hgh-9808.endpoint.nxtrace.org"
  "广州移动|骨干网 AS9808|ipv4.can-9808.endpoint.nxtrace.org"
  "北京教育网|CERNET AS4538|ipv4.pek-4538.endpoint.nxtrace.org"
  "上海教育网|CERNET AS4538|ipv4.sha-4538.endpoint.nxtrace.org"
  "杭州教育网|CERNET AS4538|ipv4.hgh-4538.endpoint.nxtrace.org"
  "合肥科技网|AS7497|ipv4.hfe-7497.endpoint.nxtrace.org"
)
# IPv6 回程节点列表
NODES_IPV6=(
  "北京电信|163 AS4134|ipv6.pek-4134.endpoint.nxtrace.org"
  "上海电信|163 AS4134|ipv6.sha-4134.endpoint.nxtrace.org"
  # "上海电信|CN2 AS4809|ipv6.sha-4809.endpoint.nxtrace.org"
  # "杭州电信|163 AS4134|ipv6.hgh-4134.endpoint.nxtrace.org"
  "广州电信|163 AS4134|ipv6.can-4134.endpoint.nxtrace.org"
  "北京联通|169 AS4837|ipv6.pek-4837.endpoint.nxtrace.org"
  # "北京联通|A网 AS9929|ipv6.pek-9929.endpoint.nxtrace.org"
  "上海联通|169 AS4837|ipv6.sha-4837.endpoint.nxtrace.org"
  # "杭州联通|169 AS4837|ipv6.hgh-4837.endpoint.nxtrace.org"
  "广州联通|169 AS4837|ipv6.can-4837.endpoint.nxtrace.org"
  "北京移动|骨干网 AS9808|ipv6.pek-9808.endpoint.nxtrace.org"
  # "北京移动|CMIN2 AS58807|ipv6.pek-58807.endpoint.nxtrace.org"
  "上海移动|骨干网 AS9808|ipv6.sha-9808.endpoint.nxtrace.org"
  # "上海移动|CMIN2 AS58807|ipv6.sha-58807.endpoint.nxtrace.org"
  # "杭州移动|骨干网 AS9808|ipv6.hgh-9808.endpoint.nxtrace.org"
  "广州移动|骨干网 AS9808|ipv6.can-9808.endpoint.nxtrace.org"
  "北京教育网|CERNET AS4538|ipv6.pek-4538.endpoint.nxtrace.org"
  "上海教育网|CERNET AS4538|ipv6.sha-4538.endpoint.nxtrace.org"
  "杭州教育网|CERNET AS4538|ipv6.hgh-4538.endpoint.nxtrace.org"
  "合肥科技网|AS7497|ipv6.hfe-7497.endpoint.nxtrace.org"
)

# 检查并安装 nexttrace
check_nexttrace() {
  if command -v nexttrace &>/dev/null; then
    return 0
  fi
  if [ "$TRACE_LANG" = "en" ]; then
    echo "[Info] nexttrace not found, attempting install..."
  else
    echo "[Info] nexttrace 未找到，尝试安装..."
  fi
  if command -v curl &>/dev/null; then
    curl -sL https://nxtrace.org/nt | bash
  else
    [ "$TRACE_LANG" = "en" ] && echo "[Error] curl required. Install nexttrace: https://nxtrace.org" || echo "[Error] 需要 curl。请先安装 nexttrace: https://nxtrace.org"
    exit 1
  fi
}

# 打印分隔线
sep() {
  printf '%.0s-' {1..70}
  echo
}

print_center() {
  local text="$1"
  local width="$2"
  local len=${#text}
  local pad=0
  if [ "$len" -lt "$width" ]; then
    pad=$(( (width - len) / 2 ))
  fi
  printf "%*s%s\n" "$pad" "" "$text"
}

# 打印帮助信息
usage() {
  echo "Usage: $0 [-4] [-6] [-l cn|en]"
  echo "  -4          IPv4 only (default)"
  echo "  -6          IPv6 only"
  echo "  -l cn|en    Language: cn=中文, en=English (default: cn)"
  echo ""
  echo "Example: $0 -6 -l en"
}

main() {
  if [ "$TRACE_IPVER" = "6" ]; then
    NODES=("${NODES_IPV6[@]}")
    NT_IP_FLAG="--ipv6"
  else
    NODES=("${NODES_IPV4[@]}")
    NT_IP_FLAG="--ipv4"
  fi

  check_nexttrace
  echo ""

  if [ "$TRACE_LANG" = "en" ]; then
    echo "========================================================================="
    print_center "NextTrace Return Route Test - nxtrace.org" 73
    print_center "IPv${TRACE_IPVER} | Lang: ${TRACE_LANG}" 73
    print_center "v0.1.0  2026-03-10" 73
    print_center "Author: TomDiary" 73
    print_center "https://github.com/tomdiary/besttrace" 73
    echo "========================================================================="
  else
    echo "========================================================================="
    print_center "NextTrace 回程测试 (Return Route) - nxtrace.org" 73
    print_center "IPv${TRACE_IPVER} | 语言: ${TRACE_LANG}" 73
    print_center "v0.1.0  2026-03-10" 73
    print_center "Author: TomDiary" 73
    print_center "https://github.com/tomdiary/besttrace" 73
    echo "========================================================================="
  fi
  echo ""

  for node in "${NODES[@]}"; do
    IFS='|' read -ra parts <<< "$node"
    name="${parts[0]}"
    carrier="${parts[1]}"
    host="${parts[2]}"
    echo "========================================================================="
    echo -e "${NODE_TITLE} $name ${FONT_SUFFIX}"
    nexttrace $NT_IP_FLAG -g "$TRACE_LANG" -M "$host"
  done
  echo "========================================================================="
}

while getopts "46hl:" opt; do
  case $opt in
    4) TRACE_IPVER=4 ;;
    6) TRACE_IPVER=6 ;;
    l)
      case "${OPTARG}" in
        cn|en) TRACE_LANG="${OPTARG}" ;;
        *) echo "Invalid -l option: ${OPTARG}. Use cn or en."; usage; exit 1 ;;
      esac
      ;;
    h) usage; exit 0 ;;
    *) usage; exit 1 ;;
  esac
done

main
