---
title: cluster
---

# cluster - Управление кластером серверов

Команды `cluster` управляют информационной базой в кластере серверов 1С через RAS напрямую (`rac` и платформа не нужны): создание и удаление ИБ, сведения о ней, сеансы, регламентные задания и рабочие процессы.

```bash
vrunner cluster <подкоманда> [опции]
```

Все команды принимают общие опции кластера: `--ras` (по умолчанию `localhost:1545`), `--db-name` (не нужна `process turn-off`), `--cluster` или `--cluster-name` (без них берётся первый кластер в списке), `--cluster-admin`/`--cluster-pwd`, а также, кроме `create` и `process turn-off`, `--db-user`/`--db-pwd` администратора ИБ - см. [Кластер серверов](./common-options#кластер-серверов). Опция `--rac` устарела и игнорируется.

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

> Общие опции: [кластер серверов](./common-options#кластер-серверов), [СУБД](./common-options#опции-субд), [файл настроек](./common-options#файл-настроек).

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

> Общие опции: [кластер серверов](./common-options#кластер-серверов), [файл настроек](./common-options#файл-настроек).

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

> Общие опции: [кластер серверов](./common-options#кластер-серверов), [файл настроек](./common-options#файл-настроек).

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
| `--filter-except` | - | Инвертировать отбор: все сеансы, **кроме** подходящих под `--filter-app`/`--filter-name`; без них - ошибка |

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
| `--connections` | - | Дополнительно вывести соединения ИБ (номер, приложение, компьютер, номер сеанса, время установки) - в том числе соединения без сеанса; отбор `--filter-*` к ним не применяется |

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

Завершает сеансы ИБ, предварительно блокируя начало новых (отключается `--no-lock`). Блокировка ставится на всю ИБ независимо от `--filter-*` и после завершения не снимается - снимите её командой [`session unlock`](#session-unlock). После каждой попытки команда до 3 секунд ждёт исчезновения сеансов и завершает оставшиеся повторно. Если по исчерпании попыток или таймаута сеансы остались - код возврата 1.

Без `--filter-*` команда также разрывает соединения ИБ без сеанса - их оставляют запущенные клиенты, чьи сеансы завершены. Не разрывается только соединение серверного вызова, зависшего в нативном коде (например, в ожидании внешнего процесса): оно не даёт установить монопольный режим, а снимает его только выключение рабочего процесса. Команда ждёт такие соединения в пределах `--retry`/`--timeout`, а если они остались, завершается с кодом 1 и называет каждое: номер, приложение, компьютер и pid рабочего процесса. Дальше - `--allow-rphost-restart` или [`process turn-off`](#process-turn-off). Для разрыва соединений в ИБ с пользователями укажите `--db-user`/`--db-pwd` администратора ИБ: если разрыв не удался, команда называет ошибку и рабочий процесс не выключает.

```bash
vrunner cluster session kill [опции]
```

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--no-lock` | - | Не блокировать новые сеансы перед завершением |
| `--retry` | - | Количество попыток завершения (по умолчанию 3); игнорируется при `--timeout` |
| `--timeout` | - | Максимальное время завершения, сек: попытки повторяются до успеха или таймаута |
| `--allow-rphost-restart` | - | Если остались только неразрывающиеся соединения без сеанса - выключить их рабочие процессы, дождаться остановки (до `expiration-timeout` кластера плюс 30-45 с, `--timeout` на это ожидание не влияет) и завершить появившиеся сеансы. При `expiration-timeout` = 0 - сразу ошибка. Не действует с `--filter-*` |

::: warning
`--allow-rphost-restart` выключает рабочие процессы целиком - с сеансами всех их ИБ. Подробнее - в [`process turn-off`](#process-turn-off).
:::

#### Примеры

```bash
# Завершить все сеансы
vrunner cluster session kill --ras localhost:1545 --db-name MyInfobase --cluster-admin ClusterAdmin --cluster-pwd secret

# Только сеансы Конфигуратора и указанных пользователей (новые сеансы блокируются во всей ИБ)
vrunner cluster session kill --db-name MyInfobase --filter-app Designer --filter-name "регламент;администратор"

# Все сеансы, кроме фоновых заданий
vrunner cluster session kill --db-name MyInfobase --filter-app BackgroundJob --filter-except

# Завершать зависшие сеансы до 2 минут вместо 3 попыток
vrunner cluster session kill --db-name MyInfobase --timeout 120

# Если серверный вызов завис - перезапустить его рабочий процесс
vrunner cluster session kill --db-name MyInfobase --allow-rphost-restart
```

### session closed

Проверяет отсутствие сеансов ИБ, а с `--timeout` - дожидается их завершения. Если сеансы остались, выводит их и завершается с кодом возврата 1 - удобно как шаг пайплайна перед обновлением. Проверяются только сеансы; соединения без сеанса показывает [`session list --connections`](#session-list).

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

> Общие опции: [кластер серверов](./common-options#кластер-серверов), [файл настроек](./common-options#файл-настроек).

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

## process

Управление рабочими процессами кластера.

```bash
vrunner cluster process turn-off [опции]
```

> Общие опции: [кластер серверов](./common-options#кластер-серверов), [файл настроек](./common-options#файл-настроек).

### process turn-off

Выключает рабочий процесс (rphost) кластера, как «Выключить» в консоли кластера и `rac process turn-off`. Команда не ждёт остановки: сообщает, через сколько секунд её выполнит кластер. Pid рабочего процесса с зависшим вызовом выводит [`session kill`](#session-kill).

::: warning Затрагивает все ИБ рабочего процесса
Выключение рабочего процесса (rphost) затрагивает все информационные базы и сеансы, которые он обслуживает, а не только указанную ИБ. Новые соединения кластер отдаёт другим процессам, а выключенный останавливает по истечении периода принудительного завершения кластера (`expiration-timeout`, в консоли кластера - «Выключенные процессы останавливать через»): оставшиеся соединения рвутся, незаписанные данные и незавершённые транзакции теряются. При `expiration-timeout` = 0 процесс не остановится, пока не вернутся все его вызовы. Нужен сервер 1С 8.3.27 и новее.
:::

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--pid` | - | PID рабочего процесса; если такой PID есть на нескольких серверах - UUID процесса. Обязательна |

#### Примеры

```bash
# Выключить рабочий процесс по PID
vrunner cluster process turn-off --ras localhost:1545 --cluster-admin ClusterAdmin --cluster-pwd secret --pid 4242

# PID совпал на двух серверах - указать UUID процесса из сообщения об ошибке
vrunner cluster process turn-off --pid 5f95e186-d5a0-495e-8118-50dff0232940
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
