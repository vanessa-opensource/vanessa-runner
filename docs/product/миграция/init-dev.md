---
title: init-dev
---

# vrunner init-dev / vrunner update-dev

`vrunner init-dev` создавал информационную базу, опционально загружая конфигурацию из хранилища 1С.
`vrunner update-dev` обновлял конфигурацию БД уже существующей ИБ.

::: warning Изменено в 3.0
Обе команды заменены командами группы `infobase`. Логика инициализации из хранилища теперь разбита на отдельные шаги.

[Документация infobase →](../команды/infobase)
:::

## Изменения

| Аспект | 2.x | 3.0 |
|--------|-----|-----|
| Создание ИБ | `vrunner init-dev` | `vrunner infobase init` |
| Обновление конфиг. БД | `vrunner update-dev` | `vrunner infobase update` |
| Загрузка из хранилища | `vrunner init-dev --storage ...` | `vrunner repo load` (отдельный шаг) |
| Флаг реструктуризации | `--v1` / `--v2` | `--rtype v1` / `--rtype v2` |
| Секция в настройках | `"init-dev"` / `"update-dev"` | `"runner.infobase.init"` / `"runner.infobase.update"` |

## Простой случай: создание ИБ без хранилища

### Было (2.x)

```bash
vrunner init-dev \
  --ibconnection /F./build/ib \
  --db-user Администратор \
  --v8version 8.3.24
```

### Стало (3.0)

```bash
vrunner infobase init \
  --ibconnection /F./build/ib \
  --db-user Администратор \
  --v8version 8.3.24
```

## Инициализация из хранилища 1С

В 2.x это делалось одной командой с флагом `--storage`:

```bash
# 2.x: Создать ИБ и загрузить конфигурацию из хранилища
set RUNNER_IBNAME=/F./build/ib
vrunner init-dev \
  --storage \
  --storage-name tcp://serverstorage/erp \
  --storage-user bot \
  --storage-pwd 123
```

В 3.0 это разбивается на три шага:

```bash
# 3.0: Шаг 1 — создать пустую ИБ
vrunner infobase init \
  --ibconnection /F./build/ib \
  --v8version 8.3.24

# 3.0: Шаг 2 — загрузить конфигурацию из хранилища
vrunner repo load \
  --ibconnection /F./build/ib \
  --storage-name tcp://serverstorage/erp \
  --storage-user bot \
  --storage-pwd 123 \
  --v8version 8.3.24

# 3.0: Шаг 3 — обновить конфигурацию БД
vrunner infobase update \
  --ibconnection /F./build/ib \
  --v8version 8.3.24
```

## Обновление ИБ (update-dev)

### Было (2.x)

```bash
vrunner update-dev \
  --ibconnection /F./build/ib \
  --db-user Администратор \
  --v8version 8.3.24 \
  --v2
```

### Стало (3.0)

```bash
vrunner infobase update \
  --ibconnection /F./build/ib \
  --db-user Администратор \
  --v8version 8.3.24 \
  --rtype v2
```

## Флаги реструктуризации --v1 / --v2

| 2.x | 3.0 |
|-----|-----|
| `vrunner updatedb --v1` | `vrunner infobase update --rtype v1` |
| `vrunner updatedb --v2` | `vrunner infobase update --rtype v2` |
| `vrunner init-dev --v2` | `vrunner infobase update --rtype v2` |
| `vrunner update-dev --v2` | `vrunner infobase update --rtype v2` |

Значение по умолчанию: `v1`.

## Файл настроек

### Было (`vrunner.json`)

```json
{
  "init-dev": {
    "--v2": true
  },
  "update-dev": {
    "--v2": true
  }
}
```

### Стало (`autumn-properties.json`)

```json
{
  "vrunner": {
    "infobase": {
      "init": {},
      "update": {
        "rtype": "v2"
      }
    }
  }
}
```
