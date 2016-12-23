echo off
SET mypath=%~dp0
rem SETLOCAL

set BUILDPATH=.\build
set CFPATH=.\cf
set CFEPATH=.\cfe
set EPFPATH=.\epf

SET RUNNER_ENV=production

rem oscript %mypath%/init.os update-dev 
rem oscript %mypath%/init.os update-dev --dev

exit /B


