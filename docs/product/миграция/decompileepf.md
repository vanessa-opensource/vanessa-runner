---
title: vrunner decompileepf → vrunner epf decompile
---

# vrunner decompileepf

Разбирает файлы внешних обработок `.epf`/`.erf` в XML-исходники.

::: warning Изменено в 3.0
`vrunner decompileepf` переименована в `vrunner epf decompile` — вошла в группу `epf`. Позиционные аргументы `inputPath`/`outputPath` заменены: `inputPath` стал обязательным `SRC`, `outputPath` стал опцией `--out`.

[Документация epf decompile →](../команды/30-epf#decompile)
:::

## Изменения

| Аспект | 2.x | 3.0 |
|--------|-----|-----|
| Команда | `vrunner decompileepf <inputPath> <outputPath>` | `vrunner epf decompile <SRC> [--out <dir>]` |
| Источник (EPF-файл или каталог) | Позиционный `inputPath` | Обязательный позиционный `SRC` |
| Каталог вывода | Позиционный `outputPath` | Опция `--out` |
| Рекурсивный поиск | Не поддерживался | `--recursive` / `-R` |
| `--ibcmd` | Не поддерживался | Поддерживается |
| Секция в настройках | `"decompileepf"` | `"runner.epf.decompile"` |

## Примеры

### Было (2.x)

```bash
vrunner decompileepf build/epf epf \
  --ibconnection /F./build/ibservice \
  --v8version 8.3.24
```

### Стало (3.0)

```bash
# Разобрать все EPF из каталога
vrunner epf decompile ./build/epf --out ./epf --ibcmd

# Рекурсивно
vrunner epf decompile ./build/epf -R --out ./epf --ibcmd

# Разобрать один файл
vrunner epf decompile ./build/epf/MyReport.epf \
  --out ./epf/MyReport \
  --ibconnection /F./build/ibservice \
  --v8version 8.3.24
```

## Файл настроек

### Было (`vrunner.json`)

```json
{
  "decompileepf": {
    "--ibconnection": "/F./build/ibservice",
    "inputPath": "./build/out/epf",
    "outputPath": "./epf"
  }
}
```

### Стало (`autumn-properties.json`)

```json
{
  "runner": {
    "epf": {
      "decompile": {
        "ibconnection": "/F./build/ibservice",
        "out": "./epf"
      }
    }
  }
}
```
