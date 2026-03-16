param(
    [string]$Path = ".",
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

function Test-BinaryFile {
    param([string]$FilePath)

    $stream = [System.IO.File]::OpenRead($FilePath)
    try {
        $buffer = New-Object byte[] 4096
        $read = $stream.Read($buffer, 0, $buffer.Length)
        for ($i = 0; $i -lt $read; $i++) {
            if ($buffer[$i] -eq 0) {
                return $true
            }
        }
        return $false
    } finally {
        $stream.Dispose()
    }
}

$resolved = (Resolve-Path -LiteralPath $Path).Path
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$replacements = [ordered]@{
    '~/.claude/' = '~/.copilot/'
    '~/.claude' = '~/.copilot'
    '${HOME}/.claude/' = '${HOME}/.copilot/'
    '${HOME}/.claude' = '${HOME}/.copilot'
    '$env:USERPROFILE\.claude\' = '$env:USERPROFILE\.copilot\'
    '$env:USERPROFILE\.claude' = '$env:USERPROFILE\.copilot'
    'Join-Path $env:USERPROFILE ".claude"' = 'Join-Path $env:USERPROFILE ".copilot"'
    '/home/youruser/.claude/' = '/home/youruser/.copilot/'
    '~\.claude\' = '~\.copilot\'
    '~\.claude' = '~\.copilot'
}

$changedFiles = New-Object System.Collections.Generic.List[string]

Get-ChildItem -LiteralPath $resolved -Recurse -File | Where-Object {
    $_.FullName -notmatch '[\\\/]\.git([\\\/]|$)'
} | ForEach-Object {
    if ($_.Name -in @('convert-claude-to-copilot-paths.ps1', 'convert-claude-to-copilot-paths.sh')) {
        return
    }

    if (Test-BinaryFile -FilePath $_.FullName) {
        return
    }

    $original = [System.IO.File]::ReadAllText($_.FullName)
    $updated = $original
    foreach ($replacement in $replacements.GetEnumerator()) {
        $updated = $updated.Replace($replacement.Key, $replacement.Value)
    }

    if ($updated -cne $original) {
        if (-not $DryRun) {
            [System.IO.File]::WriteAllText($_.FullName, $updated, $utf8NoBom)
        }
        $changedFiles.Add($_.FullName.Substring($resolved.Length).TrimStart('\')) | Out-Null
    }
}

if ($changedFiles.Count -eq 0) {
    Write-Host "No matching .claude path references found under ${resolved}."
    exit 0
}

if ($DryRun) {
    Write-Host "Dry run: the following files would be updated under ${resolved}:"
} else {
    Write-Host "Updated the following files under ${resolved}:"
}

$changedFiles | Sort-Object | ForEach-Object { Write-Host $_ }
Write-Host ""
Write-Host "Total files: $($changedFiles.Count)"
