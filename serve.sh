#!/bin/bash

# 简单的静态文件服务器脚本

PORT=${1:-8080}

echo "🚀 启动静态文件服务器..."
echo "📁 目录: build/"
echo "🌐 端口: $PORT"
echo ""

# 检查 Python 版本
if command -v python3 &> /dev/null; then
    echo "使用 Python 3 启动服务器..."
    echo ""
    echo "✅ 服务器运行在:"
    echo "   本地: http://localhost:$PORT"
    echo "   网络: http://$(ipconfig getifaddr en0 || hostname -I | awk '{print $1}'):$PORT"
    echo ""
    echo "按 Ctrl+C 停止服务器"
    echo ""
    cd build && python3 -m http.server $PORT --bind 0.0.0.0
elif command -v python &> /dev/null; then
    echo "使用 Python 2 启动服务器..."
    echo ""
    echo "✅ 服务器运行在:"
    echo "   本地: http://localhost:$PORT"
    echo "   网络: http://$(ipconfig getifaddr en0 || hostname -I | awk '{print $1}'):$PORT"
    echo ""
    echo "按 Ctrl+C 停止服务器"
    echo ""
    cd build && python -m SimpleHTTPServer $PORT
else
    echo "❌ 错误: 未找到 Python"
    echo "请安装 Python 或使用其他方式启动服务器"
    exit 1
fi
