---
title: xunit
---

# vrunner xunit

Запуск модульных тестов xUnitFor1C (`xddTestRunner.epf`). В 3.0 — `vrunner test xunit <TESTSPATH>`: [документация](../команды/test#xunit).

## Соответствие

| 2.x | 3.0 |
|-----|-----|
| `vrunner xunit <путь> [опции]` | `vrunner test xunit [опции] <TESTSPATH>` — опции до пути к тестам |
| `--reportsxunit "ГенераторОтчетаJUnitXML{путь}"` | `--report-format junit --report-path <путь>` — [Отчёты](../команды/reports). `--reportsxunit` работает, но устарела; кроме имён генераторов принимает краткие форматы `junit`, `allure`, `json`, `mxl`, `genericexecution` |
| `--reportxunit <каталог>` | устарела; `--report-format junit --report-path <путь>` |
| `--pathxunit`, `--workspace`, `--xddExitCodePath`, `--xddConfig`, `--testclient`, `--config-tests` | без изменений |
| `$addRoot/tests/smoke` | без изменений; `$addRoot` — каталог установки vanessa-add |
| `RUNNER_TESTSPATH`, `RUNNER_PATHXUNIT`, `RUNNER_CONFIG_TESTS` | `VRUNNER_TESTSPATH`, `VRUNNER_PATHXUNIT`, `VRUNNER_CONFIG_TESTS` |
| Секция настроек `xunit`, ключ `testsPath` | `vrunner.test.xunit`, ключ `testspath` (скрипт конвертации переименовывает) |

Несколько форматов за один прогон: `--report-format junit --report-format allure --report-path ./build/reports` — путь становится каталогом.

## Пример

Было (2.x):

```bash
vrunner xunit ./tests \
  --ibconnection /F./build/ib \
  --reportsxunit "ГенераторОтчетаJUnitXML{build/junit.xml}"
```

Стало (3.0):

```bash
vrunner test xunit \
  --ibconnection /F./build/ib \
  --report-format junit \
  --report-path ./build/junit.xml \
  ./tests
```

Файл настроек — было (`vrunner.json`):

```json
{
  "xunit": {
    "testsPath": "./tests",
    "--reportsxunit": "ГенераторОтчетаJUnitXML{build/junit.xml};ГенераторОтчетаAllureXMLВерсия2{build/allure}",
    "--xddExitCodePath": "build/xddExitCodePath.txt"
  }
}
```

Стало (`autumn-properties.json`):

```json
{
  "vrunner": {
    "test": {
      "xunit": {
        "testspath": "./tests",
        "report-format": ["junit", "allure"],
        "report-path": "./build/reports",
        "xddExitCodePath": "build/xddExitCodePath.txt"
      }
    }
  }
}
```

В POSIX-оболочках `$addRoot` экранируйте, чтобы макрос дошёл до vrunner: `vrunner test xunit --ibconnection /F./build/ib '$addRoot/tests/smoke'`.
