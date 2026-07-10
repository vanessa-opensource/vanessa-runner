---
title: epf
---

# epf - Операции с внешними обработками

Группа команд `epf` обеспечивает работу с внешними обработками и отчётами 1С (`.epf`, `.erf`): сборку из XML-исходников, разборку и конвертацию проектов 1С:EDT.

```bash
vrunner epf <подкоманда> [опции] [аргументы]
```

::: warning EDT поддерживается отдельной командой
`epf compile` и `epf decompile` работают с форматом Конфигуратора. Для односторонней конвертации EDT → XML используйте `epf convert`.
:::

## convert

Собирает проект внешних отчётов и обработок в 1С:EDT и разбирает полученные `.epf`/`.erf`
в XML-исходники Конфигуратора. Обратная конвертация этой командой не выполняется.

```bash
vrunner epf convert [опции] <OUT>
```

### Аргументы

| Аргумент | Описание |
|----------|----------|
| `OUT` | Каталог для XML-исходников (**обязательный**). Каждый объект записывается в подкаталог со своим именем |

### Основные опции

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `-s`, `--src` | `VRUNNER_SRC` | Каталог EDT-проекта (по умолчанию - текущий каталог) |
| `--edt-version` | `VRUNNER_EDT_VERSION` | Версия установленной 1С:EDT |
| `--edt-workspace` | `VRUNNER_EDT_WORKSPACE` | Базовый каталог временной рабочей области EDT |
| `--edt-timeout` | `VRUNNER_EDT_TIMEOUT` | Таймаут сборки проекта в секундах |
| `--edt-vmargs` | `VRUNNER_EDT_VMARGS` | JVM-аргумент `1cedtcli`; опцию можно повторять |
| `--ibconnection` | `VRUNNER_IBCONNECTION` | Готовая ИБ для разборки `.epf/.erf`; без неё создаётся временная |
| `--ibcmd` | - | Использовать `ibcmd` при создании временной ИБ |
| `--v8version` | `VRUNNER_V8VERSION` | Версия платформы 1С для Конфигуратора |
| `--settings` | `VRUNNER_SETTINGS` | Путь к файлу настроек JSON |

Остальные опции подключения, платформы и СУБД совпадают с `epf compile`/`epf decompile`.

### Пример

```bash
vrunner epf convert \
  --src ./src/epf/MyExternalProject \
  --edt-version 2025.2 \
  --edt-workspace ./build/ws \
  ./build/xml
```

Команда импортирует существующий проект в отдельную рабочую область `1cedtcli` с полной сборкой,
находит созданные EDT файлы в `bin`, а затем разбирает их Конфигуратором. Например,
`bin/MyProcessor.epf` будет выгружен в `build/xml/MyProcessor/`.

## compile

Собирает внешние обработки (`.epf`/`.erf`) из XML-исходников. Поддерживает обработку целого каталога с рекурсивным поиском.

```bash
vrunner epf compile [опции] [SRC]
```

### Аргументы

| Аргумент | Описание |
|----------|----------|
| `SRC` | Каталог с XML-исходниками обработок (по умолчанию - текущий каталог) |

### Опции

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--R`, `--recursive` | - | Рекурсивный поиск обработок в подкаталогах |
| `--out` | - | Каталог для сохранения собранных обработок |
| `--ibconnection` | `VRUNNER_IBCONNECTION` | Строка подключения к ИБ. Если не указана - автоматически создаётся временная ИБ |
| `--db-user` | `VRUNNER_DBUSER` | Пользователь информационной базы |
| `--db-pwd` | `VRUNNER_DBPWD` | Пароль пользователя ИБ |
| `--ibcmd` | - | Использовать утилиту `ibcmd` вместо Конфигуратора |
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

> Подробнее о форматах строки подключения, ibcmd и опциях СУБД: [Подключение к базе данных →](./common-options)

### Примеры

```bash
# Собрать все обработки в текущем каталоге
vrunner epf compile --ibcmd

# Рекурсивно собрать все обработки в каталоге epf/
vrunner epf compile -R --out ./build/epf --ibcmd ./epf

# Через конфигуратор
vrunner epf compile \
  --ibconnection /F./ib \
  --v8version 8.3.24 \
  ./epf
```

::: tip Формат исходников
Каждая обработка хранится в отдельном каталоге, где корневой файл имеет расширение `.os` или описание в формате конфигуратора.
:::

## decompile

Разбирает файл обработки `.epf`/`.erf` (или каталог с файлами) в XML-исходники.

```bash
vrunner epf decompile [опции] <SRC>
```

### Аргументы

| Аргумент | Описание |
|----------|----------|
| `SRC` | Путь к EPF-файлу или каталогу с EPF-файлами (**обязательный**) |

### Опции

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--R`, `--recursive` | - | Рекурсивный поиск EPF-файлов (для каталога) |
| `--out` | - | Каталог для сохранения разобранных исходников |
| `--ibconnection` | `VRUNNER_IBCONNECTION` | Строка подключения к ИБ. Если не указана - автоматически создаётся временная ИБ |
| `--db-user` | `VRUNNER_DBUSER` | Пользователь информационной базы |
| `--db-pwd` | `VRUNNER_DBPWD` | Пароль пользователя ИБ |
| `--ibcmd` | - | Использовать утилиту `ibcmd` вместо Конфигуратора |
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

> Подробнее о форматах строки подключения, ibcmd и опциях СУБД: [Подключение к базе данных →](./common-options)

### Примеры

```bash
# Разобрать один файл
vrunner epf decompile --ibcmd ./MyReport.epf

# Разобрать все файлы из каталога рекурсивно
vrunner epf decompile -R --out ./epf --ibcmd ./build/epf

# Через конфигуратор
vrunner epf decompile \
  --ibconnection /F./ib \
  --out ./src/reports/MyReport \
  ./MyReport.epf
```
