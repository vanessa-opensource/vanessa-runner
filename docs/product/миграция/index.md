---
title: Миграция с 2.x на 3.0
---

# Миграция с 2.x на 3.0

vanessa-runner 3.0 — мажорный релиз с несовместимыми изменениями относительно ветки 2.x. Поменялись структура команд (`vrunner` стал иерархическим), формат файла настроек и префиксы переменных окружения. Этот раздел проведёт вас через переход шаг за шагом: ниже — общий порядок действий и сводные таблицы, а на отдельных страницах каждая команда 2.x разобрана с конкретными примерами «было → стало».

## Кому это нужно

- **Переходите с 2.x на 3.0** — да, миграция обязательна: старые команды, формат `vrunner.json` и переменные `RUNNER_*` в 3.0 не работают без изменений.
- **Остаётесь на 2.x** — ничего делать не нужно. LTS-ветка 2.6 продолжает получать исправления (см. [Откат на 2.x](#откат-на-2-x)).
- **Начинаете новый проект на 3.0** — этот раздел можно пропустить и сразу перейти к [Началу работы](../начало-работы/установка).

## Порядок миграции

Рекомендуемая последовательность шагов. Большинство проектов мигрирует за один подход.

1. **Обновите OneScript до `2.0.0+`** — это требование 3.0 (в 2.x минимальной была `1.9.2`). Проверка: `oscript -version`.
2. **Установите 3.0** — `opm install vanessa-runner` (или `@snapshot` для тестирования).
3. **Сконвертируйте файл настроек** — переименуйте `vrunner.json` в `autumn-properties.json` и приведите его к новой схеме. Удобнее всего скриптом конвертации (см. блок ниже и [Файл настроек и переменные окружения →](./settings)).
4. **Переименуйте переменные окружения** `RUNNER_*` → `VRUNNER_*` в CI-файлах и скриптах сборки ([таблица соответствия →](./settings#переменные-окружения)).
5. **Обновите вызовы `vrunner`** в скриптах сборки по [таблице соответствия команд](#таблица-соответствия-команд) ниже.
6. **Прогоните сборку** и сверьтесь с предупреждениями — vrunner подскажет, какие ключи настроек требуют правки.

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
