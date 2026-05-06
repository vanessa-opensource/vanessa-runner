# epf - Операции с внешними обработками

Группа команд `epf` обеспечивает работу с внешними обработками и отчётами 1С (`.epf`, `.erf`): сборку из XML-исходников и разборку.

```bash
vrunner epf <подкоманда> [аргументы] [опции]
```

## compile

Собирает внешние обработки (`.epf`/`.erf`) из XML-исходников. Поддерживает обработку целого каталога с рекурсивным поиском.

```bash
vrunner epf compile [SRC] [опции]
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

> Подробнее о форматах строки подключения, ibcmd и опциях СУБД: [Подключение к базе данных →](./05-common-options)

### Примеры

```bash
# Собрать все обработки в текущем каталоге
vrunner epf compile --ibcmd

# Рекурсивно собрать все обработки в каталоге epf/
vrunner epf compile ./epf -R --out ./build/epf --ibcmd

# Через конфигуратор
vrunner epf compile ./epf \
  --ibconnection /F./ib \
  --v8version 8.3.24
```

::: tip Формат исходников
Каждая обработка хранится в отдельном каталоге, где корневой файл имеет расширение `.os` или описание в формате конфигуратора.
:::

## decompile

Разбирает файл обработки `.epf`/`.erf` (или каталог с файлами) в XML-исходники.

```bash
vrunner epf decompile <SRC> [опции]
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

> Подробнее о форматах строки подключения, ibcmd и опциях СУБД: [Подключение к базе данных →](./05-common-options)

### Примеры

```bash
# Разобрать один файл
vrunner epf decompile ./MyReport.epf --ibcmd

# Разобрать все файлы из каталога рекурсивно
vrunner epf decompile ./build/epf -R --out ./epf --ibcmd

# Через конфигуратор
vrunner epf decompile ./MyReport.epf \
  --ibconnection /F./ib \
  --out ./src/reports/MyReport
```
