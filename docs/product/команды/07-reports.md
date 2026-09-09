---
title: Отчёты о результатах
---

# Отчёты о результатах

Команды, которые проверяют или прогоняют тесты (`validate syntax-check`, `validate edt`, `test xunit`, `test yaxunit`, `test vanessa`), выгружают результат одной парой опций:

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--report-format` | - | Формат отчёта; можно указать несколько раз. Список форматов зависит от команды |
| `--report-path` | `VRUNNER_REPORT_PATH` | Куда выгрузить отчёт: файл - если формат один, каталог - если форматов несколько |

Если не задана ни одна из них, отчёт не формируется (кроме `test yaxunit`, где отчёт всегда пишется во временный файл ради сводки в консоли). Если задан только `--report-path`, подставляется формат по умолчанию - у всех команд `junit`.

## Как разрешается путь

**Один формат** - `--report-path` берётся как есть: для `junit` это файл, для `allure` - каталог.

```bash
vrunner validate syntax-check --report-format junit --report-path ./build/syntax.xml
```

**Несколько форматов** - `--report-path` становится каталогом, имена внутри него берутся по соглашению (см. таблицу ниже):

```bash
vrunner validate syntax-check \
  --report-format junit \
  --report-format allure \
  --report-path ./build/reports
# → ./build/reports/junit.xml
# → ./build/reports/allure/
```

Недостающие каталоги создаются до начала проверки.

## Форматы по командам

| Команда | Форматы | Несколько за прогон | Имя внутри каталога |
|---------|---------|:-------------------:|---------------------|
| `validate syntax-check` | `junit`, `allure` | да | `junit.xml`, `allure/` |
| `validate edt` | `junit`, `allure`, `edt` | да | `junit.xml`, `allure/`, `edt-validate.tsv` |
| `test xunit` | `junit`, `allure`, `json`, `mxl`, `genericexecution` или имя генератора Vanessa-ADD | да | `junit.xml`, `allure/`, `report.json`, `report.mxl`, `generic.xml`; для генератора - его имя |
| `test yaxunit` | `junit`, `json`, `allure` | нет, ровно один | - |
| `test vanessa` | `junit`, `allure`, `cucumberjson` | да | `junit/`, `allure/`, `cucumber/` |

Регистр значений не важен (`junit`, `jUnit`, `JUNIT`). Исключение - имена генераторов Vanessa-ADD в `test xunit`: они регистрозависимы и передаются как написаны.

## Особенности команд

- **`validate edt`**: формат `edt` - сырой файл результатов `1cedtcli validate` (текст, по замечанию на строку, поля через табуляцию); его понимает, например, [edt-ripper](https://github.com/silverbulleters/edt-ripper). Форматы `junit` и `allure` формирует сам vrunner.
- **`test yaxunit`**: отчёт пишет YAxUnit, у него один формат за прогон - два `--report-format` дают ошибку.
- **`test xunit`**: кроме перечисленных алиасов принимается полное имя генератора Vanessa-ADD, в том числе генератора-плагина (`ГенераторОтчетаJUnitXML`, `GenerateReportJUnitXML`). Разные пути для каждого генератора задаёт только устаревшая `--reportsxunit`.
- **`test vanessa`**: у `bddRunner.epf` нет ключей запуска для отчётов, поэтому vrunner накладывает каталоги отчётов на файл из `--vanessasettings` и передаёт в 1С временную копию; опции командной строки перекрывают одноимённые настройки. Путь у `test vanessa` всегда каталог.
- **Allure**: каталог результатов не очищается - Allure собирает отчёт из нескольких прогонов. Нужен чистый каталог - чистите средствами сборки (у `test xunit` есть флаг `--clear-reports`).

## Устаревшие опции

Продолжают работать; для большинства в лог выводится предупреждение с заменой.

| Устаревшая опция | Команда | Замена |
|------------------|---------|--------|
| `--junitpath <файл>` | `validate syntax-check`, `validate edt` | `--report-format junit --report-path <файл>` |
| `--allure-results <каталог>` | `validate syntax-check`, `validate edt` | `--report-format allure --report-path <каталог>` |
| `--reportsxunit "junit{путь}"` | `test xunit` | `--report-format junit --report-path <путь>` |
| `--reportxunit <каталог>` | `test xunit` | `--report-format junit --report-path <каталог>` |
| `--report <путь>` | `test yaxunit` | `--report-path <путь>` |
| `--report <файл>` | `validate edt` | `--report-format edt --report-path <файл>` |

Старые и новые опции складываются; при совпадении формата побеждает `--report-format`/`--report-path`.

Сбор покрытия тестами настраивается отдельно: [Сбор покрытия тестами](./coverage).
