# Installation Guide

## Prerequisites

- **Python 3.10+** with pip
- **Git** for cloning the repository
- **Claude Code CLI** installed and configured

Optional:
- **Playwright** for screenshot capabilities

## Quick Install

### Unix/macOS/Linux

```bash
curl -fsSL https://raw.githubusercontent.com/AgriciDaniel/claude-seo/main/install.sh | bash
```

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/AgriciDaniel/claude-seo/main/install.ps1 | iex
```

## Manual Installation

1. **Clone the repository**

```bash
git clone https://github.com/AgriciDaniel/claude-seo.git
cd claude-seo
```

2. **Run the installer**

```bash
./install.sh
```

3. **Install Python dependencies** (if not done automatically)

The installer creates a venv at `~/.copilot/skills/seo/.venv/`. If that fails, install manually:

```bash
# Option A: Use the venv
~/.copilot/skills/seo/.venv/bin/pip install -r ~/.copilot/skills/seo/requirements.txt

# Option B: User-level install
pip install --user -r ~/.copilot/skills/seo/requirements.txt
```

4. **Install Playwright browsers** (optional, for visual analysis)

```bash
pip install playwright
playwright install chromium
```

Playwright is optional — without it, visual analysis uses WebFetch as a fallback.

## Installation Paths

The installer copies files to:

| Component | Path |
|-----------|------|
| Main skill | `~/.copilot/skills/seo/` |
| Sub-skills | `~/.copilot/skills/seo-*/` |
| Subagents | `~/.copilot/agents/seo-*.md` |

## Verify Installation

1. Start Claude Code:

```bash
claude
```

2. Check that the skill is loaded:

```
/seo
```

You should see a help message or prompt for a URL.

## Uninstallation

```bash
curl -fsSL https://raw.githubusercontent.com/AgriciDaniel/claude-seo/main/uninstall.sh | bash
```

Or manually:

```bash
rm -rf ~/.copilot/skills/seo
rm -rf ~/.copilot/skills/seo-audit
rm -rf ~/.copilot/skills/seo-competitor-pages
rm -rf ~/.copilot/skills/seo-content
rm -rf ~/.copilot/skills/seo-geo
rm -rf ~/.copilot/skills/seo-hreflang
rm -rf ~/.copilot/skills/seo-images
rm -rf ~/.copilot/skills/seo-page
rm -rf ~/.copilot/skills/seo-plan
rm -rf ~/.copilot/skills/seo-programmatic
rm -rf ~/.copilot/skills/seo-schema
rm -rf ~/.copilot/skills/seo-sitemap
rm -rf ~/.copilot/skills/seo-technical
rm -f ~/.copilot/agents/seo-*.md
```

## Upgrading

To upgrade to the latest version:

```bash
# Uninstall current version
curl -fsSL https://raw.githubusercontent.com/AgriciDaniel/claude-seo/main/uninstall.sh | bash

# Install new version
curl -fsSL https://raw.githubusercontent.com/AgriciDaniel/claude-seo/main/install.sh | bash
```

## Troubleshooting

### "Skill not found" error

Ensure the skill is installed in the correct location:

```bash
ls ~/.copilot/skills/seo/SKILL.md
```

If the file doesn't exist, re-run the installer.

### Python dependency errors

Install dependencies manually:

```bash
pip install beautifulsoup4 requests lxml playwright Pillow urllib3 validators
```

### Playwright screenshot errors

Install Chromium browser:

```bash
playwright install chromium
```

### Permission errors on Unix

Make sure scripts are executable:

```bash
chmod +x ~/.copilot/skills/seo/scripts/*.py
```
