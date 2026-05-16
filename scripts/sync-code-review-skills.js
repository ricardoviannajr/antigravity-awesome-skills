const https = require('https');
const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const REPO_ROOT = path.join(__dirname, '..');
const SKILLS_DIR = path.join(REPO_ROOT, 'skills');
const CATEGORY_URL = 'https://claudemarketplaces.com/skills/category/code-review';
const TOP_COUNT = 25;

async function fetchPage(url) {
    return new Promise((resolve, reject) => {
        https.get(url, (res) => {
            let data = '';
            res.on('data', (chunk) => data += chunk);
            res.on('end', () => resolve(data));
        }).on('error', reject);
    });
}

function getSkillPaths(html) {
    const skillRegex = /\/skills\/[^\s"'>]+\/[^\s"'>]+\/[^\s"'>]+/g;
    const matches = html.match(skillRegex) || [];
    return [...new Set(matches)];
}

async function getGitHubInfo(skillPath) {
    const url = `https://claudemarketplaces.com${skillPath}`;
    console.log(`Analyzing skill: ${url}...`);
    const html = await fetchPage(url);
    
    // Look for GitHub link
    const githubRegex = /https:\/\/github\.com\/[^\s"'>]+/g;
    const githubMatches = html.match(githubRegex) || [];
    
    // Prefer the one that looks like a repo
    // Often there is a "View on GitHub" button
    const repoUrl = githubMatches.find(u => !u.includes('/issues') && !u.includes('/pulls') && !u.includes('/blob/'));
    
    // Look for skill ID in install command: npx skills add <url> --skill <id>
    const installRegex = /--skill\s+([^\s"'>]+)/;
    const installMatch = html.match(installRegex);
    const skillId = installMatch ? installMatch[1] : skillPath.split('/').pop();
    
    return { repoUrl, skillId };
}

async function syncSkill(id, repoUrl) {
    if (!repoUrl) {
        console.warn(`No GitHub URL found for skill ${id}. Skipping.`);
        return;
    }

    const targetDir = path.join(SKILLS_DIR, id);
    if (!fs.existsSync(targetDir)) {
        fs.mkdirSync(targetDir, { recursive: true });
    }

    const tempDir = path.join(REPO_ROOT, '.temp_fetch_' + id);
    if (fs.existsSync(tempDir)) fs.rmSync(tempDir, { recursive: true, force: true });

    try {
        console.log(`Fetching ${id} from ${repoUrl}...`);
        // Sparse clone to get only the skill folder
        execSync(`git clone --depth 1 --filter=blob:none --sparse ${repoUrl} "${tempDir}"`, { stdio: 'inherit' });
        
        // Try to find the skill folder or SKILL.md
        // Case 1: skill is in a folder named <id>
        // Case 2: skill is in root
        // Case 3: skill is in a folder named skills/<id>
        
        let sourcePath = '';
        const allFiles = execSync(`git -C "${tempDir}" ls-tree -r --name-only HEAD`).toString().split('\n').filter(Boolean);
        
        // Strategy 1: Exact folder match
        let skillFile = allFiles.find(f => f.endsWith(`/${id}/SKILL.md`) || f === `${id}/SKILL.md`);
        
        // Strategy 2: Match by suffix (removing vendor prefix like 'vercel-')
        if (!skillFile && id.includes('-')) {
            const parts = id.split('-');
            for (let i = 1; i < parts.length; i++) {
                const subId = parts.slice(i).join('-');
                skillFile = allFiles.find(f => f.includes(`/${subId}/SKILL.md`) || f.startsWith(`${subId}/SKILL.md`));
                if (skillFile) break;
            }
        }
        
        // Strategy 3: Root SKILL.md (only if repo is small or no other matches)
        if (!skillFile && allFiles.includes('SKILL.md')) {
            skillFile = 'SKILL.md';
        }
        
        // Strategy 4: Any SKILL.md that contains the ID or part of it
        if (!skillFile) {
            skillFile = allFiles.find(f => f.endsWith('SKILL.md') && f.includes(id.replace(/-/g, '')));
        }

        if (skillFile) {
            console.log(`Found skill file at ${skillFile}`);
            const folder = path.dirname(skillFile);
            if (folder !== '.') {
                execSync(`git -C "${tempDir}" sparse-checkout set "${folder}"`, { stdio: 'inherit' });
            }
            
            const sourcePath = path.join(tempDir, skillFile);
            const destPath = path.join(targetDir, 'SKILL.md');
            
            let content = fs.readFileSync(sourcePath, 'utf8');
            // Update name in YAML if exists
            if (content.includes('name:')) {
                const oldContent = content;
                content = content.replace(/name:\s*[^\r\n]+/m, `name: ${id}`);
                if (oldContent !== content) {
                    console.log(`Updated YAML name to ${id}`);
                }
            }
            fs.writeFileSync(destPath, content);
            console.log(`Skill ${id} updated successfully.`);
        } else {
            console.warn(`Could not find SKILL.md for ${id} in ${repoUrl}.`);
        }
    } catch (err) {
        console.error(`Error syncing ${id}: ${err.message}`);
    } finally {
        if (fs.existsSync(tempDir)) fs.rmSync(tempDir, { recursive: true, force: true });
    }
}

async function main() {
    console.log(`Starting synchronization for Code Review skills...`);
    const categoryHtml = await fetchPage(CATEGORY_URL);
    const skillPaths = getSkillPaths(categoryHtml).slice(0, TOP_COUNT);
    
    console.log(`Found ${skillPaths.length} skills to process.`);
    
    for (const skillPath of skillPaths) {
        const { repoUrl, skillId } = await getGitHubInfo(skillPath);
        await syncSkill(skillId, repoUrl);
    }
    
    console.log('Synchronization complete. Updating repository index...');
    try {
        execSync('npm run build', { cwd: REPO_ROOT, stdio: 'inherit' });
        console.log('Index updated successfully.');
    } catch (err) {
        console.error('Error updating index: ' + err.message);
    }
}

main().catch(console.error);
