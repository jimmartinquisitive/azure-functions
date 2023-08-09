param($Timer)

# Define timezone
$easternTimeZone = [System.TimeZoneInfo]::FindSystemTimeZoneById("Eastern Standard Time")
$currentTime = [System.TimeZoneInfo]::ConvertTimeFromUtc((Get-Date).ToUniversalTime(), $easternTimeZone)
$currentDayOfWeek = $currentTime.DayOfWeek

# Common variables
$resourceGroupName = "RGNAME"
$storageAccountName = "SANAME"

# Log the current day and time
Write-Host "Current day of the week: $currentDayOfWeek at time: $currentTime"

$actionTaken = $false

# Get the current SFTP state
$storageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName
$sftpStatus = if ($storageAccount.EnableSftp) { "Enabled" } else { "Disabled" }
Write-Host "Current SFTP state: $sftpStatus"

# Check if the day is between Monday and Friday
if ($currentDayOfWeek -ge [System.DayOfWeek]::Monday -and $currentDayOfWeek -le [System.DayOfWeek]::Friday) {
    if ($currentTime.Hour -ge 20) {
        Set-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName -EnableSftp $false
        Write-Host "SFTP disabled"
        $actionTaken = $true
    } elseif ($currentTime.Hour -ge 6) {
        Set-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName -EnableSftp $true
        Write-Host "SFTP enabled"
        $actionTaken = $true
    }
}
# Check if the day is Saturday
elseif ($currentDayOfWeek -eq [System.DayOfWeek]::Saturday) {
    if ($currentTime.Hour -ge 20) {
        Set-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName -EnableSftp $false
        Write-Host "SFTP disabled"
        $actionTaken = $true
    }
}
# Check if the day is Sunday
elseif ($currentDayOfWeek -eq [System.DayOfWeek]::Sunday) {
    Set-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName -EnableSftp $false
    Write-Host "SFTP disabled"
    $actionTaken = $true
}

# Log whether any action was taken
if (-not $actionTaken) {
    Write-Host "No action taken"
}

# Logs
Write-Host "PowerShell Timer trigger function executed at:$(get-date)"
Write-Host "Next timer schedule at: $($Timer.ScheduleStatus.Next)"
