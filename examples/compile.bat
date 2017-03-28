echo off
SET mypath=%~dp0
SETLOCAL

set BUILDPATH=.\build
set CFPATH=.\cf
set CFEPATH=.\cfe
set EPFPATH=.\epf

set RUNNER_IBNAME=/F"./build/ib"
rem set RUNNER_DBUSER=base
rem set RUNNER_DBPWD=234567890

SET RUNNER_ENV=production

IF %1=="" (
set mode="all"
) else (
set mode=%1
)

if "%mode%"=="all" ( call :all )
if "%mode%"=="epf" ( call :compileepf )
if "%mode%"=="cf" ( call :compilecf )
if "%mode%"=="cfe" ( call :compilecfe )

echo %mode%
exit /B

:compilecf
echo "compilecf"
oscript %mypath%/runner.os compile %CFPATH% %BUILDPATH%\1cv8.cf
exit /B

:compilecfe
rem oscript %mypath%/runner.os compileext %CFEPATH%\ДоработкиПанИнвест ДоработкиПанИнвест2 %connstring% %USERPWD%
rem 

:compileepf
oscript %mypath%/runner.os compileepf %EPFPATH%\ %BUILDPATH%\epf\
exit /B

:all
echo "all"
call :compilecf
call :compilecfe
call :compileepf
exit /B


