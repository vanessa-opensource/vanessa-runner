---
title: decompileext
---

# vrunner decompileext

Разбирает файл расширения конфигурации `.cfe` в XML-исходники.

::: warning Изменено в 3.0
`vrunner decompileext` переименована в `vrunner cfe decompile` — вошла в группу `cfe`. Каталог выгрузки стал обязательным позиционным аргументом. Параметр `extensionName` переименован в `--extension-name`, добавлен обязательный параметр `--cfe-file`.

[Документация cfe decompile →](../команды/cfe#decompile)
:::

## Изменения

| Аспект | 2.x | 3.0 |
|--------|-----|-----|
| Команда | `vrunner decompileext` | `vrunner cfe decompile <OUT>` |
| Каталог выгрузки | `outputPath` (в конфиге) | Обязательный позиционный `OUT` |
| Входной `.cfe` файл | _(не требовался явно)_ | `--cfe-file` (обязательный) |
| Имя расширения | `extensionName` (в конфиге) | `--extension-name` (обязательный) |
| `--ibcmd` | Не поддерживался | Поддерживается |
| Секция в настройках | `"decompileext"` | `"vrunner.cfe.decompile"` |

## Примеры

### Было (2.x)

```bash
vrunner decompileext \
  --extensionName Доработки \
  --outputPath ./cfe/Доработки \
  --ibconnection /F./build/ibservice \
  --v8version 8.3.24
```

### Стало (3.0)

```bash
# Через ibcmd (рекомендуется)
vrunner cfe decompile ./cfe/Доработки \
  --cfe-file ./build/Доработки.cfe \
  --extension-name Доработки \
  --ibcmd

# Через конфигуратор
vrunner cfe decompile ./cfe/Доработки \
  --cfe-file ./build/Доработки.cfe \
  --extension-name Доработки \
  --ibconnection /F./build/ibservice \
  --v8version 8.3.24
```

## Файл настроек

### Было (`vrunner.json`)

```json
{
  "decompileext": {
    "extensionName": "Доработки",
    "outputPath": "./cfe/Доработки"
  }
}
```

### Стало (`autumn-properties.json`)

```json
{
  "vrunner": {
    "cfe": {
      "decompile": {
        "cfe-file": "./build/Доработки.cfe",
        "extension-name": "Доработки"
      }
    }
  }
}
```

::: tip
Каталог для выгрузки (`OUT`) задаётся только в командной строке как позиционный аргумент — он не может быть задан в файле настроек.
:::
