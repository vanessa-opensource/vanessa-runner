@echo off
rem Сборка конфигурации, расширений и обработок из исходников в файлы дистрибуции

vrunner cf compile --src ./src ./build/1cv8.cf
vrunner cfe compile --src ./src/cfe/MyExt --extension-name MyExt ./build/MyExt.cfe
vrunner epf compile --out ./build/epf ./src/epf
