#!/bin/bash
# Загрузка конфигурации из исходников и обновление структуры БД

vrunner infobase update --ibconnection "/F./build/ib" --src ./src
