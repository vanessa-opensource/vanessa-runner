---
title: designer
---

# vrunner designer

Запуск конфигуратора с параметрами подключения к базе и хранилищу. В 3.0 — `vrunner run designer`: [документация](../команды/run#designer).

## Соответствие

| 2.x | 3.0 |
|-----|-----|
| `vrunner designer` | `vrunner run designer` |
| `--ibconnection`, `--db-user`, `--db-pwd`, `--v8version`, `--uccode` | без изменений |
| `--storage-name`, `--storage-user`, `--storage-pwd` | без изменений |
| Секция настроек `designer` | `vrunner.run.designer` |

## Пример

Было (2.x):

```bash
vrunner designer \
  --ibconnection /Sserver1c/devib \
  --storage-name tcp://serverstorage/erp \
  --storage-user bot \
  --storage-pwd 123
```

Стало (3.0):

```bash
vrunner run designer \
  --ibconnection /Sserver1c/devib \
  --storage-name tcp://serverstorage/erp \
  --storage-user bot \
  --storage-pwd 123
```
