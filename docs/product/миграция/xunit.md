---
title: vrunner xunit → vrunner test xunit
---

# vrunner xunit

Запускает модульные тесты через Vanessa-ADD (xUnit for 1C). Открывает 1С:Предприятие, загружает обработку `xddTestRunner.epf` и запускает тесты из указанного каталога или файла.

::: warning Изменено в 3.0
`vrunner xunit` переименована в `vrunner test xunit` — вошла в группу `test`.

[Документация test xunit →](../команды/80-test#xunit)
:::

## Изменения

| Аспект | 2.x | 3.0 |
|--------|-----|-----|
| Команда | `vrunner xunit` | `vrunner test xunit` |
| `--reportxunit` | Поддерживается | Устарел — используйте `--reportsxunit` |
| Формат отчёта `--reportxunit` | Путь к каталогу | Устарел |
| `--reportsxunit` | Устаревший формат русских генераторов | Поддерживается: `jUnit{путь};HTML{путь}` |
| Переменные окружения | `RUNNER_TESTSPATH`, `RUNNER_PATHXUNIT` | `VRUNNER_TESTSPATH`, `VRUNNER_PATHXUNIT` |
| Секция в настройках | `"xunit"` | `"runner.test.xunit"` |

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
  "runner": {
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
