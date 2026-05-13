---
title: vrunner designer → vrunner run designer
---

# vrunner designer

Запускает конфигуратор 1С с нужными параметрами подключения.

::: warning Изменено в 3.0
`vrunner designer` стала подкомандой `designer` внутри группы `run`.

[Документация run designer →](../команды/70-run#designer)
:::

## Изменения

| Аспект | 2.x | 3.0 |
|--------|-----|-----|
| Команда | `vrunner designer` | `vrunner run designer` |
| Опции подключения | Поддерживаются | Поддерживаются |
| Опции хранилища | `--storage-name`, `--storage-user`, `--storage-pwd` | Поддерживаются |
| Секция в настройках | `"designer"` | `"runner.run.designer"` |

## Примеры

### Было (2.x)

```bash
vrunner designer \
  --ibconnection /Sserver1c/devib \
  --storage-name tcp://serverstorage/erp \
  --storage-user bot \
  --storage-pwd 123 \
  --v8version 8.3.24
```

### Стало (3.0)

```bash
vrunner run designer \
  --ibconnection /Sserver1c/devib \
  --storage-name tcp://serverstorage/erp \
  --storage-user bot \
  --storage-pwd 123 \
  --v8version 8.3.24
```

## Файл настроек

### Было (`vrunner.json`)

```json
{
  "designer": {
    "--ibconnection": "/Sserver1c/devib",
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
    "run": {
      "designer": {
        "ibconnection": "/Sserver1c/devib",
        "storage-name": "tcp://serverstorage/erp",
        "storage-user": "bot",
        "storage-pwd": "123"
      }
    }
  }
}
```
