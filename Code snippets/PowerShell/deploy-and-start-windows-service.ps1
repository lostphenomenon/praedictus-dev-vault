$serviceName = "$(ServiceName)"
$serviceDisplayName = "$(ServiceDisplayName)"
$serviceDescription = "$(ServiceDescription)"
$exePath = "$(ServiceExeFullPath)"
$logDirectory= "$(LogDirectory)\*"
$username = "NT AUTHORITY\NETWORK SERVICE"
$password = convertto-securestring -String "dummy" -AsPlainText -Force  
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $password

Write-Host "====================================="
Write-Host $serviceName
Write-Host $serviceDisplayName
Write-Host $serviceDescription
Write-Host $exePath
Write-Host "====================================="

$existingService = Get-WmiObject -Class Win32_Service -Filter "Name='$serviceName'"

if ($existingService) 
{
  "'$serviceName' exists already. Stopping."
  Stop-Service $serviceName
  "Waiting 5 seconds to allow existing service to stop."
  Start-Sleep -s 5
  "Seting new binpath for the service '$serviceName'"
  sc.exe config $serviceName binpath= $exePath
  "Waiting 5 seconds to allow service to be re-configured."
  Start-Sleep -s 5  
}
else
{
  "Installing the service '$serviceName'"
  New-Service -BinaryPathName $exePath -Name $serviceName -Credential $cred -DisplayName $serviceDisplayName -Description $serviceDescription -StartupType Automatic
  "Service installed"
  "Waiting 5 seconds to allow service to be installed."
  Start-Sleep -s 5
}

"Starting the service."
Start-Service $serviceName
"Completed."