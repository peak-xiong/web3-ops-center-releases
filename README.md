# Web3 Ops Center 使用指南

## 下载安装

### 下载地址

📦 **GitHub Releases**: <https://github.com/peak-xiong/web3-ops-center-releases/releases>

### 支持平台

| 平台 | 文件 | 说明 |
|------|------|------|
| **macOS (Intel)** | `Web3-Ops-Center-macOS-x64.dmg` | Intel 芯片 Mac |
| **macOS (Apple Silicon)** | `Web3-Ops-Center-macOS-arm64.dmg` | M1/M2/M3 芯片 Mac |
| **Windows** | `Web3-Ops-Center-Windows-x64.exe` | Windows 10/11 64位 |
| **Linux** | `Web3-Ops-Center-Linux-x64.AppImage` | 通用 Linux |

---

## 安装说明

### macOS 安装

1. 下载对应芯片版本的 `.dmg` 文件
2. 双击打开 DMG 文件
3. 将应用拖入 Applications 文件夹

#### ⚠️ macOS 未签名应用解决方案

首次打开时，macOS 可能提示 **"Web3 Ops Center.app" 已损坏，无法打开**。

这是因为应用未经 Apple 签名，执行以下命令解决：

```bash
# 移除隔离属性
xattr -cr "/Applications/Web3 Ops Center.app"
```

或者如果提示 "无法验证开发者"：

```bash
# 允许任意来源（需要先在终端执行）
sudo spctl --master-disable

# 然后在系统偏好设置 → 安全性与隐私 → 允许任何来源
```

### Windows 安装

1. 下载 `.exe` 安装程序
2. 双击运行，按提示安装
3. 如遇 SmartScreen 警告，点击 "更多信息" → "仍要运行"

### Linux 安装

```bash
# 添加执行权限
chmod +x Web3-Ops-Center-Linux-x64.AppImage

# 运行
./Web3-Ops-Center-Linux-x64.AppImage
```

---

## 功能指南

### 1. 钱包管理

#### 导入钱包

支持两种导入方式：

1. **助记词导入**: 输入 12/24 个单词的助记词
2. **私钥导入**: 输入 64 位十六进制私钥

> 💡 批量导入：每行一个助记词或私钥

#### 钱包列表

| 列 | 说明 |
|---|------|
| EOA | 外部账户地址 |
| Safe | Polymarket Safe 钱包地址（绿点=已部署） |
| MATIC | Polygon 原生代币余额 |
| USDC | USD Coin 余额 |

### 2. Polymarket 操作

#### 激活钱包 (Deploy Safe)

点击 🚀 按钮部署 Safe 钱包到 Polymarket。

- **前提**: 钱包需要有少量 MATIC 作为 Gas 费（通常 Polymarket 代付）
- **状态**: 部署成功后显示 ✓ 图标

#### 授权 USDC (Approve)

点击 ✓ 按钮授权 USDC 用于交易。

- **前提**: Safe 钱包已部署
- **状态**: 授权成功后显示 ✓ 图标

#### 批量操作

1. 勾选多个钱包
2. 点击工具栏的 **Activate** 或 **Approve** 按钮
3. 确认后依次执行

### 3. 浏览器启动（仅桌面版）

#### 选择浏览器

工具栏提供三种浏览器选择：

| 浏览器 | 说明 |
|--------|------|
| Brave | 推荐，隐私保护好 |
| Chrome | 通用浏览器 |
| Edge | Windows 默认 |

#### 启动浏览器

点击钱包行的浏览器图标，自动：

1. 创建独立配置文件
2. 注入钱包信息
3. 打开 Polymarket 网站

> 每个钱包使用独立的浏览器配置，互不干扰

### 4. 市场数据

#### 热门市场 (Markets)

显示 Polymarket 交易量最高的市场。

#### 奖励市场 (Rewards)

显示有流动性奖励的市场，按奖励率排序。

---

## 常见问题

### Q: 钱包数据存储在哪里？

钱包数据加密存储在浏览器的 IndexedDB 中：

- **Electron**: `~/Library/Application Support/Web3 Ops Center/`
- **Web**: 浏览器本地存储

### Q: 如何备份钱包？

目前需要手动记录助记词/私钥。建议：

1. 导入前先备份原始助记词
2. 使用密码管理器保存

### Q: 激活/授权失败怎么办？

1. 检查网络连接
2. 确保钱包有少量 MATIC（虽然通常免费）
3. 等待几秒后重试

### Q: Web 版和桌面版有什么区别？

| 功能 | 桌面版 | Web 版 |
|------|--------|--------|
| 钱包管理 | ✅ | ✅ |
| 激活/授权 | ✅ | ✅ |
| 浏览器启动 | ✅ | ❌ |
| 市场数据 | ✅ | ✅ |

---

## 安全提示

⚠️ **重要安全事项**:

1. **私钥安全**: 永远不要分享你的助记词或私钥
2. **官方下载**: 只从官方 GitHub Releases 下载
3. **验证哈希**: 下载后可验证文件完整性
4. **开源审计**: 源代码完全开源，可自行审计

---

## 技术支持

- **GitHub Issues**: <https://github.com/peak-xiong/web3-ops-center/issues>
- **文档**: <https://github.com/peak-xiong/web3-ops-center/tree/main/docs>

---

## 更新日志

查看 [CHANGELOG.md](./CHANGELOG.md) 了解版本更新历史。
