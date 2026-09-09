---
title: compileepf
---

# vrunner compileepf

Сборка внешних обработок и отчётов `.epf`/`.erf` из XML-исходников. В 3.0 — `vrunner epf compile [SRC]`: [документация](../команды/epf#compile).

## Соответствие

| 2.x | 3.0 |
|-----|-----|
| `vrunner compileepf <inputPath> <outputPath>` | `vrunner epf compile [опции] [SRC]` |
| Позиционный `inputPath` | позиционный `SRC` (по умолчанию — текущий каталог) |
| Позиционный `outputPath` | опция `--out <каталог>` |
| — | `--recursive` (`-R`): поиск обработок по подкаталогам |
| — | `--ibcmd`: сборка утилитой ibcmd; без `--ibconnection` создаётся временная база |
| Секция настроек `compileepf`, ключи `inputPath`, `outputPath` | `vrunner.epf.compile`, ключи `src`, `out` (скрипт конвертации переименовывает) |

## Пример

Было (2.x):

```bash
vrunner compileepf src/epf build/epf \
  --ibconnection /F./build/ib \
  --v8version 8.3.24
```

Стало (3.0):

```bash
# Через ibcmd, рекурсивно по подкаталогам
vrunner epf compile --out ./build/epf --ibcmd -R ./src/epf

# Через конфигуратор
vrunner epf compile \
  --out ./build/epf \
  --ibconnection /F./build/ib \
  --v8version 8.3.24 \
  ./src/epf
```

Файл настроек — было (`vrunner.json`):

```json
{
  "compileepf": {
    "inputPath": "./src/epf",
    "outputPath": "./build/epf"
  }
}
```

Стало (`autumn-properties.json`):

```json
{
  "vrunner": {
    "epf": {
      "compile": {
        "src": "./src/epf",
        "out": "./build/epf"
      }
    }
  }
}
```
