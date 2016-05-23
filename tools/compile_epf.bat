SET mypath=%~dp0
SET connstring=
SET USERPWD=

rem SET connstring=--ibname /F"C:\Users\eugens\Documents\Rarus\ITIL\1"
rem SET USERPWD=--db-user base --db-pwd 234567890
SET RUNNER_ENV=production
rem SET RUNNER_V8VERSION=8.3.8.1652

oscript %mypath%/runner.os compileepf .\epf\ .\build\epf\ %connstring% %USERPWD%

