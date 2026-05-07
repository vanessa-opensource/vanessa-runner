---
title: infobase
---

# infobase - Управление информационными базами

Группа команд `infobase` обеспечивает создание, обновление и управление информационными базами 1С: инициализацию, обновление конфигурации БД, выгрузку и восстановление резервных копий.

```bash
vrunner infobase <подкоманда> [аргументы] [опции]
```

## init

Создаёт информационную базу и опционально загружает в неё конфигурацию из указанного источника.

```bash
vrunner infobase init [опции]
```

### Опции

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--source` | `VRUNNER_SOURCE` | Источник конфигурации: каталог исходников, `.cf` или `.dt` файл |
| `--ibconnection` | `VRUNNER_IBCONNECTION` | Строка подключения. Если не указана - создаётся файловая ИБ в `build/ib` |
| `--db-user` | `VRUNNER_DBUSER` | Пользователь ИБ |
| `--db-pwd` | `VRUNNER_DBPWD` | Пароль пользователя ИБ |
| `--ibcmd` | - | Использовать `ibcmd` вместо Конфигуратора |
| `--v8version` | `VRUNNER_V8VERSION` | Версия платформы 1С |
| `--uccode` | `VRUNNER_UCCODE` | Код разрешения блокировки |
| `--language` | `VRUNNER_LANGUAGE` | Язык платформы |
| `--locale` | `VRUNNER_LOCALE` | Язык сеанса (локаль) |
| `--dbms-type` | `VRUNNER_DBMS_TYPE` | Тип СУБД: `MSSQLServer`, `PostgreSQL`, `IBMDB2`, `OracleDatabase`. Нужен при `--ibcmd` для серверной ИБ |
| `--dbms-server` | `VRUNNER_DBMS_SERVER` | Адрес сервера СУБД |
| `--dbms-base` | `VRUNNER_DBMS_BASE` | Имя базы данных СУБД |
| `--dbms-user` | `VRUNNER_DBMS_USER` | Пользователь СУБД |
| `--dbms-pwd` | `VRUNNER_DBMS_PWD` | Пароль СУБД |
| `--settings` | `VRUNNER_SETTINGS` | Путь к файлу настроек (JSON) |

> Подробнее о подключении, ibcmd и опциях СУБД: [Подключение к базе данных →](./common-options)

### Логика работы

1. Если `--ibconnection` не указан - создаётся файловая ИБ в `build/ib`
2. Если `--ibconnection /F...` - создаётся файловая ИБ по указанному пути
3. Если указана серверная строка подключения (`/S...`) - ИБ **должна уже существовать**
4. Загрузка конфигурации из `--source` (если задан)

### Примеры

```bash
# Создать пустую файловую ИБ
vrunner infobase init --ibconnection /FD:/bases/MyProject

# Создать ИБ и загрузить конфигурацию из CF-файла
vrunner infobase init \
  --source ./build/MyApp.cf \
  --ibconnection /F./tmp-ib \
  --ibcmd

# Создать ИБ и загрузить из исходников
vrunner infobase init \
  --source ./src \
  --ibconnection /F./tmp-ib

# Загрузить конфигурацию в существующую серверную ИБ через ibcmd
vrunner infobase init \
  --source ./build/MyApp.cf \
  --ibconnection "/SMyServer\MyIB" \
  --ibcmd \
  --dbms-type PostgreSQL \
  --dbms-server localhost \
  --dbms-base my_db \
  --dbms-user postgres \
  --dbms-pwd secret
```

## update

Обновляет конфигурацию БД информационной базы. Опционально загружает конфигурацию из нового источника перед обновлением.

```bash
vrunner infobase update [опции]
```

### Опции

| Опция | По умолчанию | Описание |
|-------|-------------|----------|
| `--source` | - | Источник конфигурации: каталог исходников или `.cf` файл |
| `--target` | - | Цель обновления: `main` - основная конфигурация; имя расширения - конкретное расширение; пусто - всё |
| `--rtype` | `v1` | Режим реструктуризации: `v1` (обычный), `v2` (оптимизированный) |
| `--increment` | - | Инкрементальная загрузка по индексу изменений |
| `--dynamic` | - | Разрешить динамическое обновление конфигурации |
| `--ibconnection` | `VRUNNER_IBCONNECTION` | Строка подключения к ИБ (`/F<путь>` - файловая, `/S<сервер>\<база>` - серверная) |
| `--db-user` | `VRUNNER_DBUSER` | Пользователь ИБ |
| `--db-pwd` | `VRUNNER_DBPWD` | Пароль пользователя ИБ |
| `--ibcmd` | - | Использовать `ibcmd` вместо Конфигуратора |
| `--v8version` | `VRUNNER_V8VERSION` | Версия платформы 1С |
| `--uccode` | `VRUNNER_UCCODE` | Код разрешения блокировки |
| `--language` | `VRUNNER_LANGUAGE` | Язык платформы |
| `--locale` | `VRUNNER_LOCALE` | Язык сеанса (локаль) |
| `--dbms-type` | `VRUNNER_DBMS_TYPE` | Тип СУБД: `MSSQLServer`, `PostgreSQL`, `IBMDB2`, `OracleDatabase`. Нужен при `--ibcmd` для серверной ИБ |
| `--dbms-server` | `VRUNNER_DBMS_SERVER` | Адрес сервера СУБД |
| `--dbms-base` | `VRUNNER_DBMS_BASE` | Имя базы данных СУБД |
| `--dbms-user` | `VRUNNER_DBMS_USER` | Пользователь СУБД |
| `--dbms-pwd` | `VRUNNER_DBMS_PWD` | Пароль СУБД |
| `--settings` | `VRUNNER_SETTINGS` | Путь к файлу настроек (JSON) |

> Подробнее о подключении, ibcmd и опциях СУБД: [Подключение к базе данных →](./common-options)

### Примеры

```bash
# Обновить конфигурацию БД (загрузить исходники уже в базе)
vrunner infobase update --ibconnection /F./ib

# Загрузить новую конфигурацию и обновить БД
vrunner infobase update \
  --source ./build/MyApp.cf \
  --ibconnection /F./ib \
  --rtype v2

# Обновить с динамическим обновлением
vrunner infobase update \
  --ibconnection /F./ib \
  --dynamic
```

## dump-dt

Выгружает информационную базу в файл резервной копии (`.dt`).

```bash
vrunner infobase dump-dt <OUT> [опции]
```

### Аргументы

| Аргумент | Описание |
|----------|----------|
| `OUT` | Путь к создаваемому DT-файлу (**обязательный**) |

### Опции

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--ibconnection` | `VRUNNER_IBCONNECTION` | Строка подключения к ИБ (`/F<путь>` - файловая, `/S<сервер>\<база>` - серверная) |
| `--db-user` | `VRUNNER_DBUSER` | Пользователь ИБ |
| `--db-pwd` | `VRUNNER_DBPWD` | Пароль пользователя ИБ |
| `--ibcmd` | - | Использовать `ibcmd` вместо Конфигуратора |
| `--v8version` | `VRUNNER_V8VERSION` | Версия платформы 1С |
| `--uccode` | `VRUNNER_UCCODE` | Код разрешения блокировки |
| `--language` | `VRUNNER_LANGUAGE` | Язык платформы |
| `--locale` | `VRUNNER_LOCALE` | Язык сеанса (локаль) |
| `--dbms-type` | `VRUNNER_DBMS_TYPE` | Тип СУБД: `MSSQLServer`, `PostgreSQL`, `IBMDB2`, `OracleDatabase`. Нужен при `--ibcmd` для серверной ИБ |
| `--dbms-server` | `VRUNNER_DBMS_SERVER` | Адрес сервера СУБД |
| `--dbms-base` | `VRUNNER_DBMS_BASE` | Имя базы данных СУБД |
| `--dbms-user` | `VRUNNER_DBMS_USER` | Пользователь СУБД |
| `--dbms-pwd` | `VRUNNER_DBMS_PWD` | Пароль СУБД |
| `--settings` | `VRUNNER_SETTINGS` | Путь к файлу настроек (JSON) |

> Подробнее о подключении, ibcmd и опциях СУБД: [Подключение к базе данных →](./common-options)

### Примеры

```bash
vrunner infobase dump-dt ./backup/MyProject_2026-04.dt \
  --ibconnection /F./ib \
  --v8version 8.3.24
```

## restore-dt

Восстанавливает информационную базу из файла резервной копии (`.dt`).

```bash
vrunner infobase restore-dt <SRC> [опции]
```

### Аргументы

| Аргумент | Описание |
|----------|----------|
| `SRC` | Путь к DT-файлу для восстановления (**обязательный**) |

### Опции

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--ibconnection` | `VRUNNER_IBCONNECTION` | Строка подключения к ИБ (`/F<путь>` - файловая, `/S<сервер>\<база>` - серверная) |
| `--db-user` | `VRUNNER_DBUSER` | Пользователь ИБ |
| `--db-pwd` | `VRUNNER_DBPWD` | Пароль пользователя ИБ |
| `--ibcmd` | - | Использовать `ibcmd` вместо Конфигуратора |
| `--v8version` | `VRUNNER_V8VERSION` | Версия платформы 1С |
| `--uccode` | `VRUNNER_UCCODE` | Код разрешения блокировки |
| `--language` | `VRUNNER_LANGUAGE` | Язык платформы |
| `--locale` | `VRUNNER_LOCALE` | Язык сеанса (локаль) |
| `--dbms-type` | `VRUNNER_DBMS_TYPE` | Тип СУБД: `MSSQLServer`, `PostgreSQL`, `IBMDB2`, `OracleDatabase`. Нужен при `--ibcmd` для серверной ИБ |
| `--dbms-server` | `VRUNNER_DBMS_SERVER` | Адрес сервера СУБД |
| `--dbms-base` | `VRUNNER_DBMS_BASE` | Имя базы данных СУБД |
| `--dbms-user` | `VRUNNER_DBMS_USER` | Пользователь СУБД |
| `--dbms-pwd` | `VRUNNER_DBMS_PWD` | Пароль СУБД |
| `--settings` | `VRUNNER_SETTINGS` | Путь к файлу настроек (JSON) |

> Подробнее о подключении, ibcmd и опциях СУБД: [Подключение к базе данных →](./common-options)

### Примеры

```bash
vrunner infobase restore-dt ./backup/MyProject_2026-04.dt \
  --ibconnection /F./ib
```
