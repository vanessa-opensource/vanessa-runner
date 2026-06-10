---
title: decompile
---

# vrunner decompile / vrunner decompileconf

Разбирает файл конфигурации `.cf` в XML-исходники.

::: warning Изменено в 3.0
`vrunner decompile` и `vrunner decompileconf` заменены командой `vrunner cf decompile` — вошли в группу `cf`. Каталог выгрузки стал обязательным позиционным аргументом. Опция входного файла переименована из `--in` в `--cf-file`.

[Документация cf decompile →](../команды/cf#decompile)
:::

## Изменения

| Аспект | 2.x | 3.0 |
|--------|-----|-----|
| Команда | `vrunner decompile` / `vrunner decompileconf` | `vrunner cf decompile <OUT>` |
| Каталог выгрузки | `--out ./cf` | Позиционный аргумент `OUT` (обязательный) |
| Входной CF-файл | `--in ./build/1Cv8.cf` | `--cf-file ./build/1Cv8.cf` |
| `--ibcmd` | Не поддерживался | Поддерживается |
| Секция в настройках | `"decompile"` / `"decompileconf"` | `"runner.cf.decompile"` |

## Примеры

### Было (2.x)

```bash
vrunner decompile \
  --in ./build/1Cv8.cf \
  --out ./cf \
  --ibconnection /FD:/bases/temp \
  --v8version 8.3.24
```

### Стало (3.0)

```bash
# Через ibcmd (рекомендуется)
vrunner cf decompile ./cf \
  --cf-file ./build/1Cv8.cf \
  --ibcmd

# Через конфигуратор
vrunner cf decompile ./cf \
  --cf-file ./build/1Cv8.cf \
  --ibconnection /FD:/bases/temp \
  --v8version 8.3.24
```

## Файл настроек

### Было (`vrunner.json`)

```json
{
  "decompile": {
    "--in": "./build/1Cv8.cf",
    "--out": "./cf"
  }
}
```

### Стало (`autumn-properties.json`)

```json
{
  "runner": {
    "cf": {
      "decompile": {
        "cf-file": "./build/1Cv8.cf"
      }
    }
  }
}
```

::: tip
Каталог для выгрузки (`OUT`) задаётся только в командной строке как позиционный аргумент — он не может быть задан в файле настроек.
:::
