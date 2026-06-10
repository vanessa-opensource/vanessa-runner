---
title: scheduledjobs
---

# vrunner scheduledjobs lock / unlock

Управление регламентными заданиями информационной базы через `rac`/`ras`: блокировка и разблокировка фоновых задач.

::: warning Изменено в 3.0
`vrunner scheduledjobs` вошла в группу `cluster` как `vrunner cluster jobs`. Параметр `--db` переименован в `--db-name`.

[Документация cluster jobs →](../команды/cluster#jobs)
:::

## Изменения

| Аспект | 2.x | 3.0 |
|--------|-----|-----|
| `scheduledjobs lock` | `vrunner scheduledjobs lock` | `vrunner cluster jobs lock` |
| `scheduledjobs unlock` | `vrunner scheduledjobs unlock` | `vrunner cluster jobs unlock` |
| Имя базы | `--db <имя>` | `--db-name <имя>` |
| `--ras`, `--rac` | Поддерживаются | Поддерживаются |
| Администратор кластера | `--db-user` / `--db-pwd` | `--cluster-admin` / `--cluster-pwd` |

## Примеры: scheduledjobs lock

### Было (2.x)

```bash
vrunner scheduledjobs lock \
  --ras localhost:1545 \
  --rac "C:\Program Files\1cv8\8.3.24\bin\rac.exe" \
  --db MyInfobase \
  --db-user Администратор \
  --db-pwd secret
```

### Стало (3.0)

```bash
vrunner cluster jobs lock \
  --ras localhost:1545 \
  --rac "C:\Program Files\1cv8\8.3.24\bin\rac.exe" \
  --db-name MyInfobase \
  --cluster-admin ClusterAdmin \
  --cluster-pwd adminpwd
```

## Примеры: scheduledjobs unlock

### Было (2.x)

```bash
vrunner scheduledjobs unlock \
  --ras localhost:1545 \
  --rac "C:\Program Files\1cv8\8.3.24\bin\rac.exe" \
  --db MyInfobase \
  --db-user Администратор \
  --db-pwd secret
```

### Стало (3.0)

```bash
vrunner cluster jobs unlock \
  --ras localhost:1545 \
  --rac "C:\Program Files\1cv8\8.3.24\bin\rac.exe" \
  --db-name MyInfobase \
  --cluster-admin ClusterAdmin \
  --cluster-pwd adminpwd
```

## Типичный сценарий обслуживания

Полный цикл блокировки, обновления и разблокировки в 3.0:

```bash
# 1. Остановить регламентные задания
vrunner cluster jobs lock --ras localhost:1545 --db-name MyIB --cluster-admin Admin --cluster-pwd pwd

# 2. Заблокировать новые сеансы
vrunner cluster session lock --ras localhost:1545 --db-name MyIB --cluster-admin Admin --cluster-pwd pwd \
  --permission-code SECRET --denied-message "Обслуживание. Код доступа: SECRET"

# 3. Завершить активные сеансы
vrunner cluster session kill --ras localhost:1545 --db-name MyIB --cluster-admin Admin --cluster-pwd pwd

# 4. Выполнить обновление
vrunner infobase update --ibconnection "/SMyServer\MyIB" --uccode SECRET

# 5. Разблокировать сеансы
vrunner cluster session unlock --ras localhost:1545 --db-name MyIB --cluster-admin Admin --cluster-pwd pwd

# 6. Запустить регламентные задания
vrunner cluster jobs unlock --ras localhost:1545 --db-name MyIB --cluster-admin Admin --cluster-pwd pwd
```
