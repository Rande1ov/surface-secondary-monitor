<#
.SYNOPSIS
    Surface Pro 4 가상 보조 모니터 비활성화 스크립트 (Sunshine 연동용)
.DESCRIPTION
    Moonlight 세션 종료 시 실행되어 가상 디스플레이 장치를 끕니다.
    이를 통해 열려 있던 창과 마우스 커서가 보이지 않는 화면으로 사라지는 유령 모니터 현상을 방지합니다.
#>

$ErrorActionPreference = "SilentlyContinue"

Write-Output "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Surface Pro 4 가상 보조 모니터 끄기 시작..."

# 가상 디스플레이 드라이버 장치 탐색 (IddCx / Virtual Display Driver)
$device = Get-PnpDevice | Where-Object {
    ($_.FriendlyName -like "*IddCx*" -or 
     $_.FriendlyName -like "*Virtual Display*" -or 
     $_.FriendlyName -like "*Amyuni*") -and
    $_.Class -in @("Display", "System", "SoftwareDevice")
} | Select-Object -First 1

if ($device) {
    Write-Output "발견된 가상 디스플레이 장치: $($device.FriendlyName) (상태: $($device.Status))"
    if ($device.Status -eq "OK") {
        Disable-PnpDevice -InstanceId $device.InstanceId -Confirm:$false
        Write-Output "가상 모니터가 성공적으로 비활성화되었습니다."
    } else {
        Write-Output "가상 모니터가 이미 비활성화되어 있습니다."
    }
} else {
    Write-Warning "가상 디스플레이 장치를 찾지 못했습니다."
}
