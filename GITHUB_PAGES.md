# 🚀 GitHub Pages 部署指南

## 📋 部署步骤

### 1. 创建 GitHub 仓库

1. 访问 https://github.com/new
2. 创建一个新仓库（例如：`voice-recorder`）
3. **不要**勾选 "Initialize this repository with a README"
4. 点击 "Create repository"

### 2. 关联本地仓库

```bash
# 添加所有文件
git add .

# 提交
git commit -m "Initial commit: Offline voice recorder with Vosk"

# 关联远程仓库（替换为你的仓库地址）
git remote add origin https://github.com/YOUR_USERNAME/voice-recorder.git

# 推送到 main 分支
git branch -M main
git push -u origin main
```

### 3. 部署到 GitHub Pages

```bash
# 一键部署（会自动构建并推送到 gh-pages 分支）
npm run deploy
```

### 4. 启用 GitHub Pages

1. 进入仓库页面
2. 点击 **Settings** > **Pages**
3. Source 选择 **`gh-pages`** 分支
4. 点击 **Save**
5. 等待 1-2 分钟

### 5. 访问你的网站

部署完成后，GitHub 会提供访问地址：
```
https://YOUR_USERNAME.github.io/voice-recorder/
```

---

## 🔄 更新网站

每次修改代码后，重新部署：

```bash
# 1. 提交代码
git add .
git commit -m "Update: 描述你的修改"
git push

# 2. 重新部署
npm run deploy
```

---

## ⚙️ 配置说明

### 如果仓库名不是 voice-recorder

需要修改 `svelte.config.js` 添加 base path：

```javascript
import adapter from '@sveltejs/adapter-static';
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';

const config = {
	preprocess: vitePreprocess(),
	kit: {
		adapter: adapter({
			pages: 'build',
			assets: 'build',
			fallback: 'index.html',
			precompress: false,
			strict: true
		}),
		paths: {
			base: process.env.NODE_ENV === 'production' ? '/你的仓库名' : ''
		}
	}
};

export default config;
```

然后修改 `package.json` 的 deploy 脚本：

```json
{
  "scripts": {
    "deploy": "NODE_ENV=production npm run build && gh-pages -d build"
  }
}
```

---

## 🔍 检查部署状态

### 查看 gh-pages 分支

```bash
git fetch origin gh-pages
git log origin/gh-pages
```

### 检查部署文件

访问仓库的 gh-pages 分支，确认以下文件存在：
- `index.html`
- `_app/` 目录
- `models/vosk-model-small-cn-0.22.zip` (42MB)
- `audio-processor.js`

---

## ❓ 常见问题

### Q: 404 错误？

**原因**: GitHub Pages 还未启用或路径配置错误

**解决**:
1. 确认 Settings > Pages 中已选择 gh-pages 分支
2. 检查访问地址是否正确
3. 等待几分钟让 GitHub 完成部署

### Q: 网站打开但功能不正常？

**原因**: 静态资源路径问题

**解决**: 
如果仓库名不是根目录，需要配置 base path（见上方配置说明）

### Q: 模型文件加载失败？

**原因**: 模型文件太大，可能没有成功推送

**解决**:
```bash
# 检查 gh-pages 分支的文件
git fetch origin gh-pages
git checkout gh-pages
ls -lh models/

# 如果模型文件不存在，确保在 build 目录中有这个文件
cd build
ls -lh models/vosk-model-small-cn-0.22.zip
```

### Q: 手机无法使用麦克风？

**答**: ✅ **GitHub Pages 自动提供 HTTPS**，手机可以正常使用麦克风！

---

## 🎯 完整命令总结

```bash
# 1. 初始化和提交（首次）
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/voice-recorder.git
git branch -M main
git push -u origin main

# 2. 部署到 GitHub Pages
npm run deploy

# 3. 后续更新
git add .
git commit -m "Update"
git push
npm run deploy
```

---

## 📊 GitHub Pages 优势

- ✅ **自动 HTTPS** - 手机可以使用麦克风
- ✅ **免费托管** - 无需付费
- ✅ **全球 CDN** - 访问速度快
- ✅ **自动化部署** - 一条命令搞定
- ✅ **自定义域名** - 支持绑定自己的域名

---

## 🌐 自定义域名（可选）

如果有自己的域名：

1. 在仓库根目录创建 `static/CNAME` 文件：
   ```
   your-domain.com
   ```

2. 在域名 DNS 设置中添加 CNAME 记录：
   ```
   CNAME  @  YOUR_USERNAME.github.io
   ```

3. 重新部署：
   ```bash
   npm run deploy
   ```

4. 在 GitHub Settings > Pages > Custom domain 填写你的域名

---

**准备好了吗？开始部署吧！** 🚀

```bash
npm run deploy
```
