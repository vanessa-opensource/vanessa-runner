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
| Путь к фичам | `--path <путь>` | `--feature-path <путь>` |
| Путь к bddRunner.epf | `--pathvanessa <путь>` | `--bddrunner-path <путь>` |
| Прочие опции | `--vanessasettings`, `--workspace`, `--tags-ignore`, `--tags-filter`, `--additional-keys` | без изменений |
| Переменные окружения | `RUNNER_VANESSASETTINGS`, `RUNNER_WORKSPACE`, `RUNNER_PATHVANESSA` | `VRUNNER_VANESSASETTINGS`, `VRUNNER_WORKSPACE`, `VRUNNER_PATHVANESSA` |
| Секция в настройках | `"vanessa"` | `"vrunner.test.vanessa"` |

::: tip Путь к фичам
Как и в 2.x, путь к фичам передаётся в Vanessa-ADD через переменную окружения `VANESSA_FEATUREPATH` (vrunner выставляет её сам, приводя путь к абсолютному). Он переопределяет `КаталогФич` из файла настроек Vanessa. С толстым клиентом (`--ordinaryapp 1`) опция `--feature-path` несовместима — Vanessa-ADD в режиме обычных форм не поддерживает указание фич при запуске.
:::

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
  "vrunner": {
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
