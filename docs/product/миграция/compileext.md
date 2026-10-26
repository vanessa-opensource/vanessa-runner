---
title: compileext
---

# vrunner compileext

Загрузка расширения конфигурации из XML-исходников в информационную базу. В 3.0 — `vrunner cfe load [SRC]`: [документация](../команды/cfe#load). Файл `.cfe` в 2.x собирала `vrunner compileexttocfe`, в 3.0 — `vrunner cfe compile <OUT>`: [документация](../команды/cfe#compile).

## Соответствие

| 2.x | 3.0 |
|-----|-----|
| `vrunner compileext <inputPath> <extensionName>` | `vrunner cfe load [опции] [SRC]` |
| Позиционный `inputPath` | позиционный `SRC` (по умолчанию — текущий каталог) |
| Позиционный `extensionName` | `--extension-name` (`VRUNNER_EXTENSION_NAME`); если не задано — имя каталога исходников |
| `--updatedb` | поведение по умолчанию: конфигурация БД обновляется; отключение — `--no-update-db` |
| `--ibcmd`, `--dbms-*` | без изменений |
| `vrunner compileexttocfe --src <каталог> --out <файл>` | `vrunner cfe compile --src <каталог> <OUT>` |
| Секция настроек `compileext`, ключи `inputPath`, `extensionName` | `vrunner.cfe.load`, ключи `src`, `extension-name`; скрипт конвертации кладёт секцию в `vrunner.cfe.compile` — перенесите её в `vrunner.cfe.load` вручную |

## Пример

Было (2.x):

```bash
vrunner compileext ./cfe/Доработки Доработки \
  --updatedb \
  --ibconnection /F./build/ib
```

Стало (3.0):

```bash
vrunner cfe load --extension-name Доработки --ibconnection /F./build/ib ./cfe/Доработки
```

Файл настроек — было (`env.json`):

```json
{
  "compileext": {
    "inputPath": "./cfe/Доработки",
    "extensionName": "Доработки"
  }
}
```

Стало (`autumn-properties.json`):

```json
{
  "vrunner": {
    "cfe": {
      "load": {
        "src": "./cfe/Доработки",
        "extension-name": "Доработки"
      }
    }
  }
}
```
