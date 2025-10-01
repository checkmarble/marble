const fetch = require('node-fetch');

function parseMarkdownToSlackBlocks(markdownText, prBaseUrl) {
  const blocks = [];

  // Fonction utilitaire pour ajouter un bloc texte
  function addTextBlock(text) {
    if (text && text.trim()) {
      blocks.push({
        type: 'section',
        text: { type: 'mrkdwn', text },
      });
    }
  }

  // Regex pour Markdown images ![alt](url)
  const regexImgMd = /!\[(.*?)\]\((.*?)\)/g;
  // Regex pour balises HTML <img ...>
  const regexImgHtml = /<img[^>]*src="([^"]+)"[^>]*alt="([^"]*)"[^>]*>/gi;

  let text = markdownText;
  let cursor = 0;

  // Fonction générique de parsing pour 2 types d'images
  function processNextImage(match, url, alt, start, end) {
    // Texte avant l'image
    if (start > cursor) {
      let segment = text.substring(cursor, start);
      addTextBlock(formatMarkdownText(segment, prBaseUrl));
    }
    // Image
    blocks.push({
      type: 'image',
      image_url: url,
      alt_text: alt || 'image',
    });
    cursor = end;
  }

  // On combine les 2 regex dans un seul parcours
  const matches = [];
  let m;
  while ((m = regexImgMd.exec(text)) !== null) {
    matches.push({ start: m.index, end: regexImgMd.lastIndex, url: m[2], alt: m[1] });
  }
  while ((m = regexImgHtml.exec(text)) !== null) {
    matches.push({ start: m.index, end: regexImgHtml.lastIndex, url: m[1], alt: m[2] });
  }

  // Trier les matches par ordre d'apparition
  matches.sort((a, b) => a.start - b.start);

  for (const img of matches) {
    processNextImage(null, img.url, img.alt, img.start, img.end);
  }

  // Texte restant après la dernière image
  if (cursor < text.length) {
    let segment = text.substring(cursor);
    addTextBlock(formatMarkdownText(segment, prBaseUrl));
  }

  return blocks;
}

// Mise en forme Slack : titres, puces, liens, suppression GitHub
function formatMarkdownText(text, prBaseUrl) {
  // Titres -> gras
  text = text.replace(/^### (.*)$/gm, '*$1*');
  text = text.replace(/^## (.*)$/gm, '*$1*');
  text = text.replace(/^# (.*)$/gm, '*$1*');

  // Puces
  text = text.replace(/^- /gm, '• ');

  // Liens Markdown [text](url) -> Slack <url|text>
  text = text.replace(/\[([^\]]+)\]\((https?:\/\/[^)]+)\)/g, '<$2|$1>');

  // PR refs #123 -> lien
  text = text.replace(/#(\d+)/g, (match, p1) => {
    const url = `${prBaseUrl}/pull/${p1}`;
    return `<${url}|#${p1}>`;
  });

  // Supprimer tous les liens GitHub directs (hors PR déjà remplacées)
  text = text.replace(/https?:\/\/github\.com\/[^\s)]+/g, '');

  return text.trim();
}

// Fonction d'envoi
async function postReleaseToSlack({ webhookUrl, repo, tag, url, body, name }) {
  const prBaseUrl = `https://github.com/${repo}`;
  const blocks = [
    {
      type: 'header',
      text: { type: 'plain_text', text: `🚀 New release: ${name}`, emoji: true },
    },
    {
      type: 'section',
      text: { type: 'mrkdwn', text: `🔗 <${url}|View on GitHub>` },
    },
    { type: 'divider' },
    ...parseMarkdownToSlackBlocks(body, prBaseUrl),
  ];

  const payload = { blocks };
  console.log('Sending to Slack with payload:', JSON.stringify(payload, null, 2));

  const res = await fetch(webhookUrl, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  });

  if (!res.ok) {
    throw new Error(`Slack API error: ${res.status} - ${await res.text()}`);
  }
  console.log('✅ Successfully posted to Slack');
}

// Lancer si exécuté depuis GitHub Action
if (require.main === module) {
  const {
    SLACK_WEBHOOK_URL,
    GITHUB_REPOSITORY,
    RELEASE_TAG,
    RELEASE_URL,
    RELEASE_BODY,
    RELEASE_NAME,
  } = process.env;

  postReleaseToSlack({
    webhookUrl: SLACK_WEBHOOK_URL,
    repo: GITHUB_REPOSITORY,
    tag: RELEASE_TAG,
    url: RELEASE_URL,
    body: RELEASE_BODY,
    name: RELEASE_NAME || RELEASE_TAG,
  }).catch((err) => {
    console.error('❌ Failed to post release to Slack:', err);
    process.exit(1);
  });
}

module.exports = { parseMarkdownToSlackBlocks, formatMarkdownText };
