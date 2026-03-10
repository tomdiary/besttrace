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
NODES_URL="https://raw.githubusercontent.com/tomdiary/besttrace/main/nodes.json"
NODES_CACHE_DIR="${XDG_CACHE_HOME:-/tmp/.besttrace}"
NODES_FILE_LOCAL="${NODES_CACHE_DIR}/nodes.json"

# 检查并安装 nexttrace
check_nexttrace() {
  if command -v nexttrace &>/dev/null; then
    return 0
  fi
  if [ "$TRACE_LANG" = "en" ]; then
    echo "[Info] nexttrace not found, attempting install..." >&2
  else
    echo "[Info] nexttrace 未找到，尝试安装..." >&2
  fi
  if command -v curl &>/dev/null; then
    curl -sL https://nxtrace.org/nt | bash
  else
    [ "$TRACE_LANG" = "en" ] && echo "[Error] curl required. Install nexttrace: https://nxtrace.org" >&2 || echo "[Error] 需要 curl。请先安装 nexttrace: https://nxtrace.org" >&2
    exit 1
  fi
}

install_jq() {
  if command -v jq &>/dev/null; then
    return 0
  fi

  if [ "$TRACE_LANG" = "en" ]; then
    echo "[Info] jq not found, attempting install..." >&2
  else
    echo "[Info] jq 未找到，尝试自动安装..." >&2
  fi

  if command -v apt &>/dev/null; then
    apt update -y >/dev/null 2>&1 && apt install -y jq >/dev/null 2>&1 || true
  elif command -v apt-get &>/dev/null; then
    apt-get update -y >/dev/null 2>&1 && apt-get install -y jq >/dev/null 2>&1 || true
  elif command -v dnf &>/dev/null; then
    dnf install -y jq >/dev/null 2>&1 || true
  elif command -v yum &>/dev/null; then
    yum install -y jq >/dev/null 2>&1 || true
  elif command -v apk &>/dev/null; then
    apk add --no-cache jq >/dev/null 2>&1 || true
  elif command -v pacman &>/dev/null; then
    pacman -Sy --noconfirm jq >/dev/null 2>&1 || true
  elif command -v brew &>/dev/null; then
    brew install jq >/dev/null 2>&1 || true
  fi

  if ! command -v jq &>/dev/null; then
    if [ "$TRACE_LANG" = "en" ]; then
      echo "[Error] Failed to install jq automatically. Please install jq manually." >&2
    else
      echo "[Error] jq 自动安装失败，请手动安装 jq 后重试。" >&2
    fi
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

load_nodes_from_json() {
  local json_path="$NODES_FILE_LOCAL"
  mkdir -p "$NODES_CACHE_DIR"
  if command -v curl &>/dev/null; then
    local tmp_file="${NODES_FILE_LOCAL}.tmp"
    if curl -fsSL "$NODES_URL" -o "$tmp_file"; then
      mv "$tmp_file" "$NODES_FILE_LOCAL"
    else
      rm -f "$tmp_file"
    fi
  fi

  if [ ! -f "$json_path" ]; then
    echo "[Error] nodes file not found (remote/local): $NODES_URL / $NODES_FILE_LOCAL" >&2
    exit 1
  fi

  install_jq

  local key name_key
  if [ "$TRACE_IPVER" = "6" ]; then
    key="nodes_v6"
  else
    key="nodes_v4"
  fi
  if [ "$TRACE_LANG" = "en" ]; then
    name_key="name_en"
  else
    name_key="name_cn"
  fi

  jq -r --arg key "$key" --arg name_key "$name_key" \
    '.[$key][] | select(.host != null and .host != "") | "\(.[$name_key] // "")|\(.asn // "")|\(.host)"' \
    "$json_path"
}

main() {
  if [ "$TRACE_IPVER" = "6" ]; then
    NT_IP_FLAG="--ipv6"
  else
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

  mapfile -t NODES < <(load_nodes_from_json)

  for node in "${NODES[@]}"; do
    IFS='|' read -ra parts <<< "$node"
    name="${parts[0]}"
    asn="${parts[1]}"
    host="${parts[2]}"
    echo "========================================================================="
    echo -e "${NODE_TITLE} $name（$asn） ${FONT_SUFFIX}"
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
