#!/usr/bin/env bash
set -euo pipefail

main() {
    echo "→ Uninstalling DataForSEO extension..."

    # Remove skill
    rm -rf "${HOME}/.copilot/skills/seo-dataforseo"

    # Remove agent
    rm -f "${HOME}/.copilot/agents/seo-dataforseo.md"

    # Remove field config
    rm -f "${HOME}/.copilot/skills/seo/dataforseo-field-config.json"

    # Remove MCP server entry from settings.json
    SETTINGS_FILE="${HOME}/.copilot/settings.json"
    if [ -f "${SETTINGS_FILE}" ]; then
        python3 -c "
import json, os
settings_path = '${SETTINGS_FILE}'
with open(settings_path, 'r') as f:
    settings = json.load(f)
if 'mcpServers' in settings and 'dataforseo' in settings['mcpServers']:
    del settings['mcpServers']['dataforseo']
    if not settings['mcpServers']:
        del settings['mcpServers']
    with open(settings_path, 'w') as f:
        json.dump(settings, f, indent=2)
    print('  ✓ Removed dataforseo from settings.json')
else:
    print('  ✓ No dataforseo entry in settings.json')
" 2>/dev/null || echo "  ⚠  Could not auto-remove MCP config. Remove 'dataforseo' from ~/.copilot/settings.json manually."
    fi

    echo "✓ DataForSEO extension uninstalled."
}

main "$@"
