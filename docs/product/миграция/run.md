---
title: run
---

# vrunner run

Запуск 1С:Предприятия с параметрами `/C` и `/Execute`. В 3.0 — `vrunner run enterprise`: [документация](../команды/run#enterprise).

## Соответствие

| 2.x | 3.0 |
|-----|-----|
| `vrunner run` | `vrunner run enterprise` |
| `--command`, `--execute`, `--uccode`, `--additional` | без изменений |
| `--nocacheuse` | удалена: в 3.0 кеш списка баз не используется |
| `RUNNER_*` | `VRUNNER_*` (`VRUNNER_COMMAND`, `VRUNNER_EXECUTE`, `VRUNNER_ADDITIONAL`) |
| Секция настроек `run` | `vrunner.run.enterprise` |

## Пример

Было (2.x):

```bash
vrunner run \
  --ibconnection /F./build/ib \
  --uccode godModeOFF \
  --nocacheuse \
  --command "ЗапуститьОбновлениеИБ;РежимОтладки;" \
  --execute "$runnerRoot/epf/ЗакрытьПредприятие.epf"
```

Стало (3.0):

```bash
vrunner run enterprise \
  --ibconnection /F./build/ib \
  --uccode godModeOFF \
  --command "ЗапуститьОбновлениеИБ;РежимОтладки;" \
  --execute "$runnerRoot/epf/ЗакрытьПредприятие.epf"
```

Файл настроек — было (`vrunner.json`):

```json
{
  "run": {
    "--uccode": "godModeOFF",
    "--command": "ЗапуститьОбновлениеИБ;РежимОтладки;"
  }
}
```

Стало (`autumn-properties.json`):

```json
{
  "vrunner": {
    "run": {
      "enterprise": {
        "uccode": "godModeOFF",
        "command": "ЗапуститьОбновлениеИБ;РежимОтладки;"
      }
    }
  }
}
```
