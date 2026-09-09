---
title: loadrepo
---

# vrunner loadrepo

Обновление конфигурации информационной базы из хранилища. В 3.0 — `vrunner repo load`: [документация](../команды/repo#load).

## Соответствие

| 2.x | 3.0 |
|-----|-----|
| `vrunner loadrepo` | `vrunner repo load` |
| `--storage-name`, `--storage-user`, `--storage-pwd`, `--storage-ver` | без изменений |
| `RUNNER_storage_name`, `RUNNER_storage_user`, `RUNNER_storage_pwd` | `VRUNNER_STORAGE_NAME`, `VRUNNER_STORAGE_USER`, `VRUNNER_STORAGE_PWD` |
| Секция настроек `loadrepo` | `vrunner.repo.load` |

`repo load` обновляет только конфигурацию; конфигурацию БД после этого обновляет `vrunner infobase update`.

## Пример

Было (2.x):

```bash
vrunner loadrepo \
  --ibconnection /F./build/ib \
  --storage-name tcp://serverstorage/erp \
  --storage-user bot \
  --storage-pwd 123
```

Стало (3.0):

```bash
vrunner repo load \
  --ibconnection /F./build/ib \
  --storage-name tcp://serverstorage/erp \
  --storage-user bot \
  --storage-pwd 123

vrunner infobase update --ibconnection /F./build/ib
```
