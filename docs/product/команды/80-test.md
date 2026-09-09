---
title: test
---

# test - Запуск тестов

Запуск тестов 1С: модульных через [Vanessa-ADD](https://github.com/vanessa-opensource/vanessa-add) (xUnit) и [YAxUnit](https://github.com/bia-technologies/yaxunit), функциональных (BDD) через Vanessa-ADD.

```bash
vrunner test <подкоманда> [опции] [аргументы]
```

Отчёты о прогоне у всех подкоманд задаются общей парой `--report-format` / `--report-path` ([Отчёты о результатах](./reports)), покрытие кода - опциями `--coverage-*` ([Сбор покрытия тестами](./coverage)).

## xunit

Запускает тесты через обработку `xddTestRunner.epf` (xUnit for 1C) из vanessa-add и ждёт завершения 1С:Предприятия.

```bash
vrunner test xunit [опции] TESTSPATH
```

### Аргументы

| Аргумент | Переменная окружения | Описание |
|----------|---------------------|----------|
| `TESTSPATH` | `VRUNNER_TESTSPATH` | Каталог или файл с тестами; с `--config-tests` - имя расширения с тестами (значение с точкой передаётся загрузчику тестов из подсистем конфигурации). Поддерживается макрос `$addRoot` (каталог установки vanessa-add). Обязателен; в файле настроек - ключ `testspath` |

### Опции

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--workspace` | `VRUNNER_WORKSPACE` | Папка проекта (`workspaceRoot` для макросов `$workspace`), по умолчанию - текущий каталог |
| `--pathxunit` | `VRUNNER_PATHXUNIT` | Путь к `xddTestRunner.epf` (по умолчанию из vanessa-add) |
| `--reportsxunit` | `VRUNNER_REPORTSXUNIT` | _(устарела)_ Отчёты в виде `Формат{Путь};Формат{Путь}` |
| `--reportxunit` | - | _(устарела)_ Путь к отчёту jUnit |
| `--xddExitCodePath` | - | Путь к файлу статуса тестирования: `0` - пройдены, `1` - не пройдены |
| `--xddConfig` | - | Путь к конфигурационному файлу xUnitFor1C |
| `--testclient` | - | Тест-клиент: `Пользователь:Пароль:Порт`; `::` или `::Порт` - подставить `--db-user`/`--db-pwd` |
| `--testclient-additional` | - | Дополнительные параметры запуска тест-клиента |
| `--config-tests` | `VRUNNER_CONFIG_TESTS` | Загружать тесты, встроенные в конфигурацию |
| `--no-wait` | - | Не ожидать завершения 1С:Предприятия |
| `--xdddebug` | - | Выводить отладочные сообщения при прогоне |
| `--no-shutdown` | - | Не завершать 1С:Предприятие после тестов |
| `--clear-reports` | - | Очищать каталоги отчётов перед запуском |

> Общие опции: [подключение к ИБ](./common-options#подключение-к-информационной-базе), [платформа](./common-options#платформа), [запуск клиента](./common-options#запуск-клиента), [отчёты](./reports), [покрытие](./coverage), [файл настроек](./common-options#файл-настроек).

Форматы `--report-format`: `junit`, `allure`, `json`, `mxl`, `genericexecution` либо полное имя генератора Vanessa-ADD (`ГенераторОтчетаJUnitXML`, `GenerateReportJUnitXML`, в том числе генератор-плагин). Если задан только `--report-path`, формат - `junit`. Те же форматы принимает устаревшая `--reportsxunit`: `junit{./build/junit.xml};allure{./build/allure}` - её оставили для случая, когда каждому генератору нужен свой путь.

Код возврата vrunner зависит от результата тестов только при заданном `--xddExitCodePath`: после прогона файл читается, значение `1` завершает команду ошибкой. Клиент запускается с ключом `/TESTMANAGER`.

### Примеры

```bash
# Запустить тесты и сформировать JUnit-отчёт
vrunner test xunit \
  --ibconnection /F./ib \
  --report-format junit \
  --report-path ./build/reports/junit.xml \
  --xddExitCodePath ./build/status.txt \
  ./tests

# Два формата за прогон - путь становится каталогом
vrunner test xunit \
  --ibconnection /F./ib \
  --report-format junit \
  --report-format allure \
  --report-path ./build/reports \
  ./tests

# Тесты из расширения, загруженного в базу
vrunner test xunit \
  --ibconnection /F./ib \
  --config-tests \
  --report-format junit \
  --report-path ./build/reports/junit.xml \
  ТестыКонфигурации

# Встроенные дымовые тесты vanessa-add (макрос $addRoot)
vrunner test xunit \
  --ibconnection /F./ib \
  '$addRoot/tests/smoke'

# С тест-клиентом (клиент-серверный режим)
vrunner test xunit \
  --ibconnection "/SMyServer\MyIB" \
  --testclient "Тест:password:1538" \
  --report-format junit \
  --report-path ./build/reports/junit.xml \
  ./tests
```

## yaxunit

Запускает модульные тесты [YAxUnit](https://github.com/bia-technologies/yaxunit). Внешняя обработка не нужна: движок и тесты работают как расширения конфигурации, vrunner формирует файл запуска `yaxunit.json` и запускает 1С:Предприятие с ключом `/C RunUnitTests=<файл>`.

```bash
vrunner test yaxunit [опции]
```

::: warning Подготовка ИБ
Перед запуском в базу должны быть загружены через [`cfe load`](./cfe) расширение-движок YAxUnit и расширения с тестовыми модулями, а конфигурация БД - обновлена (не указывайте `--no-update-db`). Безопасный режим у расширений должен быть выключен, иначе движок не прочитает файл запуска.
:::

### Опции

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--yaxunit-config` | `VRUNNER_YAXUNIT_CONFIG` | Готовый `yaxunit.json` - используется как есть, остальные опции фильтра и отчёта игнорируются |
| `--ext` | `VRUNNER_YAXUNIT_EXT` | Имена расширений с тестами через запятую (`filter.extensions`) |
| `--modules` | - | Имена модулей с тестами через запятую (`filter.modules`) |
| `--tests` | - | Полные имена тестов через запятую: `Модуль.Тест` (`filter.tests`) |
| `--tags` | - | Теги тестов через запятую (`filter.tags`) |
| `--suites` | - | Имена наборов тестов через запятую (`filter.suites`) |
| `--report` | `VRUNNER_YAXUNIT_REPORT` | _(устарела)_ То же, что `--report-path` |
| `--exitcode` | `VRUNNER_YAXUNIT_EXITCODE` | Файл кода возврата, который пишет YAxUnit (`exitCode`): `0` - пройдены, `1` - есть ошибки |
| `--project-path` | `VRUNNER_PROJECT_PATH` | Каталог проекта для зависимостей `ФайлыПроекта` (`projectPath`), по умолчанию - текущий |
| `--workspace` | `VRUNNER_WORKSPACE` | Каталог рабочего пространства YAxUnit (`workspacePath`) |
| `--show-report` | - | Открывать форму отчёта после тестов |
| `--no-close` | - | Не закрывать 1С:Предприятие после тестов |
| `--no-wait` | - | Не ожидать завершения 1С:Предприятия |

> Общие опции: [подключение к ИБ](./common-options#подключение-к-информационной-базе), [платформа](./common-options#платформа), [запуск клиента](./common-options#запуск-клиента), [отчёты](./reports), [покрытие](./coverage), [файл настроек](./common-options#файл-настроек).

Форматы `--report-format`: `junit` (по умолчанию), `json`, `allure` - ровно один за прогон.

Опции фильтра комбинируются по «И»: `--ext МоиТесты --tags smoke` запустит тесты с тегом `smoke` только из расширения `МоиТесты`. Без фильтра выполняются все найденные тесты.

### Результат и код возврата

Если `--report-path` не задан, отчёт jUnit формируется во временном файле. По отчёту jUnit vrunner печатает саммари и выставляет код возврата: `0` - все тесты пройдены, ошибка - есть провалы или ошибки либо отчёт не сформирован (не загружены движок или расширения с тестами). Для форматов `json` и `allure` выводится только путь к отчёту, код возврата от результата не зависит; то же при `--yaxunit-config` без `reportPath`.

```
YAxUnit: всего 12, успешно 11, провалено 1, ошибок 0, пропущено 0
  [x] МойМодуль.ПроверкаСложения - ожидали 4, получили 5
```

### Примеры

```bash
# Минимальный запуск: отчёт во временный файл, саммари в консоль
vrunner test yaxunit --ibconnection /F./ib

# Тесты из расширения с JUnit-отчётом для CI
vrunner test yaxunit \
  --ibconnection /F./ib \
  --ext МоиТесты \
  --report-format junit \
  --report-path ./build/reports/yaxunit.xml

# Только тесты с заданными тегами из конкретных модулей
vrunner test yaxunit \
  --ibconnection /F./ib \
  --modules МодульТестовКаталога,МодульТестовДокумента \
  --tags "smoke,critical"

# Готовый файл запуска
vrunner test yaxunit \
  --ibconnection /F./ib \
  --yaxunit-config ./yaxunit.json
```

Формат `yaxunit.json` описан в [документации YAxUnit](https://bia-technologies.github.io/yaxunit/).

## vanessa

Запускает сценарии в формате Gherkin через обработку `bddRunner.epf` (Vanessa-ADD) и ждёт завершения 1С:Предприятия.

```bash
vrunner test vanessa [опции]
```

### Опции

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--feature-path` | `VRUNNER_FEATUREPATH` | Каталог с фичами или файл `.feature`; поддерживается макрос `$addRoot`. Несовместим с `--ordinaryapp 1` |
| `--bddrunner-path` | `VRUNNER_PATHVANESSA` | Путь к `bddRunner.epf` (по умолчанию из vanessa-add) |
| `--vanessasettings` | `VRUNNER_VANESSASETTINGS` | Файл настроек Vanessa-ADD (`VBParams`); относительный путь и макросы `$workspaceRoot`/`$workspace` разрешаются от `--workspace` |
| `--workspace` | `VRUNNER_WORKSPACE` | Папка проекта (`workspaceRoot`), по умолчанию - текущий каталог |
| `--tags-ignore` | - | Теги игнорирования фич (`TagsIgnore`) |
| `--tags-filter` | - | Теги фильтрации фич (`TagsFilter`) |
| `--additional-keys` | - | Дополнительные параметры, передаваемые в `/C` |
| `--no-wait` | - | Не ожидать завершения 1С:Предприятия |

> Общие опции: [подключение к ИБ](./common-options#подключение-к-информационной-базе), [платформа](./common-options#платформа), [запуск клиента](./common-options#запуск-клиента), [отчёты](./reports), [покрытие](./coverage), [файл настроек](./common-options#файл-настроек).

Путь к фичам передаётся в Vanessa-ADD переменной окружения `VANESSA_FEATUREPATH` и переопределяет `КаталогФич` из файла настроек. Форматы `--report-format`: `junit`, `allure`, `cucumberjson`; для всех путь - каталог, поэтому `--report-path` обязателен. У `bddRunner.epf` нет ключей запуска для отчётов, поэтому vrunner накладывает их на настройки из `--vanessasettings` (исходный файл не меняется, опции командной строки перекрывают одноимённые настройки). Клиент запускается с ключом `/TESTMANAGER`.

### Примеры

```bash
# Запустить все фичи с настройками проекта
vrunner test vanessa \
  --ibconnection /F./ib \
  --feature-path ./features \
  --vanessasettings ./tools/vanessa/vb-params.json

# Фильтр по тегам
vrunner test vanessa \
  --ibconnection /F./ib \
  --feature-path ./features \
  --tags-filter "@smoke" \
  --tags-ignore "@wip"

# Одна фича и отчёты JUnit + Allure в каталог
vrunner test vanessa \
  --ibconnection /F./ib \
  --feature-path ./features/Catalog.feature \
  --report-format junit \
  --report-format allure \
  --report-path ./build/reports
```

Формат файла настроек Vanessa-ADD описан в репозитории [vanessa-add](https://github.com/vanessa-opensource/vanessa-add).

## Покрытие тестами

Все три подкоманды умеют собирать покрытие кода конфигурации и расширений: достаточно указать `--coverage-report` - путь к XML-отчёту (`generic` для SonarQube, `cobertura`, `clover`). Опции `--coverage-*`, сервер отладки и ограничения описаны на странице [Сбор покрытия тестами](./coverage).

```bash
vrunner test yaxunit --ibconnection /F./ib --coverage-report ./build/coverage.xml
```
