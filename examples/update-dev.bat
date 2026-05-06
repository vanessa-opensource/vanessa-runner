@echo off
rem Инкрементальное обновление dev-базы: загружает только изменённые файлы исходников

vrunner infobase update --ibconnection "/F./build/ib" --source ./src --increment
