---
title: updatedb
---

# vrunner updatedb

Обновляет конфигурацию БД информационной базы — применяет изменения конфигурации к базе данных.

::: warning Изменено в 3.0
`vrunner updatedb` переименована в `vrunner infobase update` — вошла в группу `infobase`. Флаги `--v1`/`--v2` заменены опцией `--rtype`.

[Документация infobase update →](../команды/infobase#update)
:::

## Изменения

| Аспект | 2.x | 3.0 |
|--------|-----|-----|
| Команда | `vrunner updatedb` | `vrunner infobase update` |
| Режим реструктуризации | `--v1` / `--v2` (флаги) | `--rtype v1` / `--rtype v2` |
| Значение по умолчанию | `v1` (обычный) | `--rtype v1` |
| `--uccode` | Поддерживается | Поддерживается |
| `--ibconnection` | Поддерживается | Поддерживается |
| Переменные окружения | `RUNNER_*` | `VRUNNER_*` |
| Секция в настройках | `"updatedb"` | `"runner.infobase.update"` |

## Примеры

### Было (2.x)

```bash
# Обычное обновление
vrunner updatedb \
  --ibconnection /F./build/ib \
  --db-user Администратор \
  --db-pwd secret \
  --v8version 8.3.24 \
  --uccode godModeOn

# Оптимизированный режим реструктуризации
vrunner updatedb \
  --ibconnection /F./build/ib \
  --uccode godModeOn \
  --v2
```

### Стало (3.0)

```bash
# Обычное обновление (rtype v1 — по умолчанию)
vrunner infobase update \
  --ibconnection /F./build/ib \
  --db-user Администратор \
  --db-pwd secret \
  --v8version 8.3.24 \
  --uccode godModeOn

# Оптимизированный режим реструктуризации
vrunner infobase update \
  --ibconnection /F./build/ib \
  --uccode godModeOn \
  --rtype v2
```

## Файл настроек

### Было (`vrunner.json`)

```json
{
  "updatedb": {
    "--ibconnection": "/F./build/ib",
    "--db-user": "bot",
    "--db-pwd": "123",
    "--uccode": "godModeOn",
    "--v2": true
  }
}
```

### Стало (`autumn-properties.json`)

```json
{
  "vrunner": {
    "infobase": {
      "update": {
        "ibconnection": "/F./build/ib",
        "db-user": "bot",
        "db-pwd": "123",
        "uccode": "godModeOn",
        "rtype": "v2"
      }
    }
  }
}
```
