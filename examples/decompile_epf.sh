#!/bin/bash
# Разборка внешних обработок из epf-файлов в XML-исходники

vrunner epf decompile --out ./src/epf ./build/epf
