# 设置指南 - 离线语音识别应用

## 📋 已完成的配置

✅ **问题解决**: 修复了 CORS 跨域问题，改为从本地加载模型  
✅ **模型下载**: Vosk 中文模型已下载到 `static/models/` 目录  
✅ **代码更新**: 已修改为从本地路径加载模型  

## 🗂️ 当前文件结构

```
voice-recorder/
├── src/
│   └── routes/
│       └── +page.svelte              # 主页面（已配置本地模型）
├── static/
│   ├── audio-processor.js            # 音频处理 worklet
│   └── models/
│       ├── .gitignore                # 防止提交大文件
│       ├── README.md                 # 模型下载说明
│       └── vosk-model-small-cn-0.22.zip  # ✅ 中文模型 (42MB)
├── download-model.sh                 # 自动下载脚本
├── README.md                         # 项目说明
└── package.json
```

## 🎯 关键修改

### 1. 模型加载路径（src/routes/+page.svelte）

```typescript
// 之前：从远程 CDN 加载（会遇到 CORS 问题）
model = await createModel('https://alphacephei.com/vosk/models/vosk-model-small-cn-0.22.zip');

// 现在：从本地 static 目录加载
model = await createModel('/models/vosk-model-small-cn-0.22.zip');
```

### 2. 错误提示优化

现在如果模型加载失败，会显示详细的帮助信息：
- 检查模型文件是否存在
- 确认文件名是否正确
- 指向下载说明文档

### 3. 模型文件管理

- **位置**: `static/models/vosk-model-small-cn-0.22.zip`
- **大小**: 约 42MB
- **Git**: 已配置 `.gitignore`，不会提交到版本控制
- **下载**: 提供自动下载脚本 `download-model.sh`

## 🚀 使用流程

### 首次设置

```bash
# 1. 安装依赖
npm install

# 2. 下载模型（如果还没有）
bash download-model.sh

# 3. 启动开发服务器
npm run dev
```

### 日常开发

```bash
# 直接启动即可（模型已在本地）
npm run dev
```

## ✅ 验证清单

- [x] 模型文件已下载：`static/models/vosk-model-small-cn-0.22.zip`
- [x] 文件大小正确：约 42MB
- [x] 代码已更新：使用本地路径 `/models/vosk-model-small-cn-0.22.zip`
- [x] 错误提示完善：显示详细的故障排查信息
- [x] Git 配置正确：大文件不会被提交

## 🔧 故障排查

### 问题：模型加载失败

**检查步骤**：

1. 确认文件存在
   ```bash
   ls -lh static/models/vosk-model-small-cn-0.22.zip
   ```

2. 检查文件大小（应该是 42MB 左右）
   ```bash
   du -h static/models/vosk-model-small-cn-0.22.zip
   ```

3. 如果文件不存在，重新下载
   ```bash
   bash download-model.sh
   ```

### 问题：CORS 错误

**解决方案**：已解决！现在使用本地模型，不会有 CORS 问题。

## 📱 浏览器要求

- **Chrome/Edge**: 66+
- **Firefox**: 76+
- **Safari**: 14.1+

必须支持：
- Web Audio API
- AudioWorklet
- WebAssembly
- MediaStream API

## 🌐 完全离线使用

现在应用可以完全离线运行：

1. **首次访问**：需要网络下载模型（一次性）
2. **后续使用**：完全离线，无需任何网络连接
3. **数据隐私**：所有处理在浏览器本地完成

## 📚 相关文档

- **项目说明**: `README.md`
- **模型说明**: `static/models/README.md`
- **Vosk 官网**: https://alphacephei.com/vosk/
- **模型列表**: https://alphacephei.com/vosk/models

## 💡 其他模型

如果需要使用其他语言或更大的模型：

1. 下载对应的模型 zip 文件到 `static/models/`
2. 修改 `src/routes/+page.svelte` 中的路径：
   ```typescript
   model = await createModel('/models/你的模型文件名.zip');
   ```

常用模型：
- 中文小型: vosk-model-small-cn-0.22.zip (42MB)
- 中文大型: vosk-model-cn-0.22.zip (1.3GB) - 更准确
- 英文小型: vosk-model-small-en-us-0.15.zip (40MB)
- 日文小型: vosk-model-small-ja-0.22.zip (48MB)

---

**状态**: ✅ 已完成配置，可以正常使用！  
**更新时间**: 2025-11-08
