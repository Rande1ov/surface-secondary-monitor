$ErrorActionPreference = "SilentlyContinue"

$device = Get-PnpDevice -InstanceId "ROOT\DISPLAY\0000" -ErrorAction SilentlyContinue
if (-not $device) {
    $device = Get-PnpDevice | Where-Object {
        $_.FriendlyName -like "*Virtual Display*" -or 
        $_.FriendlyName -like "*IddCx*" -or 
        $_.FriendlyName -like "*Mtt*"
    } | Select-Object -First 1
}

if ($device -and $device.Status -eq "OK") {
    Disable-PnpDevice -InstanceId $device.InstanceId -Confirm:$false
}
