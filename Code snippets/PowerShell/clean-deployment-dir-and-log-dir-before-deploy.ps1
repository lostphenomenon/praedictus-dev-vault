# If this is added as an inline script
$days = "$(FileRetentionDays)"
$age = (Get-Date).AddDays(-($days))
$path = "$(InstallationRootFolder)"
$logPath = "$(LogsRootFolder)"

Write-Host "====================================="
Write-Host "Reteinton days: $days"
Write-Host "Application files should be under: $path"
Write-Host "Log files should be under: $logPath"
Write-Host "====================================="

"Applying retention to application files..."
Get-ChildItem $path -Exclude "Logs" | ForEach-Object {
    # if creationtime is 'le' (less or equal) than 30 days
    if ($_.CreationTime -le $age){s
        Write-Output "Older than 30 days - $($_.name)"
        # remove the item
        "Removing $_.fullname as its older than $days days";
        Remove-Item $_.fullname -Recurse -Force -Verbose
    }else{
        Write-Output "Less than 30 days old - $($_.name)"
        # Do stuff
    }
}

"Applying retention to log files..."
Get-ChildItem $logPath | ForEach-Object {
    # if creationtime is 'le' (less or equal) than 30 days
    if ($_.CreationTime -le $age){
        Write-Output "Older than 30 days - $($_.name)"
        # remove the item
        "Removing $_.fullname as its older than $days days";
        Remove-Item $_.fullname -Recurse -Force -Verbose
    }else{
        Write-Output "Less than 30 days old - $($_.name)"
        # Do stuff
    }
}


#Testing
# $directory = Get-Item "develop-021.222.1"
# $directory.CreationTime = "01.12.2019 10:00:00"