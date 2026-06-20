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
| `--reportxunit` | Поддерживается | Устарел — используйте `--reportsxunit` |
| Формат отчёта `--reportxunit` | Путь к каталогу | Устарел |
| `--reportsxunit` | Устаревший формат русских генераторов | Поддерживается: `jUnit{путь};HTML{путь}` |
| Переменные окружения | `RUNNER_TESTSPATH`, `RUNNER_PATHXUNIT` | `VRUNNER_TESTSPATH`, `VRUNNER_PATHXUNIT` |
| Секция в настройках | `"xunit"` | `"vrunner.test.xunit"` |

::: warning Формат --reportsxunit
В 2.x имена генераторов были на русском языке:
`ГенераторОтчетаJUnitXML{./build/junit.xml}`

В 3.0 используйте краткие англоязычные форматы:
`jUnit{./build/junit.xml}`

Поддерживаемые форматы: `jUnit`, `HTML`, `allure`, `GenericExecution`.
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
vrunner test xunit ./tests \
  --ibconnection /F./build/ib \
  --reportsxunit "jUnit{./build/reports/junit.xml}"

# Несколько форматов одновременно
vrunner test xunit ./tests \
  --ibconnection /F./build/ib \
  --reportsxunit "jUnit{./build/reports/junit.xml};allure{./build/reports/allure}"
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
        "reportsxunit": "jUnit{./build/reports/junit.xml};allure{./build/reports/allure}",
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

# Стало (3.0)
vrunner test xunit "$addRoot/tests/smoke" --ibconnection /F./build/ib
```

`$addRoot` указывает на каталог `<каталог установки oscript>/lib/add`, где лежат `xddTestRunner.epf`, `bddRunner.epf` и встроенные тесты (`tests/smoke`).

::: warning
В POSIX-оболочках `$addRoot` может быть воспринят как переменная окружения. Заключайте путь в одинарные кавычки или экранируйте `$`, чтобы макрос дошёл до vrunner буквально:

```bash
vrunner test xunit '$addRoot/tests/smoke' --ibconnection /F./build/ib
```
:::
