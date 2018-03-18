# Carga configuracion
try {
    . ("$PSScriptRoot\config.ps1")
}
catch {
    Write-Host "Error al leer configuracion, revisar archivo config.ps1 en el mismo directorio." -ForegroundColor Red
	exit 1
}

# Variables
$VERSION_FILE="version.ini"

#
Write-Host "Consultando $URL" -ForegroundColor Green
try {
	wget "$URL/$VERSION_FILE" -OutFile $VERSION_FILE
}
catch {
    Write-Host "Error al consultar repositorio." -ForegroundColor Red
	exit 1
}