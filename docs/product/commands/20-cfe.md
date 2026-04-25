# cfe — Операции с расширениями

Группа команд `cfe` обеспечивает работу с расширениями конфигурации 1С (`.cfe`): сборку из XML-исходников, разборку, загрузку в базу, выгрузку и сравнение.

```bash
vrunner cfe <подкоманда> [аргументы] [опции]
```

## compile

Собирает расширение из XML-исходников в файл `.cfe`.

```bash
vrunner cfe compile <OUT> [опции]
```

### Аргументы

| Аргумент | Описание |
|----------|----------|
| `OUT` | Путь к создаваемому файлу расширения (`.cfe`) (**обязательный**) |

### Опции

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--s`, `--src` | `VRUNNER_SRC` | Каталог XML-исходников расширения (по умолчанию — текущий каталог) |
| `--extension-name` | `VRUNNER_EXTENSION_NAME` | Имя расширения (**обязательный**) |
| `--ibconnection` | `VRUNNER_IBCONNECTION` | Строка подключения к ИБ. Если не указана — автоматически создаётся временная ИБ |
| `--db-user` | `VRUNNER_DBUSER` | Пользователь информационной базы |
| `--db-pwd` | `VRUNNER_DBPWD` | Пароль пользователя ИБ |
| `--ibcmd` | — | Использовать утилиту `ibcmd` вместо Конфигуратора |
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

> Подробнее о форматах строки подключения, ibcmd и опциях СУБД: [Подключение к базе данных →](./05-common-options)

### Примеры

```bash
vrunner cfe compile ./build/MyExtension.cfe \
  --s ./extensions/MyExtension/src \
  --extension-name MyExtension \
  --ibcmd
```

## decompile

Разбирает файл расширения `.cfe` в XML-исходники.

```bash
vrunner cfe decompile <OUT> [опции]
```

### Аргументы

| Аргумент | Описание |
|----------|----------|
| `OUT` | Каталог для выгрузки XML-исходников расширения (**обязательный**) |

### Опции

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--cfe-file` | `VRUNNER_CFE_FILE` | Путь к CFE-файлу для разборки (**обязательный**) |
| `--extension-name` | `VRUNNER_EXTENSION_NAME` | Имя расширения (**обязательный**) |
| `--ibconnection` | `VRUNNER_IBCONNECTION` | Строка подключения к ИБ. Если не указана — автоматически создаётся временная ИБ |
| `--db-user` | `VRUNNER_DBUSER` | Пользователь информационной базы |
| `--db-pwd` | `VRUNNER_DBPWD` | Пароль пользователя ИБ |
| `--ibcmd` | — | Использовать утилиту `ibcmd` вместо Конфигуратора |
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

> Подробнее о форматах строки подключения, ibcmd и опциях СУБД: [Подключение к базе данных →](./05-common-options)

### Примеры

```bash
vrunner cfe decompile ./extensions/MyExtension/src \
  --cfe-file ./build/MyExtension.cfe \
  --extension-name MyExtension \
  --ibcmd
```

## load

Загружает расширение в информационную базу из XML-исходников или CFE-файла.

```bash
vrunner cfe load <SRC> [опции]
```

### Аргументы

| Аргумент | Описание |
|----------|----------|
| `SRC` | Каталог XML-исходников или путь к CFE-файлу |

### Опции

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--extension-name` | `VRUNNER_EXTENSION_NAME` | Имя расширения в базе (по умолчанию берётся из имени каталога/файла) |
| `--safe-mode` | — | Включить безопасный режим |
| `--active` | — | Активность расширения (только ibcmd) |
| `--unsafe-action-protection` | — | Включить защиту от опасных действий |
| `--used-in-rib` | — | Используется в РИБ (только ibcmd) |
| `--scope-infobase` | — | Область действия — ИБ (только ibcmd) |
| `--ibconnection` | `VRUNNER_IBCONNECTION` | Строка подключения к ИБ (`/F<путь>` — файловая, `/S<сервер>\<база>` — серверная) |
| `--db-user` | `VRUNNER_DBUSER` | Пользователь информационной базы |
| `--db-pwd` | `VRUNNER_DBPWD` | Пароль пользователя ИБ |
| `--ibcmd` | — | Использовать утилиту `ibcmd` вместо Конфигуратора |
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

> Подробнее о форматах строки подключения, ibcmd и опциях СУБД: [Подключение к базе данных →](./05-common-options)

### Примеры

```bash
# Загрузить расширение из исходников через ibcmd
vrunner cfe load ./extensions/MyExtension/src \
  --extension-name MyExtension \
  --ibcmd \
  --ibconnection /F./ib

# Загрузить с включённым безопасным режимом
vrunner cfe load ./MyExtension.cfe \
  --extension-name MyExtension \
  --safe-mode \
  --ibconnection /F./ib
```

## unload

Выгружает расширение из информационной базы в CFE-файл.

```bash
vrunner cfe unload <OUT> [опции]
```

### Аргументы

| Аргумент | Описание |
|----------|----------|
| `OUT` | Путь к создаваемому CFE-файлу (**обязательный**) |

### Опции

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--extension-name` | `VRUNNER_EXTENSION_NAME` | Имя расширения в базе (**обязательный**) |
| `--ibconnection` | `VRUNNER_IBCONNECTION` | Строка подключения к ИБ (`/F<путь>` — файловая, `/S<сервер>\<база>` — серверная) |
| `--db-user` | `VRUNNER_DBUSER` | Пользователь информационной базы |
| `--db-pwd` | `VRUNNER_DBPWD` | Пароль пользователя ИБ |
| `--ibcmd` | — | Использовать утилиту `ibcmd` вместо Конфигуратора |
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

> Подробнее о форматах строки подключения, ibcmd и опциях СУБД: [Подключение к базе данных →](./05-common-options)

### Примеры

```bash
vrunner cfe unload ./backup/MyExtension.cfe \
  --extension-name MyExtension \
  --ibconnection /F./ib
```

## compare

Сравнивает два CFE-файла или CFE-файл с расширением в базе.

```bash
vrunner cfe compare [опции]
```

### Опции

| Опция | По умолчанию | Переменная окружения | Описание |
|-------|-------------|---------------------|----------|
| `--second-cfe` | — | — | Путь ко второму CFE-файлу (**обязательный**) |
| `--first-cfe` | — | — | Путь к первому CFE-файлу; если не задан — сравнивается с расширением в базе |
| `--extension-name` | — | — | Имя расширения |
| `--report-dir` | `.` | — | Каталог для отчёта |
| `--ibconnection` | — | `VRUNNER_IBCONNECTION` | Строка подключения к ИБ. Нужна, если сравниваем с расширением в базе |
| `--db-user` | — | `VRUNNER_DBUSER` | Пользователь информационной базы |
| `--db-pwd` | — | `VRUNNER_DBPWD` | Пароль пользователя ИБ |
| `--ibcmd` | — | — | Использовать утилиту `ibcmd` вместо Конфигуратора |
| `--v8version` | — | `VRUNNER_V8VERSION` | Версия платформы 1С |
| `--uccode` | — | `VRUNNER_UCCODE` | Код разрешения блокировки |
| `--language` | — | `VRUNNER_LANGUAGE` | Язык платформы |
| `--locale` | — | `VRUNNER_LOCALE` | Язык сеанса (локаль) |
| `--settings` | — | `VRUNNER_SETTINGS` | Путь к файлу настроек (JSON) |

> Подробнее о форматах строки подключения и ibcmd: [Подключение к базе данных →](./05-common-options)

### Примеры

```bash
vrunner cfe compare \
  --first-cfe ./old/MyExtension.cfe \
  --second-cfe ./new/MyExtension.cfe \
  --report-dir ./reports
```
