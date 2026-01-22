#!/usr/bin/env node

/**
 * Fetch X.com post content via OpenRouter Grok API
 * Usage: node fetch-x-post-openrouter.js <X.com URL>
 */

const https = require('https');
const fs = require('fs');
const path = require('path');

// Load .env file from project root
function loadEnv() {
  const envPath = path.join(__dirname, '../../.env');
  if (fs.existsSync(envPath)) {
    try {
      const envContent = fs.readFileSync(envPath, 'utf8');
      envContent.split('\n').forEach(line => {
        const trimmed = line.trim();
        if (trimmed && !trimmed.startsWith('#')) {
          const [key, ...valueParts] = trimmed.split('=');
          if (key && valueParts.length > 0) {
            let value = valueParts.join('=').trim();
            // Remove quotes if present
            if ((value.startsWith('"') && value.endsWith('"')) ||
                (value.startsWith("'") && value.endsWith("'"))) {
              value = value.slice(1, -1);
            }
            process.env[key.trim()] = value;
          }
        }
      });
    } catch (error) {
      console.error('Warning: Failed to read .env file:', error.message);
      console.error('Continuing with environment variables from shell...');
    }
  }
}

loadEnv();

const OPENROUTER_API_KEY = process.env.OPENROUTER_API_KEY;
const OPENROUTER_API_URL = 'openrouter.ai';
// Grok 4.1 fast with web search enabled via :online suffix
const GROK_MODEL = process.env.GROK_MODEL || process.argv[3] || 'x-ai/grok-4.1-fast:online';

if (!OPENROUTER_API_KEY) {
  console.error('Error: OPENROUTER_API_KEY not set');
  console.error('Create a .env file in the project root with:');
  console.error('  OPENROUTER_API_KEY="sk-or-v1-..."');
  console.error('');
  console.error('Get your API key from: https://openrouter.ai/keys');
  console.error('See .env.example for template');
  process.exit(1);
}

const xUrl = process.argv[2];
if (!xUrl) {
  console.error('Usage: fetch-x-post-openrouter.js <X.com URL> [model]');
  console.error('  model: x-ai/grok-4.1-fast:online (default)');
  console.error('         x-ai/grok-4-fast:online');
  console.error('  or set GROK_MODEL environment variable');
  process.exit(1);
}

// Validate X.com URL
if (!xUrl.match(/^https?:\/\/(twitter\.com|x\.com)\//)) {
  console.error('Error: Invalid X.com or twitter.com URL');
  process.exit(1);
}

const requestBody = JSON.stringify({
  model: GROK_MODEL,
  messages: [
    {
      role: "user",
      content: `Extract the complete content from this X.com post: ${xUrl}\n\nInclude:\n- Author name and handle\n- Timestamp\n- Full post text\n- Any thread replies (if part of a thread)\n- Media descriptions (if any)\n\nBe precise - fetch content from this exact post URL only.`
    }
  ],
  temperature: 0
});

const options = {
  hostname: OPENROUTER_API_URL,
  path: '/api/v1/chat/completions',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${OPENROUTER_API_KEY}`,
    'HTTP-Referer': 'https://github.com/everything-claude-code',
    'X-Title': 'X.com Post Fetcher',
    'Content-Length': Buffer.byteLength(requestBody)
  }
};

const req = https.request(options, (res) => {
  let data = '';

  res.on('data', (chunk) => {
    data += chunk;
  });

  res.on('end', () => {
    try {
      if (!data) {
        console.error('Empty response from OpenRouter API');
        process.exit(1);
      }

      const response = JSON.parse(data);

      if (res.statusCode !== 200) {
        console.error('OpenRouter API Error (status ' + res.statusCode + '):', response.error?.message || response.error || 'Unknown error');
        console.error('Full response:', JSON.stringify(response, null, 2));
        process.exit(1);
      }

      const content = response.choices?.[0]?.message?.content;
      if (!content) {
        console.error('No content returned from OpenRouter API');
        console.error('Response:', JSON.stringify(response, null, 2));
        process.exit(1);
      }

      // Output the extracted content
      console.log(content);

      // Show citations if available
      const annotations = response.choices?.[0]?.message?.annotations;
      if (annotations && annotations.length > 0) {
        console.log('\n--- Citations ---');
        annotations.forEach((annotation) => {
          if (annotation.type === 'url_citation') {
            console.log(`- ${annotation.url_citation.title}: ${annotation.url_citation.url}`);
          }
        });
      }
    } catch (error) {
      console.error('Failed to parse OpenRouter API response:', error.message);
      console.error('Raw response:', data.substring(0, 500));
      process.exit(1);
    }
  });
});

req.on('error', (error) => {
  console.error('Request failed:', error.message);
  process.exit(1);
});

req.on('timeout', () => {
  console.error('Request timed out after 30 seconds');
  req.destroy();
  process.exit(1);
});

req.setTimeout(30000); // 30 second timeout

req.write(requestBody);
req.end();
