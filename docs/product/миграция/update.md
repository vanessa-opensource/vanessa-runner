---
title: update
---

# vrunner update

Обновляет конфигурацию, находящуюся на поддержке, из файла поставщика (`.cf`/`.cfu`) —
команда Конфигуратора `/UpdateCfg`.

::: warning Изменено в 3.0
`vrunner update` переименована в `vrunner cf vendor-update` — вошла в группу `cf`.
После обновления конфигурация БД теперь **обновляется по умолчанию** — отдельный вызов
`updatedb` больше не нужен (отключается флагом `--no-update-db`).

[Документация cf vendor-update →](../команды/cf#vendor-update)
:::

## Изменения

| Аспект | 2.x | 3.0 |
|--------|-----|-----|
| Команда | `vrunner update` | `vrunner cf vendor-update` |
| `-s`, `--src` (`$version` в имени) | Поддерживается | Поддерживается; из нескольких подходящих файлов выбирается старшая версия |
| `--update-settings` | Поддерживается | Поддерживается (необязательна) |
| `--IncludeObjectsByUnresolvedRefs` / `--ClearUnresolvedRefs` | Поддерживаются | Поддерживаются |
| `--DumpListOfTwiceChangedProperties` | Поддерживается | Поддерживается |
| `--force` | Поддерживается | Поддерживается |
| Обновление конфигурации БД | Отдельной командой `updatedb` | По умолчанию после обновления; `--no-update-db` отключает |
| Переменные окружения | `RUNNER_*` | `VRUNNER_*` |
| Секция в настройках | `"update"` | `"vrunner.cf.vendor-update"` |

## Примеры

### Было (2.x)

```bash
vrunner update \
  --src ./updates/1cv8_$version.cfu \
  --update-settings ./update-settings.xml \
  --ibconnection /F./build/ib \
  --force

vrunner updatedb \
  --ibconnection /F./build/ib
```

### Стало (3.0)

```bash
# конфигурация БД обновляется сразу, updatedb не нужен
vrunner cf vendor-update \
  --src ./updates/1cv8_$version.cfu \
  --update-settings ./update-settings.xml \
  --ibconnection /F./build/ib \
  --force
```

## Файл настроек

### Было (`vrunner.json`)

```json
{
  "update": {
    "--ibconnection": "/F./build/ib",
    "--src": "./updates/1cv8_$version.cfu",
    "--update-settings": "./update-settings.xml"
  }
}
```

### Стало (`autumn-properties.json`)

```json
{
  "vrunner": {
    "cf": {
      "vendor-update": {
        "ibconnection": "/F./build/ib",
        "src": "./updates/1cv8_$version.cfu",
        "update-settings": "./update-settings.xml"
      }
    }
  }
}
```
