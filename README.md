<a id="markdown-vanessa-runner" name="vanessa-runner"></a>
# vanessa-runner

[![Chat on Telegram vanessa_opensource_chat](https://img.shields.io/badge/chat-Telegram-brightgreen.svg)](https://t.me/vanessa_opensource_chat)
[![GitHub release](https://img.shields.io/github/release/vanessa-opensource/vanessa-runner.svg)](https://github.com/vanessa-opensource/vanessa-runner/releases)
[![Юнит-тесты](https://github.com/vanessa-opensource/vanessa-runner/actions/workflows/unit-test.yml/badge.svg)](https://github.com/vanessa-opensource/vanessa-runner/actions/workflows/unit-test.yml)
[![E2E (клиент)](https://github.com/vanessa-opensource/vanessa-runner/actions/workflows/e2e-client.yml/badge.svg)](https://github.com/vanessa-opensource/vanessa-runner/actions/workflows/e2e-client.yml)
[![E2E (сервер)](https://github.com/vanessa-opensource/vanessa-runner/actions/workflows/e2e.yml/badge.svg)](https://github.com/vanessa-opensource/vanessa-runner/actions/workflows/e2e.yml)
[![Статус Порога Качества](https://sonar.openbsl.ru/api/project_badges/measure?project=vanessa-runner&metric=alert_status)](https://sonar.openbsl.ru/dashboard?id=vanessa-runner)
[![Покрытие](https://sonar.openbsl.ru/api/project_badges/measure?project=vanessa-runner&metric=coverage)](https://sonar.openbsl.ru/dashboard?id=vanessa-runner)

Консольная утилита для автоматизации повседневных операций разработчика 1С: сборка и разборка конфигураций, расширений и обработок, загрузка в базу, хранилище, кластер, запуск тестов (Vanessa-ADD, YAxUnit), проверка кода, MCP-сервер для ИИ-ассистентов.

📖 **Документация:** [autumn-library.github.io/vanessa-runner](https://autumn-library.github.io/vanessa-runner)

> ⚠️ **vanessa-runner 3.0** — новая мажорная версия с несовместимыми изменениями. При переходе с 2.x см. [руководство по миграции](https://autumn-library.github.io/vanessa-runner/миграция/).
>
> **LTS-версия 2.x** поддерживается в ветке [`release/2.6`](https://github.com/vanessa-opensource/vanessa-runner/tree/release/2.6) — только исправления ошибок.

## Установка

Требуется OneScript 2.0.0 или новее.

```sh
# Последняя стабильная версия
opm install vanessa-runner

# Snapshot-версия для тестирования
opm install vanessa-runner@SNAPSHOT

# LTS-версия 2.x
opm install vanessa-runner@2.6.1
```

Подробнее: [Установка](https://autumn-library.github.io/vanessa-runner/начало-работы/установка), [Первые шаги](https://autumn-library.github.io/vanessa-runner/начало-работы/первые-шаги).

## Миграция с 2.x на 3.0

| Что изменилось | Действие |
|---|---|
| Минимальная версия OneScript — 2.0.0 | Обновить OneScript ([ovm](https://github.com/oscript-library/ovm), [oscript.io](https://oscript.io)) |
| Команды сгруппированы: `vrunner vanessa` → `vrunner test vanessa`, `vrunner updatedb` → `vrunner infobase update`, `vrunner syntax-check` → `vrunner validate syntax-check` и т. д. | Переписать вызовы по [таблице соответствия](https://autumn-library.github.io/vanessa-runner/миграция/) |
| Файл настроек `vrunner.json` → `autumn-properties.json` (иерархия команд, ключи без `--`) | Сконвертировать: `oscript tools/migrate26to30.os --input vrunner.json --output autumn-properties.json` ([подробнее](https://autumn-library.github.io/vanessa-runner/миграция/settings)) |
| Переменные окружения `RUNNER_*` → `VRUNNER_*` | Переименовать в CI-файлах и скриптах |

Пример файла настроек 3.0:

```json
{
  "vrunner": {
    "ibconnection": "/F./build/ib",
    "v8version": "8.3.24",
    "test": {
      "xunit": {
        "testspath": "./tests",
        "report-format": ["junit"],
        "report-path": "./build/reports/junit.xml"
      }
    }
  }
}
```

Проблемы с миграцией — заводите [issue](https://github.com/vanessa-opensource/vanessa-runner/issues/new).
