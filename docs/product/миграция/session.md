---
title: session
---

# vrunner session lock / unlock / kill / closed

Управление сеансами информационной базы через `rac`/`ras`. В 3.0 — `vrunner cluster session …`: [документация](../команды/cluster#session).

## Соответствие

| 2.x | 3.0 |
|-----|-----|
| `vrunner session lock` | `vrunner cluster session lock` |
| `vrunner session unlock` | `vrunner cluster session unlock` |
| `vrunner session kill` | `vrunner cluster session kill` |
| `vrunner session closed` | `vrunner cluster session closed` |
| — | `vrunner cluster session list [--connections]` — список сеансов |
| `--db <имя базы>` | `--db-name <имя>` (`VRUNNER_IBNAME`) |
| `--ras`, `--rac`, `--db-user`, `--db-pwd`, `--uccode` | без изменений |
| `--lockmessage <текст>` | `--denied-message <текст>` |
| `--lockstartat <сек>`, `--lockendclear` | убраны: блокировка применяется сразу |
| `--filter "appid=Designer;1CV8"` (kill, closed) | `--filter-app "Designer;1CV8"` — несколько раз или списком через `;` |
| `--filter "name=рег1;рег2"` (kill, closed) | `--filter-name "рег1;рег2"` |
| `--mode EXCEPT` | `--filter-except` (флаг) |
| `--mode ONLY`, `OFF`, `DEFAULT`, `ALL` | убраны: `ONLY` — поведение по умолчанию, `OFF` — запуск без отбора |
| `--with-nolock` (kill) | `--no-lock` |
| kill: результат не проверялся | kill повторяет завершение зависших сеансов (по умолчанию 3 попытки с паузой 3 секунды; `--retry <n>` или `--timeout <сек>`) и завершается с кодом 1, если сеансы остались |
| closed: разовая проверка | `--timeout <сек>` — ждать завершения, проверяя каждые 3 секунды; код возврата 1, если сеансы остались |
| Секции настроек не было | общие ключи в `vrunner.cluster` (`ras`, `rac`, `db-name`, `cluster-admin`, `cluster-pwd`) действуют для всех команд группы |

Администратор кластера задаётся `--cluster-admin`/`--cluster-pwd` (`VRUNNER_CLUSTERADMIN_USER`/`VRUNNER_CLUSTERADMIN_PWD`), кластер — `--cluster` или `--cluster-name`: [Общие опции](../команды/common-options#кластер-серверов).

## Пример

Было (2.x):

```bash
vrunner session lock \
  --ras localhost:1545 \
  --db MyInfobase \
  --db-user Администратор \
  --db-pwd secret \
  --uccode MySecretCode \
  --lockmessage "База закрыта на обслуживание"

vrunner session kill \
  --ras localhost:1545 \
  --db MyInfobase \
  --db-user Администратор \
  --db-pwd secret \
  --filter "appid=Designer|name=регламент" \
  --mode EXCEPT
```

Стало (3.0):

```bash
vrunner cluster session lock \
  --ras localhost:1545 \
  --db-name MyInfobase \
  --db-user Администратор \
  --db-pwd secret \
  --uccode MySecretCode \
  --denied-message "База закрыта на обслуживание"

vrunner cluster session kill \
  --ras localhost:1545 \
  --db-name MyInfobase \
  --db-user Администратор \
  --db-pwd secret \
  --filter-app Designer \
  --filter-name регламент \
  --filter-except
```

Общие параметры кластера в `autumn-properties.json`:

```json
{
  "vrunner": {
    "cluster": {
      "ras": "localhost:1545",
      "db-name": "MyInfobase",
      "cluster-admin": "ClusterAdmin",
      "cluster-pwd": "adminpwd"
    }
  }
}
```
