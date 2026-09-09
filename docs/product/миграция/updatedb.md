---
title: updatedb
---

# vrunner updatedb

Обновление конфигурации БД. В 3.0 — `vrunner infobase update`: [документация](../команды/infobase#update).

## Соответствие

| 2.x | 3.0 |
|-----|-----|
| `vrunner updatedb` | `vrunner infobase update` |
| `--v1` / `--v2` (флаги) | `--rtype v1` / `--rtype v2`; без опции режим реструктуризации не передаётся платформе |
| `--ibconnection`, `--db-user`, `--db-pwd`, `--v8version`, `--uccode` | без изменений |
| Секция настроек `updatedb`, ключи `--v1`/`--v2` | `vrunner.infobase.update`, ключ `rtype` (скрипт конвертации переносит) |

По умолчанию обновляются основная конфигурация и все расширения; `--target main` или `--target <имя расширения>` сужает область.

## Пример

Было (2.x):

```bash
vrunner updatedb \
  --ibconnection /F./build/ib \
  --uccode godModeOn \
  --v2
```

Стало (3.0):

```bash
vrunner infobase update \
  --ibconnection /F./build/ib \
  --uccode godModeOn \
  --rtype v2
```

Файл настроек — было (`vrunner.json`):

```json
{
  "updatedb": {
    "--uccode": "godModeOn",
    "--v2": true
  }
}
```

Стало (`autumn-properties.json`):

```json
{
  "vrunner": {
    "infobase": {
      "update": {
        "uccode": "godModeOn",
        "rtype": "v2"
      }
    }
  }
}
```
