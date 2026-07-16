# MarkItDown hub helpers — venv, convert, cache, queue

$script:MarkItDownExtensions = @(
    '.pdf', '.docx', '.doc', '.pptx', '.ppt', '.xlsx', '.xls', '.csv',
    '.html', '.htm', '.epub', '.msg', '.zip', '.rtf', '.odt',
    '.png', '.jpg', '.jpeg', '.gif', '.webp', '.bmp', '.tiff', '.tif',
    '.wav', '.mp3', '.m4a', '.ogg', '.flac', '.aac'
)

function Get-MarkItDownHubRoot {
    param([string]$HubRoot = $null)
    if (-not $HubRoot) {
        $HubRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
        if (-not (Test-Path (Join-Path $HubRoot "hooks.json"))) {
            $HubRoot = "C:\Users\Asus\.cursor"
        }
    }
    return $HubRoot
}

function Get-MarkItDownPaths {
    param([string]$HubRoot = $null)
    $HubRoot = Get-MarkItDownHubRoot -HubRoot $HubRoot
    [PSCustomObject]@{
        HubRoot      = $HubRoot
        VenvDir      = Join-Path $HubRoot ".venv-markitdown"
        PythonExe    = Join-Path $HubRoot ".venv-markitdown\Scripts\python.exe"
        ConvertScript = Join-Path $HubRoot "skills\markitdown\scripts\convert_to_md.py"
        CacheDir     = Join-Path $HubRoot ".cache\markitdown"
        QueuePath    = Join-Path $HubRoot "ai-tracking\markitdown-queue.json"
        HealthPath   = Join-Path $HubRoot "ai-tracking\markitdown-health.json"
        ManifestPath = Join-Path $HubRoot "ai-tracking\markitdown-cache-manifest.json"
        UvLocalBin   = Join-Path $env:USERPROFILE ".local\bin"
    }
}

function Get-MarkItDownPython {
    param([string]$HubRoot = $null)
    $p = Get-MarkItDownPaths -HubRoot $HubRoot
    if (Test-Path $p.PythonExe) { return $p.PythonExe }
    return $null
}

function Test-MarkItDownInstalled {
    param([string]$HubRoot = $null)
    $py = Get-MarkItDownPython -HubRoot $HubRoot
    if (-not $py) { return $false }
    $prev = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    $out = & $py -c "import markitdown; print('ok')" 2>&1
    $ErrorActionPreference = $prev
    return ($LASTEXITCODE -eq 0) -and ($out -match 'ok')
}

function Get-MarkItDownManifest {
    param([string]$HubRoot = $null)
    $paths = Get-MarkItDownPaths -HubRoot $HubRoot
    if (-not (Test-Path $paths.ManifestPath)) { return @{} }
    $raw = Get-Content $paths.ManifestPath -Raw -Encoding UTF8
    if ([string]::IsNullOrWhiteSpace($raw)) { return @{} }
    $obj = $raw | ConvertFrom-Json
    $ht = @{}
    foreach ($prop in $obj.PSObject.Properties) {
        $ht[$prop.Name] = $prop.Value
    }
    return $ht
}

function Save-MarkItDownManifest {
    param(
        [hashtable]$Manifest,
        [string]$HubRoot = $null
    )
    $paths = Get-MarkItDownPaths -HubRoot $HubRoot
    $dir = Split-Path $paths.ManifestPath -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    ($Manifest | ConvertTo-Json -Depth 6) | Set-Content -Path $paths.ManifestPath -Encoding UTF8
}

function Get-MarkItDownCacheKey {
    param([string]$SourcePath)
    $fi = Get-Item -LiteralPath $SourcePath -ErrorAction SilentlyContinue
    if (-not $fi) { return $null }
    return "{0}|{1}" -f $fi.FullName.ToLowerInvariant(), $fi.LastWriteTimeUtc.Ticks
}

function Test-MarkItDownSkipPrompt {
    param([string]$Prompt)
    if ([string]::IsNullOrWhiteSpace($Prompt)) { return $true }
    if ($Prompt -match '(?i)skip-markitdown|raw\s+pdf|no-markitdown') { return $true }
    if ($Prompt.Length -lt 20 -and $Prompt -notmatch '\.(pdf|docx|pptx|xlsx|html|epub)\b') { return $true }
    return $false
}

function Find-DocumentPathsInText {
    param([string]$Text)
    if ([string]::IsNullOrWhiteSpace($Text)) { return @() }

    $found = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    $extPattern = ($script:MarkItDownExtensions | ForEach-Object { [regex]::Escape($_) }) -join '|'

    # file:///c%3A/... or file:///C:/...
    $fileUriMatches = [regex]::Matches($Text, 'file:///([^\s"''<>]+)', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    foreach ($m in $fileUriMatches) {
        try {
            $decoded = [Uri]::UnescapeDataString($m.Groups[1].Value).Replace('/', '\')
            if ($decoded -match "(?i)(?:$extPattern)$" -and (Test-Path -LiteralPath $decoded)) {
                [void]$found.Add($decoded)
            }
        } catch { }
    }

    # code_selection path="file:///..." or path="C:\..."
    $selMatches = [regex]::Matches($Text, 'path="([^"]+)"', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    foreach ($m in $selMatches) {
        $raw = $m.Groups[1].Value
        if ($raw -match '^file:///') {
            try {
                $raw = [Uri]::UnescapeDataString($raw.Substring(8)).Replace('/', '\')
            } catch { continue }
        }
        if ($raw -match "(?i)(?:$extPattern)$" -and (Test-Path -LiteralPath $raw)) {
            [void]$found.Add($raw)
        }
    }

    $patterns = @(
        "([A-Za-z]:\\[^\s\)>""']+?(?:$extPattern))",
        "(@[A-Za-z]:\\[^\s\)>""']+?(?:$extPattern))",
        "(/[^\s\)>""']+?(?:$extPattern))",
        "(uploads/[^\s\)>""']+?(?:$extPattern))"
    )

    foreach ($pat in $patterns) {
        $matches = [regex]::Matches($Text, $pat, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        foreach ($m in $matches) {
            $path = $m.Groups[1].Value.TrimStart('@')
            if ($path -match '(?i)uploads/') {
                $hub = Get-MarkItDownHubRoot
                $candidate = Join-Path $hub "projects\c-Users-Asus-cursor\$path"
                if (Test-Path $candidate) { [void]$found.Add($candidate) }
                continue
            }
            if (Test-Path -LiteralPath $path) { [void]$found.Add($path) }
        }
    }

    return @($found)
}

function Find-DocumentPathsInPrompt {
    param([string]$FullPrompt)
    if ([string]::IsNullOrWhiteSpace($FullPrompt)) { return @() }

    $all = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    foreach ($p in (Find-DocumentPathsInText -Text $FullPrompt)) { [void]$all.Add($p) }

    if ($FullPrompt -match '<user_query>\s*([\s\S]*?)\s*</user_query>') {
        foreach ($p in (Find-DocumentPathsInText -Text $Matches[1])) { [void]$all.Add($p) }
    }
    if ($FullPrompt -match '<attached_files>([\s\S]*?)</attached_files>') {
        foreach ($p in (Find-DocumentPathsInText -Text $Matches[1])) { [void]$all.Add($p) }
    }

    return @($all)
}

function Get-MarkItDownCachedOutput {
    param(
        [string]$SourcePath,
        [string]$HubRoot = $null
    )
    $manifest = Get-MarkItDownManifest -HubRoot $HubRoot
    $key = Get-MarkItDownCacheKey -SourcePath $SourcePath
    if (-not $key -or -not $manifest.ContainsKey($key)) { return $null }
    $entry = $manifest[$key]
    $outPath = $entry.output
    if ($outPath -and (Test-Path -LiteralPath $outPath)) { return $outPath }
    return $null
}

function Invoke-MarkItDownConvert {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SourcePath,
        [string]$HubRoot = $null,
        [int]$MaxBytesSync = 5242880,
        [switch]$Force
    )

    $paths = Get-MarkItDownPaths -HubRoot $HubRoot
    $py = Get-MarkItDownPython -HubRoot $HubRoot
    if (-not $py) {
        throw "MarkItDown venv missing. Run: commands/ensure-markitdown.ps1"
    }
    if (-not (Test-Path -LiteralPath $SourcePath)) {
        throw "Source not found: $SourcePath"
    }

    if (-not $Force) {
        $cached = Get-MarkItDownCachedOutput -SourcePath $SourcePath -HubRoot $HubRoot
        if ($cached) {
            return [PSCustomObject]@{
                Ok       = $true
                Source   = $SourcePath
                Output   = $cached
                Cached   = $true
                Deferred = $false
            }
        }
    }

    $fi = Get-Item -LiteralPath $SourcePath
    if ($fi.Length -gt $MaxBytesSync) {
        Add-MarkItDownQueueItem -SourcePath $SourcePath -HubRoot $HubRoot
        return [PSCustomObject]@{
            Ok       = $true
            Source   = $SourcePath
            Output   = $null
            Cached   = $false
            Deferred = $true
            Reason   = "File > $MaxBytesSync bytes; queued for background drain"
        }
    }

    if (-not (Test-Path $paths.CacheDir)) {
        New-Item -ItemType Directory -Path $paths.CacheDir -Force | Out-Null
    }

    $prevEa = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    $outLines = & $py $paths.ConvertScript $SourcePath -o $paths.CacheDir 2>&1
    $exitCode = $LASTEXITCODE
    $ErrorActionPreference = $prevEa

    if ($exitCode -ne 0) {
        throw "Convert failed: $SourcePath :: $outLines"
    }

    $outPath = ($outLines | Where-Object { $_ -match '\.md$' } | Select-Object -Last 1)
    if (-not $outPath -or -not (Test-Path -LiteralPath $outPath)) {
        throw "Convert produced no .md for: $SourcePath"
    }

    $key = Get-MarkItDownCacheKey -SourcePath $SourcePath
    $manifest = Get-MarkItDownManifest -HubRoot $HubRoot
    $manifest[$key] = @{
        source = $SourcePath
        output = $outPath.ToString()
        at     = (Get-Date).ToUniversalTime().ToString("o")
        bytes  = $fi.Length
    }
    Save-MarkItDownManifest -Manifest $manifest -HubRoot $HubRoot

    return [PSCustomObject]@{
        Ok       = $true
        Source   = $SourcePath
        Output   = $outPath.ToString()
        Cached   = $false
        Deferred = $false
    }
}

function Get-MarkItDownQueue {
    param([string]$HubRoot = $null)
    $paths = Get-MarkItDownPaths -HubRoot $HubRoot
    if (-not (Test-Path $paths.QueuePath)) { return @() }
    $raw = Get-Content $paths.QueuePath -Raw -Encoding UTF8
    if ([string]::IsNullOrWhiteSpace($raw)) { return @() }
    $data = $raw | ConvertFrom-Json
    if ($data -is [System.Array]) { return @($data) }
    return @($data)
}

function Save-MarkItDownQueue {
    param(
        [array]$Items,
        [string]$HubRoot = $null
    )
    $paths = Get-MarkItDownPaths -HubRoot $HubRoot
    $dir = Split-Path $paths.QueuePath -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    if ($Items.Count -eq 0) {
        if (Test-Path $paths.QueuePath) { Remove-Item $paths.QueuePath -Force }
        return
    }
    ($Items | ConvertTo-Json -Depth 5) | Set-Content -Path $paths.QueuePath -Encoding UTF8
}

function Add-MarkItDownQueueItem {
    param(
        [string]$SourcePath,
        [string]$HubRoot = $null
    )
    $queue = @(Get-MarkItDownQueue -HubRoot $HubRoot)
    $exists = $queue | Where-Object { $_.source -eq $SourcePath }
    if ($exists) { return }
    $queue += [ordered]@{
        source    = $SourcePath
        queuedAt  = (Get-Date).ToUniversalTime().ToString("o")
        status    = "pending"
    }
    Save-MarkItDownQueue -Items $queue -HubRoot $HubRoot
}

function Invoke-MarkItDownDrain {
    param(
        [string]$HubRoot = $null,
        [int]$MaxItems = 10
    )
    $queue = @(Get-MarkItDownQueue -HubRoot $HubRoot)
    if ($queue.Count -eq 0) {
        return [PSCustomObject]@{ Processed = 0; Remaining = 0; Results = @() }
    }

    $remaining = New-Object System.Collections.Generic.List[object]
    $results = @()
    $processed = 0

    foreach ($item in $queue) {
        if ($processed -ge $MaxItems) {
            $remaining.Add($item)
            continue
        }
        try {
            $r = Invoke-MarkItDownConvert -SourcePath $item.source -HubRoot $HubRoot -MaxBytesSync ([int]::MaxValue) -Force
            $results += $r
            $processed++
        }
        catch {
            $item.status = "error"
            $item.error = $_.Exception.Message
            $remaining.Add($item)
        }
    }

    Save-MarkItDownQueue -Items @($remaining) -HubRoot $HubRoot
    return [PSCustomObject]@{
        Processed = $processed
        Remaining = $remaining.Count
        Results   = $results
    }
}
