# test — Запуск тестов

Группа команд `test` обеспечивает запуск автоматизированного тестирования 1С-конфигураций через фреймворк [Vanessa-ADD](https://github.com/vanessa-opensource/vanessa-add): как модульного (xUnit), так и функционального (BDD).

```bash
vrunner test <подкоманда> [аргументы] [опции]
```

## xunit

Запускает модульные тесты через обработку `xddTestRunner.epf` (xUnit for 1C).

```bash
vrunner test xunit [TESTSPATH] [опции]
```

### Аргументы

| Аргумент | Переменная окружения | Описание |
|----------|---------------------|----------|
| `TESTSPATH` | `VRUNNER_TESTSPATH` | Путь к каталогу или файлу с тестами, или к встроенным тестам (с `--config-tests`) |

### Опции

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--workspace` | `VRUNNER_WORKSPACE` | Путь к папке проекта для макросов `$workspace` (по умолчанию — текущий) |
| `--pathxunit` | `VRUNNER_PATHXUNIT` | Путь к внешней обработке `xddTestRunner.epf` (по умолчанию из vanessa-add) |
| `--reportsxunit` | `VRUNNER_REPORTSXUNIT` | Параметры формирования отчётов: `ФорматВывода{Путь};ФорматВывода{Путь}` |
| `--reportxunit` | — | Путь к каталогу с отчётом jUnit _(устарел, используйте `--reportsxunit`)_ |
| `--xddExitCodePath` | — | Путь к файлу статуса (0=пройдены, 1=не пройдены) |
| `--xddConfig` | — | Путь к конфигурационному файлу xUnitFor1c |
| `--testclient` | — | Параметры тест-клиента: `Пользователь:Пароль:Порт` |
| `--testclient-additional` | — | Дополнительные параметры запуска тест-клиента |
| `--config-tests` | `VRUNNER_CONFIG_TESTS` | Загружать тесты, встроенные в конфигурацию |
| `--no-wait` | — | Не ожидать завершения |
| `--xdddebug` | — | Выводить отладочные сообщения при прогоне |
| `--no-shutdown` | — | Не завершать 1С после выполнения тестов |
| `--clear-reports` | — | Очищать каталоги отчётов перед запуском |
| `--ibconnection` | `VRUNNER_IBCONNECTION` | Строка подключения к ИБ (`/F<путь>` — файловая, `/S<сервер>\<база>` — серверная) |
| `--db-user` | `VRUNNER_DBUSER` | Пользователь ИБ |
| `--db-pwd` | `VRUNNER_DBPWD` | Пароль пользователя ИБ |
| `--ibcmd` | — | Использовать `ibcmd` вместо Конфигуратора |
| `--v8version` | `VRUNNER_V8VERSION` | Версия платформы 1С |
| `--uccode` | `VRUNNER_UCCODE` | Код разрешения блокировки |
| `--language` | `VRUNNER_LANGUAGE` | Язык платформы |
| `--locale` | `VRUNNER_LOCALE` | Язык сеанса (локаль) |
| `--nocacheuse` | `VRUNNER_NOCACHEUSE` | Не использовать кеш платформы |
| `--ordinaryapp` | `VRUNNER_ORDINARYAPP` | Режим запуска: `1` (толстый), `0` (тонкий), `-1` (авто) |
| `--additional` | `VRUNNER_ADDITIONAL` | Дополнительные параметры запуска платформы |
| `--settings` | `VRUNNER_SETTINGS` | Путь к файлу настроек (JSON) |

> Подробнее о форматах строки подключения и ibcmd: [Подключение к базе данных →](./05-common-options)

### Формат reportsxunit

Параметр `--reportsxunit` задаёт список форматов отчётов через точку с запятой:

```
jUnit{./build/reports/junit.xml};HTML{./build/reports/tests.html}
```

Поддерживаемые форматы: `jUnit`, `HTML`, `allure`, `GenericExecution`.

### Примеры

```bash
# Запустить тесты и сформировать JUnit-отчёт
vrunner test xunit ./tests \
  --ibconnection /F./ib \
  --reportsxunit "jUnit{./build/reports/junit.xml}"

# Тесты, встроенные в конфигурацию
vrunner test xunit \
  --ibconnection /F./ib \
  --config-tests \
  --reportsxunit "jUnit{./build/reports/junit.xml}"

# Запустить конкретный файл с тестами
vrunner test xunit ./tests/MyTests.os \
  --ibconnection /F./ib \
  --xddExitCodePath ./build/status.txt

# С тест-клиентом (клиент-серверный режим)
vrunner test xunit ./tests \
  --ibconnection "/SMyServer\MyIB" \
  --testclient "Тест:password:1538" \
  --reportsxunit "jUnit{./build/reports/junit.xml}"
```

## vanessa

Запускает функциональные тесты по сценариям в формате Gherkin через обработку `bddRunner.epf` (Vanessa-ADD BDD).

```bash
vrunner test vanessa [опции]
```

### Опции

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--feature-path` | `VRUNNER_FEATUREPATH` | Путь к каталогу с фичами или к конкретному файлу `.feature` |
| `--bddrunner-path` | `VRUNNER_PATHVANESSA` | Путь к `bddRunner.epf` (по умолчанию из vanessa-add) |
| `--vanessasettings` | `VRUNNER_VANESSASETTINGS` | Путь к файлу настроек фреймворка тестирования |
| `--workspace` | `VRUNNER_WORKSPACE` | Путь к папке проекта |
| `--tags-ignore` | — | Теги для игнорирования файлов фич |
| `--tags-filter` | — | Теги для фильтрации файлов фич |
| `--additional-keys` | — | Дополнительные параметры, передаваемые в `/C` |
| `--no-wait` | — | Не ожидать завершения |
| `--ibconnection` | `VRUNNER_IBCONNECTION` | Строка подключения к ИБ (`/F<путь>` — файловая, `/S<сервер>\<база>` — серверная) |
| `--db-user` | `VRUNNER_DBUSER` | Пользователь ИБ |
| `--db-pwd` | `VRUNNER_DBPWD` | Пароль пользователя ИБ |
| `--ibcmd` | — | Использовать `ibcmd` вместо Конфигуратора |
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
# Запустить все фичи
vrunner test vanessa \
  --ibconnection /F./ib \
  --feature-path ./features \
  --vanessasettings ./vb-params.json

# Запустить с фильтром по тегам
vrunner test vanessa \
  --ibconnection /F./ib \
  --feature-path ./features \
  --tags-filter "@smoke" \
  --tags-ignore "@wip"

# Запустить конкретную фичу
vrunner test vanessa \
  --ibconnection /F./ib \
  --feature-path ./features/Catalog.feature
```

::: tip vanessasettings
Файл настроек `vb-params.json` содержит конфигурацию Vanessa-ADD: пути к отчётам, настройки скриншотов, тайм-ауты и другие параметры. Документацию по формату файла см. в репозитории [vanessa-add](https://github.com/vanessa-opensource/vanessa-add).
:::
