@echo off
rem Запуск BDD-тестов Vanessa

vrunner test vanessa --ibconnection "/F./build/ib" --vanessasettings ./.vb-conf.json
