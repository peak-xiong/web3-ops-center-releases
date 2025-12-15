# Web3 Ops Center - Releases

Web3 运营中心桌面应用发布仓库。

## 一键安装

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/peak-xiong/web3-ops-center-releases/main/install.sh | bash
```

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/peak-xiong/web3-ops-center-releases/main/install.ps1 | iex
```

## 手动下载

从 [Releases](https://github.com/peak-xiong/web3-ops-center-releases/releases) 页面下载对应平台的安装包：

| 平台 | 文件格式 | 架构 |
|------|----------|------|
| macOS | `.dmg` | Intel (x64) / Apple Silicon (arm64) |
| Windows | `.exe` | x64 / arm64 |
| Linux | `.deb` / `.AppImage` | x64 / arm64 |

## 功能特性

- **钱包管理** - 多钱包导入、AES-256-GCM 加密存储
- **链上资金追踪** - 实时余额、代币持仓
- **Polymarket 集成** - 预测市场交互
- **自动交互功能** - 批量操作、定时任务

## 安全特性

- 私钥使用 AES-256-GCM 加密存储
- PBKDF2 密钥派生（10万次迭代）
- 纯本地运行，私钥永不上传

## 系统要求

| 平台 | 最低版本 |
|------|----------|
| macOS | 10.15 (Catalina) |
| Windows | Windows 10 |
| Linux | Ubuntu 20.04 / Debian 11 |

## 源代码

源代码仓库：[peak-xiong/web3-ops-center](https://github.com/peak-xiong/web3-ops-center)

## 许可证

MIT License
