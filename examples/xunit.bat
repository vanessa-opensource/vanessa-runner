@echo off
rem Запуск xUnit-тестов с отчётом jUnit

vrunner test xunit --ibconnection "/F./build/ib" --report-format junit --report-path ./build/reports/junit.xml ./tests
