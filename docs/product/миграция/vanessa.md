---
title: vanessa
---

# vrunner vanessa

Запуск BDD-тестов Vanessa-ADD (`bddRunner.epf`). В 3.0 — `vrunner test vanessa`: [документация](../команды/test#vanessa).

## Соответствие

| 2.x | 3.0 |
|-----|-----|
| `vrunner vanessa` | `vrunner test vanessa` |
| `--path <путь к фичам>` | `--feature-path <путь>` |
| `--pathvanessa <bddRunner.epf>` | `--bddrunner-path <путь>` |
| `--vanessasettings`, `--workspace`, `--tags-ignore`, `--tags-filter`, `--additional-keys`, `--additional` | без изменений |
| `RUNNER_VANESSASETTINGS`, `RUNNER_WORKSPACE`, `RUNNER_PATHVANESSA` | `VRUNNER_VANESSASETTINGS`, `VRUNNER_WORKSPACE`, `VRUNNER_PATHVANESSA` |
| Секция настроек `vanessa` | `vrunner.test.vanessa`; ключ `pathvanessa` скрипт конвертации переименовывает в `bddrunner-path`, `path` → `feature-path` — вручную |

`--feature-path` несовместима с `--ordinaryapp`. Отчёты о результатах: `--report-format`/`--report-path` — [Отчёты](../команды/reports).

## Пример

Было (2.x):

```bash
vrunner vanessa \
  --ibconnection /F./build/ib \
  --vanessasettings ./tools/vb-conf.json \
  --workspace . \
  --path ./features
```

Стало (3.0):

```bash
vrunner test vanessa \
  --ibconnection /F./build/ib \
  --vanessasettings ./tools/vb-conf.json \
  --workspace . \
  --feature-path ./features
```

Файл настроек — было (`vrunner.json`):

```json
{
  "vanessa": {
    "--vanessasettings": "./tools/vb-conf.json",
    "--workspace": ".",
    "--path": "./features"
  }
}
```

Стало (`autumn-properties.json`):

```json
{
  "vrunner": {
    "test": {
      "vanessa": {
        "vanessasettings": "./tools/vb-conf.json",
        "workspace": ".",
        "feature-path": "./features"
      }
    }
  }
}
```
