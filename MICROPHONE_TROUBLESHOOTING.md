# 🎤 麦克风故障排查指南

## 常见错误及解决方案

### ❌ 错误 1: "Requested device not found"

**原因**: 未找到麦克风设备

**解决方案**:

1. **检查物理连接**
   - 确认麦克风已正确连接到电脑
   - 如果是外接麦克风，尝试重新插拔
   - 检查 USB 接口是否工作正常

2. **检查系统设置 (macOS)**
   ```bash
   # 打开系统设置
   系统设置 > 隐私与安全性 > 麦克风
   
   # 确保浏览器有麦克风权限
   ```

3. **检查系统设置 (Windows)**
   ```
   设置 > 隐私 > 麦克风
   确保"允许应用访问麦克风"已开启
   ```

4. **检查浏览器权限**
   - Chrome: 地址栏左侧 🔒 图标 > 网站设置 > 麦克风 > 允许
   - Firefox: 地址栏左侧 🔒 图标 > 连接安全 > 更多信息 > 权限 > 使用麦克风
   - Safari: Safari > 网站偏好设置 > 麦克风 > 允许

5. **测试麦克风**
   - 点击页面上的 **"🔍 测试麦克风"** 按钮
   - 查看是否能检测到设备

---

### ❌ 错误 2: "Permission denied" / "NotAllowedError"

**原因**: 浏览器麦克风权限被拒绝

**解决方案**:

1. **重新授予权限**
   - 刷新页面
   - 点击"开始录音"
   - 在弹出的权限请求中选择"允许"

2. **检查浏览器设置**
   - Chrome: `chrome://settings/content/microphone`
   - 找到 `localhost:5173`，设置为"允许"

3. **清除网站数据**
   - 右键点击地址栏
   - 选择"清除此网站的数据"
   - 刷新页面重新授权

---

### ❌ 错误 3: "NotReadableError" / "麦克风正被使用"

**原因**: 麦克风被其他应用占用

**解决方案**:

1. **关闭占用麦克风的应用**
   - 视频会议软件 (Zoom, Teams, Skype)
   - 录音软件
   - 其他浏览器标签页

2. **macOS: 查看哪些应用在使用麦克风**
   ```bash
   # 系统设置 > 隐私与安全性 > 麦克风
   # 查看列表中正在使用麦克风的应用（绿色指示器）
   ```

3. **Windows: 查看音频设备使用情况**
   ```
   任务管理器 > 性能 > 查看音频使用情况
   ```

4. **重启浏览器**
   - 完全退出浏览器
   - 重新打开并访问应用

---

### ❌ 错误 4: "采样率不支持"

**原因**: 设备不支持 16kHz 采样率

**解决方案**: ✅ **已修复！**
- 最新版本已支持自动重采样
- 应用会自动将任何采样率转换为 16kHz
- 无需手动操作

---

## 🔍 诊断步骤

### 1. 测试麦克风是否可用

```javascript
// 在浏览器控制台执行
navigator.mediaDevices.enumerateDevices()
  .then(devices => {
    const mics = devices.filter(d => d.kind === 'audioinput');
    console.log('找到麦克风:', mics);
  });
```

### 2. 测试麦克风访问权限

```javascript
// 在浏览器控制台执行
navigator.mediaDevices.getUserMedia({ audio: true })
  .then(stream => {
    console.log('✅ 麦克风访问成功');
    stream.getTracks().forEach(track => track.stop());
  })
  .catch(err => console.error('❌ 麦克风访问失败:', err));
```

### 3. 使用应用内置测试

1. 打开应用: http://localhost:5173
2. 点击 **"🔍 测试麦克风"** 按钮
3. 查看检测结果

---

## 💡 最佳实践

### ✅ 推荐配置

1. **使用 HTTPS 或 localhost**
   - 麦克风 API 仅在安全上下文中可用
   - `localhost` 被视为安全上下文
   - 生产环境必须使用 HTTPS

2. **授予永久权限**
   - 在权限对话框中勾选"记住此决定"
   - 避免每次都要重新授权

3. **使用兼容的浏览器**
   - ✅ Chrome 66+
   - ✅ Firefox 76+
   - ✅ Safari 14.1+
   - ✅ Edge 79+

4. **关闭不必要的应用**
   - 避免多个应用同时使用麦克风
   - 减少音频冲突

---

## 🛠️ 系统特定问题

### macOS

**问题**: "此应用没有访问麦克风的权限"

**解决**:
```bash
系统设置 > 隐私与安全性 > 麦克风
找到浏览器（Chrome/Firefox/Safari）
打开开关授予权限
```

### Windows

**问题**: "未找到音频设备"

**解决**:
1. 检查设备管理器中的音频设备
2. 更新音频驱动程序
3. 在"声音设置"中设置默认麦克风

### Linux

**问题**: PulseAudio/ALSA 配置

**解决**:
```bash
# 检查音频设备
arecord -l

# 测试录音
arecord -d 3 test.wav
aplay test.wav

# 检查 PulseAudio
pactl list sources
```

---

## 📱 移动端支持

### iOS Safari

- ✅ 支持麦克风访问
- ⚠️ 需要用户交互触发（点击按钮）
- ⚠️ 可能需要在"设置 > Safari > 麦克风"中启用

### Android Chrome

- ✅ 完全支持
- 需要在权限对话框中允许麦克风访问

---

## 🔧 开发者调试

### 启用详细日志

打开浏览器控制台 (F12)，查看:
- AudioContext 采样率
- AudioWorklet 重采样日志
- 音频流状态

### 常用命令

```javascript
// 查看当前音频上下文
console.log(audioContext);

// 查看媒体流轨道
console.log(mediaStream.getTracks());

// 查看识别器状态
console.log(recognizer);
```

---

## ❓ 仍然无法解决？

如果以上方法都无法解决问题，请提供以下信息：

1. **操作系统**: macOS / Windows / Linux
2. **浏览器**: Chrome / Firefox / Safari (含版本号)
3. **错误信息**: 完整的错误提示
4. **浏览器控制台**: F12 打开控制台的截图
5. **测试结果**: 点击"测试麦克风"的结果

提交 Issue: https://github.com/YOUR_REPO/issues

---

**更新时间**: 2025-11-08  
**版本**: 1.1.0 (支持自动重采样)
