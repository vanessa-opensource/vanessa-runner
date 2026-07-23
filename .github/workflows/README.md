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

## Гейт для форков

`pull_request_target` **не подпадает** под встроенную настройку «Require approval for
first-time contributors» — она относится только к `pull_request`. То есть без
дополнительных мер любой PR из форка выполнил бы произвольный код со всеми секретами
репозитория сразу, без подтверждения.

Поэтому в каждом тестовом workflow есть джоба-допуск:

```yaml
jobs:
  gate:
    name: Допуск прогона кода из форка
    if: github.event.pull_request.head.repo.fork
    runs-on: ubuntu-22.04
    environment: pr-from-fork
    steps:
      - run: echo "Мейнтейнер подтвердил прогон кода из форка"
```

Тестовые джобы висят на `needs: gate` с условием «gate прошёл **или** пропущен»:

```yaml
    needs: gate
    if: ${{ !cancelled() && (needs.gate.result == 'success' || needs.gate.result == 'skipped') }}
```

* PR из форка → `gate` уходит в ожидание ревью environment'а, мейнтейнер смотрит диф и жмёт
  **Review deployments → Approve** в шапке прогона. Подтверждение нужно на каждый прогон,
  то есть после каждого пуша в ветку PR.
* `push`, `workflow_dispatch`, PR из веток самого репозитория → `gate` пропускается,
  тесты идут сразу.

### Настройка environment (делается один раз)

`Settings → Environments → New environment` с именем **`pr-from-fork`**, в нём включить
**Required reviewers** и добавить мейнтейнеров. Секреты в сам environment класть не нужно:
джобы берут репозиторные, а environment здесь работает только как gate.

Пока environment не создан, `gate` для PR из форка упадёт (`Unable to find environment`),
и тестовые джобы не запустятся — то есть отказ безопасный.

### Что стоит сделать дополнительно

`OSHUB_TOKEN` (публикация пакета в hub.oscript.io) и `TRIGGER_DOCS_DEPLOY_TOKEN` тестам не
нужны, но как репозиторные секреты они видны любой джобе, выполняющей код из PR. Их стоит
перенести в отдельный environment (например `release`) и указать его в `release.yml` /
`docs-deploy.yaml` — тогда прогон PR до них не дотянется даже при компрометации.

## Правки этих файлов внутри PR не действуют

`pull_request_target` всегда берёт версию workflow из **базовой** ветки. Любые изменения
в `.github/workflows/**`, приехавшие в PR, вступят в силу только после мержа в `develop`.
Проверять их удобно через `workflow_dispatch` на ветке.
