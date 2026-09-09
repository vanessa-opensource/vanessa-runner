---
title: Миграция с 2.x на 3.0
---

# Миграция с 2.x на 3.0

vanessa-runner 3.0 несовместим с 2.x: команды стали иерархическими, изменились имя и формат файла настроек, префикс переменных окружения. Ниже — порядок перехода и таблица соответствия команд; на страницах раздела каждая команда 2.x разобрана с примерами «было → стало».

Если переход откладывается, оставайтесь на ветке 2.6: `opm install vanessa-runner@2.6.1`.

## Порядок миграции

1. Обновите OneScript до 2.0.0 или новее (`oscript -version`).
2. Установите 3.0: `opm install vanessa-runner`.
3. Сконвертируйте `vrunner.json` в `autumn-properties.json` скриптом `tools/migrate26to30.os` и разберите его предупреждения — [Файл настроек и переменные окружения](./settings).
4. Переименуйте переменные окружения `RUNNER_*` → `VRUNNER_*` в CI и скриптах сборки — [таблица](./settings#переменные-окружения).
5. Замените вызовы `vrunner` по таблице ниже. Опции в 3.0 указываются до позиционного аргумента: `vrunner cf compile --src ./src ./build/1Cv8.cf`.

## Что изменилось

| Область | 2.x | 3.0 |
|---------|-----|-----|
| Минимальная версия OneScript | `1.9.2` | `2.0.0` |
| Структура команд | Плоская: `vrunner xunit` | Иерархическая: `vrunner test xunit` |
| Файл настроек | `vrunner.json` | `autumn-properties.json` |
| Ключи в файле настроек | `"--option": "value"` в секции команды | `"option": "value"` в объекте `vrunner.<группа>.<команда>` |
| Позиционные аргументы в файле настроек | `compile.--out`, `xunit.testsPath` | Ключ по имени аргумента: `out`, `testspath` |
| Переменные окружения | `RUNNER_*` | `VRUNNER_*` |

## Таблица соответствия команд

| Команда 2.x | Команда 3.0 | Страница |
|-------------|-------------|----------|
| `vrunner vanessa` | `vrunner test vanessa` | [vanessa](./vanessa) |
| `vrunner xunit` | `vrunner test xunit <TESTSPATH>` | [xunit](./xunit) |
| `vrunner run` | `vrunner run enterprise` | [run](./run) |
| `vrunner designer` | `vrunner run designer` | [designer](./designer) |
| `vrunner loadrepo` | `vrunner repo load` | [loadrepo](./loadrepo) |
| `vrunner init-dev` | `vrunner infobase init` | [init-dev](./init-dev) |
| `vrunner update-dev` | `vrunner infobase update` | [init-dev](./init-dev) |
| `vrunner updatedb` | `vrunner infobase update` | [updatedb](./updatedb) |
| `vrunner update` | `vrunner cf vendor-update` | [update](./update) |
| `vrunner syntax-check` | `vrunner validate syntax-check` | [syntax-check](./syntax-check) |
| `vrunner compile`, `vrunner compileconf` | `vrunner cf compile <OUT>` | [compile](./compile) |
| `vrunner decompile`, `vrunner decompileconf` | `vrunner cf decompile <OUT>` | [decompile](./decompile) |
| `vrunner compileepf` | `vrunner epf compile [SRC]` | [compileepf](./compileepf) |
| `vrunner decompileepf` | `vrunner epf decompile <SRC>` | [decompileepf](./decompileepf) |
| `vrunner compileext` | `vrunner cfe compile <OUT>` | [compileext](./compileext) |
| `vrunner decompileext` | `vrunner cfe decompile <OUT>` | [decompileext](./decompileext) |
| `vrunner session lock/unlock/kill/closed` | `vrunner cluster session lock/unlock/kill/closed` | [session](./session) |
| `vrunner scheduledjobs lock/unlock` | `vrunner cluster jobs lock/unlock` | [scheduledjobs](./scheduledjobs) |
| `vrunner init-project` | нет аналога | [init-project](./init-project) |

Остальные команды 3.0 отдельных страниц миграции не имеют — см. справочник команд:

| Группа | Команды 3.0 |
|--------|-------------|
| [cf](../команды/cf) | `load`, `unload`, `make-dist`, `merge`, `compare`, `convert` |
| [cfe](../команды/cfe) | `load`, `unload`, `compare`, `convert` |
| [epf](../команды/epf) | `convert` |
| [infobase](../команды/infobase) | `dump-dt`, `restore-dt`, `create-user`, `lock-resources`, `scheduled-job enable/disable`, `extensions list/check/create/delete/set-options` |
| [repo](../команды/repo) | `create`, `bind`, `unbind`, `commit`, `lock`, `unlock`, `save-cf`, `create-user`, `copy-user` |
| [cluster](../команды/cluster) | `info`, `create`, `remove`, `session list` |
| [test](../команды/test) | `yaxunit` |
| [validate](../команды/validate) | `edt` |
