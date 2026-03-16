#!/usr/bin/env bash
set -euo pipefail

target_path="${1:-.}"
dry_run=0

if [[ "${target_path}" == "--dry-run" ]]; then
    dry_run=1
    target_path="."
fi

if [[ "${2:-}" == "--dry-run" ]]; then
    dry_run=1
fi

if [[ ! -d "${target_path}" ]]; then
    echo "Target path is not a directory: ${target_path}" >&2
    exit 1
fi

changed_files=()

while IFS= read -r -d '' file; do
    case "$(basename "${file}")" in
        convert-claude-to-copilot-paths.ps1|convert-claude-to-copilot-paths.sh)
            continue
            ;;
    esac

    if ! grep -Iq . "${file}"; then
        continue
    fi

    tmp_file="$(mktemp)"
    sed \
        -e 's#~/.claude/#~/.copilot/#g' \
        -e 's#~/.claude#~/.copilot#g' \
        -e 's#${HOME}/.claude/#${HOME}/.copilot/#g' \
        -e 's#${HOME}/.claude#${HOME}/.copilot#g' \
        -e 's#\$env:USERPROFILE\\.claude\\#\$env:USERPROFILE\\.copilot\\#g' \
        -e 's#\$env:USERPROFILE\\.claude#\$env:USERPROFILE\\.copilot#g' \
        -e 's#Join-Path \$env:USERPROFILE ".claude"#Join-Path \$env:USERPROFILE ".copilot"#g' \
        -e 's#/home/youruser/.claude/#/home/youruser/.copilot/#g' \
        -e 's#~\\.claude\\#~\\.copilot\\#g' \
        -e 's#~\\.claude#~\\.copilot#g' \
        "${file}" > "${tmp_file}"

    if ! cmp -s "${file}" "${tmp_file}"; then
        changed_files+=("${file}")
        if [[ "${dry_run}" -eq 0 ]]; then
            mv "${tmp_file}" "${file}"
        else
            rm -f "${tmp_file}"
        fi
    else
        rm -f "${tmp_file}"
    fi
done < <(find "${target_path}" -path '*/.git/*' -prune -o -type f -print0)

if [[ "${#changed_files[@]}" -eq 0 ]]; then
    echo "No matching .claude path references found under ${target_path}."
    exit 0
fi

if [[ "${dry_run}" -eq 1 ]]; then
    echo "Dry run: the following files would be updated under ${target_path}:"
else
    echo "Updated the following files under ${target_path}:"
fi

printf '%s\n' "${changed_files[@]}" | sort
echo
echo "Total files: ${#changed_files[@]}"
