---
title: Миграция с 2.x на 3.0
---

# Миграция с 2.x на 3.0

vanessa-runner 3.0 содержит несовместимые изменения относительно ветки 2.x. В этом разделе каждая команда 2.x разобрана отдельно — с примерами того, что именно изменилось.

::: tip Скрипт автоматической конвертации
Для конвертации `vrunner.json` в `autumn-properties.json` используйте:

```bash
oscript tools/migrate26to30.os --input vrunner.json --output autumn-properties.json
```

Подробнее: [Файл настроек и переменные окружения →](./settings)
:::

## Что изменилось

| Область | 2.x | 3.0 |
|---------|-----|-----|
| Минимальная версия OneScript | `1.9.2` | `2.0.0+` |
| Структура команд | Плоская | Иерархическая |
| Файл настроек | `vrunner.json` | `autumn-properties.json` |
| Ключи в файле настроек | `"--option": "value"` | `"option": "value"` |
| Иерархия настроек | Плоские секции | Вложенные `runner.<cmd>.<sub>` |
| Переменные окружения | `RUNNER_*` | `VRUNNER_*` |

## Таблица соответствия команд

| Команда 2.x | Команда 3.0 | Страница миграции |
|-------------|-------------|-------------------|
| `vrunner vanessa` | `vrunner test vanessa` | [→](./vanessa) |
| `vrunner xunit` | `vrunner test xunit` | [→](./xunit) |
| `vrunner run` | `vrunner run enterprise` | [→](./run) |
| `vrunner loadrepo` | `vrunner repo load` | [→](./loadrepo) |
| `vrunner init-dev` | `vrunner infobase init` | [→](./init-dev) |
| `vrunner update-dev` | `vrunner infobase update` | [→](./init-dev) |
| `vrunner updatedb` | `vrunner infobase update` | [→](./updatedb) |
| `vrunner syntax-check` | `vrunner validate syntax-check` | [→](./syntax-check) |
| `vrunner compile` / `vrunner compileconf` | `vrunner cf compile <OUT>` | [→](./compile) |
| `vrunner decompile` / `vrunner decompileconf` | `vrunner cf decompile <OUT>` | [→](./decompile) |
| `vrunner compileepf` | `vrunner epf compile` | [→](./compileepf) |
| `vrunner decompileepf` | `vrunner epf decompile` | [→](./decompileepf) |
| `vrunner compileext` | `vrunner cfe compile <OUT>` | [→](./compileext) |
| `vrunner decompileext` | `vrunner cfe decompile <OUT>` | [→](./decompileext) |
| `vrunner designer` | `vrunner run designer` | [→](./designer) |
| `vrunner session lock/unlock/kill` | `vrunner cluster session lock/unlock/kill` | [→](./session) |
| `vrunner scheduledjobs lock/unlock` | `vrunner cluster jobs lock/unlock` | [→](./scheduledjobs) |
| `vrunner init-project` | _(удалена)_ | [→](./init-project) |

## Обновление файла настроек

Подробное описание изменений формата настроек, полная таблица переменных окружения и скрипт автоматической конвертации: [→](./settings)

## Откат на 2.x

Если миграция занимает время — оставайтесь на LTS-ветке 2.6:

```bash
opm install vanessa-runner@2.6.1
```

Ветка [`release/2.6`](https://github.com/vanessa-opensource/vanessa-runner/tree/release/2.6) продолжает получать патчи с исправлениями ошибок.
