@echo off
rem Обновление информационной базы: загрузить конфигурацию из исходников и обновить структуру БД

vrunner infobase update --ibconnection "/F./build/ib" --source ./src
