# 🚀 快速开始

## 三步启动

```bash
# 1️⃣ 安装依赖
npm install

# 2️⃣ 下载模型（首次使用）
bash download-model.sh

# 3️⃣ 启动应用
npm run dev
```

然后打开 http://localhost:5173 开始使用！

---

## 🎤 使用方法

1. 点击 **"开始录音"**
2. 允许麦克风权限
3. **开始说话**
4. 实时查看识别结果
5. 点击 **"停止录音"**

---

## ✅ 特性

- ✅ 完全离线运行
- 🇨🇳 支持中文
- 🔒 隐私安全
- 📝 实时转写
- 💾 本地模型

---

## 📁 重要文件

| 文件 | 说明 |
|------|------|
| `src/routes/+page.svelte` | 主界面 |
| `static/models/*.zip` | 模型文件 |
| `download-model.sh` | 下载脚本 |

---

## 🔧 故障排查

**模型加载失败？**

```bash
# 检查模型文件
ls -lh static/models/vosk-model-small-cn-0.22.zip

# 重新下载
bash download-model.sh
```

---

## 📚 更多文档

- 详细说明：`README.md`
- 设置指南：`SETUP.md`
- 模型说明：`static/models/README.md`
