# Besttrace

基于 `nexttrace` 的回程测试脚本，支持按节点批量执行 `IPv4/IPv6` 回程检测，提供中英文输出，并覆盖电信、联通、移动、教育网与科技网五网测试场景。

## 功能

- 批量测试预设节点（电信/联通/移动/教育网等）
- 支持 `-4` / `-6` 切换 IP 类型
- 支持 `-l cn|en` 切换语言

## 快速开始

### 方式一：一键运行

```bash
bash <(curl -Ls "https://raw.githubusercontent.com/tomdiary/besttrace/main/main.sh")
```

### 方式二：下载后运行

```bash
wget --no-check-certificate "https://raw.githubusercontent.com/tomdiary/besttrace/main/main.sh" && chmod +x main.sh && ./main.sh
```

## 使用示例

```bash
# 默认：IPv4 + 中文
bash <(curl -Ls "https://raw.githubusercontent.com/tomdiary/besttrace/main/main.sh")

# IPv6 + 中文
bash <(curl -Ls "https://raw.githubusercontent.com/tomdiary/besttrace/main/main.sh") -6

# IPv4 + 英文
bash <(curl -Ls "https://raw.githubusercontent.com/tomdiary/besttrace/main/main.sh") -4 -l en

# IPv6 + 英文
bash <(curl -Ls "https://raw.githubusercontent.com/tomdiary/besttrace/main/main.sh") -6 -l en
```

## 参数

| 参数 | 取值 | 说明 |
| :--: | :--: | :-- |
| `-4` | - | 仅测试 IPv4（默认） |
| `-6` | - | 仅测试 IPv6 |
| `-l` | `cn` / `en` | 输出语言：中文/英文（默认 `cn`） |
| `-h` | - | 显示帮助 |

## 说明

- 首次运行可能会安装 `nexttrace`，请确保网络可访问 `https://nxtrace.org`。
- 部分节点可能因网络策略、ICMP 限制或路由波动出现超时（`*`），属正常现象。
- 节点来源于: https://github.com/nxtrace/NTrace-dev/blob/main/fast_trace/basic.go
