@echo off
rem Запуск обработки после обновления в режиме 1С:Предприятие

vrunner run enterprise --ibconnection "/F./build/ib" --execute ./build/epf/RunAfterUpdate.epf
