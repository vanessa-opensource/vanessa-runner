---
title: session
---

# vrunner session lock / unlock / kill / closed

Управление сеансами информационной базы через `rac`/`ras`: блокировка новых сеансов, снятие блокировки, принудительное завершение активных сеансов, проверка отсутствия сеансов.

::: warning Изменено в 3.0
`vrunner session` вошла в группу `cluster` как `vrunner cluster session`. Изменились имена нескольких опций.

[Документация cluster session →](../команды/cluster#session)
:::

## Изменения

| Аспект | 2.x | 3.0 |
|--------|-----|-----|
| `session lock` | `vrunner session lock` | `vrunner cluster session lock` |
| `session unlock` | `vrunner session unlock` | `vrunner cluster session unlock` |
| `session kill` | `vrunner session kill` | `vrunner cluster session kill` |
| `session closed` | `vrunner session closed` | `vrunner cluster session closed` |
| Список сеансов | — | `vrunner cluster session list` (**новое**) |
| Проверка завершения (kill) | Нет — «выстрелил и забыл» | Есть: ретраи зависших сеансов, `--retry`/`--timeout` |
| Ожидание завершения (closed) | Нет — только разовая проверка | `--timeout <сек>` — проверка каждые 3 секунды |
| Имя базы | `--db <имя>` | `--db-name <имя>` |
| Код допуска | `--uccode <код>` | `--uccode <код>` (без изменений) |
| Сообщение блокировки | `--lockmessage <текст>` | `--denied-message <текст>` |
| `--lockstartat <сек>` | Поддерживался | **Удалён** |
| `--lockendclear` | Поддерживался | **Удалён** |
| Отбор по приложению (kill/closed) | `--filter appid=Designer;1CV8` | `--filter-app "Designer;1CV8"` |
| Отбор по пользователю (kill/closed) | `--filter name=рег1;рег2` | `--filter-name "рег1;рег2"` |
| Режим отбора | `--mode EXCEPT` | `--filter-except` |
| Режим отбора | `--mode ONLY` / `OFF` / `DEFAULT` / `ALL` | **Удалены** (см. ниже) |
| `--with-nolock` (kill) | Поддерживался | `--no-lock` |
| `--ras`, `--rac` | Поддерживаются | Поддерживаются |

::: warning Удалены параметры
`--lockstartat` и `--lockendclear` не имеют аналогов в 3.0 — блокировка применяется немедленно.
:::

::: tip Отбор сеансов в 3.0
Единая опция `--filter` с мини-синтаксисом `ключ=значение` заменена двумя явными опциями: `--filter-app` (идентификатор приложения, значения проверяются по списку допустимых) и `--filter-name` (пользователь ИБ). Обе можно указывать несколько раз или перечислять значения через `;` — все условия объединяются по ИЛИ, как в 2.x.

Опция `--mode` заменена флагом `--filter-except` (аналог `--mode EXCEPT` — действие применяется ко всем сеансам, кроме подходящих под отбор). Прочие режимы аналога не имеют: `ONLY` был поведением по умолчанию, `OFF` эквивалентен запуску без отбора, а `DEFAULT`/`ALL` опирались на встроенные фильтры vanessa-runner, которых так и не появилось.
:::

::: warning kill проверяет результат
В 2.x `session kill` не проверял, что сеансы действительно завершились, и всегда возвращал 0. В 3.0 команда после каждой попытки перечитывает список, добивает зависшие сеансы повторно (по умолчанию 3 попытки с паузой 3 секунды; настраивается `--retry`/`--timeout`) и завершается с кодом 1, если сеансы так и остались. Пайплайны, полагавшиеся на «kill всегда успешен», теперь честно упадут на незавершаемых сеансах.
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
  --uccode MySecretCode \
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
  --filter "appid=Designer|name=регламент;администратор" \
  --mode EXCEPT \
  --ras localhost:1545 \
  --rac "C:\Program Files\1cv8\8.3.24\bin\rac.exe" \
  --db MyInfobase \
  --db-user Администратор \
  --db-pwd secret
```

### Стало (3.0)

```bash
vrunner cluster session kill \
  --filter-app Designer \
  --filter-name "регламент;администратор" \
  --filter-except \
  --ras localhost:1545 \
  --rac "C:\Program Files\1cv8\8.3.24\bin\rac.exe" \
  --db-name MyInfobase \
  --cluster-admin ClusterAdmin \
  --cluster-pwd adminpwd
```

## Примеры: session closed

Действие `closed` проверяет отсутствие сеансов: если сеансы найдены, команда печатает их список и завершается с ненулевым кодом возврата. Типовой сценарий — после `session lock` дождаться завершения фоновых заданий перед обновлением.

### Было (2.x)

```bash
vrunner session closed \
  --ras localhost:1545 \
  --db MyInfobase \
  --db-user Администратор \
  --db-pwd secret
```

### Стало (3.0)

```bash
vrunner cluster session closed \
  --ras localhost:1545 \
  --db-name MyInfobase \
  --cluster-admin ClusterAdmin \
  --cluster-pwd adminpwd
```

## Файл настроек

Секции `session` в `vrunner.json` не существовало — параметры всегда передавались из командной строки.

В 3.0 можно задать общие параметры cluster в `autumn-properties.json`:

```json
{
  "vrunner": {
    "cluster": {
      "ras": "localhost:1545",
      "cluster-admin": "ClusterAdmin",
      "cluster-pwd": "adminpwd"
    }
  }
}
```
