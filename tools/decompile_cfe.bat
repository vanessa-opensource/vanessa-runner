SET mypath=%~dp0
echo "%cd%"
echo "%mypath%"
rem SET connstring=--ibname /F"d:/Apache/base/wms/"
SET connstring=
SET USERPWD=
rem SET connstring=/F"%cd%\build\ib\"
SET RUNNER_ENV=production

oscript %mypath%/runner.os decompileext test2 .\src\cfe\test2 %connstring% %USERPWD%
oscript %mypath%/runner.os decompileext test .\src\cfe\test %connstring% %USERPWD%