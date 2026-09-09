---
title: cluster
---

# cluster - Управление кластером серверов

Команды `cluster` управляют информационной базой в кластере серверов 1С через RAS: создание и удаление ИБ, сведения о ней, сеансы и регламентные задания.

```bash
vrunner cluster <подкоманда> [опции]
```

Все команды принимают общие опции кластера: `--ras` (по умолчанию `localhost:1545`), `--db-name`, `--cluster` или `--cluster-name` (без них берётся первый кластер в списке), `--cluster-admin`/`--cluster-pwd`, а также `--db-user`/`--db-pwd` администратора ИБ - см. [Кластер серверов](./common-options#кластер-серверов). Версия платформы для поиска `rac` - опция `--v8version` из раздела [Платформа](./common-options#платформа).

## create

Создаёт информационную базу в кластере. По умолчанию создаётся и база данных в СУБД по опциям `--dbms-*`.

```bash
vrunner cluster create [опции]
```

### Опции

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--ib-locale` | - | Локализация ИБ (по умолчанию `ru_RU`) |
| `--no-create-db` | - | Не создавать базу данных в СУБД |
| `--lock-jobs` | - | Сразу заблокировать регламентные задания |

> Общие опции: [кластер серверов](./common-options#кластер-серверов), [платформа](./common-options#платформа), [СУБД](./common-options#опции-субд), [файл настроек](./common-options#файл-настроек).

### Примеры

```bash
vrunner cluster create \
  --ras localhost:1545 \
  --cluster-admin ClusterAdmin \
  --cluster-pwd secret \
  --db-name MyInfobase \
  --dbms-type PostgreSQL \
  --dbms-server localhost \
  --dbms-base my_db \
  --dbms-user postgres \
  --dbms-pwd secret
```

## info

Выводит сведения об ИБ в кластере: имя, идентификатор, СУБД, сервер и имя базы данных, блокировки сеансов и регламентных заданий, выдачу лицензий.

```bash
vrunner cluster info [опции]
```

> Общие опции: [кластер серверов](./common-options#кластер-серверов), [платформа](./common-options#платформа), [файл настроек](./common-options#файл-настроек).

### Примеры

```bash
vrunner cluster info --ras localhost:1545 --db-name MyInfobase --cluster-admin ClusterAdmin --cluster-pwd secret
```

## remove

Удаляет информационную базу из кластера. Без флагов база данных в СУБД остаётся нетронутой.

```bash
vrunner cluster remove [опции]
```

### Опции

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--drop-db` | - | Удалить базу данных в СУБД |
| `--clear-db` | - | Очистить базу данных в СУБД |

> Общие опции: [кластер серверов](./common-options#кластер-серверов), [платформа](./common-options#платформа), [файл настроек](./common-options#файл-настроек).

### Примеры

```bash
vrunner cluster remove --drop-db --ras localhost:1545 --db-name MyInfobase --cluster-admin ClusterAdmin --cluster-pwd secret
```

## session

Управление сеансами информационной базы.

```bash
vrunner cluster session <lock | unlock | list | kill | closed> [опции]
```

Команды `list`, `kill` и `closed` принимают отбор сеансов:

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--filter-app` | - | Отбор по приложению сеанса; можно указать несколько раз или списком через `;` |
| `--filter-name` | - | Отбор по имени пользователя ИБ; можно указать несколько раз или списком через `;` |
| `--filter-except` | - | Инвертировать отбор: все сеансы, **кроме** подходящих под `--filter-app`/`--filter-name` |

Условия объединяются по ИЛИ: сеанс подходит, если совпало приложение **или** пользователь. Сравнение регистронезависимое, без масок. Допустимые значения `--filter-app`: `Designer`, `1CV8`, `1CV8C`, `WebClient`, `WSConnection`, `HTTPServiceConnection`, `COMConnection`, `WebServerExtension`, `BackgroundJob`, `JobScheduler`, `SrvrConsole`, `RAS`, `AgentStandardCall`.

> Общие опции всех подкоманд: [кластер серверов](./common-options#кластер-серверов), [платформа](./common-options#платформа), [файл настроек](./common-options#файл-настроек).

### session lock

Блокирует начало новых сеансов. Код разрешения задаётся опцией `--uccode`.

```bash
vrunner cluster session lock [опции]
```

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--denied-message` | - | Сообщение при попытке начать сеанс |

#### Примеры

```bash
vrunner cluster session lock \
  --ras localhost:1545 \
  --db-name MyInfobase \
  --cluster-admin ClusterAdmin \
  --cluster-pwd secret \
  --uccode MySecretCode \
  --denied-message "База закрыта на обслуживание"
```

### session unlock

Снимает блокировку начала сеансов.

```bash
vrunner cluster session unlock [опции]
```

#### Примеры

```bash
vrunner cluster session unlock --ras localhost:1545 --db-name MyInfobase --cluster-admin ClusterAdmin --cluster-pwd secret
```

### session list

Выводит в stdout сеансы ИБ: номер, приложение, пользователь, компьютер, время начала и последней активности.

```bash
vrunner cluster session list [опции]
```

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--connections` | - | Дополнительно вывести соединения ИБ (номер, приложение, компьютер, номер сеанса, время установки) - в том числе соединения без сеанса |

#### Примеры

```bash
# Все сеансы базы
vrunner cluster session list --db-name MyInfobase

# Только фоновые задания
vrunner cluster session list --db-name MyInfobase --filter-app BackgroundJob

# Сеансы вместе с соединениями
vrunner cluster session list --db-name MyInfobase --connections
```

### session kill

Завершает сеансы ИБ, предварительно блокируя начало новых (отключается `--no-lock`). После каждой попытки команда выдерживает паузу 3 секунды, перечитывает список и завершает оставшиеся сеансы повторно. Если по исчерпании попыток или таймаута сеансы остались - код возврата 1.

```bash
vrunner cluster session kill [опции]
```

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--no-lock` | - | Не блокировать новые сеансы перед завершением |
| `--retry` | - | Количество попыток завершения (по умолчанию 3); игнорируется при `--timeout` |
| `--timeout` | - | Максимальное время завершения, сек: попытки повторяются до успеха или таймаута |

#### Примеры

```bash
# Завершить все сеансы
vrunner cluster session kill --ras localhost:1545 --db-name MyInfobase --cluster-admin ClusterAdmin --cluster-pwd secret

# Только сеансы Конфигуратора и указанных пользователей
vrunner cluster session kill --db-name MyInfobase --filter-app Designer --filter-name "регламент;администратор"

# Все сеансы, кроме фоновых заданий
vrunner cluster session kill --db-name MyInfobase --filter-app BackgroundJob --filter-except

# Завершать зависшие сеансы до 2 минут вместо 3 попыток
vrunner cluster session kill --db-name MyInfobase --timeout 120
```

### session closed

Проверяет отсутствие сеансов ИБ, а с `--timeout` - дожидается их завершения. Если сеансы остались, выводит их и завершается с кодом возврата 1 - удобно как шаг пайплайна перед обновлением.

```bash
vrunner cluster session closed [опции]
```

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--timeout` | - | Время ожидания, сек: проверка повторяется каждые 3 секунды. По умолчанию `0` - одна проверка |

#### Примеры

```bash
# Убедиться, что сеансов нет
vrunner cluster session closed --db-name MyInfobase

# Дождаться (до 5 минут), пока фоновые задания завершатся сами
vrunner cluster session closed --db-name MyInfobase --filter-app BackgroundJob --timeout 300
```

## jobs

Управление регламентными заданиями информационной базы.

```bash
vrunner cluster jobs <lock | unlock> [опции]
```

> Общие опции: [кластер серверов](./common-options#кластер-серверов), [платформа](./common-options#платформа), [файл настроек](./common-options#файл-настроек).

### jobs lock

Блокирует выполнение регламентных заданий.

```bash
vrunner cluster jobs lock [опции]
```

### jobs unlock

Снимает блокировку регламентных заданий.

```bash
vrunner cluster jobs unlock [опции]
```

## Типичный сценарий: обновление под нагрузкой

```bash
# 1. Заблокировать новые сеансы и регламентные задания
vrunner cluster session lock --ras localhost:1545 --db-name MyIB --cluster-admin admin --cluster-pwd pwd --uccode UPDATE2026
vrunner cluster jobs lock --ras localhost:1545 --db-name MyIB --cluster-admin admin --cluster-pwd pwd

# 2. Дождаться (до 10 минут), пока запущенные фоновые задания доработают
vrunner cluster session closed --ras localhost:1545 --db-name MyIB --cluster-admin admin --cluster-pwd pwd --filter-app BackgroundJob --timeout 600

# 3. Завершить оставшиеся сеансы (зависшие добиваются до 2 минут)
vrunner cluster session kill --ras localhost:1545 --db-name MyIB --cluster-admin admin --cluster-pwd pwd --timeout 120

# 4. ... обновление ИБ ...

# 5. Разблокировать задания и сеансы
vrunner cluster jobs unlock --ras localhost:1545 --db-name MyIB --cluster-admin admin --cluster-pwd pwd
vrunner cluster session unlock --ras localhost:1545 --db-name MyIB --cluster-admin admin --cluster-pwd pwd
```
