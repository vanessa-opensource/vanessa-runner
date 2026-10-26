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
| Каталог обходился рекурсивно всегда | `--recursive` (`-R`): обход подкаталогов; без него `SRC` — каталог одной обработки |
| — | `--ibcmd`: временная база создаётся утилитой ibcmd; сборка всегда идёт конфигуратором |
| `--cachekey`, `--onlycopy` | убраны |
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
# Временная база через ibcmd, обход подкаталогов
vrunner epf compile --out ./build/epf --ibcmd -R ./src/epf

# С явной базой
vrunner epf compile \
  --out ./build/epf \
  --ibconnection /F./build/ib \
  --v8version 8.3.24 \
  -R \
  ./src/epf
```

Файл настроек — было (`env.json`):

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
        "out": "./build/epf",
        "recursive": true
      }
    }
  }
}
```
