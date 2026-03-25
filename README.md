# Besttrace

基于 `nexttrace` 的回程测试脚本，支持批量测试预设节点的 `IPv4/IPv6` 回程检测，并支持中英文输出，并覆盖电信、联通、移动、教育网与科技网五网测试场景。

脚本同时支持两套节点数据源：
- `-i nt`：使用 nxtrace 的 `nxtrace_nodes.json`
- `-i zc`：使用 zstaticcdn 的 `zstaticcdn_nodes.json`

## 功能

- 批量测试预设节点（电信/联通/移动/教育网等）
- 支持 `-4` / `-6` 切换 IPv4 / IPv6
- 支持 `-l cn|en` 切换输出语言
- 支持 `-i zc|nt` 切换节点数据源（默认 `nt`）

## 快速开始

### 方式一：一键运行（推荐）

```bash
bash <(curl -Ls "https://raw.githubusercontent.com/tomdiary/besttrace/main/main.sh")
```

### 方式二：下载后运行

```bash
wget --no-check-certificate "https://raw.githubusercontent.com/tomdiary/besttrace/main/main.sh" \
  && chmod +x main.sh \
  && ./main.sh
```

## 使用示例

```bash
# 默认：IPv4 + 中文 + 节点源 nt
bash <(curl -Ls "https://raw.githubusercontent.com/tomdiary/besttrace/main/main.sh")

# IPv6 + 中文
bash <(curl -Ls "https://raw.githubusercontent.com/tomdiary/besttrace/main/main.sh") -6

# IPv4 + 英文
bash <(curl -Ls "https://raw.githubusercontent.com/tomdiary/besttrace/main/main.sh") -4 -l en

# zstaticcdn 节点源 + IPv4
bash <(curl -Ls "https://raw.githubusercontent.com/tomdiary/besttrace/main/main.sh") -i zc -4

# nxtrace 节点源 + IPv6 + 英文
bash <(curl -Ls "https://raw.githubusercontent.com/tomdiary/besttrace/main/main.sh") -i nt -6 -l en
```

## 参数

| 参数 | 取值 | 说明 |
| :--: | :--: | :-- |
| `-4` | - | 仅测试 IPv4（默认） |
| `-6` | - | 仅测试 IPv6 |
| `-i` | `zc` / `nt` | 节点数据源：`zc=zstaticcdn`，`nt=nxtrace`（默认 `nt`） |
| `-l` | `cn` / `en` | 输出语言：中文/英文（默认 `cn`） |
| `-h` | - | 显示帮助 |

## 说明

- 首次运行可能会自动安装 `nexttrace` 与 `jq`（用于解析 `nodes.json`）。
- 由于 `zstaticcdn_nodes.json` 不包含教育网/科技网节点，当你选择 `-i zc` 时，教育网/科技网相关测试将使用 `nxtrace` 的数据源）。
- 个别节点可能会出现超时或丢包（输出 `*`），一般属于网络波动/ICMP/TCP 限制导致的正常现象。
