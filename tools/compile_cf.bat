
SET mypath=%~dp0

set BUILDPATH=.\build
set CFPATH=.\cf
if not exist %BUILDPATH% set BUILDPATH=..\build
if not exist %CFPATH% set CFPATH=..\cf

SET RUNNER_ENV=production

oscript %mypath%/runner.os compile %CFPATH% %BUILDPATH%\1cv8.cf

