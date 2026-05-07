---
title: repo — хранилище конфигурации
---

# repo - Работа с хранилищем конфигурации

Группа команд `repo` обеспечивает работу с хранилищем конфигурации 1С: подключение, загрузку изменений, управление пользователями, фиксацию изменений, блокировку и разблокировку.

```bash
vrunner repo <подкоманда> [аргументы] [опции]
```

## Подключение и платформа

Большинство подкоманд `repo` работают с информационной базой и хранилищем. Строка подключения и опции СУБД описаны на странице [Подключение к базе данных](./common-options).

## create

Создаёт новое хранилище конфигурации 1С.

```bash
vrunner repo create [опции]
```

### Примеры

```bash
vrunner repo create \
  --storage-name D:/repos/MyProject \
  --storage-user Администратор \
  --storage-pwd secret \
  --ibconnection /F./ib
```

## bind

Подключает информационную базу к хранилищу конфигурации.

```bash
vrunner repo bind [опции]
```

### Опции

| Опция | Описание |
|-------|----------|
| `--ignore-already-bound` | Не считать ошибкой, если ИБ уже подключена к хранилищу |
| `--do-not-replace-cfg` | - | Не заменять конфигурацию БД конфигурацией хранилища |
| `--ibconnection` | `VRUNNER_IBCONNECTION` | Строка подключения к ИБ (`/F<путь>` - файловая, `/S<сервер>\<база>` - серверная) |
| `--db-user` | `VRUNNER_DBUSER` | Пользователь ИБ |
| `--db-pwd` | `VRUNNER_DBPWD` | Пароль пользователя ИБ |
| `--ibcmd` | - | Использовать `ibcmd` вместо Конфигуратора |
| `--v8version` | `VRUNNER_V8VERSION` | Версия платформы 1С |
| `--uccode` | `VRUNNER_UCCODE` | Код разрешения блокировки |
| `--language` | `VRUNNER_LANGUAGE` | Язык платформы |
| `--locale` | `VRUNNER_LOCALE` | Язык сеанса (локаль) |
| `--storage-name` | `VRUNNER_STORAGE_NAME` | Адрес хранилища конфигурации |
| `--storage-user` | `VRUNNER_STORAGE_USER` | Пользователь хранилища |
| `--storage-pwd` | `VRUNNER_STORAGE_PWD` | Пароль хранилища |
| `--storage-ver` | `VRUNNER_STORAGE_VER` | Версия хранилища |
| `--settings` | `VRUNNER_SETTINGS` | Путь к файлу настроек (JSON) |

> [Подключение к базе данных →](./common-options)

### Примеры

```bash
vrunner repo bind \
  --storage-name D:/repos/MyProject \
  --storage-user DevUser \
  --storage-pwd secret \
  --ibconnection /F./ib \
  --ignore-already-bound
```

## unbind

Отключает информационную базу от хранилища конфигурации.

```bash
vrunner repo unbind [опции]
```

### Примеры

```bash
vrunner repo unbind \
  --ibconnection /F./ib \
  --storage-user DevUser \
  --storage-pwd secret
```

## load

Обновляет конфигурацию информационной базы из хранилища (загружает последнюю версию).

```bash
vrunner repo load [опции]
```

### Примеры

```bash
vrunner repo load \
  --ibconnection /F./ib \
  --storage-name D:/repos/MyProject \
  --storage-user DevUser \
  --storage-pwd secret \
  --storage-ver 42
```

## commit

Помещает изменения в хранилище конфигурации (фиксирует захваченные объекты).

```bash
vrunner repo commit [опции]
```

### Опции

| Опция | Описание |
|-------|----------|
| `--objects` | Путь к XML-файлу со списком объектов для помещения |
| `--comment` | Комментарий к фиксируемым объектам |
| `--keep-locked` | Оставить объекты захваченными после помещения |
| `--force` | - | Игнорировать удалённые объекты |
| `--ibconnection` | `VRUNNER_IBCONNECTION` | Строка подключения к ИБ |
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
| `--storage-name` | `VRUNNER_STORAGE_NAME` | Адрес хранилища |
| `--storage-user` | `VRUNNER_STORAGE_USER` | Пользователь хранилища |
| `--storage-pwd` | `VRUNNER_STORAGE_PWD` | Пароль хранилища |
| `--storage-ver` | `VRUNNER_STORAGE_VER` | Версия хранилища |
| `--settings` | `VRUNNER_SETTINGS` | Путь к файлу настроек (JSON) |

> [Подключение к базе данных →](./common-options)

### Примеры

```bash
vrunner repo commit \
  --ibconnection /F./ib \
  --storage-name D:/repos/MyProject \
  --storage-user DevUser \
  --storage-pwd secret \
  --comment "Задача #123: добавлены новые справочники"
```

## save-cf

Сохраняет конфигурацию из хранилища в CF-файл.

```bash
vrunner repo save-cf [OUT] [опции]
```

### Аргументы

| Аргумент | Описание |
|----------|----------|
| `OUT` | Путь к создаваемому CF-файлу |

### Примеры

```bash
vrunner repo save-cf ./build/MyApp.cf \
  --storage-name D:/repos/MyProject \
  --storage-user DevUser \
  --storage-pwd secret \
  --storage-ver 100
```

## create-user

Создаёт пользователя в хранилище конфигурации.

```bash
vrunner repo create-user [опции]
```

## copy-user

Копирует права пользователя хранилища от одного пользователя к другому.

```bash
vrunner repo copy-user [опции]
```

## lock

Устанавливает блокировку объектов хранилища для захвата.

```bash
vrunner repo lock [опции]
```

## unlock

Снимает захват объектов хранилища.

```bash
vrunner repo unlock [опции]
```
