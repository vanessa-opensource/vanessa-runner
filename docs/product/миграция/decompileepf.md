---
title: decompileepf
---

# vrunner decompileepf

Разборка внешних обработок и отчётов `.epf`/`.erf` в XML-исходники. В 3.0 — `vrunner epf decompile <SRC>`: [документация](../команды/epf#decompile).

## Соответствие

| 2.x | 3.0 |
|-----|-----|
| `vrunner decompileepf <inputPath> <outputPath>` | `vrunner epf decompile [опции] <SRC>` |
| Позиционный `inputPath` | позиционный `SRC`: файл `.epf`/`.erf` или каталог с ними (в командной строке или ключ `src` в файле настроек) |
| Позиционный `outputPath` | опция `--out <каталог>` |
| — | `--recursive` (`-R`): поиск файлов по подкаталогам |
| — | `--ibcmd`: разборка утилитой ibcmd; без `--ibconnection` создаётся временная база |
| Секция настроек `decompileepf`, ключи `inputPath`, `outputPath` | `vrunner.epf.decompile`, ключи `src`, `out` (скрипт конвертации переименовывает) |

## Пример

Было (2.x):

```bash
vrunner decompileepf build/epf src/epf \
  --ibconnection /F./build/ib \
  --v8version 8.3.24
```

Стало (3.0):

```bash
# Каталог с обработками через ibcmd
vrunner epf decompile --out ./src/epf --ibcmd ./build/epf

# Один файл через конфигуратор
vrunner epf decompile \
  --out ./src/epf/MyReport \
  --ibconnection /F./build/ib \
  --v8version 8.3.24 \
  ./build/epf/MyReport.epf
```
