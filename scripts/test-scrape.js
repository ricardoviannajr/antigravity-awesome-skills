const https = require('https');

async function fetchPage(url) {
    return new Promise((resolve, reject) => {
        https.get(url, (res) => {
            let data = '';
            res.on('data', (chunk) => data += chunk);
            res.on('end', () => resolve(data));
        }).on('error', reject);
    });
}

async function main() {
    const url = 'https://claudemarketplaces.com/skills/category/code-review';
    console.log(`Fetching ${url}...`);
    const html = await fetchPage(url);
    
    // Simple regex to find skill links
    // Format usually: <a href="/skills/user/repo/id">
    const skillRegex = /\/skills\/[^\s"'>]+\/[^\s"'>]+\/[^\s"'>]+/g;
    const matches = html.match(skillRegex) || [];
    
    // Unique skills
    const uniqueSkills = [...new Set(matches)];
    console.log(`Found ${uniqueSkills.length} potential skills.`);
    
    // Take top 25
    const top25 = uniqueSkills.slice(0, 25);
    top25.forEach((path, i) => {
        console.log(`${i + 1}: https://claudemarketplaces.com${path}`);
    });
}

main().catch(console.error);
