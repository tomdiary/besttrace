# Besttrace

## 使用

```bash
wget --no-check-certificate https://raw.githubusercontent.com/tomdiary/besttrace/main/main.sh && chmod +x main.sh && ./main.sh
```

或者

```bash
curl -LsO https://raw.githubusercontent.com/tomdiary/besttrace/main/main.sh; bash main.sh
```

再或者

```bash
bash <(curl -Lso- https://raw.githubusercontent.com/tomdiary/besttrace/main/main.sh) main.sh
```

## 参数

|  键  |     值      |               说明               |
| :--: | :---------: | :------------------------------: |
|  -l  |    cn/en    | 语言，支持中文和英文（默认英文） |
|  -b  | github/ipip | besttrace脚本来源（默认gitHub）  |
|  -q  |     1~3     |    每次探测报文数量（默认1）     |
|      |             |                                  |

