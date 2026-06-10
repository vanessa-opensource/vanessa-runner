---
title: compileepf
---

# vrunner compileepf

Собирает внешние обработки `.epf`/`.erf` из XML-исходников.

::: warning Изменено в 3.0
`vrunner compileepf` переименована в `vrunner epf compile` — вошла в группу `epf`. Позиционные аргументы `inputPath`/`outputPath` заменены: `inputPath` стал необязательным позиционным `SRC`, `outputPath` стал опцией `--out`.

[Документация epf compile →](../команды/epf#compile)
:::

## Изменения

| Аспект | 2.x | 3.0 |
|--------|-----|-----|
| Команда | `vrunner compileepf <inputPath> <outputPath>` | `vrunner epf compile [SRC] --out <dir>` |
| Каталог исходников | Позиционный `inputPath` | Необязательный позиционный `SRC` |
| Каталог вывода | Позиционный `outputPath` | Опция `--out` |
| Рекурсивный поиск | Не поддерживался | `--recursive` / `-R` |
| `--ibcmd` | Не поддерживался | Поддерживается |
| Секция в настройках | `"compileepf"` | `"runner.epf.compile"` |

## Примеры

### Было (2.x)

```bash
# Собрать обработки из src/epf в build/epf
vrunner compileepf src/epf build/epf \
  --ibconnection /F./build/ibservice \
  --v8version 8.3.24

# Несколько каталогов — несколько вызовов
vrunner compileepf src/tools tools/epf/utils
vrunner compileepf src/tests tests/smoke
```

### Стало (3.0)

```bash
# Собрать обработки из ./epf в ./build/epf
vrunner epf compile ./epf --out ./build/epf --ibcmd

# Рекурсивно обработать все подкаталоги
vrunner epf compile ./epf -R --out ./build/epf --ibcmd

# Через конфигуратор
vrunner epf compile ./epf \
  --out ./build/epf \
  --ibconnection /F./build/ibservice \
  --v8version 8.3.24
```

## Файл настроек

### Было (`vrunner.json`)

```json
{
  "compileepf": {
    "--ibconnection": "/F./build/ibservice",
    "inputPath": "./epf",
    "outputPath": "./build/epf"
  }
}
```

### Стало (`autumn-properties.json`)

```json
{
  "runner": {
    "epf": {
      "compile": {
        "ibconnection": "/F./build/ibservice",
        "out": "./build/epf"
      }
    }
  }
}
```

::: tip
Значения `inputPath` и `outputPath` из конфига 2.x не переносятся автоматически. Каталог исходников (`SRC`) можно задать только в командной строке; `--out` можно задать в `autumn-properties.json`.
:::
