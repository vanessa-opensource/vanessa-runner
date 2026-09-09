@echo off
rem Создание информационной базы и загрузка конфигурации из исходников

vrunner infobase init --ibconnection "/F./build/ib" --src ./src
