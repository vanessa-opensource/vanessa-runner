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
> При переходе с 2.x обязательно ознакомьтесь с [руководством по миграции](#миграция-с-2x-на-30).(Пока в разработке)
>
> Стабильная **LTS-версия 2.x** продолжает поддерживаться в ветке [`release/2.6`](https://github.com/vanessa-opensource/vanessa-runner/tree/release/2.6) — там выпускаются только багфиксы.

📖 **Документация:** [vanessa-opensource.github.io/vanessa-runner](https://vanessa-opensource.github.io/vanessa-runner) _(публикация в процессе — ссылка станет рабочей в ближайшее время)_

---

## Установка

```sh
# Последняя стабильная версия
opm install vanessa-runner

# Конкретная snapshot-версия для тестирования
opm install vanessa-runner@snapshot

# LTS-версия 2.x (рекомендуется для production до стабилизации 3.0)
opm install vanessa-runner@2.6.1
```

---

## Миграция с 2.x на 3.0

vanessa-runner 3.0 содержит ряд изменений. Подробное руководство со всеми деталями — на [сайте документации](https://vanessa-opensource.github.io/vanessa-runner/migration). Ниже — краткое резюме.

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

Часть команд переименована, часть удалена. Полная таблица — в [migration guide](https://vanessa-opensource.github.io/vanessa-runner/migration#commands).

| Было (2.x) | Стало (3.0) | Комментарий |
|---|---|---|
| `vrunner <!-- TODO -->` | `vrunner <!-- TODO -->` | переименована |
| `vrunner <!-- TODO -->` | — | удалена, используйте `<!-- TODO -->` |
| `vrunner <!-- TODO -->` | `vrunner <!-- TODO -->` | изменён набор ключей |

### 3. Изменён формат `vrunner.json`

Структура файла настроек обновлена. При запуске со старым форматом vrunner выведет ошибку с указанием, какие ключи нужно поправить.

**Было (2.x):**

```json
{
  "<!-- TODO: old-key -->": "value"
}
```

**Стало (3.0):**

```json
{
  "<!-- TODO: new-key -->": "value"
}
```

> 💡 Для автоматической конвертации старого `vrunner.json` используйте команду:
>
> ```sh
> vrunner <!-- TODO: migrate-config --> tools/vrunner.json
> ```

### 4. Переименованы переменные окружения

Переменные окружения `RUNNER_*` переименованы для устранения конфликтов с CI-окружениями (GitHub Actions, GitLab Runner и др., где `RUNNER_*` зарезервированы системой).


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