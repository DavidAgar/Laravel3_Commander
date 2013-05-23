@echo off

REM -- Laravel 3 Commander --


call:setTitle
call:check7Zip
call:checkWget

SET path="C:\Program Files\7-Zip\";%path%

IF "%1"=="" goto:eof
IF "%1"=="setup" call:setup %*
IF "%1"=="install" call:install %1 %2
IF "%1"=="p" call:setup setup project %2
IF "%1"=="project" call:setup setup project %2
IF "%1"=="c" call:controller %*
IF "%1"=="controller" call:controller %*
IF "%1"=="m" call:model %*
IF "%1"=="model" call:model %*
IF "%1"=="v" call:view %*
IF "%1"=="view" call:view %*
IF "%1"=="mig" call:migration %*
IF "%1"=="migration" call:migration %*
IF "%1"=="r" call:resource %*
IF "%1"=="resource" call:resource %*
IF "%1"=="a" call:assets %*
IF "%1"=="assets" call:assets %*
IF "%1"=="t" call:test %*
IF "%1"=="test" call:test %*
IF "%1"=="migrate" call:migrate %1 %2
IF "%1"=="rollback" call:rollback
IF "%1"=="artisan" call:artisan %*
IF "%1"=="help" call:help
IF "%1"=="info" call:info
goto:eof

::subroutines follow

:check7Zip
IF NOT EXIST "C:\Program Files\7-Zip" (
echo 7-ZIP is required to run the installation,
echo you can download the installer at http://www.7-zip.org/
pause
exit
)
goto:eof

:checkWget
IF NOT EXIST wget.exe (
echo wget.exe is missing and is needed to run the installations.
echo.
echo Please download it from http://users.ugent.be/~bpuype/wget/
echo and place it within the same folder as this script.
echo %CD%
pause
exit
)
goto:eof

:setTitle
SET version=1.1
SET title=Laravel 3 Commander - v%version%
TITLE %title%
goto:eof

:setup
IF "%2"=="base" (
call:setupProjectBase
goto:savedTxt
goto:eof
)
IF "%2"=="project" (
call:setupProject %*
goto:savedTxt
goto:eof
)

call:setupProjectBase
cls
goto:savedTxt
goto:eof

:savedTxt
echo.
echo Settings have be saved
echo.
call:info
::pause
goto:eof

:setupProjectBase
call:readSettings
setlocal enableextensions enabledelayedexpansion
echo Project Base
echo.
echo Do you want to use the following as your project base dir
echo.
echo %PROJECT_BASE_DIR%
echo.
set /P pb1=(y/n) : 
IF "%pb1%"=="n" (
echo.
set /P pb2=Enter new path [no trailing slash]:
IF "!pb2!" NEQ "" (
IF NOT EXIST !pb2! goto:noprojectbase
call:buildSettings base !pb2!
)
)
endlocal
goto:eof

:setupProject
call:readSettings
IF "%3" NEQ "" (
IF NOT EXIST %PROJECT_BASE_DIR%\%3\artisan goto:proj_notexists
call:buildSettings project %3
goto:eof
)
setlocal enableextensions enabledelayedexpansion
echo Working Project
echo.
echo Do you want to use the following as your working project
echo.
echo %PROJECT_FOLDER%
echo.
set /P pf1=(y/n): 
IF "%pf1%"=="n" (
echo.
set /P pf2=Enter new folder [no trailing slash] : 
IF "!pf2!" NEQ "" (
IF NOT EXIST %PROJECT_BASE_DIR%\!pf2!\artisan goto:proj_notexists
call:buildSettings project !pf2!
)
)
endlocal
goto:eof

:buildSettings
IF "%1"=="base" (
echo SET PROJECT_BASE_DIR=%2> laravel3_current.cmd
echo SET PROJECT_FOLDER=%PROJECT_FOLDER%>> laravel3_current.cmd
)
IF "%1"=="project" (
echo SET PROJECT_BASE_DIR=%PROJECT_BASE_DIR%> laravel3_current.cmd
echo SET PROJECT_FOLDER=%2>> laravel3_current.cmd
)
goto:eof

:install
call:readSettings installcheck
echo Installing Laravel to %2
IF "%2"=="" GOTO no_dest
IF EXIST %PROJECT_BASE_DIR%\%2 GOTO dest_exists
echo.
echo Dowloading Laravel from Github
echo Please wait.....
wget --no-check-certificate -q -O laravel.zip https://github.com/laravel/laravel/archive/master.zip
echo Download complete

echo.
echo Moving files to destination
7z x laravel.zip -o%PROJECT_BASE_DIR%\%2 > nul
DEL laravel.zip
XCOPY %PROJECT_BASE_DIR%\%2\laravel-master\* %PROJECT_BASE_DIR%\%2 /s /i /q
rmdir /s /q %PROJECT_BASE_DIR%\%2\laravel-master

echo.
echo Downloading generate.php by Jeffery Way
wget --no-check-certificate -q https://raw.github.com/JeffreyWay/Laravel-Generator/master/generate.php
MOVE generate.php %PROJECT_BASE_DIR%\%2\application\tasks\generate.php >nul

echo.
echo Downloading blank application.php file
wget --no-check-certificate -q https://gist.github.com/DavidAgar/1933531314a059a5b93b/raw/eb6873dd347e813adfb0bece49eb7cc8aee1309f/application.php
MOVE application.php %PROJECT_BASE_DIR%\%2\application\config\application.php >nul

echo SET LARAVEL_FOLDER=%PROJECT_BASE_DIR%\%2 > laravel3_current.cmd
call:buildSettings project %2
call:readSettings change
echo.
echo Generating Laravel key
php artisan key:generate

echo.
echo Install complete
echo The working project has been set to this new installation
pause
goto:eof

:no_dest
echo You didn't enter a path to install Laravel
echo Cancelling installation
pause
goto:eof

:dest_exists
echo Destination already exists 
echo %PROJECT_BASE_DIR%\%2
echo.
echo Cancelling installation
pause
goto:eof

:readSettings
:: set local vars from laravel3_current.cmd
IF NOT EXIST laravel3_current.cmd goto:nosettings
IF EXIST laravel3_current.cmd call laravel3_current.cmd

IF "%~1"=="installcheck" (
IF "%PROJECT_BASE_DIR%"=="" goto:projectDirMissing
IF NOT EXIST %PROJECT_BASE_DIR% goto:noprojectbase
)
IF "%~1"=="change" (
IF "%PROJECT_BASE_DIR%"=="" goto:projectDirMissing
IF NOT EXIST %PROJECT_BASE_DIR% goto:noprojectbase
IF NOT EXIST %PROJECT_BASE_DIR%\%PROJECT_FOLDER% goto:noproject
%PROJECT_BASE_DIR:~,1%:
cd %PROJECT_BASE_DIR%\%PROJECT_FOLDER%
)
goto:eof

:nosettings
echo.
echo The Settings file(laravel3_current.cmd) could not be found.
echo.
echo Please make sure you have all files within this folder
echo %cd%
pause
exit
goto:eof

:projectDirMissing
echo.
echo The Project base path has not yet been set.
echo.
echo Please run setup
pause
exit
goto:eof

:noprojectbase
echo.
echo The project base folder could not be found.
echo.
echo Please create the folder and try again.
pause
exit
goto:eof

:noproject
echo A working project has not been found.
echo.
echo Please set this using: project [project_dir]
pause
exit
goto:eof

:proj_notexists
echo.
echo The project location can not be found !
echo.
echo If you intended to start a new project please call: 
echo install [folder_location]
echo.
echo Otherwise please run again with a current project destination.
echo.
pause
exit
goto:eof

:controller
setlocal enableextensions enabledelayedexpansion
set extras=
SET /A COUNT=1
FOR %%A IN (%*) DO (
	IF "!COUNT!" gtr "2" (
	set extras=!extras! %%A
	)
   SET /A COUNT+=1
)
IF "%extras%" NEQ "" set extras=%extras:~1%
call:readSettings change
php artisan generate:controller %2 %extras%
endlocal
pause
goto:eof

:model
setlocal enableextensions enabledelayedexpansion
set extras=
SET /A COUNT=1
FOR %%A IN (%*) DO (
	IF "!COUNT!" gtr "2" (
	set extras=!extras! %%A
	)
   SET /A COUNT+=1
)
set extras=%extras:~1%
call:readSettings change
php artisan generate:model %2 %extras%
endlocal
pause
goto:eof

:view
setlocal enableextensions enabledelayedexpansion
set extras=
SET /A COUNT=1
FOR %%A IN (%*) DO (
	IF "!COUNT!" gtr "2" (
	set extras=!extras! %%A
	)
   SET /A COUNT+=1
)
IF "%extras%" NEQ "" set extras=%extras:~1%
call:readSettings change
php artisan generate:view %2 %extras%
endlocal
pause
goto:eof

:migration
setlocal enableextensions enabledelayedexpansion
set extras=
SET /A COUNT=1
FOR %%A IN (%*) DO (
	IF "!COUNT!" gtr "2" (
	set extras=!extras! %%A
	)
   SET /A COUNT+=1
)
IF "%extras%" NEQ "" set extras=%extras:~1%
call:readSettings change
php artisan generate:migration %2 %extras%
endlocal
pause
goto:eof

:assets
setlocal enableextensions enabledelayedexpansion
set extras=
SET /A COUNT=1
FOR %%A IN (%*) DO (
	IF "!COUNT!" gtr "2" (
	set extras=!extras! %%A
	)
   SET /A COUNT+=1
)
IF "%extras%" NEQ "" set extras=%extras:~1%
call:readSettings change
php artisan generate:assets %2 %extras%
endlocal
pause
goto:eof

:resource
setlocal enableextensions enabledelayedexpansion
set extras=
SET /A COUNT=1
FOR %%A IN (%*) DO (
	IF "!COUNT!" gtr "2" (
	set extras=!extras! %%A
	)
   SET /A COUNT+=1
)
IF "%extras%" NEQ "" set extras=%extras:~1%
call:readSettings change
php artisan generate:resource %2 %extras%
endlocal
pause
goto:eof

:test
setlocal enableextensions enabledelayedexpansion
set extras=
SET /A COUNT=1
FOR %%A IN (%*) DO (
	IF "!COUNT!" gtr "2" (
	set extras=!extras! %%A
	)
   SET /A COUNT+=1
)
IF "%extras%" NEQ "" set extras=%extras:~1%
call:readSettings change
php artisan generate:test %2 %extras%
endlocal
pause
goto:eof

:migrate
call:readSettings change
IF "%2"=="install" (
php artisan migrate:install
pause
goto:eof
) else (
php artisan migrate
)
pause
goto:eof

:rollback
call:readSettings change
php artisan migrate:rollback
pause
goto:eof

:artisan
setlocal enableextensions enabledelayedexpansion
set extras=
SET /A COUNT=1
FOR %%A IN (%*) DO (
	IF "!COUNT!" gtr "2" (
	set extras=!extras! %%A
	)
   SET /A COUNT+=1
)
IF "%extras%" NEQ "" set extras=%extras:~1%
call:readSettings change
php artisan %2 %extras%
endlocal
pause
goto:eof

:info
call:readSettings
echo The project base folder is: %PROJECT_BASE_DIR%
echo.
echo The current working folder is: %PROJECT_FOLDER%
echo.
pause
goto:eof


:help
echo The following commands are available
echo.
echo -- General --
echo setup	-Runs the project base setup
echo help	-Show the help text.
echo info	-Shows the current project dir.
echo project [project_dir]	-Change the project dir.
echo p [project_dir]	-Shortcut for above
echo install [project_dir]	-Install laravel to choosen dir and set as current project.
echo.
echo -- Controller --
echo c [name] [methods/actions]
echo controller [name] [methods/actions]
echo Example: c Admin restful index index:post
echo.
echo -- Model --
echo m [name]
echo model [name]
echo Example: m Admin
echo.
echo -- View --
echo v [name/s]
echo view [name/s]
echo example: v index show
echo.
echo -- Migration --
echo mig [action] [schema]
echo migration [action] [schema]
echo Example: mig create_users_table id:integer name:string email_address:string
echo.
echo migrate [install]	-To execute the migrate, include install to set up migration tables
echo rollback	-To execute the rollback
echo.
echo -- Other --
echo r [name]
echo resource [name]
echo Example: r post index show
echo.
echo a [asset/s]
echo assets [asset/s]
echo Example: a style.css style2.css admin/script.js
echo.
echo artisan [command]	-Run any command
pause
goto:eof