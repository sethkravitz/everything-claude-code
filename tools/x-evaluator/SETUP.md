# X.com Evaluator Setup Guide

## Step 1: Get Grok API Key

1. Go to https://console.x.ai/
2. Create or access your API key
3. **IMPORTANT:** Enable model permissions for:
   - `grok-3` (minimum)
   - `grok-4` (recommended)

## Step 2: Add to Environment

Already done! Your API key is in `~/.zshrc`:
```bash
export GROK_API_KEY="xai-..."
```

## Step 3: Enable Model Permissions

**Current Issue:** Your API key lacks permissions for Grok 3/4 models.

To fix:
1. Visit https://console.x.ai/
2. Click on your API key
3. Under "Permissions" or "Models", enable these exact models:
   - ✅ grok-4-1-fast-reasoning (recommended)
   - ✅ grok-4-1-fast-non-reasoning
   - ✅ grok-4-fast-non-reasoning
4. Save changes

## Step 4: Test

After enabling permissions:

```bash
# Source your profile to load the API key
source ~/.zshrc

# Test with default (grok-4-1-fast-reasoning)
node staging/bin/fetch-x-post.js "https://x.com/anthropicai/status/1880654764315332702"

# Or specify a different model
node staging/bin/fetch-x-post.js "https://x.com/anthropicai/status/1880654764315332702" "grok-4-fast-non-reasoning"

# Or set default model
export GROK_MODEL="grok-4-1-fast-reasoning"
node staging/bin/fetch-x-post.js "https://x.com/anthropicai/status/1880654764315332702"
```

## Common Issues

### "API key lacks permissions"
- Go to console.x.ai and enable grok-3/grok-4 for your API key

### "Model was deprecated"
- Use grok-3 or grok-4 (older models like grok-beta are deprecated)

### "API key not set"
- Run `source ~/.zshrc` to load it in current terminal
- Or restart your terminal

## Once Working

Use the skill in Claude Code:
```
/x-evaluator https://x.com/username/status/1234567890
```

Claude will:
1. Fetch post content via Grok
2. Apply EVALUATE.md framework
3. Recommend: IGNORE, PARK, MICRO-TEST, or ADOPT
