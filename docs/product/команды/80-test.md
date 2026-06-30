---
title: test
---

# test - Запуск тестов

Группа команд `test` обеспечивает запуск автоматизированного тестирования 1С-конфигураций: модульного (xUnit) и функционального (BDD) через фреймворк [Vanessa-ADD](https://github.com/vanessa-opensource/vanessa-add), а также модульного через фреймворк [YAxUnit](https://github.com/bia-technologies/yaxunit).

```bash
vrunner test <подкоманда> [опции] [аргументы]
```

## xunit

Запускает модульные тесты через обработку `xddTestRunner.epf` (xUnit for 1C).

```bash
vrunner test xunit [опции] [TESTSPATH]
```

### Аргументы

| Аргумент | Переменная окружения | Описание |
|----------|---------------------|----------|
| `TESTSPATH` | `VRUNNER_TESTSPATH` | Путь к каталогу или файлу с тестами, или к встроенным тестам (с `--config-tests`). Поддерживается макрос `$addRoot` — каталог установки vanessa-add |

### Опции

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--workspace` | `VRUNNER_WORKSPACE` | Путь к папке проекта для макросов `$workspace` (по умолчанию - текущий) |
| `--pathxunit` | `VRUNNER_PATHXUNIT` | Путь к внешней обработке `xddTestRunner.epf` (по умолчанию из vanessa-add) |
| `--reportsxunit` | `VRUNNER_REPORTSXUNIT` | Параметры формирования отчётов: `ФорматВывода{Путь};ФорматВывода{Путь}` |
| `--reportxunit` | - | Путь к каталогу с отчётом jUnit _(устарел, используйте `--reportsxunit`)_ |
| `--xddExitCodePath` | - | Путь к файлу статуса (0=пройдены, 1=не пройдены) |
| `--xddConfig` | - | Путь к конфигурационному файлу xUnitFor1c |
| `--testclient` | - | Параметры тест-клиента: `Пользователь:Пароль:Порт` |
| `--testclient-additional` | - | Дополнительные параметры запуска тест-клиента |
| `--config-tests` | `VRUNNER_CONFIG_TESTS` | Загружать тесты, встроенные в конфигурацию |
| `--no-wait` | - | Не ожидать завершения |
| `--xdddebug` | - | Выводить отладочные сообщения при прогоне |
| `--no-shutdown` | - | Не завершать 1С после выполнения тестов |
| `--clear-reports` | - | Очищать каталоги отчётов перед запуском |
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

> Подробнее о форматах строки подключения и ibcmd: [Подключение к базе данных →](./common-options)

### Формат reportsxunit

Параметр `--reportsxunit` задаёт список форматов отчётов через точку с запятой:

```
jUnit{./build/reports/junit.xml};HTML{./build/reports/tests.html}
```

Поддерживаемые форматы: `jUnit`, `HTML`, `allure`, `GenericExecution`.

### Примеры

```bash
# Запустить тесты и сформировать JUnit-отчёт
vrunner test xunit \
  --ibconnection /F./ib \
  --reportsxunit "jUnit{./build/reports/junit.xml}" \
  ./tests

# Тесты, встроенные в конфигурацию
vrunner test xunit \
  --ibconnection /F./ib \
  --config-tests \
  --reportsxunit "jUnit{./build/reports/junit.xml}"

# Встроенные дымовые тесты vanessa-add (макрос $addRoot)
vrunner test xunit \
  --ibconnection /F./ib \
  '$addRoot/tests/smoke'

# Запустить конкретный файл с тестами
vrunner test xunit \
  --ibconnection /F./ib \
  --xddExitCodePath ./build/status.txt \
  ./tests/MyTests.os

# С тест-клиентом (клиент-серверный режим)
vrunner test xunit \
  --ibconnection "/SMyServer\MyIB" \
  --testclient "Тест:password:1538" \
  --reportsxunit "jUnit{./build/reports/junit.xml}" \
  ./tests
```

## yaxunit

Запускает модульные тесты через фреймворк [YAxUnit](https://github.com/bia-technologies/yaxunit). В отличие от xUnit, YAxUnit не требует внешней обработки-раннера: движок фреймворка и сами тесты подключаются к информационной базе как расширения конфигурации и исполняются внутри 1С:Предприятия.

```bash
vrunner test yaxunit [опции]
```

::: warning Предварительная подготовка ИБ
Перед запуском в информационную базу должны быть загружены через [`cfe load`](./cfe) с применением к базе (`--update-db`):

1. **расширение-движок YAxUnit** (`.cfe` со страницы релизов проекта);
2. **расширение(я) с тестовыми модулями** — общими модулями, регистрирующими тесты в процедуре `ИсполняемыеСценарии`.

Без применения к базе модули тестов не попадут в метаданные сеанса, и YAxUnit их не обнаружит. Движку также требуется отключённый безопасный режим (загрузка через Конфигуратор это обеспечивает) — иначе он не сможет прочитать файл запуска.
:::

### Опции

Конфигурацию запуска YAxUnit можно задать двумя способами: передать готовый файл через `--yaxunit-config` (используется как есть) либо собрать её из опций фильтрации и отчёта, перечисленных ниже.

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--yaxunit-config` | `VRUNNER_YAXUNIT_CONFIG` | Путь к готовому `yaxunit.json` — используется как есть, опции фильтрации и отчёта игнорируются |
| `--ext` | `VRUNNER_YAXUNIT_EXT` | Имена расширений с тестами через запятую (`filter.extensions`) |
| `--modules` | - | Имена модулей с тестами через запятую (`filter.modules`) |
| `--tests` | - | Полные имена тестов через запятую в формате `Модуль.Тест` (`filter.tests`) |
| `--tags` | - | Теги тестов через запятую (`filter.tags`) |
| `--suites` | - | Имена наборов тестов через запятую (`filter.suites`) |
| `--report` | `VRUNNER_YAXUNIT_REPORT` | Путь к файлу или каталогу отчёта (`reportPath`); если не указан — отчёт jUnit формируется во временном файле |
| `--report-format` | - | Формат отчёта: `jUnit` (по умолчанию), `JSON`, `allure` |
| `--exitcode` | `VRUNNER_YAXUNIT_EXITCODE` | Путь к файлу кода возврата тестирования (`0` - пройдены, `1` - есть ошибки) |
| `--project-path` | `VRUNNER_PROJECT_PATH` | Корневой каталог проекта для зависимостей `ФайлыПроекта` (`projectPath`); по умолчанию - каталог запуска vrunner |
| `--workspace` | `VRUNNER_WORKSPACE` | Рабочий каталог пространства YAxUnit (`workspacePath`) |
| `--show-report` | - | Открывать форму отчёта после тестов (по умолчанию выключено) |
| `--no-close` | - | Не закрывать 1С:Предприятие после выполнения тестов |
| `--no-wait` | - | Не ожидать завершения |
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

> Подробнее о форматах строки подключения и ibcmd: [Подключение к базе данных →](./common-options)

### Фильтрация тестов

Опции `--ext`, `--modules`, `--tests`, `--tags`, `--suites` формируют секцию `filter` файла запуска YAxUnit и комбинируются по «И»: например, `--ext МоиТесты --tags smoke` запустит тесты с тегом `smoke` только из расширения `МоиТесты`. Если не задана ни одна опция фильтра, выполняются все обнаруженные тесты. При указании `--yaxunit-config` опции фильтрации не применяются — фильтр берётся из переданного файла.

### Результат и код возврата

Команда работоспособна с минимумом параметров — достаточно строки подключения (расширения YAxUnit и тестов должны быть загружены в ИБ). Если путь к отчёту не задан, отчёт jUnit формируется во временном файле, после чего команда разбирает его и печатает короткое саммари в консоль:

```
YAxUnit: всего 12, успешно 11, провалено 1, ошибок 0, пропущено 0
  [x] МойМодуль.ПроверкаСложения [Сервер] — ожидали 4, получили 5
```

Код возврата команды: `0` — все тесты пройдены; ненулевой — есть провалы/ошибки либо отчёт не сформирован (например, не загружены движок или расширения с тестами). Это позволяет использовать команду в CI без дополнительных опций. Авто-саммари формируется для формата `jUnit` (по умолчанию); для прочих форматов выводится только путь к отчёту.

### Примеры

```bash
# Минимальный запуск: только подключение (отчёт во временный файл + саммари в консоль)
vrunner test yaxunit --ibconnection /F./ib

# Запустить все тесты из расширения и сформировать JUnit-отчёт
vrunner test yaxunit \
  --ibconnection /F./ib \
  --ext МоиТесты \
  --report ./build/reports/yaxunit.xml \
  --exitcode ./build/status.txt

# Запустить конкретные модули
vrunner test yaxunit \
  --ibconnection /F./ib \
  --modules МодульТестовКаталога,МодульТестовДокумента \
  --report ./build/reports/yaxunit.xml

# Только тесты с заданными тегами
vrunner test yaxunit \
  --ibconnection /F./ib \
  --ext МоиТесты \
  --tags "smoke,critical"

# Использовать готовый конфигурационный файл
vrunner test yaxunit \
  --ibconnection /F./ib \
  --yaxunit-config ./yaxunit.json
```

::: tip Формат yaxunit.json
Готовый файл запуска (`--yaxunit-config`) описывает фильтрацию тестов, формат и путь отчёта, файл кода возврата и поведение после прогона. Подробнее о формате см. в [документации YAxUnit](https://bia-technologies.github.io/yaxunit/).
:::

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
| `--tags-ignore` | - | Теги для игнорирования файлов фич |
| `--tags-filter` | - | Теги для фильтрации файлов фич |
| `--additional-keys` | - | Дополнительные параметры, передаваемые в `/C` |
| `--no-wait` | - | Не ожидать завершения |
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

> Подробнее о форматах строки подключения и ibcmd: [Подключение к базе данных →](./common-options)

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
