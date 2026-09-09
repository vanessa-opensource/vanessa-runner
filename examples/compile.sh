#!/bin/bash
# Сборка конфигурации, расширения и обработок из исходников

vrunner cf compile --src ./src ./build/1cv8.cf
vrunner cfe compile --src ./src/cfe/MyExt --extension-name MyExt ./build/MyExt.cfe
vrunner epf compile --out ./build/epf ./src/epf
