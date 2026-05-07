# validate - Проверка конфигурации

Группа команд `validate` обеспечивает статическую проверку конфигурации 1С: синтаксическую проверку через конфигуратор и проверку в EDT.

```bash
vrunner validate <подкоманда> [опции]
```

## syntax-check

Выполняет проверку синтаксиса конфигурации в указанных режимах через конфигуратор. Формирует отчёт в формате JUnit XML, совместимый с системами CI/CD.

```bash
vrunner validate syntax-check [опции]
```

### Опции

| Опция | По умолчанию | Переменная окружения | Описание |
|-------|-------------|---------------------|----------|
| `--mode` | - | - | Режимы проверки (можно указать несколько через повторение опции) |
| `--junitpath` | - | `VRUNNER_JUNITPATH` | Путь к файлу отчёта JUnit XML |
| `--exception-file` | - | - | Путь к файлу исключений (UTF-8, по одному исключению на строку) |
| `--groupbymetadata` | `false` | - | Группировать ошибки по объектам метаданных |
| `--testsuitename` | `syntax-check` | - | Имя тестового набора в JUnit-отчёте |
| `--ibconnection` | - | `VRUNNER_IBCONNECTION` | Строка подключения к ИБ (`/F<путь>` - файловая, `/S<сервер>\<база>` - серверная) |
| `--db-user` | - | `VRUNNER_DBUSER` | Пользователь ИБ |
| `--db-pwd` | - | `VRUNNER_DBPWD` | Пароль пользователя ИБ |
| `--ibcmd` | - | - | Использовать `ibcmd` вместо Конфигуратора |
| `--v8version` | - | `VRUNNER_V8VERSION` | Версия платформы 1С |
| `--uccode` | - | `VRUNNER_UCCODE` | Код разрешения блокировки |
| `--language` | - | `VRUNNER_LANGUAGE` | Язык платформы |
| `--locale` | - | `VRUNNER_LOCALE` | Язык сеанса (локаль) |
| `--dbms-type` | - | `VRUNNER_DBMS_TYPE` | Тип СУБД: `MSSQLServer`, `PostgreSQL`, `IBMDB2`, `OracleDatabase`. Нужен при `--ibcmd` для серверной ИБ |
| `--dbms-server` | - | `VRUNNER_DBMS_SERVER` | Адрес сервера СУБД |
| `--dbms-base` | - | `VRUNNER_DBMS_BASE` | Имя базы данных СУБД |
| `--dbms-user` | - | `VRUNNER_DBMS_USER` | Пользователь СУБД |
| `--dbms-pwd` | - | `VRUNNER_DBMS_PWD` | Пароль СУБД |
| `--storage-name` | - | `VRUNNER_STORAGE_NAME` | Адрес хранилища |
| `--storage-user` | - | `VRUNNER_STORAGE_USER` | Пользователь хранилища |
| `--storage-pwd` | - | `VRUNNER_STORAGE_PWD` | Пароль хранилища |
| `--storage-ver` | - | `VRUNNER_STORAGE_VER` | Версия хранилища |
| `--settings` | - | `VRUNNER_SETTINGS` | Путь к файлу настроек (JSON) |

> Подробнее о подключении, ibcmd и опциях СУБД: [Подключение к базе данных →](./common-options)

### Доступные режимы проверки (--mode)

| Режим | Описание |
|-------|----------|
| `ThinClient` | Тонкий клиент |
| `WebClient` | Веб-клиент |
| `Server` | Сервер |
| `ExternalConnection` | Внешнее соединение |
| `ExternalConnectionServer` | Внешнее соединение (клиент-серверный) |
| `MobileClient` | Мобильный клиент |
| `MobileClientStandalone` | Мобильный клиент (автономный) |
| `MobileAppClient` | Мобильное приложение (клиент) |
| `MobileAppServer` | Мобильное приложение (сервер) |
| `ThickClientManagedApplication` | Толстый клиент (управляемое приложение) |
| `ThickClientServerManagedApplication` | Толстый клиент (управляемое, клиент-серверный) |
| `ThickClientOrdinaryApplication` | Толстый клиент (обычное приложение) |
| `ThickClientServerOrdinaryApplication` | Толстый клиент (обычное, клиент-серверный) |
| `ConfigLogIntegrity` | Проверка логической целостности конфигурации |
| `IncorrectReferences` | Поиск некорректных ссылок |
| `DistributiveModules` | Поставка модулей без исходных текстов |
| `UnreferenceProcedures` | Поиск неиспользуемых процедур и функций |
| `HandlersExistence` | Проверка существования назначенных обработчиков |
| `EmptyHandlers` | Поиск пустых обработчиков |
| `ExtendedModulesCheck` | Расширенная проверка модулей |
| `CheckUseModality` | Поиск использования модальности |
| `CheckUseSynchronousCalls` | Поиск синхронных вызовов |
| `UnsupportedFunctional` | Поиск неподдерживаемой функциональности |
| `AllExtensions` | Проверка всех расширений |

### Примеры

```bash
# Проверить синтаксис для нескольких режимов клиента
vrunner validate syntax-check \
  --ibconnection /F./ib \
  --mode ThinClient \
  --mode Server \
  --mode WebClient \
  --junitpath ./build/reports/syntax.xml

# Проверить с группировкой по метаданным и файлом исключений
vrunner validate syntax-check \
  --ibconnection /F./ib \
  --mode ThinClient \
  --mode Server \
  --junitpath ./build/reports/syntax.xml \
  --groupbymetadata \
  --exception-file ./syntax-check-exceptions.txt \
  --testsuitename "MyProject syntax check"
```

::: tip Файл исключений
Файл исключений (`--exception-file`) позволяет игнорировать известные/допустимые ошибки. Каждая строка файла - одна строка из сообщения об ошибке, которую нужно пропустить. Кодировка: UTF-8.
:::

::: tip Интеграция с CI
JUnit-отчёт совместим с GitLab CI, Jenkins, GitHub Actions и другими системами CI/CD. Укажите путь к файлу в настройках сборки для публикации результатов проверки.
:::

## edt

::: warning В разработке
Команда `validate edt` находится в разработке и пока не реализована.
:::

Выполняет проверку проекта средствами Enterprise Development Tools (EDT).

```bash
vrunner validate edt [опции]
```
