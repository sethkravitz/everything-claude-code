# X.com Post Evaluator

Fetch and evaluate Claude Code techniques from X.com posts using Grok API.

## Quick Start

### 1. Get Grok API Key

Visit https://console.x.ai/ and get your API key.

### 2. Set Environment Variable

Add to your shell profile (~/.zshrc or ~/.bashrc):

```bash
export GROK_API_KEY="xai-..."
# OR
export XAI_API_KEY="xai-..."
```

Then reload:
```bash
source ~/.zshrc
```

### 3. Test the Fetcher

```bash
node staging/bin/fetch-x-post.js https://x.com/anthropicai/status/1234567890
```

### 4. Use the Skill

In Claude Code:
```
/x-evaluator https://x.com/username/status/1234567890
```

## How It Works

1. Calls Grok API via `fetch-x-post.js` script
2. Grok extracts post content (bypasses X.com's bot blocking)
3. Claude applies EVALUATE.md framework
4. Provides recommendation: IGNORE, PARK, MICRO-TEST, or ADOPT

## Troubleshooting

### "GROK_API_KEY not set"
- Make sure you've exported the environment variable
- Restart your terminal after adding to shell profile
- Check with: `echo $GROK_API_KEY`

### "Invalid X.com URL"
- URL must start with `https://x.com/` or `https://twitter.com/`
- Must be a valid post URL format

### "Grok API Error"
- Check your API key is valid
- Ensure you have API credits remaining
- Verify the post URL is accessible

## Files

- `SKILL.md` - Skill definition and instructions for Claude
- `staging/bin/fetch-x-post.js` - Grok API integration script
- `README.md` - This file
