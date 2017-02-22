SET mypath=%~dp0
echo "%cd%"
echo "%mypath%"

SET RUNNER_ENV=production

set RUNNER_IBNAME=/F"D:\work\base\dev"
set RUNNER_DBUSER=base
set RUNNER_DBPWD=234567890

set BUILDPATH=.\build
set CFEPATH=.\cfe
if not exist %BUILDPATH% set BUILDPATH=..\build
if not exist %CFEPATH% set CFEPATH=..\cfe

oscript %mypath%/runner.os decompileext Доработки %CFEPATH%\Доработки %connstring% %USERPWD%
