---
title: init-dev
---

# vrunner init-dev / vrunner update-dev

`init-dev` создавал информационную базу (с `--storage` — с загрузкой конфигурации из хранилища), `update-dev` обновлял конфигурацию БД. В 3.0 — `vrunner infobase init` и `vrunner infobase update`: [документация](../команды/infobase#init).

## Соответствие

| 2.x | 3.0 |
|-----|-----|
| `vrunner init-dev` | `vrunner infobase init` |
| `vrunner update-dev` | `vrunner infobase update` |
| `vrunner init-dev --storage --storage-name …` | три команды: `infobase init`, `repo bind`, `infobase update` (пример ниже) |
| `--v1` / `--v2` | `--rtype v1` / `--rtype v2` у `infobase update`; без опции режим реструктуризации не передаётся платформе |
| Секции настроек `init-dev`, `update-dev` | `vrunner.infobase.init`, `vrunner.infobase.update`; скрипт конвертации их не переносит |

`infobase init` может сразу загрузить конфигурацию (`--src`: каталог исходников, `.cf` или `.dt`) и расширения (`--ext`, с `--recursive` — поиском по каталогам).

## Пример

Было (2.x):

```bash
vrunner init-dev \
  --ibconnection /F./build/ib \
  --storage \
  --storage-name tcp://serverstorage/erp \
  --storage-user bot \
  --storage-pwd 123
```

Стало (3.0):

```bash
# 1. Создать пустую базу
vrunner infobase init --ibconnection /F./build/ib

# 2. Подключить к хранилищу: конфигурация базы заменяется конфигурацией хранилища
vrunner repo bind \
  --ibconnection /F./build/ib \
  --storage-name tcp://serverstorage/erp \
  --storage-user bot \
  --storage-pwd 123

# 3. Обновить конфигурацию БД
vrunner infobase update --ibconnection /F./build/ib
```

Обновление (update-dev) — было:

```bash
vrunner update-dev --ibconnection /F./build/ib --v2
```

Стало:

```bash
vrunner infobase update --ibconnection /F./build/ib --rtype v2
```
