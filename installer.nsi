; Read configuration
!include "config\data.nsi"
;--------------------------------
SetCompressor /SOLID /FINAL LZMA
;--------------------------------

Name "${APP_NAME}"
OutFile "${APP_NAME}.exe"
InstallDir ${INSTALL_PATH}
;--------------------------------
; Request application privileges
RequestExecutionLevel admin
;--------------------------------
Page directory
Page instfiles
;--------------------------------
; Installation steps
Section "install"

	; Set output path to the installation directory.
	SetOutPath $INSTDIR

	; Write Powershell config
	FileOpen $4 "$INSTDIR\config.ps1" w
	FileWrite $4 "$$Url = '${UPDATE_URL}'$\r$\n"
	FileWrite $4 "$$InstallPath = '$INSTDIR\app'$\r$\n"
	FileWrite $4 "$$APP_NAME = '${APP_NAME}'$\r$\n"
	FileClose $4

	; Put  loader files
	File files\loader.ps1
	File config\icon.ico

	; Create shortcut with app icon and Powershell loader
	ReadEnvStr $3 PUBLIC
	CreateShortCut "$3\Desktop\${APP_NAME}.lnk" "powershell.exe" "-File $INSTDIR\loader.ps1" "$INSTDIR\icon.ico"
	CreateShortCut "$3\Desktop\${APP_NAME}.lnk" "powershell.exe" "-File $INSTDIR\loader.ps1" "$INSTDIR\icon.ico"
	
	; Create uninstaller
	writeUninstaller "$INSTDIR\uninstall.exe"
SectionEnd

Section "uninstall"
 	
	; Remove app files
	RMDir /r $INSTDIR\app
	
	; Remove loader files
	delete $INSTDIR\config.ps1
	delete $INSTDIR\icon.ico
	delete $INSTDIR\loader.ps1
	
	; Remove shortcut
	ReadEnvStr $3 PUBLIC
	delete $3\Desktop\${APP_NAME}.lnk
	
	; Remove uninstaller at the end
	delete $INSTDIR\uninstall.exe
 
	; Remove installation directory
	rmDir $INSTDIR
SectionEnd