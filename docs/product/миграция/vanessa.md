---
title: vanessa
---

# vrunner vanessa

Запускает функциональные BDD-тесты через Vanessa-ADD. Передаёт управление в режим 1С:Предприятие с подключённой обработкой `bddRunner.epf`.

::: warning Изменено в 3.0
`vrunner vanessa` переименована в `vrunner test vanessa` — вошла в группу `test`.

[Документация test vanessa →](../команды/test#vanessa)
:::

## Изменения

| Аспект | 2.x | 3.0 |
|--------|-----|-----|
| Команда | `vrunner vanessa` | `vrunner test vanessa` |
| Опции | без изменений | без изменений |
| Переменные окружения | `RUNNER_VANESSASETTINGS`, `RUNNER_WORKSPACE`, `RUNNER_PATHVANESSA` | `VRUNNER_VANESSASETTINGS`, `VRUNNER_WORKSPACE`, `VRUNNER_PATHVANESSA` |
| Секция в настройках | `"vanessa"` | `"runner.test.vanessa"` |

## Примеры

### Было (2.x)

```bash
vrunner vanessa \
  --ibconnection /F./build/ib \
  --vanessasettings ./tools/vb-conf.json \
  --workspace . \
  --additional "/DisplayAllFunctions /L ru"
```

### Стало (3.0)

```bash
vrunner test vanessa \
  --ibconnection /F./build/ib \
  --vanessasettings ./tools/vb-conf.json \
  --workspace . \
  --additional "/DisplayAllFunctions /L ru"
```

## Файл настроек

### Было (`vrunner.json`)

```json
{
  "default": {
    "--ibconnection": "/F./build/ib",
    "--db-user": "Администратор",
    "--db-pwd": ""
  },
  "vanessa": {
    "--vanessasettings": "./tools/VBParams.json",
    "--workspace": ".",
    "--additional": "/DisplayAllFunctions /L ru"
  }
}
```

### Стало (`autumn-properties.json`)

```json
{
  "runner": {
    "ibconnection": "/F./build/ib",
    "db-user": "Администратор",
    "db-pwd": "",
    "test": {
      "vanessa": {
        "vanessasettings": "./tools/VBParams.json",
        "workspace": ".",
        "additional": "/DisplayAllFunctions /L ru"
      }
    }
  }
}
```
