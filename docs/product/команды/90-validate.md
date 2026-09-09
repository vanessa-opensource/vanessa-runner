---
title: validate
---

# validate - Проверка конфигурации

Статическая проверка: синтаксический контроль конфигурации через Конфигуратор и проверка проекта средствами 1С:EDT. Обе команды печатают замечания в лог, выгружают их в отчёт для CI ([Отчёты о результатах](./reports)) и завершаются с ошибкой при наличии замечаний.

```bash
vrunner validate <подкоманда> [опции]
```

## syntax-check

Выполняет проверку конфигурации Конфигуратором (`/CheckConfig`) в указанных режимах и по указанным целям. Без `--ibconnection` проверка выполняется во временной файловой базе - это имеет смысл вместе с `--storage-name`: конфигурация берётся из хранилища.

```bash
vrunner validate syntax-check [опции]
```

### Опции

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--mode` | - | Режим проверки; можно указать несколько раз. По умолчанию: `ThinClient`, `WebClient`, `Server`, `ExternalConnection`, `ThickClientOrdinaryApplication` |
| `--target` | - | Что проверять: `main`, `AllExtensions` или имя расширения; можно указать несколько раз. По умолчанию - всё |
| `--junitpath` | `VRUNNER_JUNITPATH` | _(устарела)_ Путь к файлу отчёта JUnit XML |
| `--allure-results` | `VRUNNER_ALLURE_RESULTS` | _(устарела)_ Каталог результатов Allure 2 |
| `--exception-file` | - | Файл исключений: UTF-8, по одной подстроке замечания на строку |
| `--groupbymetadata` | - | Группировать замечания в отчётах по объектам метаданных |
| `--testsuitename` | - | Имя тестового набора в отчёте (по умолчанию `syntax-check`) |

> Общие опции: [подключение к ИБ](./common-options#подключение-к-информационной-базе), [платформа](./common-options#платформа), [СУБД](./common-options#опции-субд), [хранилище конфигурации](./common-options#хранилище-конфигурации), [отчёты](./reports), [файл настроек](./common-options#файл-настроек).

Форматы `--report-format`: `junit` (по умолчанию), `allure`. Код возврата `1`, если после фильтрации исключениями остались замечания.

### Что проверять (--target)

Область проверки у платформы взаимоисключающая: за один запуск Конфигуратор проверяет либо основную конфигурацию, либо расширения. Поэтому каждая цель `--target` - отдельный запуск Конфигуратора и отдельная полная проверка.

| Значение | Что проверяется |
|----------|-----------------|
| _не указано_ | основная конфигурация и все расширения (два запуска) |
| `main` | только основная конфигурация |
| `AllExtensions` | все расширения базы одним запуском |
| `<имя расширения>` | только это расширение; имя - как в базе (`vrunner infobase extensions list`) |

- `AllExtensions` поглощает перечисленные поимённо расширения: `--target Расш1 --target AllExtensions` даст один запуск по всем расширениям.
- Порядок запусков: сначала основная конфигурация, затем расширения в порядке перечисления.
- Если расширения с таким именем в базе нет, команда завершается ошибкой.
- Значение `AllExtensions` в `--mode` (способ 2.x) равносильно `--target AllExtensions`.

### Режимы проверки (--mode)

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
| `CheckUseSynchronousCalls` | Поиск использования синхронных вызовов |
| `UnsupportedFunctional` | Поиск неподдерживаемой функциональности |
| `AllExtensions` | Проверка всех расширений (то же, что `--target AllExtensions`) |

### Файл исключений

Каждая строка файла `--exception-file` - подстрока замечания, которое нужно пропустить (регистр не важен). Многострочные замечания Конфигуратора склеиваются в одну строку, так что подстрока может быть и из фрагмента кода. Всегда пропускаются сообщения об обработчиках `Подключаемый_` (нет ссылок на процедуру, пустой обработчик). Если файл не найден, выводится предупреждение и проверка идёт без него.

### Структура отчёта

По умолчанию каждое замечание - отдельный тест-кейс с текстом замечания в имени. С `--groupbymetadata` тест-кейс создаётся на объект метаданных, а все его замечания попадают в `failure` по строке на каждое; у объектов расширения в имя входит имя расширения (`ТестРасширения ОбщийМодуль.Расш1_Модуль1.Модуль`). Замечания без привязки к объекту собираются в тест-кейс `Синтаксическая проверка конфигурации`. Успешная проверка тоже даёт один тест-кейс - пустой отчёт неотличим от прогона, который до отчёта не дошёл.

В результатах Allure у кейса проставляются метки `suite` (значение `--testsuitename`), `package` (объект метаданных) и `severity`.

### Примеры

```bash
# Несколько режимов, отчёт JUnit
vrunner validate syntax-check \
  --ibconnection /F./ib \
  --mode ThinClient \
  --mode Server \
  --mode WebClient \
  --report-format junit \
  --report-path ./build/reports/syntax.xml

# Только основная конфигурация, группировка по метаданным, файл исключений
vrunner validate syntax-check \
  --ibconnection /F./ib \
  --target main \
  --groupbymetadata \
  --exception-file ./syntax-check-exceptions.txt \
  --testsuitename "MyProject syntax check" \
  --report-format junit \
  --report-path ./build/reports/syntax.xml

# Конкретные расширения - по запуску на каждое
vrunner validate syntax-check --ibconnection /F./ib --target Расш1 --target Расш2

# JUnit и Allure за один прогон - путь становится каталогом
vrunner validate syntax-check \
  --ibconnection /F./ib \
  --report-format junit \
  --report-format allure \
  --report-path ./build/reports
```

## edt

Выполняет штатную проверку EDT-проекта (`1cedtcli validate`), разбирает замечания и завершается с ошибкой, если есть замечания не ниже уровня `--min-severity`.

```bash
vrunner validate edt [опции]
```

### Опции

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--src`, `-s` | `VRUNNER_SRC` | Каталог EDT-проекта (по умолчанию - текущий) |
| `--min-severity` | - | Уровень замечаний, начиная с которого команда завершается с ошибкой: `critical`, `major` (по умолчанию), `minor`, `none` |
| `--report` | `VRUNNER_EDT_REPORT` | _(устарела)_ Файл результатов в исходном формате 1С:EDT |
| `--junitpath` | `VRUNNER_JUNITPATH` | _(устарела)_ Путь к файлу отчёта JUnit XML |
| `--allure-results` | `VRUNNER_ALLURE_RESULTS` | _(устарела)_ Каталог результатов Allure 2 |
| `--testsuitename` | - | Имя тестового набора в отчёте (по умолчанию `edt`) |

> Общие опции: [формат исходников](./common-options#формат-исходников), [EDT (`--edt-*`)](./edt), [отчёты](./reports), [файл настроек](./common-options#файл-настроек).

Форматы `--report-format`: `junit` (по умолчанию), `allure`, `edt`. Формат `edt` - сырой файл результатов `1cedtcli validate` (текст, по замечанию на строку, поля через табуляцию), который принимает, например, [edt-ripper](https://github.com/silverbulleters/edt-ripper) для загрузки в SonarQube.

### Уровни важности (--min-severity)

| Значение | Команда завершается с ошибкой |
|----------|-------------------------------|
| `critical` | только при критических замечаниях |
| `major` | при значительных и критических (по умолчанию) |
| `minor` | при любых замечаниях |
| `none` | никогда - только отчёт |

В отчётах все замечания присутствуют независимо от порога: в JUnit блокирующие помечены как `failure`, в Allure - статус `failed`, остальные - `broken`. Метка `package` кейса Allure - категория замечания EDT, `severity` - его уровень (`critical`, `normal`, `minor`). Если `1cedtcli` не создал файл результатов, команда завершается ошибкой с его выводом.

### Примеры

```bash
# Проверить EDT-проект в текущем каталоге (порог по умолчанию - major)
vrunner validate edt

# Конкретный проект и версия EDT, отчёт JUnit для CI
vrunner validate edt \
  --src ./edt-project \
  --edt-version 2024.1 \
  --report-format junit \
  --report-path ./build/reports/edt.xml

# Не падать на замечаниях, только собрать отчёт
vrunner validate edt --src ./edt-project --min-severity none --report-format junit --report-path ./build/reports/edt.xml

# Исходный отчёт EDT для SonarQube через edt-ripper
vrunner validate edt --src ./edt-project --min-severity none --report-format edt --report-path ./build/reports/edt-validate.tsv

# Несколько форматов за один прогон - путь становится каталогом
vrunner validate edt --src ./edt-project --report-format junit --report-format edt --report-path ./build/reports
```
