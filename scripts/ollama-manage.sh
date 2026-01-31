#!/usr/bin/env bash
# scripts/ollama-manage.sh - Manage Ollama models

set -euo pipefail

ACTION="${1:-list}"

case "$ACTION" in
    list)
        echo "📋 Available Ollama models:"
        ollama list
        ;;
    pull)
        MODEL="${2:-llama3.2}"
        echo "📦 Downloading model: $MODEL"
        ollama pull "$MODEL"
        ;;
    remove)
        MODEL="${2:-}"
        if [ -z "$MODEL" ]; then
            echo "❌ Usage: $0 remove <model-name>"
            exit 1
        fi
        echo "🗑️  Removing model: $MODEL"
        ollama rm "$MODEL"
        ;;
    status)
        echo "🔍 Ollama service status:"
        curl -s http://localhost:11434/api/tags | jq '.'
        ;;
    switch)
        MODEL="${2:-}"
        if [ -z "$MODEL" ]; then
            echo "❌ Usage: $0 switch <model-name>"
            exit 1
        fi
        echo "🔄 Switching to model: $MODEL"
        CONFIG_PATH="${OPENCLAW_STATE_DIR}/openclaw.json"
        if [ -f "$CONFIG_PATH" ]; then
            # Use jq to update the model in the config
            jq ".agent.model = \"ollama/$MODEL\"" "$CONFIG_PATH" > "${CONFIG_PATH}.tmp"
            mv "${CONFIG_PATH}.tmp" "$CONFIG_PATH"
            echo "✅ Updated config to use ollama/$MODEL"
        else
            echo "❌ Config file not found: $CONFIG_PATH"
            exit 1
        fi
        ;;
    recommended)
        echo "🦙 Recommended Ollama models for OpenClaw:"
        echo ""
        echo "  llama3.2          ~2GB   - Fast, good for testing (default)"
        echo "  llama3.2:3b       ~2GB   - Smaller, faster"
        echo "  llama3.1:8b       ~4.7GB - Better quality"
        echo "  mistral:7b        ~4.1GB - Good balance"
        echo "  qwen2.5-coder:7b  ~4.7GB - Best for coding tasks"
        echo ""
        echo "Pull a model: $0 pull <model-name>"
        ;;
    *)
        echo "Usage: $0 {list|pull|remove|status|switch|recommended} [model-name]"
        exit 1
        ;;
esac
