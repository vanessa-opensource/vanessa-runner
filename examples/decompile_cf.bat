SET mypath=%~dp0
SET RUNNER_ENV=production

set BUILDPATH=.\build
set CFPATH=.\cf
if not exist %BUILDPATH% set BUILDPATH=..\build
if not exist %CFPATH% set CFPATH=..\cf

oscript %mypath%/runner.os decompile %BUILDPATH%\1cv8.cf %CFPATH%

