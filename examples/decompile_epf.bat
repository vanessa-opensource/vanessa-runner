SET mypath=%~dp0
rem SET connstring=--ibname /F"C:\Users\eugens\Documents\Rarus\ITIL\1"
rem SET USERPWD=--db-user base --db-pwd 234567890
SET connstring=
SET USERPWD=
SET RUNNER_ENV=production

set BUILDPATH=.\build
set EPFPATH=.\epf

oscript %mypath%/runner.os decompileepf %BUILDPATH%\epf\ %EPFPATH% %connstring% %USERPWD%

