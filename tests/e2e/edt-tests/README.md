# EDT-блок e2e-тестов

Этот каталог содержит e2e-тесты, проверяющие поддержку формата **1С:EDT** в командах
vanessa-runner (`cf`/`cfe` с `--src-format edt`, автоопределение формата, `epf convert`,
команда `validate edt`). Они выполняют реальную конвертацию EDT ↔ XML, сборку проекта
внешних обработок и проверку через `1cedtcli`.

## Почему отдельный блок

Тестам нужна установленная **1С:EDT** (исполняемый `1cedtcli`), которой нет на CI.
Поэтому каталог намеренно вынесен из `tests/e2e/client-tests/` — основной e2e-прогон
(`tasks/test_e2e.os`, рекурсивно по `client-tests`) его **не** подхватывает.

В отличие от остальных e2e-тестов, проверки здесь жёсткие: если `1cedtcli` не найдена,
команда vanessa-runner завершится с ошибкой «Не удалось найти 1cedtcli», и тест упадёт
(а не пропустится «по-тихому»).

## Как запустить

Локально или на раннере с установленной 1С:EDT **и** платформой 1С:Предприятие:

```sh
oscript tasks/test_e2e_edt.os
```

Отчёт JUnit: `build/reports/junit-edt.xml`.

`1cedtcli` ищется библиотекой [edtfind](https://github.com/senja006/EDTfind/) (по умолчанию —
максимальная установленная версия EDT). Переопределить:

| Переменная окружения / опция | Назначение |
|---|---|
| `VRUNNER_EDT_VERSION` / `--edt-version` | выбрать конкретную версию EDT (например `2024.1`) |
| `VRUNNER_EDT_WORKSPACE` / `--edt-workspace` | базовый каталог рабочей области EDT |

## Состав

Тесты атомарные — по одной операции на сценарий.

| Тест | Команда | Сценарий |
|---|---|---|
| `cf/ТестCfCompileEdt.os`    | `cf compile --src-format edt`   | сборка `.cf` из EDT-исходников конфигурации |
| `cf/ТестCfLoadEdt.os`       | `cf load --src-format edt`      | загрузка EDT-исходников конфигурации в базу |
| `cf/ТестCfDecompileEdt.os`  | `cf decompile --src-format edt` | разборка `.cf` в EDT-проект конфигурации |
| `cf/ТестCfAutodetectEdt.os` | `cf compile` (без `--src-format`)| автоопределение формата EDT по маркерам каталога |
| `cfe/ТестCfeCompileEdt.os`  | `cfe compile --src-format edt`  | сборка `.cfe` из EDT-исходников расширения |
| `cfe/ТестCfeDecompileEdt.os`| `cfe decompile --src-format edt`| разборка `.cfe` в EDT-проект расширения |
| `epf/ТестEpfConvertEdt.os`  | `epf convert`                   | двунаправленная конвертация внешних объектов EDT ⇄ XML (export/import, round-trip) |
| `epf/ТестEpfCompileEdt.os`  | `epf compile --src-format edt`  | сборка `.epf` из EDT-проекта внешних обработок (EDT → XML → `.epf`) |
| `epf/ТестEpfDecompileEdt.os`| `epf decompile --src-format edt`| разборка `.epf` в EDT-проект внешних объектов (`.epf` → XML → EDT) |
| `validate/ТестValidateEdt.os`| `validate edt`                 | проверка EDT-проекта (1cedtcli validate), отчёт + порог `--min-severity` |

> `epf compile`/`epf decompile`/`epf convert` работают и с форматом EDT (через `1cedtcli`
> export/import). Требуют установленной 1С:EDT, поэтому проверяются здесь, а не в CI-блоке.

> Осмысленная ошибка при неверном `--src-format edt` на XML-дампе проверяется в
> CI-блоке (`tests/e2e/client-tests/cf/ТестCfSrcFormatEdt.os`) — она не требует EDT.

## Фикстуры EDT-проектов

Готовые EDT-проекты (для команд `compile`/`load`, которым нужны EDT-исходники на входе):

| Фикстура | Назначение |
|---|---|
| `tests/e2e/fixtures/edt/Конфигурация` | EDT-проект конфигурации (`V8ConfigurationNature`) |
| `tests/e2e/fixtures/edt/Расширение`   | EDT-проект расширения (`V8ExtensionNature`) |
| `tests/e2e/fixtures/edt/ВнешниеОбработки` | EDT-проект внешних обработок (`V8ExternalObjectsNature`) с двумя обработками (для `epf convert`) |

Сгенерированы из XML-фикстур `fixtures/cf`, `fixtures/cfe` и `fixtures/epf` импортом через
`1cedtcli` (версия проекта 8.3.14). Пересоздать при изменении XML-фикстур:

```sh
oscript tasks/create_edt_fixtures.os
```

Тесты работают с копией фикстуры во временном каталоге — коммитнутая фикстура не меняется.

## Юнит-тесты

Логика `СервисEDT` без реальной EDT покрыта юнит-тестами (`tests/unit/Сервисы/ТестСервисEDT.os`
со стабами `1cedtcli`/edtfind) — они работают на CI и здесь не дублируются.
