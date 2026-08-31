---
title: syntax-check
---

# vrunner syntax-check

Выполняет синтаксическую проверку конфигурации через конфигуратор в указанных режимах клиента. Формирует JUnit-совместимый отчёт и/или результаты Allure.

::: warning Изменено в 3.0
`vrunner syntax-check` переименована в `vrunner validate syntax-check` — вошла в группу `validate`. Изменился формат задания режимов проверки: значения больше не пишутся с ведущим дефисом.

[Документация validate syntax-check →](../команды/validate#syntax-check)
:::

## Изменения

| Аспект | 2.x | 3.0 |
|--------|-----|-----|
| Команда | `vrunner syntax-check` | `vrunner validate syntax-check` |
| Значения `--mode` | `-ThinClient`, `-Server` (с дефисом) | `ThinClient`, `Server` (без дефиса) |
| `--groupbymetadata` | `--groupbymetadata true` | `--groupbymetadata` (флаг) |
| Область проверки | Только основная конфигурация (`-AllExtensions` в `--mode` - только расширения) | По умолчанию конфигурация **и** все расширения; сужается опцией `--target` |
| `--exception-file` | Поддерживается | Поддерживается |
| JUnit-отчёт | _(не документирован)_ | `--report-format junit --report-path ./build/syntax.xml` |
| Отчёт Allure | `--allure-results` (Allure 1, XML) и `--allure-results2` (Allure 2, JSON) | `--report-format allure --report-path ./build/allure-results` (Allure 2, JSON) |
| Секция в настройках | `"syntax-check"` | `"vrunner.validate.syntax-check"` |

::: danger Важно: формат режимов проверки
В 2.x режимы задавались со знаком `-` как часть значения:
```
--mode "-ThinClient" "-Server" "-WebClient"
```

В 3.0 ведущий дефис убран — режимы задаются без него:
```
--mode ThinClient --mode Server --mode WebClient
```

Значения с ведущим дефисом в командной строке 3.0 будут восприниматься как неизвестные ключи.
:::

::: danger Важно: отчёты задаются общей парой опций
В 2.x у каждого формата была своя опция: `--junitpath` для JUnit, `--allure-results` для Allure 1 (XML с пространством имён `urn:model.allure.qatools.yandex.ru`) и `--allure-results2` для Allure 2 (JSON).

В 3.0 формат и путь задаются одинаково во всех командах, которые выгружают результат:

```
--report-format junit  --report-path ./build/syntax.xml
--report-format allure --report-path ./build/allure-results

# оба формата за прогон - путь становится каталогом
--report-format junit --report-format allure --report-path ./build/reports
```

Allure 1 не поддерживается - формат заброшен, а результаты Allure 2 читают все актуальные версии генератора отчётов. Опция `--allure-results2` убрана; `--junitpath` и `--allure-results` продолжают работать, но выводят предупреждение. Тем, кто собирал отчёт из XML-результатов Allure 1, потребуется перейти на Allure 2.

Подробнее: [Отчёты о результатах](../команды/reports).
:::

## Примеры

### Было (2.x)

```bash
vrunner syntax-check \
  --ibconnection /F./build/ib \
  --groupbymetadata true \
  --exception-file ./syntax-check-exceptions.txt \
  --mode "-ExtendedModulesCheck" "-ThinClient" "-WebClient" "-Server" \
    "-ExternalConnection" "-ThickClientOrdinaryApplication"
```

### Стало (3.0)

```bash
vrunner validate syntax-check \
  --ibconnection /F./build/ib \
  --groupbymetadata \
  --exception-file ./syntax-check-exceptions.txt \
  --report-format junit \
  --report-path ./build/reports/syntax.xml \
  --mode ExtendedModulesCheck \
  --mode ThinClient \
  --mode WebClient \
  --mode Server \
  --mode ExternalConnection \
  --mode ThickClientOrdinaryApplication
```

## Файл настроек

### Было (`vrunner.json`)

```json
{
  "syntax-check": {
    "--groupbymetadata": true,
    "--exception-file": "./syntax-check-exceptions.txt",
    "--mode": [
      "-ExtendedModulesCheck",
      "-ThinClient",
      "-WebClient",
      "-Server",
      "-ExternalConnection",
      "-ThickClientOrdinaryApplication"
    ]
  }
}
```

### Стало (`autumn-properties.json`)

```json
{
  "vrunner": {
    "validate": {
      "syntax-check": {
        "groupbymetadata": true,
        "exception-file": "./syntax-check-exceptions.txt",
        "report-format": ["junit"],
        "report-path": "./build/reports/syntax.xml",
        "mode": [
          "ExtendedModulesCheck",
          "ThinClient",
          "WebClient",
          "Server",
          "ExternalConnection",
          "ThickClientOrdinaryApplication"
        ]
      }
    }
  }
}
```

## Полный список режимов

| Режим (3.0, без дефиса) | Описание |
|------------------------|----------|
| `ThinClient` | Тонкий клиент |
| `WebClient` | Веб-клиент |
| `Server` | Сервер |
| `ExternalConnection` | Внешнее соединение |
| `ThickClientManagedApplication` | Толстый клиент (управляемое приложение) |
| `ThickClientOrdinaryApplication` | Толстый клиент (обычное приложение) |
| `ExtendedModulesCheck` | Расширенная проверка модулей |
| `ConfigLogIntegrity` | Проверка логической целостности |
| `UnreferenceProcedures` | Поиск неиспользуемых процедур |
| `EmptyHandlers` | Поиск пустых обработчиков |
| `AllExtensions` | Проверка всех расширений |

Полный список: [validate syntax-check →](../команды/validate#syntax-check)
