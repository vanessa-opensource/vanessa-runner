---
title: syntax-check
---

# vrunner syntax-check

Синтаксическая проверка конфигурации конфигуратором. В 3.0 — `vrunner validate syntax-check`: [документация](../команды/validate#syntax-check).

## Соответствие

| 2.x | 3.0 |
|-----|-----|
| `vrunner syntax-check` | `vrunner validate syntax-check` |
| `--mode "-ThinClient" "-Server"` (значения с дефисом) | `--mode ThinClient --mode Server` (без дефиса, опция повторяется) |
| `--groupbymetadata true` | `--groupbymetadata` (флаг) |
| `--exception-file <файл>` | без изменений |
| `--junitpath <файл>` | устарела; `--report-format junit --report-path <файл>` — [Отчёты](../команды/reports) |
| `--allure-results <каталог>` (Allure 1, XML) | `--report-format allure --report-path <каталог>` (Allure 2, JSON); `--allure-results` работает, но устарела и пишет Allure 2 |
| `--allure-results2 <каталог>` | убрана; `--report-format allure --report-path <каталог>` |
| Область проверки: основная конфигурация; расширения — режимом `-AllExtensions` | По умолчанию конфигурация и все расширения; `--target main`, `--target AllExtensions` или `--target <имя>` сужают область |
| Секция настроек `syntax-check` | `vrunner.validate.syntax-check`; дефисы в `mode` скрипт конвертации убирает |

Значение `--mode` с ведущим дефисом в 3.0 воспринимается как неизвестная опция. Несколько форматов отчёта: `--report-format junit --report-format allure --report-path ./build/reports` — путь становится каталогом.

## Пример

Было (2.x):

```bash
vrunner syntax-check \
  --ibconnection /F./build/ib \
  --groupbymetadata true \
  --exception-file ./syntax-check-exceptions.txt \
  --junitpath ./build/syntax.xml \
  --mode "-ExtendedModulesCheck" "-ThinClient" "-Server"
```

Стало (3.0):

```bash
vrunner validate syntax-check \
  --ibconnection /F./build/ib \
  --groupbymetadata \
  --exception-file ./syntax-check-exceptions.txt \
  --report-format junit \
  --report-path ./build/syntax.xml \
  --mode ExtendedModulesCheck \
  --mode ThinClient \
  --mode Server
```

Файл настроек — было (`vrunner.json`):

```json
{
  "syntax-check": {
    "--groupbymetadata": true,
    "--exception-file": "./syntax-check-exceptions.txt",
    "--mode": ["-ExtendedModulesCheck", "-ThinClient", "-Server"]
  }
}
```

Стало (`autumn-properties.json`):

```json
{
  "vrunner": {
    "validate": {
      "syntax-check": {
        "groupbymetadata": true,
        "exception-file": "./syntax-check-exceptions.txt",
        "report-format": ["junit"],
        "report-path": "./build/syntax.xml",
        "mode": ["ExtendedModulesCheck", "ThinClient", "Server"]
      }
    }
  }
}
```
