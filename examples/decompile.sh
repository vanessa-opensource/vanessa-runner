#!/bin/bash
# Разборка конфигурации, расширения и обработок в исходники

vrunner cf decompile --cf-file ./build/1cv8.cf ./src
vrunner cfe decompile --cfe-file ./build/MyExt.cfe --extension-name MyExt ./src/cfe/MyExt
vrunner epf decompile --out ./src/epf ./build/epf
