# Модель запуска CI

Единая для всех тестовых workflow: `unit-test.yml`, `qa.yml`, `e2e.yml`, `e2e-client.yml`, `e2e-edt.yml`.

## Триггеры

| Событие | Когда | Зачем |
|---|---|---|
| `push` в `develop` / `master` / `release/**` | после мержа | пост-мердж прогон целевых веток |
| `pull_request_target` | открытие/обновление PR | валидация изменений PR |
| `workflow_dispatch` | вручную | перепрогон по требованию |

Ветки самого репозитория по `push` **не** прогоняются: разработка ведётся через PR, и триггер
`push` на все ветки давал двойной прогон (ветка + её PR).

## Почему `pull_request_target`, а не `pull_request`

Тестам нужны секреты — учётка портала 1С (`ONEC_USERNAME` / `ONEC_PASSWORD`) для установки
платформы и лицензии (`ONEC_LICENCE`, `ONEC_SERVER_LICENCE`). PR из форка при событии
`pull_request` секретов **не получает**, поэтому все джобы с установкой 1С в нём падают в
принципе — а `unit-test.yml`, где секретов не надо, до недавнего времени вообще висел в
`action_required`.

`pull_request_target` выполняется в контексте базовой ветки и секреты видит. Плата за это —
код PR туда не попадает автоматически: по умолчанию checkout берёт базовую ветку, из-за чего
раньше «E2E (сервер)» показывал зелёный, фактически прогоняя `develop`, а не PR.

Поэтому во всех тестовых workflow код PR забирается явно:

```yaml
- uses: actions/checkout@v4
  with:
    ref: ${{ github.event.pull_request.number && format('refs/pull/{0}/merge', github.event.pull_request.number) || '' }}
    allow-unsafe-pr-checkout: true
```

* `refs/pull/<N>/merge` — merge-коммит PR, то есть ровно то состояние, которое попадёт в
  базовую ветку. Именно его и надо тестировать.
* `allow-unsafe-pr-checkout: true` — обязательный опт-ин `actions/checkout` (появился в
  v4.4.0 / v7). Без него checkout отказывается брать код форка под `pull_request_target`.

## Подтверждения нет — это сознательное решение

Прогон PR из форка стартует сразу, без чьего-либо аппрува. Надо понимать, что это значит:
**любой автор PR выполняет свой код с секретами репозитория.**

Штатной защиты здесь нет. Встроенная настройка «Require approval for external
contributors» относится только к событию `pull_request` — GitHub Docs прямо пишут, что
workflow, запущенные по `pull_request_target`, «will always run, regardless of approval
settings». А `pull_request` форку секретов не отдаёт, поэтому тесты на нём не поднимаются.
Одновременно получить и кнопку, и секреты нельзя.

Ручные варианты гейта (environment с обязательным ревьюером, метка `ci:approved` с
`types: [labeled]`) пробовались и признаны слишком дорогими в ежедневной работе:
подтверждение требуется на каждый пуш в ветку PR, а окружение выдаёт его на прогон, не на
PR — то есть по клику на каждый workflow.

### Чем это ограничить

Тестам нужны только учётка портала 1С (`ONEC_USERNAME` / `ONEC_PASSWORD`), лицензии
(`ONEC_LICENCE`, `ONEC_SERVER_LICENCE`) и `SONARQUBE_TOKEN` / `SONARQUBE_HOST`. Всё
остальное в PR-прогоне лишнее, но как репозиторные секреты видно любой джобе:

* `OSHUB_TOKEN` — публикация пакета в hub.oscript.io;
* `TRIGGER_DOCS_DEPLOY_TOKEN` — запуск деплоя документации.

Это единственные секреты, утечка которых бьёт не по проекту, а по пользователям пакета.
Их стоит перенести в отдельный environment (например `release`) и указать его в
`release.yml` / `docs-deploy.yaml` — тогда прогон PR до них не дотянется вообще.

## Concurrency

Ключ группы включает `github.event_name`:

```yaml
group: ${{ github.workflow }}-${{ github.event_name }}-${{ github.event.pull_request.number || github.ref }}
```

Событие в ключе нужно из-за переходного периода. Прогон по `pull_request` читает workflow
**из ветки PR**, а не из базовой, поэтому у PR, открытых до перехода на
`pull_request_target`, старая версия файла с триггером `pull_request` продолжает
запускаться. Без `event_name` в ключе такой прогон попадает в ту же группу и отменяет наш
прогон по `pull_request_target`. Дубли уйдут сами, как только ветки PR подтянут `develop`.

Номер PR в ключе — вместо `github.ref_name`: под `pull_request_target` `ref_name` равен
базовой ветке, и все PR оказывались в одной группе, отменяя прогоны друг друга.

## Правки этих файлов внутри PR не действуют

`pull_request_target` всегда берёт версию workflow из **базовой** ветки. Любые изменения
в `.github/workflows/**`, приехавшие в PR, вступят в силу только после мержа в `develop`.
Проверять их удобно через `workflow_dispatch` на ветке.
