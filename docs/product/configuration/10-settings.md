# Файл настроек (autumn-properties.json)

vanessa-runner использует файл `autumn-properties.json` для задания настроек по умолчанию на уровне проекта.

## Расположение файла

Файл `autumn-properties.json` должен находиться в рабочем каталоге, из которого запускается `vrunner`. Как правило, это корень проекта.

## Формат файла

```json
{
  "runner": {
    "<опция>": "<значение>",
    "<команда>": {
      "<опция>": "<значение>"
    }
  }
}
```

Ключи задаются через пространство имён `runner`.

## Каскад приоритетов

Настройки применяются в следующем порядке (от низшего приоритета к высшему):

1. Значения по умолчанию из пакета vanessa-runner
2. `autumn-properties.json` в текущем рабочем каталоге
3. Переменные окружения
4. Аргументы командной строки

## Примеры конфигурации

### Базовые настройки подключения

```json
{
  "runner": {
    "ibconnection": "/FD:/bases/MyProject",
    "db-user": "Администратор",
    "db-pwd": "",
    "v8version": "8.3.24"
  }
}
```

### Настройки для конкретных команд

```json
{
  "runner": {
    "ibconnection": "/F./ib",
    "v8version": "8.3.24",
    "cf": {
      "compile": {
        "src": "./src"
      }
    },
    "repo": {
      "load": {
        "storage-name": "D:/repos/MyProject",
        "storage-user": "StorageUser"
      }
    }
  }
}
```

### Пример для CI-окружения

```json
{
  "runner": {
    "v8version": "8.3.24",
    "ibcmd": true,
    "test": {
      "xunit": {
        "reportsxunit": "jUnit{./build/reports/junit.xml}"
      }
    }
  }
}
```

## Уровни логирования

Уровень логирования настраивается через `autumn-properties.json`:

```json
{
  "logos": {
    "logger": {
      "vrunner": "DEBUG"
    }
  }
}
```

Доступные уровни: `DEBUG`, `INFO`, `WARN`, `ERROR`.

Или через переменную окружения:

```bash
export LOGOS_LOGGER_VRUNNER=DEBUG
vrunner cf compile ./build/App.cf
```
