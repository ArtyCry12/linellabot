param(
    [int]$Port = 8765,
    [string]$HubRoot = ""
)

$ErrorActionPreference = "Stop"
if (-not $HubRoot) {
    $HubRoot = Split-Path $PSScriptRoot -Parent
}

$staticRoot = Join-Path $HubRoot "docs/ecosystem-audit"
if (-not (Test-Path (Join-Path $staticRoot "index.html"))) {
    Write-Error "Missing $staticRoot\index.html"
    exit 1
}

. (Join-Path $HubRoot "lib/quiz-channel/QuizChannel.ps1")

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Port/")
$listener.Start()

Write-Host "Ecosystem audit: http://localhost:$Port/"
Write-Host "Quiz ingest API: POST http://localhost:$Port/api/quiz-ingest"
Write-Host "Ctrl+C to stop"

function Send-Bytes {
    param($Response, [byte[]]$Bytes, [string]$ContentType, [int]$Status = 200)
    $Response.StatusCode = $Status
    $Response.ContentType = $ContentType
    $Response.ContentLength64 = $Bytes.Length
    $Response.OutputStream.Write($Bytes, 0, $Bytes.Length)
    $Response.OutputStream.Close()
}

function Get-MimeType {
    param([string]$Path)
    switch ([IO.Path]::GetExtension($Path).ToLower()) {
        ".html" { "text/html; charset=utf-8" }
        ".css"  { "text/css; charset=utf-8" }
        ".js"   { "application/javascript; charset=utf-8" }
        ".json" { "application/json; charset=utf-8" }
        ".svg"  { "image/svg+xml" }
        default { "application/octet-stream" }
    }
}

try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $req = $context.Request
        $res = $context.Response

        try {
            $path = $req.Url.LocalPath
            if ($path -eq "/") { $path = "/index.html" }

            if ($req.HttpMethod -eq "POST" -and $path -eq "/api/quiz-ingest") {
                $reader = New-Object System.IO.StreamReader($req.InputStream, $req.ContentEncoding)
                $body = $reader.ReadToEnd()
                $reader.Close()

                if ([string]::IsNullOrWhiteSpace($body)) {
                    $err = '{"ok":false,"error":"empty body"}'
                    Send-Bytes -Response $res -Bytes ([Text.Encoding]::UTF8.GetBytes($err)) -ContentType "application/json; charset=utf-8" -Status 400
                    continue
                }

                $payload = $body | ConvertFrom-Json
                if (-not $payload.source) {
                    $payload | Add-Member -NotePropertyName source -NotePropertyValue "ecosystem-audit-localhost" -Force
                }

                $result = Invoke-QuizIngest -Payload $payload -HubRoot $HubRoot
                $out = @{
                    ok      = $true
                    quiz    = $result.Quiz
                    recordId = $result.RecordId
                    profile = $result.Profile
                } | ConvertTo-Json -Compress

                Send-Bytes -Response $res -Bytes ([Text.Encoding]::UTF8.GetBytes($out)) -ContentType "application/json; charset=utf-8"
                Write-Host "INGEST quiz=$($result.Quiz) id=$($result.RecordId)"
                continue
            }

            if ($req.HttpMethod -ne "GET") {
                Send-Bytes -Response $res -Bytes ([Text.Encoding]::UTF8.GetBytes("Method not allowed")) -ContentType "text/plain" -Status 405
                continue
            }

            $rel = $path.TrimStart("/").Replace("/", [IO.Path]::DirectorySeparatorChar)
            $file = Join-Path $staticRoot $rel
            $fullStatic = [IO.Path]::GetFullPath($staticRoot)
            $fullFile = [IO.Path]::GetFullPath($file)

            if (-not $fullFile.StartsWith($fullStatic) -or -not (Test-Path $fullFile -PathType Leaf)) {
                Send-Bytes -Response $res -Bytes ([Text.Encoding]::UTF8.GetBytes("Not found")) -ContentType "text/plain" -Status 404
                continue
            }

            $bytes = [IO.File]::ReadAllBytes($fullFile)
            Send-Bytes -Response $res -Bytes $bytes -ContentType (Get-MimeType $fullFile)
        }
        catch {
            $msg = '{"ok":false,"error":"server error"}'
            Send-Bytes -Response $res -Bytes ([Text.Encoding]::UTF8.GetBytes($msg)) -ContentType "application/json; charset=utf-8" -Status 500
            Write-Host "ERR $($_.Exception.Message)"
        }
    }
}
finally {
    $listener.Stop()
    $listener.Close()
}
