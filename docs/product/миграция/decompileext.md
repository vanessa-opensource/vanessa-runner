---
title: decompileext
---

# vrunner decompileext

Разборка расширения конфигурации в XML-исходники. В 3.0 — `vrunner cfe decompile <OUT>`: [документация](../команды/cfe#decompile).

## Соответствие

| 2.x | 3.0 |
|-----|-----|
| `vrunner decompileext` | `vrunner cfe decompile [опции] <OUT>` |
| `--outputPath <каталог>` | позиционный `OUT` (в командной строке или ключ `out` в файле настроек) |
| `--extensionName` | `--extension-name` (`VRUNNER_EXTENSION_NAME`), обязательна |
| Источник — расширение из базы `--ibconnection` | без изменений; дополнительно `--cfe-file <файл>` (`VRUNNER_CFE_FILE`) разбирает файл `.cfe` — тогда база не нужна, создаётся временная |
| — | `--ibcmd`: разборка утилитой ibcmd |
| Секция настроек `decompileext`, ключи `outputPath`, `extensionName` | `vrunner.cfe.decompile`, ключи `out`, `extension-name` (скрипт конвертации переименовывает) |

## Пример

Было (2.x):

```bash
vrunner decompileext \
  --extensionName Доработки \
  --outputPath ./cfe/Доработки \
  --ibconnection /F./build/ib
```

Стало (3.0):

```bash
# Расширение из базы
vrunner cfe decompile \
  --extension-name Доработки \
  --ibconnection /F./build/ib \
  ./cfe/Доработки

# Файл cfe через ibcmd
vrunner cfe decompile \
  --cfe-file ./build/Доработки.cfe \
  --extension-name Доработки \
  --ibcmd \
  ./cfe/Доработки
```

Файл настроек — было (`vrunner.json`):

```json
{
  "decompileext": {
    "extensionName": "Доработки",
    "outputPath": "./cfe/Доработки"
  }
}
```

Стало (`autumn-properties.json`):

```json
{
  "vrunner": {
    "cfe": {
      "decompile": {
        "extension-name": "Доработки",
        "out": "./cfe/Доработки"
      }
    }
  }
}
```
