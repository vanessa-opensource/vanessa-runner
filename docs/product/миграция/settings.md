---
title: Файл настроек и переменные окружения
---

# Файл настроек и переменные окружения

В 3.0 изменились имя и формат файла настроек и префикс переменных окружения. Формат 3.0 описан на странице [Файл настроек](../настройка/настройки).

## Скрипт конвертации

Скрипт `tools/migrate26to30.os` входит в пакет vanessa-runner (в установленном пакете: `<каталог библиотек OneScript>/vanessa-runner/tools/migrate26to30.os`):

```bash
oscript tools/migrate26to30.os --input vrunner.json --output autumn-properties.json
```

Без параметров читает `vrunner.json` и пишет `autumn-properties.json` в текущем каталоге. Что делает:

- убирает префикс `--` у ключей и раскладывает секции команд по иерархии 3.0 (таблица ниже);
- переименовывает ключи `inputPath` → `src`, `outputPath` → `out`, `extensionName` → `extension-name`, `pathvanessa` → `bddrunner-path`, `testsPath` → `testspath`;
- у значений `mode` в `syntax-check` убирает ведущий дефис (`-ThinClient` → `ThinClient`);
- в `updatedb` заменяет флаги `--v1`/`--v2` ключом `rtype`;
- предупреждает об устаревшем ключе `--reportxunit`.

Секции `init-dev`, `update-dev`, `init-project` и неизвестные секции не конвертируются: скрипт выводит предупреждение и завершается с кодом 1. Остальные ключи переносятся как есть, поэтому опции, переименованные в 3.0 (`path` → `feature-path` у `vanessa`, `in` → `cf-file` у `decompile`), правятся вручную — см. страницы команд.

## Формат

| | 2.x | 3.0 |
|---|-----|-----|
| Имя файла | `vrunner.json` | `autumn-properties.json` |
| Ключ опции | `"--ibconnection"` | `"ibconnection"` |
| Общие настройки | секция `default` | корень `vrunner` |
| Настройки команды | секция `xunit` | вложенный объект `vrunner.test.xunit` |
| Позиционный аргумент | `testsPath`, `--out` | имя аргумента в нижнем регистре: `testspath`, `out` |

Ключ в корне `vrunner` действует для всех команд, ключ в объекте команды — только для неё и её подкоманд.

## Маппинг секций

| Секция 2.x | Путь 3.0 |
|------------|----------|
| `default` | `vrunner` |
| `xunit` | `vrunner.test.xunit` |
| `vanessa` | `vrunner.test.vanessa` |
| `syntax-check` | `vrunner.validate.syntax-check` |
| `compile`, `compileconf` | `vrunner.cf.compile` |
| `decompile`, `decompileconf` | `vrunner.cf.decompile` |
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

Было (`vrunner.json`):

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
| `RUNNER_IBNAME` (строка подключения) | `VRUNNER_IBCONNECTION` |
| `RUNNER_DBUSER` | `VRUNNER_DBUSER` |
| `RUNNER_DBPWD` | `VRUNNER_DBPWD` |
| `RUNNER_uccode` | `VRUNNER_UCCODE` |
| `RUNNER_v8version` | `VRUNNER_V8VERSION` |
| `RUNNER_VANESSASETTINGS` | `VRUNNER_VANESSASETTINGS` |
| `RUNNER_PATHVANESSA` | `VRUNNER_PATHVANESSA` |
| `RUNNER_WORKSPACE` | `VRUNNER_WORKSPACE` |
| `RUNNER_TESTSPATH` | `VRUNNER_TESTSPATH` |
| `RUNNER_PATHXUNIT` | `VRUNNER_PATHXUNIT` |
| `RUNNER_CONFIG_TESTS` | `VRUNNER_CONFIG_TESTS` |
| `RUNNER_storage_name` | `VRUNNER_STORAGE_NAME` |
| `RUNNER_storage_user` | `VRUNNER_STORAGE_USER` |
| `RUNNER_storage_pwd` | `VRUNNER_STORAGE_PWD` |

`VRUNNER_IBNAME` в 3.0 — имя базы в кластере (`--db-name`) для команд `cluster`, а не строка подключения.

## Опция --settings

`--settings <файл>` (`VRUNNER_SETTINGS`) сохранена, но файл читается в формате `autumn-properties.json`. Порядок применения файлов, переменных окружения и командной строки — [Каскад приоритетов](../настройка/настройки#приоритеты). Аналог `env.json` — локальный файл, на который проектный `autumn-properties.json` ссылается ключом `settings`: [Опция settings](../настройка/настройки#опция-settings).
