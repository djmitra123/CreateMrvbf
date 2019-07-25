@echo on
@echo off
color a
cls

set cwd=%~dp0
pushd %cwd%


echo "                                                                                                                                                  ";
echo "                                                                                                                                                  ";
echo "                                                                                                                                                  ";
echo "                                                                                                                                                  ";
echo "                                                                                                                                                  ";
echo " ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ";
echo "|___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___| ";
echo "|___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___| ";
echo " _                                                           *     (                  (        *             (    (    (        )              _  ";
echo "| |   (  (           (                             )       (  \`    )\ )           (   )\ )   (  \`     (      )\ ) )\ ) )\ )  ( /(  (        | | ";
echo "| |   )\))(   '   (  )\             )      (    ( /(       )\))(  (()/( (   (   ( )\ (()/(   )\))(    )\    (()/((()/((()/(  )\()) )\ )       | | ";
echo "| |  ((_)()\ )   ))\((_) (   (     (      ))\   )\()) (   ((_)()\  /(_)))\  )\  )((_) /(_)) ((_)()\((((_)(   /(_))/(_))/(_))((_)\ (()/(       | | ";
echo "| |  _(())\_)() /((_)_   )\  )\    )\  ' /((_) (_))/  )\  (_()((_)(_)) ((_)((_)((_)_ (_))_| (_()((_))\ _ )\ (_)) (_)) (_))   _((_) /(_))_     | | ";
echo "| |  \ \((_)/ /(_)) | | ((_)((_) _((_)) (_))   | |_  ((_) |  \/  || _ \\ \ / /  | _ )| |_   |  \/  |(_)_\(_)| _ \| _ \|_ _| | \| |(_)) __|    | | ";
echo "| |   \ \/\/ / / -_)| |/ _|/ _ \| '  \()/ -_)  |  _|/ _ \ | |\/| ||   / \ V /   | _ \| __|  | |\/| | / _ \  |  _/|  _/ | |  | .\` |  | (_ |   | | ";
echo "| |    \_/\_/  \___||_|\__|\___/|_|_|_| \___|   \__|\___/ |_|  |_||_|_\  \_/    |___/|_|    |_|  |_|/_/ \_\ |_|  |_|  |___| |_|\_|   \___|    | | ";
echo "|_|                                                                                                                                           |_| ";
echo " ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ";
echo "|___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___| ";
echo "|___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___||___| ";
echo "                                                                                                                                                  ";
echo.
echo.

echo.
echo "CHECKING R INSTALLATION...."

set testR="C:\Program Files\R\R-3.5.3\"
IF EXIST %testR% (
echo "R-3.5.3 already exists in the system"
echo "Skipping R installation!.." 
) ELSE (
cmd /c @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
cmd /c choco install -y r.project --version 3.5.3 --force
)

echo.
echo.
echo "INSTALLING SAGA!!!..."
cmd /c @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -Command "& '%cwd%\ps_check.ps1'"


echo.
echo.
dir
"C:\Program Files\R\R-3.5.3\bin\x64\Rscript.exe" calculateMrvbf.R
rmdir /S /Q C:\saga620
IF EXIST %testR% (
GOTO :end
) ELSE (
cmd /c choco uninstall -y r.project --version 3.5.3 --force
GOTO :end
)

		
:end
echo.
echo.
color c
popd %cwd%   
echo.
echo.                                                                                           
echo "================================================================================="
echo "MRVBF CALCULATIONS COMPLETE!!........"
echo "================================================================================="
echo.
echo. 

@echo on
pause