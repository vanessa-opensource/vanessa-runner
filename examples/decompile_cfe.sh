#!/bin/bash
# Разборка расширения из cfe-файла в XML-исходники

vrunner cfe decompile --cfe-file ./build/MyExt.cfe ./src/cfe/MyExt
