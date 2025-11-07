#!/bin/bash

# 下载 Vosk 中文模型到 static/models 目录
# 使用方法: bash download-model.sh

echo "🎤 开始下载 Vosk 中文语音识别模型..."
echo ""

# 创建目录
mkdir -p static/models

# 模型 URL 和文件名
MODEL_URL="https://alphacephei.com/vosk/models/vosk-model-small-cn-0.22.zip"
MODEL_FILE="static/models/vosk-model-small-cn-0.22.zip"

# 检查是否已存在
if [ -f "$MODEL_FILE" ]; then
    echo "✅ 模型文件已存在: $MODEL_FILE"
    echo ""
    
    # 获取文件大小
    FILE_SIZE=$(du -h "$MODEL_FILE" | cut -f1)
    echo "📦 文件大小: $FILE_SIZE"
    echo ""
    
    read -p "是否重新下载? (y/N): " confirm
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        echo "跳过下载"
        exit 0
    fi
    echo ""
fi

# 下载模型
echo "⬇️  正在下载模型 (约 42MB)..."
echo "下载地址: $MODEL_URL"
echo ""

if command -v curl &> /dev/null; then
    # 使用 curl 下载
    curl -L --progress-bar "$MODEL_URL" -o "$MODEL_FILE"
elif command -v wget &> /dev/null; then
    # 使用 wget 下载
    wget --show-progress "$MODEL_URL" -O "$MODEL_FILE"
else
    echo "❌ 错误: 未找到 curl 或 wget 命令"
    echo "请手动下载模型:"
    echo "  $MODEL_URL"
    echo "并保存到:"
    echo "  $MODEL_FILE"
    exit 1
fi

# 检查下载是否成功
if [ -f "$MODEL_FILE" ]; then
    FILE_SIZE=$(du -h "$MODEL_FILE" | cut -f1)
    echo ""
    echo "✅ 下载完成!"
    echo "📦 文件大小: $FILE_SIZE"
    echo "📁 保存位置: $MODEL_FILE"
    echo ""
    echo "🚀 现在可以运行 'npm run dev' 启动应用了!"
else
    echo ""
    echo "❌ 下载失败"
    echo "请检查网络连接或手动下载模型"
    exit 1
fi
