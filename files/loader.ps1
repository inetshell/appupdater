#################################################
################### Functions ###################
#################################################
Function ExitWithSleep{
	sleep 10
	exit 1
}

Function Try-Catch-Command{
	Param ($Cmd, $ErrorMessage)
	Try {
		Invoke-Expression $Cmd
	}
	Catch {
		Write-Host "$ErrorMessage" -ForegroundColor Red
		Write-Host "Trying to run local app" -ForegroundColor Yellow
		Run-App
		ExitWithSleep
	}
}

Function Update-App{
	Param ($InstallZip, $OutPath)
	Write-Host "Extracting file" -ForegroundColor Green
	Try-Catch-Command "Unzip-File '$InstallZip' '$OutPath'" "Error during installation"
}

Function Download-File{
	Param ($Location, $OutFile)
	Write-Host "Downloading $Location" -ForegroundColor Cyan
	Try-Catch-Command "wget '$Location' -OutFile '$OutFile' 2>&1 | Out-Null" "Error downloading $Location"
}

Function Unzip-File{
	Param ($InFile, $OutPath)
	If(Test-path $OutPath) {Remove-item -Recurse -Force $OutPath}
	Add-Type -assembly "system.io.compression.filesystem"
	[io.compression.zipfile]::ExtractToDirectory($InFile, $OutPath)
}

Function Run-App{
	Try {
		. "$InstallPath\init.ps1"
	}
	Catch {
		Write-Host "Error trying to run app" -ForegroundColor Red
		ExitWithSleep
	}
}
#################################################
##################### Main ######################
#################################################
$VersionFile="version.ini"
$InstallFile="install.zip"

Write-Host "Loading config" -ForegroundColor Green
Try{. ("$PSScriptRoot\config.ps1")} Catch {	Write-Host "Error reading config file, check if config.ps1 exist in directory" -ForegroundColor Red; ExitWithSleep}

Write-Host "Creating temporary directory" -ForegroundColor Green
$TempPath="$env:TEMP\" + [System.IO.Path]::GetRandomFileName()
Try-Catch-Command "New-Item -ItemType directory -Path '$TempPath' 2>&1 | Out-Null" "Error creating temporary directory"

Write-Host "Checking latest version" -ForegroundColor Green
Download-File "$Url/$VersionFile" "$TempPath\$VersionFile"
$RemoteApp = ConvertFrom-StringData((Get-Content $TempPath\$VersionFile ) -join "`n")
Write-Host "Remote version found: $($RemoteApp.CompileCount)" -ForegroundColor Cyan

Write-Host "Checking local version from $PSScriptRoot\$VersionFile" -ForegroundColor Green
If(test-path "$PSScriptRoot\$VersionFile"){
	$LocalApp = ConvertFrom-StringData((Get-Content $PSScriptRoot\$VersionFile ) -join "`n")
	Write-Host "Local version found: $($LocalApp.CompileCount)" -ForegroundColor Cyan
}
else{
	Write-Host "No local version found" -ForegroundColor Yellow
	$InstallApp = $True
}

Write-Host "Closing app if running" -ForegroundColor Green
Stop-Process -Force -Name $AppName 2>&1 | Out-Null

If([int]$RemoteApp.CompileCount -gt [int]$LocalApp.CompileCount){
	Write-Host "Update required" -ForegroundColor Green
	$InstallApp = $True
}

If($InstallApp){
	Write-Host "Installing the latest version" -ForegroundColor Green
	Download-File "$Url/$InstallFile" "$TempPath\$InstallFile"
	Update-App "$TempPath\$InstallFile" "$InstallPath"
	Copy-Item "$TempPath\$VersionFile" -Destination "$PSScriptRoot\$VersionFile"
}
else{
	Write-Host "You have the latest version" -ForegroundColor Green
}

Write-Host "Running app" -ForegroundColor Green
Run-App

Write-Host "Removing temporary directory" -ForegroundColor Green
Try-Catch-Command "Remove-Item -Recurse '$TempPath' -Force" "Error removing directory $TempPath"