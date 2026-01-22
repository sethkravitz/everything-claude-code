#!/usr/bin/env node

/**
 * Fetch X.com post content via Grok API
 * Usage: node fetch-x-post.js <X.com URL>
 */

const https = require('https');

const GROK_API_KEY = process.env.GROK_API_KEY || process.env.XAI_API_KEY;
const GROK_API_URL = 'api.x.ai';
const GROK_MODEL = process.env.GROK_MODEL || process.argv[3] || 'grok-4-1-fast-reasoning'; // Must use Grok 4+ for web search

if (!GROK_API_KEY) {
  console.error('Error: GROK_API_KEY or XAI_API_KEY environment variable not set');
  process.exit(1);
}

const xUrl = process.argv[2];
if (!xUrl) {
  console.error('Usage: fetch-x-post.js <X.com URL> [model]');
  console.error('  model: grok-4-1-fast-reasoning (default), grok-4-1-fast-non-reasoning, grok-4-fast-non-reasoning');
  console.error('  or set GROK_MODEL environment variable');
  process.exit(1);
}

// Validate X.com URL
if (!xUrl.match(/^https?:\/\/(twitter\.com|x\.com)\//)) {
  console.error('Error: Invalid X.com or twitter.com URL');
  process.exit(1);
}

const requestBody = JSON.stringify({
  messages: [
    {
      role: "user",
      content: `What is the content of this X.com post? ${xUrl}`
    }
  ],
  model: GROK_MODEL,
  stream: false,
  temperature: 0,
  search_parameters: {
    mode: "on"
  }
});

const options = {
  hostname: GROK_API_URL,
  path: '/v1/chat/completions',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${GROK_API_KEY}`,
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
        console.error('Empty response from Grok API');
        process.exit(1);
      }
      const response = JSON.parse(data);

      if (res.statusCode !== 200) {
        console.error('Grok API Error (status ' + res.statusCode + '):', response.error?.message || response.error || 'Unknown error');
        console.error('Full response:', JSON.stringify(response, null, 2));
        process.exit(1);
      }

      const content = response.choices?.[0]?.message?.content;
      if (!content) {
        console.error('No content returned from Grok API');
        process.exit(1);
      }

      // Output the extracted content
      console.log(content);
    } catch (error) {
      console.error('Failed to parse Grok API response:', error.message);
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
