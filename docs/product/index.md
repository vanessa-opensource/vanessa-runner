# О проекте

**vanessa-runner** - консольная утилита для автоматизации задач разработчика 1С:Предприятие: сборка и разборка конфигураций, расширений и внешних обработок, создание и обновление информационных баз, работа с хранилищем конфигурации, управление кластером серверов, запуск тестов и проверка конфигурации. Работает на OneScript, операции с базой выполняет через конфигуратор или `ibcmd`.

## Начало работы

- [Установка](./начало-работы/установка)
- [Первые шаги](./начало-работы/первые-шаги)

## Группы команд

```bash
vrunner <группа> <подкоманда> [опции] [аргумент]
```

| Группа | Описание |
|--------|----------|
| [`cf`](./команды/cf) | Операции с конфигурацией: compile, decompile, load, unload, convert, make-dist, merge, vendor-update, compare |
| [`cfe`](./команды/cfe) | Операции с расширениями конфигурации: compile, decompile, load, unload, convert, compare |
| [`epf`](./команды/epf) | Операции с внешними обработками и отчётами: compile, decompile, convert |
| [`infobase`](./команды/infobase) | Операции с информационной базой: init, update, dump-dt, restore-dt, create-user, extensions, scheduled-job, lock-resources |
| [`repo`](./команды/repo) | Операции с хранилищем конфигурации: create, bind, unbind, load, lock, unlock, commit, save-cf, create-user, copy-user |
| [`cluster`](./команды/cluster) | Управление базой в кластере серверов: create, remove, info, session, jobs |
| [`run`](./команды/run) | Запуск конфигуратора и 1С:Предприятия: designer, enterprise |
| [`test`](./команды/test) | Запуск тестирования: xunit, yaxunit, vanessa |
| [`validate`](./команды/validate) | Проверка конфигурации: syntax-check, edt |

Общие для команд темы: [Общие опции](./команды/common-options), [Исходники в формате 1С:EDT](./команды/edt), [Отчёты о результатах](./команды/reports), [Сбор покрытия тестами](./команды/coverage).

## Настройка

- [Файл настроек](./настройка/настройки) - `autumn-properties.json` в каталоге проекта.
- [Переменные окружения](./настройка/переменные-окружения) - `VRUNNER_*`.

## Интеграция с ИИ-ассистентами

[MCP-сервер](./mcp) `vrunner-mcp` выставляет команды vanessa-runner как инструменты для Claude, Copilot, Cursor и других клиентов.

## Миграция с 2.x

Версия 3.0 несовместима с 2.x по составу команд, формату файла настроек и именам переменных окружения. Таблицы соответствия - в разделе [Миграция с 2.x](./миграция/).

## Поддержка

- Telegram: [vanessa_opensource_chat](https://t.me/vanessa_opensource_chat)
- GitHub Issues: [vanessa-runner/issues](https://github.com/vanessa-opensource/vanessa-runner/issues)
