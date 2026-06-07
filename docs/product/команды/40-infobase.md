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
| `--source` | `VRUNNER_SOURCE` | Источник конфигурации: каталог исходников (XML-дамп или [1С:EDT](./edt)), `.cf` или `.dt` файл |
| `--src-format` | - | Формат каталога исходников: `auto` (по умолчанию), `edt`, `xml`. См. [1С:EDT](./edt) |
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

## create-user

Создаёт пользователя в информационной базе. Пользователь создаётся **только если в ИБ ещё нет ни одного пользователя**; по умолчанию ему назначаются роли полного доступа (`ПолныеПрава`, `АдминистраторСистемы`). Набор ролей можно переопределить ключами `--role`, что позволяет создавать не только администратора, но и пользователя с произвольным набором прав. Команда работает на конфигурациях, основанных на БСП, и запускается в режиме 1С:Предприятие.

```bash
vrunner infobase create-user <NAME> [--role <РОЛЬ>]... [опции]
```

### Аргументы

| Аргумент | Описание |
|----------|----------|
| `NAME` | Имя создаваемого пользователя (**обязательный**) |

### Опции

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--role` | - | Имя роли для назначения пользователю. Можно указать несколько раз. По умолчанию: `ПолныеПрава`, `АдминистраторСистемы` |
| `--ibconnection` | `VRUNNER_IBCONNECTION` | Строка подключения к ИБ (`/F<путь>` - файловая, `/S<сервер>\<база>` - серверная) |
| `--db-user` | `VRUNNER_DBUSER` | Пользователь ИБ |
| `--db-pwd` | `VRUNNER_DBPWD` | Пароль пользователя ИБ |
| `--ibcmd` | - | Использовать `ibcmd` вместо Конфигуратора |
| `--v8version` | `VRUNNER_V8VERSION` | Версия платформы 1С |
| `--uccode` | `VRUNNER_UCCODE` | Код разрешения блокировки |
| `--language` | `VRUNNER_LANGUAGE` | Язык платформы |
| `--locale` | `VRUNNER_LOCALE` | Язык сеанса (локаль) |
| `--dbms-type` | `VRUNNER_DBMS_TYPE` | Тип СУБД: `MSSQLServer`, `PostgreSQL`, `IBMDB2`, `OracleDatabase` |
| `--dbms-server` | `VRUNNER_DBMS_SERVER` | Адрес сервера СУБД |
| `--dbms-base` | `VRUNNER_DBMS_BASE` | Имя базы данных СУБД |
| `--dbms-user` | `VRUNNER_DBMS_USER` | Пользователь СУБД |
| `--dbms-pwd` | `VRUNNER_DBMS_PWD` | Пароль СУБД |

> Подробнее о подключении, ibcmd и опциях СУБД: [Подключение к базе данных →](./common-options)

### Примеры

```bash
# Создать администратора с именем "Администратор" в файловой ИБ (роли по умолчанию)
vrunner infobase create-user Администратор --ibconnection /F./ib

# Создать пользователя с произвольным набором ролей
vrunner infobase create-user Оператор \
  --role ЧтениеДанных \
  --role РаботаСЗаказами \
  --ibconnection /F./ib
```

## lock-resources

Разрешает или запрещает работу информационной базы с внешними ресурсами (использует механизм Библиотеки стандартных подсистем). Необходимо указать ровно один из взаимоисключающих флагов `--allow` или `--deny`.

```bash
vrunner infobase lock-resources (--allow | --deny) [опции]
```

### Опции

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--allow` | - | Разрешить работу с внешними ресурсами |
| `--deny` | - | Запретить работу с внешними ресурсами |
| `--ibconnection` | `VRUNNER_IBCONNECTION` | Строка подключения к ИБ (`/F<путь>` - файловая, `/S<сервер>\<база>` - серверная) |
| `--db-user` | `VRUNNER_DBUSER` | Пользователь ИБ |
| `--db-pwd` | `VRUNNER_DBPWD` | Пароль пользователя ИБ |
| `--ibcmd` | - | Использовать `ibcmd` вместо Конфигуратора |
| `--v8version` | `VRUNNER_V8VERSION` | Версия платформы 1С |
| `--uccode` | `VRUNNER_UCCODE` | Код разрешения блокировки |
| `--language` | `VRUNNER_LANGUAGE` | Язык платформы |
| `--locale` | `VRUNNER_LOCALE` | Язык сеанса (локаль) |

> Подробнее о подключении и ibcmd: [Подключение к базе данных →](./common-options)

### Примеры

```bash
# Запретить работу с ВНЕШНИМИ ресурсами, например на развёрнутой копии базы,
# чтобы она случайно не отправляла письма/обмены в боевые системы
vrunner infobase lock-resources --deny --ibconnection /F./ib

# Снова разрешить работу с внешними ресурсами
vrunner infobase lock-resources --allow --ibconnection /F./ib
```

## scheduled-job

Группа команд управления регламентными заданиями (использует механизм Библиотеки стандартных подсистем). Позволяет включать и отключать регламентное задание по имени его метаданных.

```bash
vrunner infobase scheduled-job <enable | disable> <JOB> [опции]
```

### Аргументы

| Аргумент | Описание |
|----------|----------|
| `JOB` | Имя метаданных регламентного задания (**обязательный**) |

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

> Подробнее о подключении и ibcmd: [Подключение к базе данных →](./common-options)

### Примеры

```bash
# Отключить регламентное задание извлечения текста
vrunner infobase scheduled-job disable ИзвлечениеТекста --ibconnection /F./ib

# Снова включить регламентное задание извлечения текста
vrunner infobase scheduled-job enable ИзвлечениеТекста --ibconnection /F./ib
```

> [!NOTE]
> В будущем планируется управление расписанием регламентных заданий через
> передачу расписания в cron-формате (а не только включение/отключение).

## extensions

Группа команд для работы с уже установленными в базе расширениями конфигурации. Не требует `.cfe`-файлов или исходников: команды работают с расширениями, которые уже подключены к информационной базе. Команды `list`/`check`/`delete`/`set-options` запускаются в режиме 1С:Предприятие; `create` создаёт пустое расширение конфигуратором.

```bash
vrunner infobase extensions <list | check | create | delete | set-options> [опции]
```

### list

Выводит список установленных расширений. По умолчанию - только имена; с флагом `--verbose`/`-v` - таблица с именем, версией, активностью, безопасным режимом, защитой от опасных действий и режимом основных ролей.

```bash
vrunner infobase extensions list [-v] [опции]
```

| Опция | Описание |
|-------|----------|
| `--verbose`, `-v` | Подробный вывод: таблица с параметрами расширений (по умолчанию - только имена) |

### check

Проверяет применимость установленных расширений без их загрузки. Без аргумента `NAME` проверяются все расширения, иначе - только указанное.

```bash
vrunner infobase extensions check [NAME] [опции]
```

| Аргумент | Описание |
|----------|----------|
| `NAME` | Имя конкретного расширения для проверки (по умолчанию - все) |

### create

Создаёт пустое расширение конфигурации с заданным именем (загрузкой минимальных исходников через конфигуратор). Если расширение с таким именем уже существует - команда завершается ошибкой; чтобы пересоздать его, укажите `--overwrite`.

```bash
vrunner infobase extensions create <NAME> [--overwrite] [опции]
```

| Аргумент | Описание |
|----------|----------|
| `NAME` | Имя создаваемого расширения (**обязательный**) |

| Опция | Описание |
|-------|----------|
| `--overwrite` | Пересоздать расширение, если оно уже существует |

### delete

Удаляет установленное расширение по имени. Если расширение не найдено - команда завершается ошибкой.

```bash
vrunner infobase extensions delete <NAME> [опции]
```

| Аргумент | Описание |
|----------|----------|
| `NAME` | Имя удаляемого расширения (**обязательный**) |

### set-options

Изменяет свойства уже установленного расширения по имени без его перезагрузки. Меняются только явно переданные параметры; опущенные остаются без изменений.

```bash
vrunner infobase extensions set-options <NAME> [опции]
```

| Аргумент | Описание |
|----------|----------|
| `NAME` | Имя расширения (**обязательный**) |

| Опция | Описание |
|-------|----------|
| `--active` | Активность расширения: `true`/`false` (если не указано - не меняется) |
| `--safe-mode` | Безопасный режим: `true`/`false` (если не указано - не меняется) |
| `--unsafe-action-protection` | Защита от опасных действий: `true`/`false` |
| `--main-roles-for-all` | Использовать основные роли для всех пользователей (8.3.15+): `true`/`false` |

Все подкоманды поддерживают общие опции подключения и платформы (`--ibconnection`, `--db-user`, `--db-pwd`, `--ibcmd`, `--v8version` и др.). Опции указываются **до** позиционного аргумента `NAME`.

> Подробнее о подключении и ibcmd: [Подключение к базе данных →](./common-options)

### Примеры

```bash
# Список установленных расширений (только имена)
vrunner infobase extensions list --ibconnection /F./ib

# Подробная таблица расширений
vrunner infobase extensions list -v --ibconnection /F./ib

# Проверить применимость всех установленных расширений
vrunner infobase extensions check --ibconnection /F./ib

# Создать пустое расширение
vrunner infobase extensions create --ibconnection /F./ib МоёРасширение

# Пересоздать существующее расширение
vrunner infobase extensions create --overwrite --ibconnection /F./ib МоёРасширение

# Удалить расширение
vrunner infobase extensions delete --ibconnection /F./ib МоёРасширение

# Включить безопасный режим и снять защиту от опасных действий
vrunner infobase extensions set-options --safe-mode true \
  --unsafe-action-protection false \
  --ibconnection /F./ib МоёРасширение
```
