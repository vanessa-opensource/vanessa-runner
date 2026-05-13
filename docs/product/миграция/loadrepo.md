---
title: vrunner loadrepo → vrunner repo load
---

# vrunner loadrepo

Загружает конфигурацию из хранилища 1С в информационную базу (обновляет ИБ до последней версии в хранилище).

::: warning Изменено в 3.0
`vrunner loadrepo` переименована в `vrunner repo load` — вошла в группу `repo`.

[Документация repo load →](../команды/50-repo#load)
:::

## Изменения

| Аспект | 2.x | 3.0 |
|--------|-----|-----|
| Команда | `vrunner loadrepo` | `vrunner repo load` |
| `--storage-name` | Поддерживается | Поддерживается |
| `--storage-user` | Поддерживается | Поддерживается |
| `--storage-pwd` | Поддерживается | Поддерживается |
| `--storage-ver` | Поддерживается | Поддерживается |
| Переменные окружения | `RUNNER_storage_name`, `RUNNER_storage_user`, `RUNNER_storage_pwd` | `VRUNNER_STORAGE_NAME`, `VRUNNER_STORAGE_USER`, `VRUNNER_STORAGE_PWD` |
| Секция в настройках | `"loadrepo"` | `"runner.repo.load"` |

## Примеры

### Было (2.x)

```bash
vrunner loadrepo \
  --ibconnection /F./build/ibservice \
  --storage-name tcp://serverstorage/erp \
  --storage-user bot \
  --storage-pwd 123 \
  --db-user Администратор \
  --db-pwd secret \
  --v8version 8.3.24
```

### Стало (3.0)

```bash
vrunner repo load \
  --ibconnection /F./build/ibservice \
  --storage-name tcp://serverstorage/erp \
  --storage-user bot \
  --storage-pwd 123 \
  --db-user Администратор \
  --db-pwd secret \
  --v8version 8.3.24
```

## Файл настроек

### Было (`vrunner.json`)

```json
{
  "loadrepo": {
    "--ibconnection": "/F./build/ibservice",
    "--storage-name": "tcp://serverstorage/erp",
    "--storage-user": "bot",
    "--storage-pwd": "123"
  }
}
```

### Стало (`autumn-properties.json`)

```json
{
  "runner": {
    "repo": {
      "load": {
        "ibconnection": "/F./build/ibservice",
        "storage-name": "tcp://serverstorage/erp",
        "storage-user": "bot",
        "storage-pwd": "123"
      }
    }
  }
}
```
