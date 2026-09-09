---
title: update
---

# vrunner update

Обновление конфигурации на поддержке из файла поставщика (`.cf`/`.cfu`, команда конфигуратора `/UpdateCfg`). В 3.0 — `vrunner cf vendor-update`: [документация](../команды/cf#vendor-update).

## Соответствие

| 2.x | 3.0 |
|-----|-----|
| `vrunner update` | `vrunner cf vendor-update` |
| `--src` (`-s`), шаблон `$version` в имени файла | без изменений; из нескольких подходящих файлов берётся старшая версия |
| `--update-settings`, `--IncludeObjectsByUnresolvedRefs`, `--ClearUnresolvedRefs`, `--DumpListOfTwiceChangedProperties`, `--force` | без изменений |
| Обновление конфигурации БД отдельной командой `updatedb` | выполняется сразу после обновления; отключается флагом `--no-update-db`; режим реструктуризации — `--rtype`, `--dynamic` |
| Секция настроек `update` | `vrunner.cf.vendor-update` |

## Пример

Было (2.x):

```bash
vrunner update \
  --src './updates/1cv8_$version.cfu' \
  --update-settings ./update-settings.xml \
  --ibconnection /F./build/ib \
  --force

vrunner updatedb --ibconnection /F./build/ib
```

Стало (3.0):

```bash
vrunner cf vendor-update \
  --src './updates/1cv8_$version.cfu' \
  --update-settings ./update-settings.xml \
  --ibconnection /F./build/ib \
  --force
```

Файл настроек — было (`vrunner.json`):

```json
{
  "update": {
    "--src": "./updates/1cv8_$version.cfu",
    "--update-settings": "./update-settings.xml"
  }
}
```

Стало (`autumn-properties.json`):

```json
{
  "vrunner": {
    "cf": {
      "vendor-update": {
        "src": "./updates/1cv8_$version.cfu",
        "update-settings": "./update-settings.xml"
      }
    }
  }
}
```
