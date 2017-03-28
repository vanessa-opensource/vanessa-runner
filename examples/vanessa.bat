chcp 1251
SET mypath=%~dp0
SET connstring=--ibname /F"C:\Users\eugens\Documents\Rarus\ITIL\1"
SET USERPWD=--db-user base --db-pwd 234567890
set RUNNER_PATHVANESSA=D:\git\vanessa-behavoir\vanessa-behavior.epf

oscript %mypath%/runner.os vanessa %connstring% %USERPWD% --vanessasettings .\.vb-conf.json --additional "/RunModeOrdinaryApplication /itdi "

