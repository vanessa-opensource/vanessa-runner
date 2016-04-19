SET mypath=%~dp0
echo "%cd%"
echo "%mypath%"
SET connstring=--ibname /F"d:/Apache/base/wms/"
SET USERPWD=
SET RUNNER_ENV=production

oscript %mypath%/runner.os compileext .\src\cfe\test2 test2 %connstring% %USERPWD%
oscript %mypath%/runner.os compileext .\src\cfe\test test %connstring% %USERPWD%