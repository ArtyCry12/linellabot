# MCP tier classification for Cursor hub (Session 2)

$ErrorActionPreference = "Stop"

function Get-McpTiersManifest {
    param([string]$HubRoot = "C:\Users\Asus\.cursor")
    [ordered]@{
        version  = 2
        source   = "ai-tracking/mcp-plugin-tiers-s2.md"
        alwaysOn = @(
            "memory", "gitnexus"
        )
        # markitdown: prefer hook; MCP optional — listed on-demand
        onDemand = @(
            "markitdown-mcp",
            "plugin-exa-exa", "fetch", "plugin-firecrawl-firecrawl",
            "playwright", "chrome-devtools", "cursor-ide-browser",
            "stitch", "figma", "context7",
            "n8n-mcp", "notion", "iconify", "@21st-dev/magic",
            "magnific", "gemini", "apify", "prompts.chat",
            "google-workspace", "google-maps",
            "plugin-vercel-vercel", "plugin-supabase-supabase",
            "plugin-zapier-zapier", "plugin-apify-apify",
            "plugin-shadcn-shadcn", "plugin-aikido-cursor-plugin-aikido"
        )
        # legacy alias for callers expecting taskRouter
        taskRouter = @(
            "plugin-exa-exa", "fetch", "plugin-firecrawl-firecrawl",
            "playwright", "chrome-devtools", "cursor-ide-browser",
            "stitch", "figma"
        )
        pluginOnDemand = @(
            "plugin-vercel-vercel", "plugin-supabase-supabase",
            "plugin-zapier-zapier", "plugin-apify-apify",
            "plugin-firecrawl-firecrawl"
        )
        disableArchive = @(
            "obsidian",
            "tavily", "plugin-tavily-tavily",
            "browse", "plugin-browse-browser"
        )
        browserRouting = [ordered]@{
            e2eTests = "playwright"
            domDebug = "chrome-devtools"
            ideSmoke = "cursor-ide-browser"
        }
        webRouting = [ordered]@{
            research = "plugin-exa-exa"
            singleUrl = "fetch"
            crawl    = "plugin-firecrawl-firecrawl"
        }
        hubRoot = $HubRoot
    }
}

function Get-McpConfigPath {
    param([string]$HubRoot = "C:\Users\Asus\.cursor")
    Join-Path $HubRoot "mcp.json"
}

function Test-McpServerConfigured {
    param(
        [string]$ServerId,
        [string]$HubRoot = "C:\Users\Asus\.cursor"
    )
    $path = Get-McpConfigPath -HubRoot $HubRoot
    if (-not (Test-Path $path)) { return $false }
    $cfg = Get-Content $path -Raw -Encoding UTF8 | ConvertFrom-Json
    return $null -ne $cfg.mcpServers.PSObject.Properties[$ServerId]
}

function Get-McpHealthReport {
    param([string]$HubRoot = "C:\Users\Asus\.cursor")
    $manifest = Get-McpTiersManifest -HubRoot $HubRoot
    $rows = @()
    foreach ($id in $manifest.alwaysOn) {
        $rows += [PSCustomObject]@{
            id         = $id
            tier       = "always-on"
            configured = (Test-McpServerConfigured -ServerId $id -HubRoot $HubRoot)
        }
    }
    foreach ($id in $manifest.onDemand) {
        $rows += [PSCustomObject]@{
            id         = $id
            tier       = "on-demand"
            configured = (Test-McpServerConfigured -ServerId $id -HubRoot $HubRoot)
        }
    }
    foreach ($id in $manifest.disableArchive) {
        $rows += [PSCustomObject]@{
            id         = $id
            tier       = "disable-archive"
            configured = (Test-McpServerConfigured -ServerId $id -HubRoot $HubRoot)
        }
    }
    return [PSCustomObject]@{
        checkedAt = (Get-Date).ToUniversalTime().ToString("o")
        manifest  = $manifest
        servers   = $rows
    }
}
