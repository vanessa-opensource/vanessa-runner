@echo off
rem Worker wrapper for the parallel e2e runner (Windows).
rem Isolates the 1C platform cache/temp per worker so concurrent 1C/ibcmd
rem processes on one machine do not contend on the shared platform cache
rem ("Ошибка при работе с файлом").
rem   %1 - isolated env dir   %2 - test file   %3 - junit report   %4 - log file
set "TEMP=%~1"
set "TMP=%~1"
set "LOCALAPPDATA=%~1\LocalAppData"
set "APPDATA=%~1\AppData"
oneunit execute -f "%~2" --junit "%~3" --mode flat > "%~4" 2>&1
