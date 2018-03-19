#################################################
################### Functions ###################
#################################################
Function Try-Catch-Command{
	Param ($Cmd, $ErrorMessage)
	try {
		Invoke-Expression $Cmd
	}
	catch {
		Write-Host "$ErrorMessage" -ForegroundColor Red
		exit 1
	}
}

Function Update-App{
	Param ($RemoteVersionFile, $InstallZip, $OutPath)
	try {
		Unzip-File "$InstallZip" "$OutPath"
		Copy-Item "$RemoteVersionFile" -Destination "$OutPath"
	}
	catch {
		Write-Host "Error during installation" -ForegroundColor Red
		exit 1
	}
}

Function Download-File{
	Param ($Location, $OutFile)
	Try-Catch-Command "wget '$Location' -OutFile '$OutFile' 2>&1 | Out-Null" "Error downloading $Location"
}

Function Unzip-File{
	Param ($InFile, $OutPath)
	If(Test-path $OutPath) {Remove-item -Recurse -Force $OutPath}
	Add-Type -assembly "system.io.compression.filesystem"
	[io.compression.zipfile]::ExtractToDirectory($InFile, $OutPath)
}

#################################################
##################### Main ######################
#################################################
# Global variables
$VersionFile="version.ini"
$InstallFile="install.zip"

Write-Host "Loading config" -ForegroundColor Green
Try{. ("$PSScriptRoot\config.ps1")} Catch {	Write-Host "Error reading config file, check if config.ps1 exist in directory" -ForegroundColor Red; exit 1}

Write-Host "Creating temporal directory" -ForegroundColor Green
$TempPath="$env:TEMP\" + [System.IO.Path]::GetRandomFileName()
Try-Catch-Command "New-Item -ItemType directory -Path '$TempPath' 2>&1 | Out-Null" "Error creating temporal directory"

Write-Host "Checking lastest version from $Url" -ForegroundColor Green
Download-File "$Url/$VersionFile" "$TempPath\$VersionFile"
$RemoteApp = ConvertFrom-StringData((Get-Content $TempPath\$VersionFile ) -join "`n")
Write-Host "Remote version found: $($RemoteApp.CompileCount)" -ForegroundColor Cyan

Write-Host "Checking local version from $InstallPath\$VersionFile" -ForegroundColor Green
If(test-path "$InstallPath\$VersionFile"){
	$LocalApp = ConvertFrom-StringData((Get-Content $InstallPath\$VersionFile ) -join "`n")
	Write-Host "Local version found: $($LocalApp.CompileCount)" -ForegroundColor Cyan
}
else {
	Write-Host "No local version found" -ForegroundColor Yellow
}

if([int]$RemoteApp.CompileCount -gt [int]$LocalApp.CompileCount) {
	Write-Host "There is a new version, downloading updates" -ForegroundColor Green
	Download-File "$Url/$InstallFile" "$TempPath\$InstallFile"
	Update-App "$TempPath\$VersionFile" "$TempPath\$InstallFile" "$InstallPath"
}
else {
	Write-Host "You have the lastest version, running app" -ForegroundColor Green
}

Write-Host "Removing temporal directory" -ForegroundColor Green
Try-Catch-Command "Remove-Item -Recurse '$TempPath' -Force" "Error removing directory $TempPath"