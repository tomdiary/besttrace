#!/usr/bin/env bash

# 全局变量
WORK_DIR="/tmp/.besttrace/" # 工作目录
SHELL_VERSION="0.0.1" # shell 脚本
IS_DEBUG=0 # 是否开启 DEBUG（0-关闭，1-开启）

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

# 输出语句颜色
MSG_INFO="${FONT_BLUE} [Info] ${FONT_SUFFIX}"
MSG_WARNING="${FONT_YELLOW} [Warning] ${FONT_SUFFIX}"
MSG_DEG="${FONT_PURPLE} [Debug] ${FONT_SUFFIX}"
MSG_ERROR="${FONT_RED} [Error] ${FONT_SUFFIX}"
MSG_SUCCESS="${FONT_GREEN} [Success] ${FONT_SUFFIX}"
MSG_FAIL="${FONT_SKYBLUE} [Failed] ${FONT_SUFFIX}"

declare -A ip_address=(
  ['0']="219.141.136.12"
  ['1']="202.106.50.1"
  ['2']="221.179.155.161"
  ['3']="202.96.209.133"
  ['4']="210.22.97.1"
  ['5']="211.136.112.200"
  ['6']="58.60.188.222"
  ['7']="210.21.196.6"
  ['8']="120.196.165.24"
  ['9']="202.112.14.151"
)

declare -A ip_address_en=(
  ['0']="Beijing Telecom"
  ['1']="Beijing Unicom"
  ['2']="Beijing Mobile"
  ['3']="Shanghai Telecom"
  ['3']="Shanghai Unicom"
  ['3']="Shanghai Mobile"
  ['3']="Guangzhou Telecom"
  ['3']="Guangzhou Unicom"
  ['3']="Guangzhou Mobile"
  ['3']="Chengdu Educate"
)

declare -A ip_address_cn=(
  ['0']="北京电信"
  ['1']="北京联通"
  ['2']="北京移动"
  ['3']="上海电信"
  ['4']="上海联通"
  ['5']="上海移动"
  ['6']="广州电信"
  ['7']="广州联通"
  ['8']="广州移动"
  ['9']="成都教育网"
)

basic_init() {
  if [ -n $1 ]; then
    lang=$1
  else
    lang="en"
  fi
  
  if [ ! -d $WORK_DIR ]; then
    mkdir $WORK_DIR
    rm -f "${WORK_DIR}"*
  fi

  if [ -f /etc/redhat-release ]; then
    release="centos"
	elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
	elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
	elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
	elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
	elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
	elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
	fi

  # install wget
	if [ ! -e '/usr/bin/wget' ]; then
    echo -e "${MSG_INFO}Installing Wget ..."
    if [ "${release}" == "centos" ]; then
      yum -y install wget > /dev/null 2>&1
    else
      apt-get -y install wget > /dev/null 2>&1
    fi
		echo -ne "\e[1A"; echo -ne "\e[0K\r"
	fi

  if [ ! -e '/usr/bin/unzip' ]; then
    echo -e "${MSG_INFO}Installing Unzip ..."
    if [ "${release}" == "centos" ]; then
      yum -y install unzip > /dev/null 2>&1
    else
      apt-get -y install unzip > /dev/null 2>&1
    fi
		echo -ne "\e[1A"; echo -ne "\e[0K\r"
	fi

  if [ ! -d $WORK_DIR ]; then
    mkdir $WORK_DIR
  fi

  # install besttrace
  if [ ! -f "${WORK_DIR}besttrace" ]; then
    echo -e "${MSG_INFO}Installing Besttrace ..."
    # https://raw.githubusercontent.com/tomdiary/besttrace/main/besttrace4linux.zip
    # https://cdn.ipip.net/17mon/besttrace4linux.zip
    wget --no-check-certificate -O "besttrace.zip" https://cdn.ipip.net/17mon/besttrace4linux.zip
    # wget --no-check-certificate -O "besttrace.zip" https://raw.githubusercontent.com/tomdiary/besttrace/main/besttrace4linux.zip
    unzip "besttrace.zip" -d "${WORK_DIR}"
    chmod +x "${WORK_DIR}besttrace"
  fi
}

next() {
  printf "%-70s\n" "-" | sed 's/\s/-/g'
}

clear_besttrace() {
  [ $IS_DEBUG != 1 ] && rm -rf ./main.sh
  rm -rf ./besttrace.zip
  rm -rf $WORK_DIR
}

main() {
  basic_init

  clear
  next

  for key in "${!ip_address_cn[@]}"; do
    echo -e "${ip_address_cn[$key]}"
    "${WORK_DIR}besttrace" -g ${lang} -q 1 ${ip_address[$key]}
    next
  done

  clear_besttrace
}

main
