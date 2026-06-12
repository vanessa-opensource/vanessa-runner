---
title: compile 
---

# vrunner compile / vrunner compileconf

Собирает конфигурацию 1С из XML-исходников в файл `.cf`.

::: warning Изменено в 3.0
`vrunner compile` и `vrunner compileconf` заменены командой `vrunner cf compile` — вошли в группу `cf`. Путь к выходному файлу стал обязательным позиционным аргументом.

[Документация cf compile →](../команды/cf#compile)
:::

## Изменения

| Аспект | 2.x | 3.0 |
|--------|-----|-----|
| Команда | `vrunner compile` / `vrunner compileconf` | `vrunner cf compile <OUT>` |
| Выходной файл | `--out ./build/1Cv8.cf` | Позиционный аргумент `OUT` (обязательный) |
| Каталог исходников | `--src ./cf` | `--s ./src` или `--src ./src` |
| `--ibconnection` | Обязательный (для конфигуратора) | Опциональный — если не указан, создаётся временная ИБ |
| `--ibcmd` | Не поддерживался | Поддерживается — быстрее конфигуратора |
| Секция в настройках | `"compile"` / `"compileconf"` | `"runner.cf.compile"` |

## Примеры

### Было (2.x)

```bash
# Через конфигуратор
vrunner compile \
  --src ./cf \
  --out ./build/1Cv8.cf \
  --ibconnection /FD:/bases/temp \
  --v8version 8.3.24
```

### Стало (3.0)

```bash
# Через ibcmd (рекомендуется — не требует запуска конфигуратора)
vrunner cf compile ./build/1Cv8.cf \
  --s ./cf \
  --ibcmd

# Через конфигуратор с явным подключением
vrunner cf compile ./build/1Cv8.cf \
  --s ./cf \
  --ibconnection /FD:/bases/temp \
  --v8version 8.3.24
```

## Файл настроек

### Было (`vrunner.json`)

```json
{
  "compile": {
    "--src": "./cf",
    "--out": "./build/1Cv8.cf"
  }
}
```

### Стало (`autumn-properties.json`)

```json
{
  "vrunner": {
    "cf": {
      "compile": {
        "src": "./cf"
      }
    }
  }
}
```

::: tip
Путь к выходному `.cf` файлу задаётся только в командной строке как позиционный аргумент — он не может быть задан в файле настроек.
:::
