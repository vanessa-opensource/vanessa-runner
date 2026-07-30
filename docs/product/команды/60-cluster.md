---
title: cluster
---

# cluster - Управление кластером серверов

Группа команд `cluster` обеспечивает управление кластером серверов 1С через утилиты `rac`/`ras`: получение информации, создание и удаление кластера, управление сеансами и фоновыми заданиями.

```bash
vrunner cluster <подкоманда> [опции]
```

## Подключение и администрирование

Все подкоманды `cluster` управляют кластером через утилиту `rac`/`ras`. Подробнее о строке подключения: [Подключение к базе данных](./common-options).

**Опции, доступные всем подкомандам:**

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--ras` | `VRUNNER_RAS` | Сетевой адрес RAS (по умолчанию `localhost:1545`) |
| `--rac` | `VRUNNER_RAC` | Путь к утилите `rac` |
| `--db-name` | `VRUNNER_IBNAME` | Имя информационной базы в кластере |
| `--cluster` | - | Идентификатор кластера |
| `--cluster-name` | - | Имя кластера |
| `--cluster-admin` | `VRUNNER_CLUSTERADMIN_USER` | Имя администратора кластера |
| `--cluster-pwd` | `VRUNNER_CLUSTERADMIN_PWD` | Пароль администратора кластера |
| `--ibconnection` | `VRUNNER_IBCONNECTION` | Строка подключения к ИБ (для идентификации базы в кластере) |
| `--db-user` | `VRUNNER_DBUSER` | Пользователь ИБ |
| `--db-pwd` | `VRUNNER_DBPWD` | Пароль пользователя ИБ |
| `--v8version` | `VRUNNER_V8VERSION` | Версия платформы 1С |
| `--settings` | `VRUNNER_SETTINGS` | Путь к файлу настроек (JSON) |

::: tip
`cluster create` дополнительно использует опции СУБД (`--dbms-type`, `--dbms-server`, `--dbms-base`, `--dbms-user`, `--dbms-pwd`).
:::

## info

Выводит информацию об информационной базе в кластере.

```bash
vrunner cluster info [опции]
```

### Примеры

```bash
vrunner cluster info \
  --ras localhost:1545 \
  --db-name MyInfobase \
  --cluster-admin ClusterAdmin \
  --cluster-pwd secret
```

## create

Создаёт новый кластер серверов 1С.

```bash
vrunner cluster create [опции]
```

## remove

Удаляет кластер серверов 1С.

```bash
vrunner cluster remove [опции]
```

## session

Группа подкоманд для управления сеансами информационной базы.

```bash
vrunner cluster session <подкоманда> [опции]
```

### session lock

Блокирует новые сеансы для информационной базы.

```bash
vrunner cluster session lock [опции]
```

#### Опции

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--uccode` | `VRUNNER_UCCODE` | Код допуска к заблокированной ИБ |
| `--denied-message` | - | Сообщение, отображаемое при попытке начать сеанс |
| `--ras` | `VRUNNER_RAS` | Сетевой адрес RAS (по умолчанию `localhost:1545`) |
| `--rac` | `VRUNNER_RAC` | Путь к утилите `rac` |
| `--db-name` | `VRUNNER_IBNAME` | Имя ИБ в кластере |
| `--cluster` | - | Идентификатор кластера |
| `--cluster-name` | - | Имя кластера |
| `--cluster-admin` | `VRUNNER_CLUSTERADMIN_USER` | Имя администратора кластера |
| `--cluster-pwd` | `VRUNNER_CLUSTERADMIN_PWD` | Пароль администратора кластера |
| `--settings` | `VRUNNER_SETTINGS` | Путь к файлу настроек (JSON) |

#### Примеры

```bash
vrunner cluster session lock \
  --ras localhost:1545 \
  --db-name MyInfobase \
  --cluster-admin ClusterAdmin \
  --cluster-pwd secret \
  --uccode MySecretCode \
  --denied-message "База закрыта на обслуживание. Используйте код: MySecretCode"
```

### session unlock

Снимает блокировку новых сеансов для информационной базы.

```bash
vrunner cluster session unlock [опции]
```

#### Примеры

```bash
vrunner cluster session unlock \
  --ras localhost:1545 \
  --db-name MyInfobase \
  --cluster-admin ClusterAdmin \
  --cluster-pwd secret
```

### session kill

Принудительно завершает активные сеансы информационной базы. Перед завершением блокирует начало новых сеансов (отключается опцией `--no-lock`).

Завершение проверяется: `rac` завершает сеансы асинхронно, а зависшие сеансы могут не завершиться с первой попытки, поэтому после каждой попытки команда выдерживает паузу (3 секунды), перечитывает список и добивает оставшиеся сеансы повторно. Если после исчерпания лимита попыток сеансы остались — команда печатает их и завершается с кодом возврата 1.

```bash
vrunner cluster session kill [опции]
```

#### Опции

| Опция | Описание |
|-------|----------|
| `--no-lock` | Не блокировать новые сеансы перед завершением |
| `--retry` | Количество попыток завершения (по умолчанию 3). Не используется при заданном `--timeout` |
| `--timeout` | Максимальное время завершения, сек: попытки повторяются до успеха или таймаута, `--retry` игнорируется |
| `--filter-app` | Отбор по приложению сеанса. Можно указывать несколько раз или списком через `;` |
| `--filter-name` | Отбор по имени пользователя ИБ. Можно указывать несколько раз или списком через `;` |
| `--filter-except` | Инвертировать отбор: завершать все сеансы, **кроме** подходящих под `--filter-app`/`--filter-name` |

Условия объединяются по ИЛИ: сеанс попадает под отбор, если совпало приложение **или** пользователь. Сравнение регистронезависимое, без масок.

Допустимые значения `--filter-app` (проверяются при запуске): `Designer` (конфигуратор), `1CV8` (толстый клиент), `1CV8C` (тонкий клиент), `WebClient`, `WSConnection` (веб-сервис), `HTTPServiceConnection`, `COMConnection`, `WebServerExtension`, `BackgroundJob` (фоновое задание), `JobScheduler`, `SrvrConsole`, `RAS`, `AgentStandardCall`.

#### Примеры

```bash
# Завершить все сеансы
vrunner cluster session kill \
  --ras localhost:1545 \
  --db-name MyInfobase \
  --cluster-admin ClusterAdmin \
  --cluster-pwd secret

# Завершить только сеансы Конфигуратора и регламентных пользователей
vrunner cluster session kill \
  --db-name MyInfobase \
  --filter-app Designer \
  --filter-name "регламент;администратор"

# Завершить все сеансы, кроме фоновых заданий
vrunner cluster session kill \
  --db-name MyInfobase \
  --filter-app BackgroundJob \
  --filter-except

# Добивать зависшие сеансы до 2 минут (вместо 3 попыток)
vrunner cluster session kill \
  --db-name MyInfobase \
  --timeout 120
```

### session closed

Проверяет отсутствие активных сеансов информационной базы, а с опцией `--timeout` — дожидается их завершения. Если по итогам сеансы остались, печатает их список и завершается с ненулевым кодом возврата — удобно как шаг пайплайна: после `session lock` дождаться завершения фоновых заданий перед обновлением.

```bash
vrunner cluster session closed [опции]
```

#### Опции

| Опция | Описание |
|-------|----------|
| `--timeout` | Время ожидания завершения сеансов, сек: проверка повторяется каждые 3 секунды. По умолчанию `0` — одна проверка без ожидания |
| `--filter-app` / `--filter-name` / `--filter-except` | Отбор сеансов — те же опции, что у `session kill` |

#### Примеры

```bash
# Убедиться, что сеансов нет (код возврата 1, если есть)
vrunner cluster session closed --db-name MyInfobase

# Дождаться (до 5 минут), пока фоновые задания сами завершатся
vrunner cluster session closed \
  --db-name MyInfobase \
  --filter-app BackgroundJob \
  --timeout 300
```

### session list

Выводит список сеансов информационной базы с детализацией: номер сеанса, приложение, пользователь, компьютер, время начала и последней активности. Поддерживает те же опции отбора, что и `kill`/`closed`.

```bash
vrunner cluster session list [опции]
```

#### Опции

| Опция | Описание |
|-------|----------|
| `--connections` | Дополнительно вывести соединения ИБ (номер, приложение, компьютер, номер сеанса, время установки) — в том числе зависшие соединения без сеанса |
| `--filter-app` / `--filter-name` / `--filter-except` | Отбор сеансов — те же опции, что у `session kill` |

#### Примеры

```bash
# Все сеансы базы
vrunner cluster session list --db-name MyInfobase

# Только фоновые задания
vrunner cluster session list --db-name MyInfobase --filter-app BackgroundJob

# Сеансы вместе с соединениями (диагностика зависших)
vrunner cluster session list --db-name MyInfobase --connections
```

## jobs

Группа подкоманд для управления фоновыми заданиями информационной базы.

```bash
vrunner cluster jobs <подкоманда> [опции]
```

### jobs lock

Блокирует выполнение фоновых заданий для информационной базы.

```bash
vrunner cluster jobs lock [опции]
```

### jobs unlock

Снимает блокировку фоновых заданий для информационной базы.

```bash
vrunner cluster jobs unlock [опции]
```

## Типичный сценарий: обновление под нагрузкой

```bash
# 1. Заблокировать новые сеансы
vrunner cluster session lock \
  --ras localhost \
  --db-name MyIB \
  --cluster-admin admin \
  --cluster-pwd pwd \
  --uccode UPDATE2026

# 2. Заблокировать фоновые задания
vrunner cluster jobs lock \
  --ras localhost \
  --db-name MyIB \
  --cluster-admin admin \
  --cluster-pwd pwd

# 3. Дождаться (до 10 минут), пока запущенные фоновые задания сами доработают
vrunner cluster session closed \
  --ras localhost \
  --db-name MyIB \
  --cluster-admin admin \
  --cluster-pwd pwd \
  --filter-app BackgroundJob \
  --timeout 600

# 4. Завершить оставшиеся сеансы (зависшие добиваются ретраями до 2 минут)
vrunner cluster session kill \
  --ras localhost \
  --db-name MyIB \
  --cluster-admin admin \
  --cluster-pwd pwd \
  --timeout 120

# 5. ... обновление ИБ ...

# 6. Разблокировать задания и сеансы
vrunner cluster jobs unlock ...
vrunner cluster session unlock ...
```
