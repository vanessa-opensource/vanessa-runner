@echo off
rem Запуск обработки послеобновления в режиме предприятия

vrunner run enterprise --ibconnection "/F./build/ib" --execute ./build/epf/RunAfterUpdate.epf
