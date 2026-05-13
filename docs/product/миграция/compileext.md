---
title: vrunner compileext → vrunner cfe compile
---

# vrunner compileext

Собирает расширение конфигурации (`.cfe`) из XML-исходников.

::: warning Изменено в 3.0
`vrunner compileext` переименована в `vrunner cfe compile` — вошла в группу `cfe`. Путь к выходному `.cfe` файлу стал обязательным позиционным аргументом. Параметр `extensionName` переименован в `--extension-name`.

[Документация cfe compile →](../команды/20-cfe#compile)
:::

## Изменения

| Аспект | 2.x | 3.0 |
|--------|-----|-----|
| Команда | `vrunner compileext <inputPath>` | `vrunner cfe compile <OUT.cfe>` |
| Выходной `.cfe` файл | _(определялся автоматически или через опцию)_ | Обязательный позиционный `OUT` |
| Каталог исходников | `inputPath` | `--s` / `--src` |
| Имя расширения | `extensionName` (в конфиге) | `--extension-name` (обязательный) |
| `--ibcmd` | Не поддерживался | Поддерживается |
| Секция в настройках | `"compileext"` | `"runner.cfe.compile"` |

## Примеры

### Было (2.x)

```bash
vrunner compileext ./cfe/Доработки \
  --extensionName Доработки \
  --ibconnection /F./build/ibservice \
  --v8version 8.3.24
```

### Стало (3.0)

```bash
# Через ibcmd (рекомендуется)
vrunner cfe compile ./build/Доработки.cfe \
  --s ./cfe/Доработки \
  --extension-name Доработки \
  --ibcmd

# Через конфигуратор
vrunner cfe compile ./build/Доработки.cfe \
  --s ./cfe/Доработки \
  --extension-name Доработки \
  --ibconnection /F./build/ibservice \
  --v8version 8.3.24
```

## Файл настроек

### Было (`vrunner.json`)

```json
{
  "compileext": {
    "inputPath": "./cfe/Доработки",
    "extensionName": "Доработки"
  }
}
```

### Стало (`autumn-properties.json`)

```json
{
  "runner": {
    "cfe": {
      "compile": {
        "src": "./cfe/Доработки",
        "extension-name": "Доработки"
      }
    }
  }
}
```

::: tip
Путь к выходному `.cfe` файлу (`OUT`) задаётся только в командной строке как позиционный аргумент — он не может быть задан в файле настроек.
:::
