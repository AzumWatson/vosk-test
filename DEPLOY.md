# 📦 部署指南

## 🏗️ 构建静态文件

### 1. 构建命令

```bash
npm run build
```

构建完成后，静态文件会生成在 `build/` 目录。

### 2. 构建产物

```
build/
├── _app/                          # SvelteKit 应用文件
├── audio-processor.js             # 音频处理器
├── models/
│   └── vosk-model-small-cn-0.22.zip  # 语音模型（42MB）
├── index.html                     # 入口文件
└── robots.txt
```

---

## 🌐 本地测试静态文件

### 方法 1: 使用自带脚本（推荐）

```bash
# 默认端口 8080
bash serve.sh

# 自定义端口
bash serve.sh 3000
```

### 方法 2: 使用 Python

```bash
# Python 3
cd build && python3 -m http.server 8080

# Python 2
cd build && python -m SimpleHTTPServer 8080
```

### 方法 3: 使用 Node.js http-server

```bash
# 安装（首次使用）
npm install -g http-server

# 启动
http-server build -p 8080 -a 0.0.0.0
```

### 方法 4: 使用 SvelteKit preview

```bash
npm run preview
```

访问: http://localhost:8080

---

## ☁️ 部署到云服务

### 🚀 Netlify（推荐 - 最简单）

#### 1. 通过 Web 界面部署

1. 访问 https://app.netlify.com
2. 登录/注册账号
3. 点击 "Add new site" > "Deploy manually"
4. 拖拽 `build/` 文件夹到上传区
5. 等待部署完成（1-2分钟）
6. 获得免费的 HTTPS 网址！

#### 2. 通过命令行部署

```bash
# 安装 Netlify CLI
npm install -g netlify-cli

# 登录
netlify login

# 部署
netlify deploy --prod --dir=build
```

**优势**:
- ✅ 自动 HTTPS
- ✅ 全球 CDN
- ✅ 免费
- ✅ 可自定义域名

---

### 🔷 Vercel

```bash
# 安装 Vercel CLI
npm install -g vercel

# 登录
vercel login

# 部署
vercel --prod
```

**配置文件** (`vercel.json`):
```json
{
  "buildCommand": "npm run build",
  "outputDirectory": "build"
}
```

---

### 📄 GitHub Pages

#### 1. 创建 GitHub 仓库

```bash
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/voice-recorder.git
git push -u origin main
```

#### 2. 部署到 gh-pages 分支

```bash
# 安装 gh-pages
npm install -D gh-pages

# 添加部署脚本到 package.json
```

在 `package.json` 添加:
```json
{
  "scripts": {
    "deploy": "npm run build && gh-pages -d build"
  }
}
```

```bash
# 执行部署
npm run deploy
```

#### 3. 启用 GitHub Pages

1. 进入仓库 Settings > Pages
2. Source 选择 `gh-pages` 分支
3. 等待部署完成

访问: https://YOUR_USERNAME.github.io/voice-recorder/

---

## 🐳 Docker 部署

### Dockerfile

创建 `Dockerfile`:
```dockerfile
FROM nginx:alpine

# 复制构建文件
COPY build/ /usr/share/nginx/html/

# 配置 nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

### nginx.conf

创建 `nginx.conf`:
```nginx
server {
    listen 80;
    server_name localhost;
    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # 缓存静态资源
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # 模型文件特殊处理
    location /models/ {
        add_header Content-Type application/zip;
    }
}
```

### 构建和运行

```bash
# 构建镜像
docker build -t voice-recorder .

# 运行容器
docker run -d -p 8080:80 voice-recorder
```

访问: http://localhost:8080

---

## 📱 支持手机访问

### ⚠️ 重要：HTTPS 要求

手机浏览器访问麦克风**必须使用 HTTPS**！

#### ✅ 推荐部署方案（自动 HTTPS）:

1. **Netlify** - 自动配置 HTTPS
2. **Vercel** - 自动配置 HTTPS
3. **GitHub Pages** - 自动配置 HTTPS

#### ❌ 本地 HTTP 服务器:

使用 `bash serve.sh` 启动的本地服务器是 HTTP，手机无法使用麦克风。

---

## 🔍 部署检查清单

部署前确认：

- [ ] `build/` 目录存在
- [ ] `build/models/vosk-model-small-cn-0.22.zip` 存在（42MB）
- [ ] `build/index.html` 存在
- [ ] `build/audio-processor.js` 存在

部署后测试：

- [ ] 页面能正常打开
- [ ] 模型能正常加载
- [ ] 点击"测试麦克风"能检测到设备
- [ ] 点击"开始录音"能正常录音
- [ ] 语音识别功能正常

---

## 🛠️ 常见问题

### Q: 模型加载失败？

**原因**: 模型文件可能没有包含在构建中

**解决**:
```bash
# 确保模型文件存在
ls -lh static/models/vosk-model-small-cn-0.22.zip

# 重新构建
npm run build
```

### Q: 手机上麦克风不工作？

**原因**: 需要 HTTPS

**解决**: 部署到 Netlify/Vercel/GitHub Pages

### Q: 404 错误？

**原因**: 服务器配置问题

**解决**: 确保服务器支持 SPA（单页应用），所有路由都应返回 `index.html`

---

## 📊 性能优化

### 1. 开启 Gzip 压缩

在服务器配置中启用 Gzip：

```nginx
gzip on;
gzip_types text/plain text/css application/json application/javascript;
gzip_min_length 1000;
```

### 2. 启用 CDN

使用 Netlify/Vercel 会自动启用全球 CDN。

### 3. 模型文件缓存

模型文件（42MB）会被浏览器自动缓存，首次加载后无需重复下载。

---

## 🎯 推荐部署流程

### 最简单的方式（5分钟）:

```bash
# 1. 构建
npm run build

# 2. 部署到 Netlify（拖拽上传）
# 访问 https://app.netlify.com
# 拖拽 build/ 文件夹
# 完成！
```

---

**更新时间**: 2025-11-08
