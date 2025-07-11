const fetch = require('node-fetch');

// Util: transforms a markdown text into a Slack blocks array with images intercalated
function parseMarkdownToSlackBlocks(markdownText, prBaseUrl) {
  const blocks = [];
  // Regex to detect markdown images : ![alt](url)
  const regexImg = /!\[(.*?)\]\((.*?)\)/g;

  let lastIndex = 0;
  let match;

  while ((match = regexImg.exec(markdownText)) !== null) {
    const index = match.index;

    // Text before the image
    if (index > lastIndex) {
      let textSegment = markdownText.substring(lastIndex, index).trim();
      if (textSegment) {
        textSegment = formatMarkdownText(textSegment, prBaseUrl);
        blocks.push({
          type: 'section',
          text: {
            type: 'mrkdwn',
            text: textSegment,
          },
        });
      }
    }

    // Found image
    const alt = match[1];
    const url = match[2];
    blocks.push({
      type: 'image',
      image_url: url,
      alt_text: alt || 'image',
    });

    lastIndex = regexImg.lastIndex;
  }

  // Text after the last image
  if (lastIndex < markdownText.length) {
    let textSegment = markdownText.substring(lastIndex).trim();
    if (textSegment) {
      textSegment = formatMarkdownText(textSegment, prBaseUrl);
      blocks.push({
        type: 'section',
        text: {
          type: 'mrkdwn',
          text: textSegment,
        },
      });
    }
  }

  return blocks;
}

// Slack text formatting function: bold titles, bullet points, PR links
function formatMarkdownText(text, prBaseUrl) {
  // Replace titles #, ##, ### by bold
  text = text.replace(/^### (.*)$/gm, '*$1*');
  text = text.replace(/^## (.*)$/gm, '*$1*');
  text = text.replace(/^# (.*)$/gm, '*$1*');

  // Replace bullet points - by • (only at the beginning of the line)
  text = text.replace(/^- /gm, '• ');

  // Replace #123 by a PR link
  text = text.replace(/#(\d+)/g, (match, p1) => {
    const url = `${prBaseUrl}/pull/${p1}`;
    return `<${url}|#${p1}>`;
  });

  return text;
}

const slackWebhookUrl = process.env.SLACK_WEBHOOK_URL;
const repo = process.env.GITHUB_REPOSITORY;
const release = {
  name: process.env.RELEASE_NAME || process.env.RELEASE_TAG,
  tag_name: process.env.RELEASE_TAG,
  html_url: process.env.RELEASE_URL,
  body: process.env.RELEASE_BODY,
};

async function postReleaseToSlack(release) {
  const prBaseUrl = `https://github.com/${repo}`;
  const blocks = parseMarkdownToSlackBlocks(release.body, prBaseUrl);

  const payload = {
    blocks: [
      {
        type: 'header',
        text: {
          type: 'plain_text',
          text: `🚀 New release: ${release.name}`,
          emoji: true,
        },
      },
      {
        type: 'section',
        text: {
          type: 'mrkdwn',
          text: `🔗 <${release.html_url}|View on GitHub>`,
        },
      },
      { type: 'divider' },
      ...blocks,
    ],
  };

  const res = await fetch(slackWebhookUrl, {
    method: 'POST',
    body: JSON.stringify(payload),
    headers: { 'Content-Type': 'application/json' },
  });

  const text = await res.text();

  if (res.status !== 200 || text !== 'ok') {
    throw new Error(`Slack API error: ${res.status} - ${text}`);
  }
}

postReleaseToSlack(release).catch((err) => {
  console.error('❌ Failed to post release to Slack:', err);
  process.exit(1);
});
