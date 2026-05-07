# run - Запуск 1С

Группа команд `run` обеспечивает запуск 1С:Предприятия и Конфигуратора с нужными параметрами из командной строки.

```bash
vrunner run <подкоманда> [опции]
```

## enterprise

Запускает 1С:Предприятие в указанном режиме.

```bash
vrunner run enterprise [опции]
```

### Опции

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--command` | `VRUNNER_COMMAND` | Строка, передаваемая в параметр `/C` |
| `--execute` | `VRUNNER_EXECUTE` | Путь к внешней обработке 1С для запуска (поддерживается переменная `$runnerRoot`) |
| `--url` | - | Навигационная ссылка для перехода после старта |
| `--no-wait` | - | Не ожидать завершения запущенного процесса |
| `--exitCodePath` | - | Путь к файлу статуса выполнения (0=успех, 1=ошибка, 2=предупреждение) |
| `--ibconnection` | `VRUNNER_IBCONNECTION` | Строка подключения к ИБ (`/F<путь>` - файловая, `/S<сервер>\<база>` - серверная) |
| `--db-user` | `VRUNNER_DBUSER` | Пользователь ИБ |
| `--db-pwd` | `VRUNNER_DBPWD` | Пароль пользователя ИБ |
| `--ibcmd` | - | Использовать `ibcmd` вместо Конфигуратора |
| `--v8version` | `VRUNNER_V8VERSION` | Версия платформы 1С |
| `--uccode` | `VRUNNER_UCCODE` | Код разрешения блокировки |
| `--language` | `VRUNNER_LANGUAGE` | Язык платформы |
| `--locale` | `VRUNNER_LOCALE` | Язык сеанса (локаль) |
| `--nocacheuse` | `VRUNNER_NOCACHEUSE` | Не использовать кеш платформы |
| `--ordinaryapp` | `VRUNNER_ORDINARYAPP` | Режим запуска: `1` (толстый), `0` (тонкий), `-1` (авто) |
| `--additional` | `VRUNNER_ADDITIONAL` | Дополнительные параметры запуска платформы |
| `--settings` | `VRUNNER_SETTINGS` | Путь к файлу настроек (JSON) |

> Подробнее о форматах строки подключения и ibcmd: [Подключение к базе данных →](./05-common-options)

### Примеры

```bash
# Запустить обработку для первоначального заполнения ИБ
vrunner run enterprise \
  --ibconnection /F./ib \
  --execute ./tools/InitIB.epf \
  --exitCodePath ./build/result.txt

# Запустить с командой и дождаться завершения
vrunner run enterprise \
  --ibconnection /F./ib \
  --command "StartFilling" \
  --v8version 8.3.24

# Запустить в фоне (не ждать завершения)
vrunner run enterprise \
  --ibconnection /F./ib \
  --execute ./tools/Server.epf \
  --no-wait

# Запустить с навигационной ссылкой
vrunner run enterprise \
  --ibconnection /F./ib \
  --url "e1cib/list/Catalog.Контрагенты"
```

::: tip Переменная $runnerRoot
В опции `--execute` поддерживается переменная `$runnerRoot`, которая раскрывается в корневой каталог vanessa-runner. Это позволяет использовать встроенные обработки инструмента.
:::

## designer

Запускает Конфигуратор 1С.

```bash
vrunner run designer [опции]
```

### Опции

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--additional` | `VRUNNER_ADDITIONAL` | Дополнительные параметры запуска конфигуратора |
| `--no-wait` | - | Не ожидать завершения |
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

> Подробнее о форматах строки подключения и ibcmd: [Подключение к базе данных →](./05-common-options)

### Примеры

```bash
# Запустить конфигуратор с дополнительными ключами
vrunner run designer \
  --ibconnection /F./ib \
  --additional "/DumpConfigToFiles ./src"

# Запустить и не ждать завершения
vrunner run designer \
  --ibconnection /F./ib \
  --no-wait
```
