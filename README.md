# AppUpdater
Script using Powershell for installing and updating Apps from a Webserver.

## Getting Started
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

3. Put an icon for the App in `config\icon.ico`

4. Install NSIS from [Official Site](http://nsis.sourceforge.net/Download).

5. Compile the NSIS file `installer.nsi`.

## Author

* **Manuel Carrillo (inetshell)** - *Initial work* - [inetshell.mx](https://www.inetshell.mx)