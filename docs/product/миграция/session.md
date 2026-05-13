---
title: vrunner session → vrunner cluster session
---

# vrunner session lock / unlock / kill

Управление сеансами информационной базы через `rac`/`ras`: блокировка новых сеансов, снятие блокировки, принудительное завершение активных сеансов.

::: warning Изменено в 3.0
`vrunner session` вошла в группу `cluster` как `vrunner cluster session`. Изменились имена нескольких опций.

[Документация cluster session →](../команды/60-cluster#session)
:::

## Изменения

| Аспект | 2.x | 3.0 |
|--------|-----|-----|
| `session lock` | `vrunner session lock` | `vrunner cluster session lock` |
| `session unlock` | `vrunner session unlock` | `vrunner cluster session unlock` |
| `session kill` | `vrunner session kill` | `vrunner cluster session kill` |
| Имя базы | `--db <имя>` | `--db-name <имя>` |
| Код допуска | `--uccode <код>` | `--permission-code <код>` |
| Сообщение блокировки | `--lockmessage <текст>` | `--denied-message <текст>` |
| `--lockstartat <сек>` | Поддерживался | **Удалён** |
| `--lockendclear` | Поддерживался | **Удалён** |
| Фильтр сеансов (kill) | `--filter appid=Designer` | `--filter appid=Designer` |
| `--ras`, `--rac` | Поддерживаются | Поддерживаются |

::: warning Удалены параметры
`--lockstartat` и `--lockendclear` не имеют аналогов в 3.0 — блокировка применяется немедленно.
:::

## Примеры: session lock

### Было (2.x)

```bash
vrunner session lock \
  --ras localhost:1545 \
  --rac "C:\Program Files\1cv8\8.3.24\bin\rac.exe" \
  --db MyInfobase \
  --db-user Администратор \
  --db-pwd secret \
  --lockstartat 10 \
  --lockendclear \
  --lockmessage "База закрыта на обслуживание" \
  --uccode MySecretCode \
  --v8version 8.3.24
```

### Стало (3.0)

```bash
vrunner cluster session lock \
  --ras localhost:1545 \
  --rac "C:\Program Files\1cv8\8.3.24\bin\rac.exe" \
  --db-name MyInfobase \
  --cluster-admin ClusterAdmin \
  --cluster-pwd adminpwd \
  --permission-code MySecretCode \
  --denied-message "База закрыта на обслуживание. Код: MySecretCode"
```

## Примеры: session unlock

### Было (2.x)

```bash
vrunner session unlock \
  --ras localhost:1545 \
  --rac "C:\Program Files\1cv8\8.3.24\bin\rac.exe" \
  --db MyInfobase \
  --db-user Администратор \
  --db-pwd secret \
  --uccode MySecretCode
```

### Стало (3.0)

```bash
vrunner cluster session unlock \
  --ras localhost:1545 \
  --rac "C:\Program Files\1cv8\8.3.24\bin\rac.exe" \
  --db-name MyInfobase \
  --cluster-admin ClusterAdmin \
  --cluster-pwd adminpwd
```

## Примеры: session kill

### Было (2.x)

```bash
vrunner session kill \
  --filter appid=Designer \
  --ras localhost:1545 \
  --rac "C:\Program Files\1cv8\8.3.24\bin\rac.exe" \
  --db MyInfobase \
  --db-user Администратор \
  --db-pwd secret
```

### Стало (3.0)

```bash
vrunner cluster session kill \
  --filter appid=Designer \
  --ras localhost:1545 \
  --rac "C:\Program Files\1cv8\8.3.24\bin\rac.exe" \
  --db-name MyInfobase \
  --cluster-admin ClusterAdmin \
  --cluster-pwd adminpwd
```

## Файл настроек

Секции `session` в `vrunner.json` не существовало — параметры всегда передавались из командной строки.

В 3.0 можно задать общие параметры cluster в `autumn-properties.json`:

```json
{
  "runner": {
    "cluster": {
      "ras": "localhost:1545",
      "cluster-admin": "ClusterAdmin",
      "cluster-pwd": "adminpwd"
    }
  }
}
```
