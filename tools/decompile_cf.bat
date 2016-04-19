SET mypath=%~dp0
SET RUNNER_ENV=production

oscript %mypath%/runner.os decompile .\build\1cv8.cf .\src\cf

