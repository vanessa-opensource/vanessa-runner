---
title: xunit
---

# vrunner xunit

Запускает модульные тесты через Vanessa-ADD (xUnit for 1C). Открывает 1С:Предприятие, загружает обработку `xddTestRunner.epf` и запускает тесты из указанного каталога или файла.

::: warning Изменено в 3.0
`vrunner xunit` переименована в `vrunner test xunit` — вошла в группу `test`.

[Документация test xunit →](../команды/test#xunit)
:::

## Изменения

| Аспект | 2.x | 3.0 |
|--------|-----|-----|
| Команда | `vrunner xunit` | `vrunner test xunit` |
| Отчёты | `--reportsxunit "Генератор{путь}"` | `--report-format <формат> --report-path <путь>` — [подробнее](../команды/reports) |
| `--reportxunit` | Поддерживается | Устарела |
| `--reportsxunit` | Имена генераторов Vanessa-ADD | Устарела; принимает краткие форматы (`junit{путь};allure{путь}`) **и** имена генераторов |
| Переменные окружения | `RUNNER_TESTSPATH`, `RUNNER_PATHXUNIT` | `VRUNNER_TESTSPATH`, `VRUNNER_PATHXUNIT` |
| Секция в настройках | `"xunit"` | `"vrunner.test.xunit"` |

::: warning Формат --reportsxunit
В 2.x указывались полные имена генераторов Vanessa-ADD:
`ГенераторОтчетаJUnitXML{./build/junit.xml}`

В 3.0 добавлены краткие форматы (регистр не важен):

| Краткий формат | Генератор Vanessa-ADD |
|----------------|-----------------------|
| `junit` | `ГенераторОтчетаJUnitXML` |
| `allure` | `ГенераторОтчетаAllureXMLВерсия2` |
| `json` | `ГенераторОтчетаJSON` |
| `mxl` | `ГенераторОтчетаMXL` |
| `genericexecution` | `ГенераторОтчетаGenericExecution` |

Полные имена генераторов из 2.x (`ГенераторОтчета*{путь}`, `GenerateReport*{путь}`) по-прежнему принимаются — старые строки запуска работают без изменений. Это позволяет использовать и генераторы-плагины, которых нет в кратком списке (например, `ГенераторОтчетаJUnitXML_TFS`).

Сама опция `--reportsxunit` при этом устарела: обычный способ — `--report-format junit --report-path ./build/reports/junit.xml`. Скобочный синтаксис остаётся для случая, когда каждому формату нужен свой отдельный путь.
:::

::: warning Порядок аргументов
В 3.0 опции указываются **до** позиционного аргумента `TESTSPATH`: `vrunner test xunit --reportsxunit "junit{...}" ./tests`. Вариант 2.x с опциями после пути к тестам (`vrunner xunit ./tests --reportsxunit ...`) парсер 3.0 пока не принимает.
:::

## Примеры

### Было (2.x)

```bash
# Запуск тестов с JUnit-отчётом (старый формат)
vrunner xunit ./tests \
  --ibconnection /F./build/ib \
  --reportsxunit "ГенераторОтчетаJUnitXML{build/junit.xml}"

# Запуск через ключ --settings
vrunner xunit --settings tools/vrunner.json
```

### Стало (3.0)

```bash
# Запуск тестов с JUnit-отчётом
vrunner test xunit \
  --ibconnection /F./build/ib \
  --report-format junit \
  --report-path ./build/reports/junit.xml \
  ./tests

# Несколько форматов одновременно - путь становится каталогом
vrunner test xunit \
  --ibconnection /F./build/ib \
  --report-format junit \
  --report-format allure \
  --report-path ./build/reports \
  ./tests
```

## Файл настроек

### Было (`vrunner.json`)

```json
{
  "default": {
    "--ibconnection": "/F./build/ib",
    "--db-user": "Администратор",
    "--db-pwd": ""
  },
  "xunit": {
    "testsPath": "./tests",
    "--reportsxunit": "ГенераторОтчетаJUnitXML{build/junit/xddreport.xml};ГенераторОтчетаAllureXML{build/allure/allure-testsuite.xml}",
    "--xddExitCodePath": "build/xddExitCodePath.txt",
    "--testclient": "Автотест:123:48223"
  }
}
```

### Стало (`autumn-properties.json`)

```json
{
  "vrunner": {
    "ibconnection": "/F./build/ib",
    "db-user": "Администратор",
    "db-pwd": "",
    "test": {
      "xunit": {
        "report-format": ["junit", "allure"],
        "report-path": "./build/reports",
        "xddExitCodePath": "build/xddExitCodePath.txt",
        "testclient": "Автотест:123:48223"
      }
    }
  }
}
```

::: tip
Позиционный аргумент `testsPath` из конфига 2.x не поддерживается в `autumn-properties.json`. Путь к тестам передавайте позиционным аргументом в командной строке или через переменную окружения `VRUNNER_TESTSPATH`.
:::

## Встроенные тесты vanessa-add и макрос `$addRoot`

Макрос `$addRoot` (каталог установки библиотеки Vanessa-ADD) сохранён в 3.0. Он раскрывается в аргументе `TESTSPATH` команды `test xunit` (и в `--feature-path` команды `test vanessa`).

Запуск встроенных дымовых тестов Vanessa-ADD, как в 2.x:

```bash
# Было (2.x)
vrunner xunit "$addRoot/tests/smoke" --ibconnection /F./build/ib

# Стало (3.0) - опции указываются до пути к тестам
vrunner test xunit --ibconnection /F./build/ib "$addRoot/tests/smoke"
```

`$addRoot` указывает на каталог `<каталог установки oscript>/lib/add`, где лежат `xddTestRunner.epf`, `bddRunner.epf` и встроенные тесты (`tests/smoke`).

::: warning
В POSIX-оболочках `$addRoot` может быть воспринят как переменная окружения. Заключайте путь в одинарные кавычки или экранируйте `$`, чтобы макрос дошёл до vrunner буквально:

```bash
vrunner test xunit --ibconnection /F./build/ib '$addRoot/tests/smoke'
```
:::
