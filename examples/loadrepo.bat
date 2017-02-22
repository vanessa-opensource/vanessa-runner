
SET mypath=%~dp0

set BUILDPATH=.\build
set CFPATH=.\cf
if not exist %BUILDPATH% set BUILDPATH=..\build
if not exist %CFPATH% set CFPATH=..\cf

SET RUNNER_ENV=production
rem set RUNNER_IBNAME=/F"D:\work\base\dev"
rem set RUNNER_DBUSER=base
rem set RUNNER_DBPWD=234567890

oscript %mypath%/runner.os loadrepo --storage-name tcp://test.local/test --storage-user dddd --storage-pwd 123444 

