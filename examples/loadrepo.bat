@echo off
rem Обновление конфигурации из хранилища 1С

vrunner repo load --ibconnection "/F./build/ib" --storage-name tcp://server/storage --storage-user user --storage-pwd password
