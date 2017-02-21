
SET mypath=%~dp0

SET RUNNER_ENV=production
set RUNNER_IBNAME=/F"D:\work\base\dev"
set RUNNER_DBUSER=base
set RUNNER_DBPWD=234567890

oscript %mypath%/runner.os updatedb --uccode test


