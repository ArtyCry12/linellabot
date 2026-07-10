param(
    [Parameter(Mandatory = $true)]
    [string]$LessonPath,
    [string]$HubRoot = "C:\Users\Asus\.cursor",
    [switch]$Json
)

$ErrorActionPreference = "Stop"
. (Join-Path $HubRoot "lib/prompt-coach/PromptCoach.ps1")

$full = if ([System.IO.Path]::IsPathRooted($LessonPath)) { $LessonPath } else { Join-Path $HubRoot $LessonPath }
$payload = Get-NotionPublishPayload -LessonPath $full -HubRoot $HubRoot

if ($Json) {
    $payload | ConvertTo-Json -Depth 5
    exit 0
}

Write-Host "=== Notion publish package (approval required) ===" -ForegroundColor Cyan
Write-Host "Parent: $($payload.notion_hub)"
Write-Host "Page ID: $($payload.parent_page_id)"
Write-Host "Title: $($payload.title)"
Write-Host ""
Write-Host "MCP: $($payload.mcp_tool) with parent page_id"
Write-Host "Ask user: Opublikovat urok v Notion? (da/net)"
Write-Host ""
Write-Host "Content length: $($payload.content_md.Length) chars"
