#!/usr/bin/env bash
set -euo pipefail

# Check if gateway is already running
if pgrep -f "openclaw.*gateway" > /dev/null; then
    echo "⚠️  OpenClaw Gateway is already running"
else
    echo ""
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                                                              ║"
    echo "║                🦞 OpenClaw Development                       ║"
    echo "║                                                              ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""
    echo "📋 Quick Commands:"
    echo "   pnpm openclaw gateway --verbose     # Start gateway"
    echo "   pnpm openclaw gateway --help        # Gateway options"
    echo "   pnpm test                           # Run tests"
    echo "   pnpm build                          # Build project"
    echo "   pnpm lint                           # Run linter"
    echo "   pnpm ui:dev                         # Start UI dev server"
    echo ""
    echo "🔌 Port Forwarding:"
    echo "   18789 - OpenClaw Gateway (WebSocket)"
    echo "   18790 - Canvas Host"
    echo "   18791 - Node Host"
    echo "   18792 - Browser Relay"
    echo "   5173  - UI Dev Server"
    echo ""
    echo "⚙️  Configuration:"
    echo "   Location: ${OPENCLAW_STATE_DIR}/openclaw.json"
    echo "   Workspace: ${OPENCLAW_WORKSPACE_DIR}"
    echo ""
    echo "🦙 Ollama Status:"
    if curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
        echo "   ✅ Running at http://localhost:11434"
        echo "   Models: $(ollama list 2>/dev/null | tail -n +2 | wc -l) installed"
    else
        echo "   ⚠️  Not running (start with: ollama serve &)"
    fi
    echo ""
    echo "📝 Manage models: bash scripts/ollama-manage.sh recommended"
    echo ""
    echo "🚀 Getting Started:"
    echo "   1. Configure API keys in GitHub Codespaces Secrets (optional):"
    echo "      https://github.com/settings/codespaces"
    echo "   2. Or use Ollama (no API keys needed) - see model management below"
    echo "   3. Run: pnpm openclaw gateway --verbose"
    echo "   4. Access via the forwarded HTTPS URL"
    echo "   5. Connect your Android app using the forwarded URL"
    echo ""
    echo "�� Documentation: https://docs.openclaw.ai"
    echo ""
fi
