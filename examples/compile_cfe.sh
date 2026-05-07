#!/bin/bash
# Сборка расширения из XML-исходников в cfe-файл

vrunner cfe compile --src ./src/cfe/MyExt --extension-name MyExt ./build/MyExt.cfe
