#!/bin/bash
# Запуск BDD-сценариев Vanessa-ADD

vrunner test vanessa --ibconnection "/F./build/ib" --vanessasettings ./vb-conf.json
