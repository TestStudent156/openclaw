#!/usr/bin/env bash
set -euo pipefail

echo "🦞 Setting up OpenClaw development environment..."

# Install pnpm globally
echo "📦 Installing pnpm..."
npm install -g pnpm@latest

# Install dependencies
echo "📚 Installing dependencies..."
pnpm install --frozen-lockfile

# Install Ollama (optional, if OPENCLAW_USE_OLLAMA is set or no API keys)
echo "🦙 Installing Ollama for local models..."
curl -fsSL https://ollama.com/install.sh | sh

# Start Ollama service in background
echo "🚀 Starting Ollama service..."
ollama serve > /dev/null 2>&1 &
OLLAMA_PID=$!
sleep 2

# Pull a default model (llama3.2 is small and fast)
echo "📦 Downloading default model (llama3.2 ~2GB)..."
ollama pull llama3.2

echo "✅ Ollama setup complete (PID: $OLLAMA_PID)"

# Build the project
echo "🔨 Building OpenClaw..."
pnpm build

# Build the UI
echo "🎨 Building Control UI..."
pnpm ui:build

# Create state directories
echo "📁 Creating state directories..."
mkdir -p "${OPENCLAW_STATE_DIR}/workspace"
mkdir -p "${OPENCLAW_STATE_DIR}/credentials"
mkdir -p "${OPENCLAW_STATE_DIR}/agents"

# Create default config if it doesn't exist
CONFIG_PATH="${OPENCLAW_STATE_DIR}/openclaw.json"
if [ ! -f "$CONFIG_PATH" ]; then
    echo "⚙️  Creating default configuration..."
    
    # Check if API keys are available
    if [ -z "$ANTHROPIC_API_KEY" ] && [ -z "$OPENAI_API_KEY" ]; then
        echo "📝 No API keys found, configuring Ollama as default..."
        cat > "$CONFIG_PATH" << 'CONFIGEOF'
{
  "gateway": {
    "mode": "local",
    "bind": "0.0.0.0",
    "port": 18789,
    "controlUi": {
      "enabled": true
    }
  },
  "agent": {
    "model": "ollama/llama3.2"
  },
  "models": {
    "providers": {
      "ollama": {
        "baseUrl": "http://localhost:11434",
        "api": "openai-completions",
        "models": [
          {
            "id": "llama3.2",
            "name": "Llama 3.2",
            "reasoning": false,
            "input": ["text"],
            "cost": {"input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0},
            "contextWindow": 128000,
            "maxTokens": 8192
          }
        ]
      }
    }
  }
}
CONFIGEOF
    else
        echo "🔑 API keys detected, using cloud providers..."
        cat > "$CONFIG_PATH" << 'CONFIGEOF'
{
  "gateway": {
    "mode": "local",
    "bind": "0.0.0.0",
    "port": 18789,
    "controlUi": {
      "enabled": true
    }
  },
  "agent": {
    "model": "anthropic/claude-opus-4-5"
  }
}
CONFIGEOF
    fi
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "📝 Next steps:"
if [ -z "$ANTHROPIC_API_KEY" ] && [ -z "$OPENAI_API_KEY" ]; then
    echo "   🦙 Using Ollama (local models) - no API keys needed!"
    echo "   1. Run: pnpm openclaw gateway --verbose"
    echo "   2. Access via forwarded HTTPS URL (port 18789)"
    echo "   3. (Optional) Set API keys in GitHub Codespaces Secrets for cloud providers"
    echo "   4. Manage models: bash scripts/ollama-manage.sh recommended"
else
    echo "   1. Run: pnpm openclaw gateway --verbose"
    echo "   2. Access via forwarded HTTPS URL (port 18789)"
fi
echo ""
