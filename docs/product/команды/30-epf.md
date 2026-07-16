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

Конвертирует внешние отчёты и обработки между форматами **1С:EDT** и **XML Конфигуратора**
штатными `export`/`import` утилиты `1cedtcli`. Направление определяется автоматически по каталогу
источника (`--src`):

- **EDT-проект → XML**: объекты выгружаются в подкаталоги `ExternalDataProcessors/` и `ExternalReports/`
  каталога `OUT` — по одному корневому `<Имя>.xml` на объект;
- **XML → EDT-проект**: те же XML-дампы импортируются обратно в EDT-проект внешних объектов.

Сборка `.epf`/`.erf` и информационная база **не требуются** — операция работает только с 1С:EDT.

```bash
vrunner epf convert [опции] <OUT>
```

### Аргументы

| Аргумент | Описание |
|----------|----------|
| `OUT` | Каталог результата в противоположном формате (**обязательный**) |

### Опции

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `-s`, `--src` | `VRUNNER_SRC` | Каталог источника: EDT-проект или XML-дампы (по умолчанию - текущий каталог) |
| `--edt-version` | `VRUNNER_EDT_VERSION` | Версия установленной 1С:EDT |
| `--edt-workspace` | `VRUNNER_EDT_WORKSPACE` | Базовый каталог временной рабочей области EDT |
| `--edt-timeout` | `VRUNNER_EDT_TIMEOUT` | Таймаут операций `1cedtcli` в секундах |
| `--edt-vmargs` | `VRUNNER_EDT_VMARGS` | JVM-аргумент `1cedtcli`; опцию можно повторять |
| `--settings` | `VRUNNER_SETTINGS` | Путь к файлу настроек JSON |

::: tip Только опции EDT
В отличие от `epf compile`/`epf decompile`, команде `convert` не нужны опции подключения,
платформы, `ibcmd` и СУБД: она не создаёт временную базу и не собирает `.epf`.
:::

### Примеры

```bash
# EDT → XML
vrunner epf convert \
  --src ./src/epf/MyExternalProject \
  --edt-version 2025.2 \
  --edt-workspace ./build/ws \
  ./build/xml

# XML → EDT (обратно)
vrunner epf convert --src ./build/xml ./build/edt
```

Например, при выгрузке внешняя обработка `MyProcessor` окажется в
`build/xml/ExternalDataProcessors/MyProcessor.xml`, а обратный импорт этого же каталога
воссоздаст EDT-проект в `build/edt`.

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
| `--src-format` | - | Формат исходников: `auto` (по умолчанию), `xml`, `edt` |
| `--edt-version`, `--edt-workspace`, `--edt-timeout`, `--edt-vmargs` | `VRUNNER_EDT_*` | Параметры 1С:EDT (для `--src-format edt`) |
| `--settings` | `VRUNNER_SETTINGS` | Путь к файлу настроек (JSON) |

> Подробнее о форматах строки подключения, ibcmd и опциях СУБД: [Подключение к базе данных →](./common-options)

::: tip Исходники 1С:EDT
Если `SRC` — проект внешних объектов 1С:EDT (`--src-format edt` или автоопределение),
`compile` сначала выгружает его в XML через `1cedtcli` (`export`), затем собирает `.epf`
из полученных XML. Требуется установленная 1С:EDT.
:::

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
| `--src-format` | - | Формат выгрузки: `auto`/`xml` (XML Конфигуратора) или `edt` (проект 1С:EDT) |
| `--edt-version`, `--edt-workspace`, `--edt-timeout`, `--edt-vmargs` | `VRUNNER_EDT_*` | Параметры 1С:EDT (для `--src-format edt`) |
| `--settings` | `VRUNNER_SETTINGS` | Путь к файлу настроек (JSON) |

> Подробнее о форматах строки подключения, ibcmd и опциях СУБД: [Подключение к базе данных →](./common-options)

::: tip Выгрузка в 1С:EDT
С `--src-format edt` команда разбирает `.epf`/`.erf` во временный XML и затем импортирует
его в EDT-проект внешних объектов через `1cedtcli` (`import`). Требуется установленная 1С:EDT.
:::

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
