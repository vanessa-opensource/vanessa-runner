---
title: compileext
---

# vrunner compileext

Сборка расширения конфигурации из XML-исходников в `.cfe`. В 3.0 — `vrunner cfe compile <OUT>`: [документация](../команды/cfe#compile).

## Соответствие

| 2.x | 3.0 |
|-----|-----|
| `vrunner compileext <inputPath>` | `vrunner cfe compile [опции] <OUT>` |
| Позиционный `inputPath` | `--src <каталог>` (`-s`), по умолчанию — текущий каталог |
| Выходной файл определялся автоматически | позиционный `OUT` — путь к `.cfe` (в командной строке, `VRUNNER_CFE_OUT` или ключ `out` в файле настроек) |
| `--extensionName` | `--extension-name` (`VRUNNER_EXTENSION_NAME`); если не задано — имя каталога исходников |
| — | `--ibcmd`: сборка утилитой ibcmd; без `--ibconnection` создаётся временная база |
| Секция настроек `compileext`, ключи `inputPath`, `extensionName` | `vrunner.cfe.compile`, ключи `src`, `extension-name` (скрипт конвертации переименовывает); ключ `out` добавьте вручную |

## Пример

Было (2.x):

```bash
vrunner compileext ./cfe/Доработки \
  --extensionName Доработки \
  --ibconnection /F./build/ib
```

Стало (3.0):

```bash
# Через ibcmd
vrunner cfe compile --src ./cfe/Доработки --ibcmd ./build/Доработки.cfe

# Через конфигуратор с явной базой
vrunner cfe compile \
  --src ./cfe/Доработки \
  --extension-name Доработки \
  --ibconnection /F./build/ib \
  ./build/Доработки.cfe
```

Файл настроек — было (`vrunner.json`):

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
      "compile": {
        "src": "./cfe/Доработки",
        "extension-name": "Доработки",
        "out": "./build/Доработки.cfe"
      }
    }
  }
}
```
