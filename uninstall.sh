#!/usr/bin/env bash
set -euo pipefail

main() {
    echo "→ Uninstalling Claude SEO..."

    # Remove main skill (includes venv and requirements.txt)
    rm -rf "${HOME}/.copilot/skills/seo"

    # Remove sub-skills
    for skill in seo-audit seo-competitor-pages seo-content seo-geo seo-hreflang seo-images seo-page seo-plan seo-programmatic seo-schema seo-sitemap seo-technical; do
        rm -rf "${HOME}/.copilot/skills/${skill}"
    done

    # Remove agents
    for agent in seo-technical seo-content seo-schema seo-sitemap seo-performance seo-visual seo-geo; do
        rm -f "${HOME}/.copilot/agents/${agent}.md"
    done

    echo "✓ Claude SEO uninstalled."
}

main "$@"
