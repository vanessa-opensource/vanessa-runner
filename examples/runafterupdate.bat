chcp 1251
SET mypath=%~dp0

SET RUNNER_ENV=production
set RUNNER_IBNAME=/F"D:\work\base\dev"
set RUNNER_DBUSER=base
set RUNNER_DBPWD=234567890

set BUILDPATH=.\build
set CFEPATH=.\cfe
if not exist %BUILDPATH% set BUILDPATH=..\build
if not exist %CFEPATH% set CFEPATH=..\cfe

pushd %BUILDPATH%
set BUILDPATH=%CD%
popd

oscript %mypath%/runner.os run --uccode test --command "�������������������������������������;����������������������;" --execute %BUILDPATH%\epf\������������������.epf
rem oscript %mypath%/runner.os run --uccode test --command "%BUILDPATH%\cfe\���������.cfe;����������������������;" --execute %BUILDPATH%\epf\�������������������.epf
rem oscript %mypath%/runner.os run --uccode test --command "%BUILDPATH%\epfload\;����������������������;" --execute %BUILDPATH%\epf\������������������.epf



