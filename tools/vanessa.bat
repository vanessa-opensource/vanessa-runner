chcp 1251
SET mypath=%~dp0
SET connstring=--ibname /F"C:\Users\eugens\Documents\Rarus\ITIL\1"
SET USERPWD=--db-user base --db-pwd 234567890

oscript %mypath%/runner.os vanessa .\tools\vanessa-behavoir\features\Libraries\Пауза\ "./build/reports.xml" %connstring% %USERPWD% --pathsettings .\.conf.json

