param(
    [switch]$ForceRestart
)

$ErrorActionPreference = "SilentlyContinue"
$sunshineExe = "C:\Program Files\Sunshine\sunshine.exe"
$sunshineDir = "C:\Program Files\Sunshine"

$existing = Get-Process -Name "sunshine" -ErrorAction SilentlyContinue
if ($existing -and -not $ForceRestart) {
    $hasConsole = Get-CimInstance Win32_Process -Filter "Name = 'OpenConsole.exe'" | Where-Object {
        $_.CreationDate -ge $existing[0].StartTime.AddSeconds(-5) -and $_.CreationDate -le $existing[0].StartTime.AddSeconds(5)
    }
    if (-not $hasConsole) {
        Write-Host "Sunshine is already running in silent background mode."
        exit 0
    }
    Write-Host "Detected console-attached Sunshine instance. Restarting in silent mode..."
    $ForceRestart = $true
}

if ($ForceRestart -and $existing) {
    Stop-Process -Name "sunshine" -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}

$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = $sunshineExe
$psi.WorkingDirectory = $sunshineDir
$psi.CreateNoWindow = $true
$psi.UseShellExecute = $false
$psi.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden

$proc = [System.Diagnostics.Process]::Start($psi)
if ($proc) {
    Write-Host "Started Sunshine silently in background (PID: $($proc.Id))."
} else {
    Write-Host "Failed to start Sunshine."
    exit 1
}
