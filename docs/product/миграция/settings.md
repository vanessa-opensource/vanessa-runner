---
title: Файл настроек и переменные окружения
---

# Файл настроек и переменные окружения

В 3.0 изменились формат файла настроек, правила именования ключей и префиксы переменных окружения.

::: tip Скрипт конвертации
Для автоматической конвертации `vrunner.json` → `autumn-properties.json`:

```bash
oscript tools/migrate26to30.os --input vrunner.json --output autumn-properties.json
```

Скрипт обрабатывает все стандартные секции, переименовывает ключи и выводит предупреждения о случаях, требующих ручной правки.
:::

## Имя файла

| 2.x | 3.0 |
|-----|-----|
| `vrunner.json` | `autumn-properties.json` |

Старое имя `vrunner.json` больше не распознаётся. Файл необходимо переименовать или создать заново.

## Формат ключей

В 2.x ключи в файле настроек записывались с префиксом `--` (как в командной строке):

```json
{
  "default": {
    "--ibconnection": "/F./build/ib",
    "--v8version": "8.3.24"
  }
}
```

В 3.0 ключи задаются **без** `--` префикса:

```json
{
  "vrunner": {
    "ibconnection": "/F./build/ib",
    "v8version": "8.3.24"
  }
}
```

## Иерархия секций

В 2.x файл настроек был плоским, каждая команда — своя секция верхнего уровня:

```json
{
  "default": { "--ibconnection": "/F./ib", "--v8version": "8.3.24" },
  "xunit": { "--reportsxunit": "jUnit{./build/junit.xml}" },
  "vanessa": { "--vanessasettings": "./vb-conf.json" }
}
```

В 3.0 настройки вложены в пространство имён `vrunner`, а команды отражают иерархию CLI:

```json
{
  "vrunner": {
    "ibconnection": "/F./ib",
    "v8version": "8.3.24",
    "test": {
      "xunit": {
        "reportsxunit": "jUnit{./build/junit.xml}"
      },
      "vanessa": {
        "vanessasettings": "./vb-conf.json"
      }
    }
  }
}
```

## Маппинг секций

| Секция в 2.x | Путь в 3.0 |
|--------------|------------|
| `default` | `vrunner` |
| `xunit` | `vrunner.test.xunit` |
| `vanessa` | `vrunner.test.vanessa` |
| `syntax-check` | `vrunner.validate.syntax-check` |
| `compile` / `compileconf` | `vrunner.cf.compile` |
| `decompile` / `decompileconf` | `vrunner.cf.decompile` |
| `compileepf` | `vrunner.epf.compile` |
| `decompileepf` | `vrunner.epf.decompile` |
| `compileext` | `vrunner.cfe.compile` |
| `decompileext` | `vrunner.cfe.decompile` |
| `updatedb` | `vrunner.infobase.update` |
| `run` | `vrunner.run.enterprise` |
| `loadrepo` | `vrunner.repo.load` |
| `designer` | `vrunner.run.designer` |

::: warning
Секции `init-dev`, `update-dev` и `init-project` не имеют прямого аналога в 3.0. Смотрите отдельные страницы миграции: [init-dev →](./init-dev), [init-project →](./init-project).
:::

## Полный пример конвертации

**Было** (`vrunner.json`):

```json
{
  "default": {
    "--ibconnection": "/F./build/ib",
    "--db-user": "Администратор",
    "--db-pwd": "",
    "--v8version": "8.3.24"
  },
  "xunit": {
    "--reportsxunit": "ГенераторОтчетаJUnitXML{build/junit.xml}",
    "testsPath": "./tests"
  },
  "vanessa": {
    "--vanessasettings": "./tools/vb-conf.json",
    "--workspace": "."
  },
  "syntax-check": {
    "--groupbymetadata": true,
    "--exception-file": "./syntax-check-exceptions.txt",
    "--mode": ["-ThinClient", "-Server", "-WebClient"]
  },
  "loadrepo": {
    "--storage-name": "tcp://server/storage",
    "--storage-user": "bot",
    "--storage-pwd": "123"
  },
  "updatedb": {
    "--uccode": "godModeOn",
    "--v2": true
  }
}
```

**Стало** (`autumn-properties.json`):

```json
{
  "vrunner": {
    "ibconnection": "/F./build/ib",
    "db-user": "Администратор",
    "db-pwd": "",
    "v8version": "8.3.24",
    "test": {
      "xunit": {
        "reportsxunit": "ГенераторОтчетаJUnitXML{build/junit.xml}"
      },
      "vanessa": {
        "vanessasettings": "./tools/vb-conf.json",
        "workspace": "."
      }
    },
    "validate": {
      "syntax-check": {
        "groupbymetadata": true,
        "exception-file": "./syntax-check-exceptions.txt",
        "mode": ["ThinClient", "Server", "WebClient"]
      }
    },
    "repo": {
      "load": {
        "storage-name": "tcp://server/storage",
        "storage-user": "bot",
        "storage-pwd": "123"
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

Все переменные окружения переименованы с префикса `RUNNER_` на `VRUNNER_`. Это необходимо для устранения конфликтов с зарезервированными переменными в CI-системах (GitHub Actions, GitLab Runner и других).

::: warning
Обновите определения переменных в `.gitlab-ci.yml`, GitHub workflow-файлах, `Jenkinsfile` и скриптах сборки.
:::

| 2.x переменная | 3.0 переменная |
|----------------|----------------|
| `RUNNER_IBNAME` | `VRUNNER_IBCONNECTION` |
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

::: tip
Обратите внимание, что `RUNNER_IBNAME` (имя базы для cluster) заменён на `VRUNNER_IBCONNECTION` (строка подключения). Для cluster-команд используется `VRUNNER_IBNAME` как отдельная переменная.
:::

## Каскад приоритетов

В 2.x порядок приоритетов был:

1. `env.json` (или `--settings <файл>`)
2. Переменные окружения `RUNNER_*`
3. Ключи командной строки `--*`

В 3.0 порядок аналогичен, но схема изменилась:

1. Значения по умолчанию из пакета vanessa-runner
2. `autumn-properties.json` в текущем каталоге
3. Переменные окружения `VRUNNER_*`
4. Аргументы командной строки

::: warning
Параметр `--settings <файл>` сохранён для обратной совместимости, но указанный файл читается как `autumn-properties.json` (новый формат), а не как `vrunner.json`.
:::
