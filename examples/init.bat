echo off
SET mypath=%~dp0
rem SETLOCAL

set BUILDPATH=.\build
set CFPATH=.\cf
set CFEPATH=.\cfe
set EPFPATH=.\epf

SET RUNNER_ENV=production

oscript %mypath%/init.os init-dev 
oscript %mypath%/init.os init-dev --dev

exit /B


