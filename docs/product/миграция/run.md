---
title: run
---

# vrunner run

Запускает 1С:Предприятие в режиме предприятия с переданными параметрами `/C` и `/Execute`.

::: warning Изменено в 3.0
`vrunner run` стала подкомандой `enterprise` внутри группы `run`.

[Документация run enterprise →](../команды/70-run#enterprise)
:::

## Изменения

| Аспект | 2.x | 3.0 |
|--------|-----|-----|
| Команда | `vrunner run` | `vrunner run enterprise` |
| `--command` | Поддерживается | Поддерживается |
| `--execute` | Поддерживается | Поддерживается |
| `--nocacheuse` | Поддерживается | Поддерживается |
| Переменные окружения | `RUNNER_*` | `VRUNNER_*` |
| Секция в настройках | `"run"` | `"runner.run.enterprise"` |

## Примеры

### Было (2.x)

```bash
vrunner run \
  --ibconnection /F./build/ib \
  --db-user Администратор \
  --v8version 8.3.24 \
  --uccode godModeOFF \
  --nocacheuse \
  --command "ЗапуститьОбновлениеИБ;РежимОтладки;" \
  --execute "$runnerRoot\epf\ЗакрытьПредприятие.epf"
```

### Стало (3.0)

```bash
vrunner run enterprise \
  --ibconnection /F./build/ib \
  --db-user Администратор \
  --v8version 8.3.24 \
  --uccode godModeOFF \
  --nocacheuse \
  --command "ЗапуститьОбновлениеИБ;РежимОтладки;" \
  --execute "$runnerRoot\epf\ЗакрытьПредприятие.epf"
```

## Файл настроек

### Было (`vrunner.json`)

```json
{
  "run": {
    "--uccode": "godModeOFF",
    "--command": "ЗапуститьОбновлениеИБ;РежимОтладки;ОтключитьЛогикуРаботыПрограммы;",
    "--execute": "$runnerRoot\\epf\\ЗакрытьПредприятие.epf"
  }
}
```

### Стало (`autumn-properties.json`)

```json
{
  "runner": {
    "run": {
      "enterprise": {
        "uccode": "godModeOFF",
        "command": "ЗапуститьОбновлениеИБ;РежимОтладки;ОтключитьЛогикуРаботыПрограммы;",
        "execute": "$runnerRoot\\epf\\ЗакрытьПредприятие.epf"
      }
    }
  }
}
```
