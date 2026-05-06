@echo off
rem Разборка конфигурации, расширений и обработок в XML-исходники

vrunner cf decompile --cf-file ./build/1cv8.cf ./src
vrunner cfe decompile --cfe-file ./build/MyExt.cfe ./src/cfe/MyExt
vrunner epf decompile --out ./src/epf ./build/epf
