<#
.SYNOPSIS
    Surface Pro 4 가상 보조 모니터 활성화 스크립트 (Sunshine 연동용)
.DESCRIPTION
    Moonlight 연결 시작 시 실행되어 가상 디스플레이 장치(VDD)를 활성화합니다.
#>

$ErrorActionPreference = "SilentlyContinue"

Write-Output "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Surface Pro 4 가상 보조 모니터 켜기 시작..."

# 가상 디스플레이 드라이버 장치 탐색 (IddCx / Virtual Display Driver)
$device = Get-PnpDevice | Where-Object {
    ($_.FriendlyName -like "*IddCx*" -or 
     $_.FriendlyName -like "*Virtual Display*" -or 
     $_.FriendlyName -like "*Amyuni*") -and
    $_.Class -in @("Display", "System", "SoftwareDevice")
} | Select-Object -First 1

if ($device) {
    Write-Output "발견된 가상 디스플레이 장치: $($device.FriendlyName) (상태: $($device.Status))"
    if ($device.Status -ne "OK") {
        Enable-PnpDevice -InstanceId $device.InstanceId -Confirm:$false
        Start-Sleep -Seconds 1
        Write-Output "가상 모니터가 성공적으로 활성화되었습니다."
    } else {
        Write-Output "가상 모니터가 이미 활성화되어 있습니다."
    }
} else {
    Write-Warning "가상 디스플레이 장치를 찾지 못했습니다. 드라이버가 정상적으로 설치되었는지 확인해 주세요."
}
