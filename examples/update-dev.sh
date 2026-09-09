#!/bin/bash
# Инкрементальное обновление dev-базы: грузятся только изменённые файлы

vrunner infobase update --ibconnection "/F./build/ib" --src ./src --increment
