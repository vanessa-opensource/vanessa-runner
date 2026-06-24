<a id="markdown-vanessa-runner" name="vanessa-runner"></a>
# vanessa-runner

[![Chat on Telegram vanessa_opensource_chat](https://img.shields.io/badge/chat-Telegram-brightgreen.svg)](https://t.me/vanessa_opensource_chat)
[![GitHub release](https://img.shields.io/github/release/vanessa-opensource/vanessa-runner.svg)](https://github.com/vanessa-opensource/vanessa-runner/releases)
[![Юнит-тесты](https://github.com/vanessa-opensource/vanessa-runner/actions/workflows/unit-test.yml/badge.svg)](https://github.com/vanessa-opensource/vanessa-runner/actions/workflows/unit-test.yml)
[![E2E (клиент)](https://github.com/vanessa-opensource/vanessa-runner/actions/workflows/e2e-client.yml/badge.svg)](https://github.com/vanessa-opensource/vanessa-runner/actions/workflows/e2e-client.yml)
[![E2E (сервер)](https://github.com/vanessa-opensource/vanessa-runner/actions/workflows/e2e.yml/badge.svg)](https://github.com/vanessa-opensource/vanessa-runner/actions/workflows/e2e.yml)
[![Статус Порога Качества](https://sonar.openbsl.ru/api/project_badges/measure?project=vanessa-runner&metric=alert_status)](https://sonar.openbsl.ru/dashboard?id=vanessa-runner)
[![Покрытие](https://sonar.openbsl.ru/api/project_badges/measure?project=vanessa-runner&metric=coverage)](https://sonar.openbsl.ru/dashboard?id=vanessa-runner)

> ⚠️ **vanessa-runner 3.0** — новая мажорная версия содержит BREAKING CHANGES.
> При переходе с 2.x обязательно ознакомьтесь с [руководством по миграции](https://autumn-library.github.io/vanessa-runner/миграция/).
>
> Стабильная **LTS-версия 2.x** продолжает поддерживаться в ветке [`release/2.6`](https://github.com/vanessa-opensource/vanessa-runner/tree/release/2.6) — там выпускаются только багфиксы.

📖 **Документация:** [autumn-library.github.io/vanessa-runner](https://autumn-library.github.io/vanessa-runner)

---

## Установка

```sh
# Последняя стабильная версия
opm install vanessa-runner

# Конкретная snapshot-версия для тестирования
opm install vanessa-runner@SNAPSHOT

# LTS-версия 2.x (рекомендуется для production до стабилизации 3.0)
opm install vanessa-runner@2.6.1
```

---

## Миграция с 2.x на 3.0

vanessa-runner 3.0 содержит ряд изменений. Подробное руководство со всеми деталями — на [сайте документации](https://autumn-library.github.io/vanessa-runner/миграция/). Ниже — краткое резюме.

### TL;DR — что менять

| Что изменилось | Действие |
|---|---|
| Минимальная версия OneScript | Обновить OneScript до версии 2.0.0+|
| Состав команд `vrunner` | Заменить переименованные/удалённые команды |
| Формат `vrunner.json` | Привести файл настроек к новой схеме |
| Имена переменных окружения | Переименовать `RUNNER_*` в `VRUNNER_*` |

---

### 1. Повышена минимальная версия OneScript

Для работы 3.0 требуется OneScript **не ниже `2.0.0`** (в 2.x минимальная была `1.9.2`).

```sh
# Проверить текущую версию
oscript -version
```

Обновить OneScript можно через [ovm](https://github.com/oscript-library/ovm) или установив свежий пакет с [oscript.io](https://oscript.io).

### 2. Изменения в командах vrunner

Часть команд переименована, часть удалена. Полная таблица — в [руководстве по миграции](https://autumn-library.github.io/vanessa-runner/миграция/).

| Было (2.x) | Стало (3.0) | Комментарий |
|---|---|---|
| `vrunner vanessa` | `vrunner test vanessa` | переименована |
| `vrunner updatedb` | `vrunner infobase update` | функционал обновления ИБ консолидирован в новой команде |
| `vrunner syntax-check` | `vrunner validate syntax-check` | изменён набор ключей |

### 3. Изменён формат `vrunner.json`

Структура файла настроек обновлена. При запуске со старым форматом vrunner выведет ошибку с указанием, какие ключи нужно поправить.

**Было (2.x)** — плоский `vrunner.json` с ключами в формате `--ключ`:

```json
{
  "default": {
    "--ibconnection": "/F./build/ib",
    "--v8version": "8.3.24"
  },
  "xunit": {
    "--reportsxunit": "jUnit{./build/reports/junit.xml}"
  },
  "vanessa": {
    "--vanessasettings": "./tools/.vb-conf.json"
  }
}
```

**Стало (3.0)** — иерархический `autumn-properties.json` без `--` в ключах:

```json
{
  "vrunner": {
    "ibconnection": "/F./build/ib",
    "v8version": "8.3.24",
    "test": {
      "xunit": {
        "reportsxunit": "jUnit{./build/reports/junit.xml}"
      },
      "vanessa": {
        "vanessasettings": "./tools/.vb-conf.json"
      }
    }
  }
}
```

> 💡 Для автоматической конвертации `vrunner.json` → `autumn-properties.json` используйте скрипт из поставки:
> ```sh
> oscript tools/migrate26to30.os --input vrunner.json --output autumn-properties.json
> ```
> Скрипт переименует ключи, перестроит иерархию секций и выведет предупреждения о случаях, требующих ручной правки.

### 4. Переименованы переменные окружения

Переменные окружения `RUNNER_*` переименованы для устранения конфликтов с CI-окружениями (GitHub Actions, GitLab Runner и др., где `RUNNER_*` зарезервированы системой). Полная таблица соответствия `RUNNER_*` → `VRUNNER_*` — в [разделе миграции](https://autumn-library.github.io/vanessa-runner/миграция/settings#переменные-окружения).

⚠️ Не забудьте поправить определения переменных в `.gitlab-ci.yml`, GitHub workflow-файлах, Jenkinsfile и shell-скриптах сборки.

---

### Откат на 2.x

Если миграция занимает время — оставайтесь на LTS:

```sh
opm install vanessa-runner@2.6.1
```

Ветка [`release/2.6`](https://github.com/vanessa-opensource/vanessa-runner/tree/release/2.6) продолжает получать багфиксы.

### Помощь

Проблемы с миграцией — заводите [issue](https://github.com/vanessa-opensource/vanessa-runner/issues/new).
