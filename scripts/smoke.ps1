$ErrorActionPreference = "Stop"

function Wait-ForOk([string]$url, [int]$timeoutSec = 60) {
  $deadline = (Get-Date).AddSeconds($timeoutSec)

  while ((Get-Date) -lt $deadline) {
    try {
      $r = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 5
      if ($r.StatusCode -eq 200) { return }
    } catch { }

    Start-Sleep -Seconds 2
  }

  throw "SMOKE_TIMEOUT: $url"
}

Wait-ForOk "http://127.0.0.1:8000/health" 60
Wait-ForOk "http://127.0.0.1:8000/customers" 60
Wait-ForOk "http://127.0.0.1:8000/invoices" 60

Write-Output "SMOKE_OK"
