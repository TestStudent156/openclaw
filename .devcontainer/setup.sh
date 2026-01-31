#!/usr/bin/env bash
set -euo pipefail

echo "🦞 Setting up OpenClaw development environment..."

# Install pnpm globally
echo "📦 Installing pnpm..."
npm install -g pnpm@latest

# Install dependencies
echo "📚 Installing dependencies..."
pnpm install --frozen-lockfile

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

echo ""
echo "✅ Setup complete!"
echo ""
echo "📝 Next steps:"
echo "   1. Set API keys in GitHub Codespaces Secrets"
echo "   2. Run: pnpm openclaw gateway --verbose"
echo "   3. Access via forwarded HTTPS URL (port 18789)"
echo ""
