SET mypath=%~dp0
SET connstring=--ibname /F"C:\Users\eugens\Documents\Rarus\ITIL\1"
SET USERPWD=--db-user base --db-pwd 234567890

oscript %mypath%/runner.os compileepf .\src\ .\build\ %connstring% %USERPWD% 

