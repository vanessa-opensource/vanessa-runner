@echo off
SET mypath=%~dp0
SETLOCAL

set BUILDPATH=.\build
set CFPATH=.\cf
set CFEPATH=.\cfe
set EPFPATH=.\epf

if not exist %BUILDPATH% set BUILDPATH=..\build
if not exist %CFPATH% set CFPATH=..\cf
if not exist %CFEPATH% set CFEPATH=..\cfe
if not exist %EPFPATH% set EPFPATH=..\epf

rem set RUNNER_IBNAME=/F"D:\work\base\dev"
rem set RUNNER_DBUSER=base
rem set RUNNER_DBPWD=234567890

SET RUNNER_ENV=production


IF "%1"=="" (
set mode=all
) else (
set mode=%1
)

if "%mode%"=="all" ( call :all )
if "%mode%"=="epf" ( call :decompileepf )
if "%mode%"=="cf" ( call :decompilecf )
if "%mode%"=="cfe" ( call :decompilecfe )

echo %mode%
exit /B

:decompilecf
echo "decompilecf"
oscript %mypath%/runner.os decompile %BUILDPATH%\1cv8.cf %CFPATH%
exit /B

:decompilecfe
rem oscript %mypath%/runner.os decompileext ДоработкиПанИнвест %CFEPATH%\ДоработкиПанИнвест %connstring% %USERPWD%


:decompileepf
oscript %mypath%/runner.os decompileepf %BUILDPATH%\epf\ %EPFPATH% %connstring% %USERPWD%
exit /B

:all
echo "run all"
call :decompilecf
call :decompilecfe
call :decompileepf
exit /B


