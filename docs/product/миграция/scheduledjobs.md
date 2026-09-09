---
title: scheduledjobs
---

# vrunner scheduledjobs lock / unlock

Блокировка и разблокировка регламентных заданий информационной базы через `rac`/`ras`. В 3.0 — `vrunner cluster jobs lock` / `unlock`: [документация](../команды/cluster#jobs).

## Соответствие

| 2.x | 3.0 |
|-----|-----|
| `vrunner scheduledjobs lock` | `vrunner cluster jobs lock` |
| `vrunner scheduledjobs unlock` | `vrunner cluster jobs unlock` |
| `--db <имя базы>` | `--db-name <имя>` (`VRUNNER_IBNAME`) |
| `--ras`, `--rac`, `--db-user`, `--db-pwd` | без изменений |
| Секции настроек не было | общие ключи в `vrunner.cluster` (`ras`, `rac`, `db-name`, `cluster-admin`, `cluster-pwd`) |

Администратор кластера задаётся `--cluster-admin`/`--cluster-pwd`: [Общие опции](../команды/common-options#кластер-серверов). Отключение отдельного регламентного задания по имени метаданных (БСП) — `vrunner infobase scheduled-job disable <JOB>`: [документация](../команды/infobase#scheduled-job).

## Пример

Было (2.x):

```bash
vrunner scheduledjobs lock \
  --ras localhost:1545 \
  --rac "C:\Program Files\1cv8\8.3.24\bin\rac.exe" \
  --db MyInfobase \
  --db-user Администратор \
  --db-pwd secret
```

Стало (3.0):

```bash
vrunner cluster jobs lock \
  --ras localhost:1545 \
  --rac "C:\Program Files\1cv8\8.3.24\bin\rac.exe" \
  --db-name MyInfobase \
  --db-user Администратор \
  --db-pwd secret
```

Типичный цикл обслуживания в 3.0 (`jobs lock` → `session lock` → `session kill` → обновление → `session unlock` → `jobs unlock`): [cluster](../команды/cluster).
