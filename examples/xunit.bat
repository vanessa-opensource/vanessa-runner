chcp 1251
SET mypath=%~dp0
SET connstring=--ibname /F"C:\Users\eugens\Documents\Rarus\ITIL\1"
SET USERPWD=--db-user base --db-pwd 234567890

oscript %mypath%/runner.os xunit .\tools\xUnitFor1C\Tests\Core\Тесты_СистемаПлагинов.epf --report "./build/report.xml" %connstring% %USERPWD% --path .\tools\xUnitFor1C\xddTestRunner.epf 

