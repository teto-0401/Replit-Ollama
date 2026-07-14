#!/bin/bash
set -e

echo "Installing Ollama..."

# インストール（Replit環境はインストールがリセットされるため）
nix profile add nixpkgs#ollama

# PATHを更新
if command -v ollama >/dev/null 2>&1; then
    OLLAMA_BIN=$(command -v ollama)
else
    OLLAMA_PATH=$(nix profile list | grep -o '/nix/store/[^ ]*-ollama-[^ ]*' | head -n1)

    if [ -z "$OLLAMA_PATH" ]; then
        echo "Error: Ollama installation not found."
        exit 1
    fi

    export PATH="$OLLAMA_PATH/bin:$PATH"
    OLLAMA_BIN="$OLLAMA_PATH/bin/ollama"
fi

echo "Using: $OLLAMA_BIN"

# サーバー起動（既に起動していたらスキップ）
if ! pgrep -f "ollama serve" >/dev/null; then
    echo "Starting Ollama server..."
    ollama serve >/tmp/ollama.log 2>&1 &
    sleep 5
else
    echo "Ollama server already running."
fi

# モデルをダウンロード
echo "Checking model..."
ollama pull qwen2.5:1.5b

echo
echo "=================================="
echo "Ollama is ready!"
echo "API: http://127.0.0.1:11434"
echo "Model: qwen2.5:1.5b"
echo "=================================="
#server.jsへ