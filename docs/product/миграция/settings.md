---
title: Файл настроек и переменные окружения
---

# Файл настроек и переменные окружения

В 3.0 изменились имя и формат файла настроек и префикс переменных окружения. Формат 3.0 описан на странице [Файл настроек](../настройка/настройки).

## Скрипт конвертации

Скрипт `tools/migrate26to30.os` входит в пакет vanessa-runner (в установленном пакете: `<каталог библиотек OneScript>/vanessa-runner/tools/migrate26to30.os`):

```bash
oscript tools/migrate26to30.os --input env.json --output autumn-properties.json
```

Без параметров читает `vrunner.json` и пишет `autumn-properties.json` в текущем каталоге; для файла 2.x по умолчанию (`env.json`) укажите `--input env.json`. Что делает:

- убирает префикс `--` у ключей и раскладывает секции команд по иерархии 3.0 (таблица ниже);
- переименовывает ключи `inputPath` → `src`, `outputPath` → `out`, `extensionName` → `extension-name`, `pathvanessa` → `bddrunner-path`, `testsPath` → `testspath`;
- у значений `mode` в `syntax-check` убирает ведущий дефис (`-ThinClient` → `ThinClient`);
- в `updatedb` заменяет флаги `--v1`/`--v2` ключом `rtype`;
- предупреждает об устаревшем ключе `--reportxunit`.

Секции `init-dev`, `update-dev`, `init-project` и неизвестные секции (в том числе `session`, `scheduledjobs`) не конвертируются: скрипт выводит предупреждение, записывает остальные секции и завершается с кодом 1. Остальные ключи переносятся как есть, поэтому опции, переименованные в 3.0 (`ibname` → `ibconnection`, `path` → `feature-path` у `vanessa`, `in` → `cf-file` у `decompile`), правятся вручную — см. страницы команд.

## Формат

| | 2.x | 3.0 |
|---|-----|-----|
| Имя файла | `env.json` или файл из `--settings` | `autumn-properties.json` |
| Ключ опции | `"--ibconnection"` | `"ibconnection"` |
| Общие настройки | секция `default` | корень `vrunner` |
| Настройки команды | секция `xunit` | вложенный объект `vrunner.test.xunit` |
| Позиционный аргумент | `testsPath` (у `compile` — опция `--out`) | имя аргумента в нижнем регистре: `testspath`, `out` |

Ключ в корне `vrunner` действует для всех команд, ключ в объекте команды — только для неё и её подкоманд.

Подстановка переменных окружения `${ИМЯ}` в значения файла настроек и макросы `$workspaceRoot`/`$runnerRoot` в значениях опций в 3.0 не поддерживаются; исключения — `$runnerRoot` в `--execute` команды `run enterprise` и `$workspaceRoot` в `--vanessasettings` команды `test vanessa`.

## Маппинг секций

| Секция 2.x | Путь 3.0 |
|------------|----------|
| `default` | `vrunner` |
| `xunit` | `vrunner.test.xunit` |
| `vanessa` | `vrunner.test.vanessa` |
| `syntax-check` | `vrunner.validate.syntax-check` |
| `compile` | `vrunner.cf.compile` |
| `decompile` | `vrunner.cf.decompile` |
| `compileepf` | `vrunner.epf.compile` |
| `decompileepf` | `vrunner.epf.decompile` |
| `compileext` | `vrunner.cfe.compile` |
| `decompileext` | `vrunner.cfe.decompile` |
| `updatedb` | `vrunner.infobase.update` |
| `update` | `vrunner.cf.vendor-update` |
| `run` | `vrunner.run.enterprise` |
| `loadrepo` | `vrunner.repo.load` |
| `designer` | `vrunner.run.designer` |
| `init-dev`, `update-dev`, `init-project` | не конвертируются: [init-dev](./init-dev), [init-project](./init-project) |

## Пример

Было (`env.json`):

```json
{
  "default": {
    "--ibconnection": "/F./build/ib",
    "--v8version": "8.3.24"
  },
  "xunit": {
    "testsPath": "./tests",
    "--reportsxunit": "ГенераторОтчетаJUnitXML{build/junit.xml}"
  },
  "syntax-check": {
    "--groupbymetadata": true,
    "--mode": ["-ThinClient", "-Server"]
  },
  "updatedb": {
    "--uccode": "godModeOn",
    "--v2": true
  }
}
```

Стало (`autumn-properties.json`):

```json
{
  "vrunner": {
    "ibconnection": "/F./build/ib",
    "v8version": "8.3.24",
    "test": {
      "xunit": {
        "testspath": "./tests",
        "reportsxunit": "ГенераторОтчетаJUnitXML{build/junit.xml}"
      }
    },
    "validate": {
      "syntax-check": {
        "groupbymetadata": true,
        "mode": ["ThinClient", "Server"]
      }
    },
    "infobase": {
      "update": {
        "uccode": "godModeOn",
        "rtype": "v2"
      }
    }
  }
}
```

## Переменные окружения

Префикс `RUNNER_` заменён на `VRUNNER_`. Обновите переменные в CI-файлах и скриптах сборки. Полный список переменных 3.0 — [Переменные окружения](../настройка/переменные-окружения).

| 2.x | 3.0 |
|-----|-----|
| `RUNNER_IBCONNECTION` | `VRUNNER_IBCONNECTION` |
| `RUNNER_IBNAME` (строка подключения) | `VRUNNER_IBCONNECTION` |
| `RUNNER_DBUSER` | `VRUNNER_DBUSER` |
| `RUNNER_DBPWD` | `VRUNNER_DBPWD` |
| `RUNNER_UCCODE` | `VRUNNER_UCCODE` |
| `RUNNER_V8VERSION` | `VRUNNER_V8VERSION` |
| `RUNNER_LANGUAGE` | `VRUNNER_LANGUAGE` |
| `RUNNER_LOCALE` | `VRUNNER_LOCALE` |
| `RUNNER_SRC` | `VRUNNER_SRC` (у `infobase init`/`update` — `VRUNNER_SOURCE`) |
| `RUNNER_DBMS_*` (`TYPE`, `SERVER`, `BASE`, `USER`, `PWD`) | `VRUNNER_DBMS_*` с теми же суффиксами |
| `RUNNER_CLUSTERADMIN_USER` | `VRUNNER_CLUSTERADMIN_USER` |
| `RUNNER_CLUSTERADMIN_PWD` | `VRUNNER_CLUSTERADMIN_PWD` |
| `RUNNER_VANESSASETTINGS` | `VRUNNER_VANESSASETTINGS` |
| `RUNNER_PATHVANESSA` | `VRUNNER_PATHVANESSA` |
| `RUNNER_WORKSPACE` | `VRUNNER_WORKSPACE` |
| `RUNNER_TESTSPATH` | `VRUNNER_TESTSPATH` |
| `RUNNER_PATHXUNIT` | `VRUNNER_PATHXUNIT` |
| `RUNNER_CONFIG_TESTS` | `VRUNNER_CONFIG_TESTS` |
| `RUNNER_STORAGE_NAME` | `VRUNNER_STORAGE_NAME` |
| `RUNNER_STORAGE_USER` | `VRUNNER_STORAGE_USER` |
| `RUNNER_STORAGE_PWD` | `VRUNNER_STORAGE_PWD` |
| `RUNNER_STORAGE_VER` | `VRUNNER_STORAGE_VER` |
| `RUNNER_ROOT`, `RUNNER_NOCACHEUSE` | нет аналогов |

`VRUNNER_IBNAME` в 3.0 — имя базы в кластере (`--db-name`) для команд `cluster`, а не строка подключения.

## Опция --settings

`--settings <файл>` (`VRUNNER_SETTINGS`) сохранена, но файл читается в формате `autumn-properties.json`. Порядок применения файлов, переменных окружения и командной строки — [Каскад приоритетов](../настройка/настройки#приоритеты). `env.json` 2.x — основной файл проекта, ему соответствует `autumn-properties.json`; личные настройки выносятся в локальный файл, на который проектный `autumn-properties.json` ссылается ключом `settings`: [Опция settings](../настройка/настройки#опция-settings).
