#Connect to SQL server which has SSIS Package

$sqlInstance = "dil\denali"

$sqlConnectionString = "Data Source=$sqlInstance;Initial Catalog=master;Integrated Security=SSPI"

$sqlConnection = New-Object System.Data.SqlClient.SqlConnection $sqlConnectionString

 

#Connect to Integration Service Catalog and load project

$ssisServer = New-Object Microsoft.SqlServer.Management.IntegrationServices.IntegrationServices $sqlConnection

$ssisCatalog = $ssisServer.Catalogs["SSISDB"]

$ssisFolderName = "ExecuteTest"

$ssisFolder = $ssisCatalog.Folders.Item($ssisFolderName)

$ssisProjectName = "BuildTestSSIS"

$ssisProject = $ssisFolder.Projects.Item($ssisProjectName)

$ssisPackageName = "Package.dtsx"

 

#Below code creates environment for specific catalog

$environment = New-Object "Microsoft.SqlServer.Management.IntegrationServices.EnvironmentInfo"($ssisFolder, "Environment_from_powershell", "Env1 Desc.")

$environment.Create()

$environment.Variables.Add("Server", [System.TypeCode]::String, "dilkush\sql2k8r2", $false, "")

$environment.Alter()

$environment.Variables.Add("DB", [System.TypeCode]::String, "master", $false, "")

$environment.Alter()

$environment.Variables.Add("Query", [System.TypeCode]::String, "select @@servername as servername", $false, "")

$environment.Alter()

 

#Below code will add environment reference to project

$ssisProject.References.Add("Environment_from_powershell", $ssisFolder.Name)

$ssisProject.Alter()

 

#Below code will create reference to environment variables for package parameters once we fire alter changes will reflect in package which will be saved

#in SQL Server we can run this modified package anytime later

#considering they are project level parameters

$Server = "Server"

$ssisProject.Parameters["Server"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, $Server)

$DB = "DB"

$ssisProject.Parameters["DB"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, $DB)

$Query = "Query"

$ssisProject.Parameters["Query"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, $Query)

$ssisProject.Alter()

 

#Below code will create reference to environment variables for package parameters once we fire alter changes will reflect in package which will be saved

#in SQL Server we can run this modified package anytime later

#considering they are package level parameters

$ssisPackage = $ssisProject.Packages.Item($ssisPackageName)

$Server = "Server"

$ssisPackage.Parameters["Server"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, $Server)

$DB = "DB"

$ssisPackage.Parameters["DB"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, $DB)

$Query = "Query"

$ssisPackage.Parameters["Query"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, $Query)

$ssisPackage.Alter()

 

#We can execute above changed package anytime using referencing this environment like below

$environmentReference = $ssisProject.References.Item("Environment_from_powershell", $ssisFolder.Name)

$environmentReference.Refresh()

Write-Host $environmentReference.ReferenceId

$ssisPackage.Execute($false, $environmentReference)

Write-Host "Package Execution ID: " $executionId