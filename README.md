# AppUpdater
Script using Powershell for installing and updating Apps from a Webserver.

## Getting Started

### Prerequisites
* Install NSIS from [Official Site](http://nsis.sourceforge.net/Download).

### Compile installer
1. Download code from [Github](https://github.com/inetshell/appupdater.git)

2. Define the App parameters in `config/data.nsi`:
```NSIS 
!define APP_NAME "TestApp"
!define UPDATE_URL "https://www.example.com/apps/testname"
!define INSTALL_PATH "c:\Apps\TestApp"
```

3. Put an icon for the App in `config\icon.ico`

4. Compile the NSIS file `installer.nsi`.

### Deployment

Under construction.

## Built With

* [PowerShell](https://docs.microsoft.com/en-us/powershell/) - Windows scripting language
* [NSIS](http://nsis.sourceforge.net/) - Installer authoring tool 

## Author

* **Manuel Carrillo (inetshell)** - *Initial work* - [inetshell.mx](https://www.inetshell.mx)


## License

This project is licensed under the BSD 3-Clause License - see the [LICENSE.md](LICENSE.md) file for details.