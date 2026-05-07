@echo off
rem Инициализация информационной базы: создать ИБ и загрузить конфигурацию из исходников

vrunner infobase init --ibconnection "/F./build/ib" --source ./src
