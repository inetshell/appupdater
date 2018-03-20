# AppUpdater
Script using Powershell for installing and updating Apps from a Webserver.

1. Use git to clone repository:
```BatchFile
git clone https://github.com/inetshell/appupdater.git
```

2. Define the App parameters in `config/data.nsi`:
```NSIS 
!define APP_NAME "TestApp"
!define UPDATE_URL "https://www.example.com/apps/testname"
!define INSTALL_PATH "c:\Apps\TestApp"
```

3. Install NSIS from [Official Site](http://nsis.sourceforge.net/Download).

4. Compile the NSIS file `installer.nsi`.