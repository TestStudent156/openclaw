# Codespaces + Ollama Troubleshooting

## Ollama not starting

```bash
# Check if Ollama is running
curl http://localhost:11434/api/tags

# Start manually if needed
ollama serve > /tmp/ollama.log 2>&1 &

# Check logs
tail -f /tmp/ollama.log
```

## Model download fails

```bash
# Check disk space (models are 2-5GB each)
df -h

# Try smaller model
ollama pull llama3.2:3b
```

## Gateway can't connect to Ollama

```bash
# Verify Ollama is listening
curl -v http://localhost:11434/api/tags

# Check OpenClaw config
cat ~/.openclaw-state/openclaw.json | jq '.models.providers.ollama'

# Ensure baseUrl is correct (should be http://localhost:11434)
```

## Switch back to cloud providers

Edit `~/.openclaw-state/openclaw.json`:

```json
{
  "agent": {
    "model": "anthropic/claude-opus-4-5"
  }
}
```

Then set your API key in [Codespaces Secrets](https://github.com/settings/codespaces).
