#!/bin/bash
# Запуск xUnit-тестов

vrunner test xunit --ibconnection "/F./build/ib" --reportsxunit "jUnit{./build/xunit.xml}" ./tests
