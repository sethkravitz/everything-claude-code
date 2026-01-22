#!/bin/bash
set -e  # Exit immediately if a command exits with non-zero status

# Usage: ./tools/x-evaluator/evaluate.sh <URL>
# Detects X.com URLs and routes to appropriate fetcher

URL="$1"

if [ -z "$URL" ]; then
  echo "Usage: evaluate.sh <URL>"
  exit 1
fi

# Check if X.com/Twitter URL using bash regex (safer than echo | grep)
if [[ "$URL" =~ ^https?://(twitter\.com|x\.com)/ ]]; then
  # Use X.com fetcher
  node "$(dirname "$0")/fetch-x-post-openrouter.js" "$URL" || exit $?
else
  # Return URL for WebFetch
  echo "Use WebFetch for: $URL"
  echo "Not an X.com URL - Claude Code WebFetch will handle this automatically"
fi
