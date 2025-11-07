# 🎤 离线语音记录 - 纯前端实现

一个基于 **SvelteKit** 和 **Vosk-Browser** 的完全离线语音识别网页应用。

## ✨ 特性

- ✅ **完全离线运行** - 无需任何网络连接即可使用
- 🇨🇳 **支持中文识别** - 使用 Vosk 中文语音识别模型
- 🔒 **隐私安全** - 所有数据在浏览器本地处理，不上传服务器
- 💾 **自动缓存模型** - 首次下载后，模型文件会被浏览器缓存
- 🎨 **现代化界面** - 美观的渐变色设计，支持实时识别和最终结果显示
- 📝 **实时转写** - 边说边转写，实时显示识别结果

## 🚀 快速开始

### 1. 安装依赖

```bash
npm install
```

### 2. 下载语音识别模型

**重要**: 需要先下载 Vosk 中文模型才能使用！

```bash
# 🚀 快速下载（推荐）
bash download-model.sh

# 或手动下载
curl -L https://alphacephei.com/vosk/models/vosk-model-small-cn-0.22.zip \
     -o static/models/vosk-model-small-cn-0.22.zip
```

模型大小约 42MB，下载可能需要几分钟。下载完成后会保存在 `static/models/` 目录。

### 3. 启动开发服务器

```bash
npm run dev
```

应用将在 http://localhost:5173 启动。

### 4. 使用应用

1. 打开浏览器访问 http://localhost:5173
2. 点击"开始录音"按钮
3. 允许浏览器访问麦克风
4. 开始说话，实时识别结果会显示在文本框中
5. 说完后点击"停止录音"

## 📦 构建生产版本

```bash
npm run build
```

构建完成后，可以使用以下命令预览：

```bash
npm run preview
```

## 🛠️ 技术栈

- **SvelteKit** - 现代化的 Web 框架
- **Vosk-Browser** - 基于 WebAssembly 的离线语音识别引擎
- **Web Audio API** - 浏览器原生音频处理
- **AudioWorklet** - 高性能音频数据处理

## 📁 项目结构

```
voice-recorder/
├── src/
│   └── routes/
│       └── +page.svelte        # 主页面（语音识别界面）
├── static/
│   └── audio-processor.js      # 音频处理 AudioWorklet
├── package.json
└── README.md
```

## 🌐 模型说明

应用使用的是 Vosk 的小型中文模型 `vosk-model-small-cn-0.22`：
- 模型大小：约 42MB
- 识别语言：简体中文
- 首次使用会自动从 alphacephei.com 下载
- 下载后会被浏览器缓存，之后无需网络即可使用

### 使用其他模型

如果想使用更大更准确的模型，可以修改 `src/routes/+page.svelte` 中的模型 URL：

```typescript
// 使用大型中文模型（更准确，但体积更大）
model = await createModel('https://alphacephei.com/vosk/models/vosk-model-cn-0.22.zip');
```

更多模型请访问：https://alphacephei.com/vosk/models

## 🔧 浏览器要求

- Chrome 66+
- Firefox 76+
- Safari 14.1+
- Edge 79+

需要浏览器支持：
- Web Audio API
- AudioWorklet
- WebAssembly
- MediaStream API（麦克风访问）

## 💡 常见问题

### Q: 麦克风无法使用怎么办？
A: 请查看 [麦克风故障排查指南](MICROPHONE_TROUBLESHOOTING.md)，或点击应用中的"🔍 测试麦克风"按钮进行诊断。

### Q: 为什么首次加载很慢？
A: 需要下载约 42MB 的语音识别模型。下载完成后会被缓存，之后就很快了。

### Q: 可以完全离线使用吗？
A: 模型下载后完全可以离线使用，无需任何网络连接。

### Q: 识别准确率如何？
A: 使用的是小型模型，适合大部分场景。如需更高准确率，可以换用大型模型。

### Q: 支持其他语言吗？
A: 支持！Vosk 提供多种语言模型，只需修改模型 URL 即可。

### Q: 支持哪些采样率？
A: 支持任意采样率！应用会自动重采样到 16kHz，无需手动配置。

## 📄 License

MIT

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！
