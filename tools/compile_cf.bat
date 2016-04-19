
SET mypath=%~dp0

echo %olib%

if not exist %mypath%..\src mkdir %mypath%..\src
if not exist %mypath%..\src\cf mkdir %mypath%..\src\cf

echo "run build"
rem echo "oscript.exe %olib%gitsync\src\vanessa.os decompile %cd%\build\1cv8.cf %cd%\src\cf"
rem %oscriptpath% %olib%gitsync\src\vanessa.os decompile %cd%\build\1cv8.cf %cd%\src\cf\
rem echo %mypath%
rem cd 

SET RUNNER_ENV=production

oscript runner.os compile ..\src\cf ..\build\1cv8_USTR.cf

