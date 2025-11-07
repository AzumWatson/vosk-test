# 模型文件目录

## 下载 Vosk 中文模型

请下载以下模型文件并放置在此目录下：

### 小型中文模型（推荐）
- **模型名称**: vosk-model-small-cn-0.22
- **文件大小**: 约 42MB
- **下载地址**: https://alphacephei.com/vosk/models/vosk-model-small-cn-0.22.zip
- **放置位置**: `static/models/vosk-model-small-cn-0.22.zip`

### 下载方法

#### 方法 1: 使用浏览器直接下载
```bash
# 在浏览器中打开以下链接下载
https://alphacephei.com/vosk/models/vosk-model-small-cn-0.22.zip

# 下载后移动到此目录
mv ~/Downloads/vosk-model-small-cn-0.22.zip static/models/
```

#### 方法 2: 使用 curl 命令下载
```bash
# 在项目根目录执行
curl -L https://alphacephei.com/vosk/models/vosk-model-small-cn-0.22.zip \
     -o static/models/vosk-model-small-cn-0.22.zip
```

#### 方法 3: 使用 wget 命令下载
```bash
# 在项目根目录执行
wget https://alphacephei.com/vosk/models/vosk-model-small-cn-0.22.zip \
     -P static/models/
```

### 验证下载

下载完成后，此目录应该包含：
```
static/models/
├── README.md (本文件)
└── vosk-model-small-cn-0.22.zip (42MB)
```

### 使用其他模型

如果想使用其他 Vosk 模型，请：
1. 从 https://alphacephei.com/vosk/models 下载对应模型
2. 将 zip 文件放在此目录
3. 修改 `src/routes/+page.svelte` 中的模型路径

例如使用大型中文模型：
```typescript
model = await createModel('/models/vosk-model-cn-0.22.zip');
```

### 注意事项

⚠️ **重要**: 
- 模型文件较大（42MB-300MB），下载需要一定时间
- 模型文件必须是 `.zip` 格式，不要解压
- 确保文件名和代码中的路径一致
- Git 仓库默认会忽略大文件，不要提交模型到仓库

### 支持的语言模型

更多语言模型请访问: https://alphacephei.com/vosk/models

常用模型：
- 🇨🇳 中文: vosk-model-small-cn-0.22.zip (42MB)
- 🇺🇸 英文: vosk-model-small-en-us-0.15.zip (40MB)
- 🇯🇵 日文: vosk-model-small-ja-0.22.zip (48MB)
- 🇷🇺 俄文: vosk-model-small-ru-0.22.zip (45MB)
