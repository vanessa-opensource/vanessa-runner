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
| Каталог обходился рекурсивно всегда | `--recursive` (`-R`): обход подкаталогов; без него разбираются только файлы верхнего уровня `SRC` |
| — | `--ibcmd`: временная база создаётся утилитой ibcmd; разборка всегда идёт конфигуратором |
| `--cachekey` | убрана |
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
# Каталог с обработками, временная база через ibcmd
vrunner epf decompile --out ./src/epf --ibcmd -R ./build/epf

# Один файл с явной базой
vrunner epf decompile \
  --out ./src/epf \
  --ibconnection /F./build/ib \
  --v8version 8.3.24 \
  ./build/epf/MyReport.epf
```
