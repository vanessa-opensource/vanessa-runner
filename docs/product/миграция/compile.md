---
title: compile 
---

# vrunner compile / vrunner compileconf

Сборка конфигурации из XML-исходников в `.cf`. В 3.0 — `vrunner cf compile <OUT>`: [документация](../команды/cf#compile).

## Соответствие

| 2.x | 3.0 |
|-----|-----|
| `vrunner compile`, `vrunner compileconf` | `vrunner cf compile [опции] <OUT>` |
| `--out ./build/1Cv8.cf` | позиционный аргумент `OUT` (в командной строке, `VRUNNER_CF_OUT` или ключ `out` в файле настроек) |
| `--src ./cf` | `--src ./cf` (`-s`), по умолчанию — текущий каталог |
| `--ibconnection` | необязательна: без неё создаётся временная файловая база |
| — | `--ibcmd`: сборка утилитой ibcmd вместо конфигуратора |
| Секции настроек `compile`, `compileconf` | `vrunner.cf.compile` (ключи `src`, `out`) |

## Пример

Было (2.x):

```bash
vrunner compile \
  --src ./cf \
  --out ./build/1Cv8.cf \
  --ibconnection /F./build/tmp-ib \
  --v8version 8.3.24
```

Стало (3.0):

```bash
# Через ibcmd, без явной базы
vrunner cf compile --src ./cf --ibcmd ./build/1Cv8.cf

# Через конфигуратор с явной базой
vrunner cf compile \
  --src ./cf \
  --ibconnection /F./build/tmp-ib \
  --v8version 8.3.24 \
  ./build/1Cv8.cf
```

Файл настроек — было (`vrunner.json`):

```json
{
  "compile": {
    "--src": "./cf",
    "--out": "./build/1Cv8.cf"
  }
}
```

Стало (`autumn-properties.json`):

```json
{
  "vrunner": {
    "cf": {
      "compile": {
        "src": "./cf",
        "out": "./build/1Cv8.cf"
      }
    }
  }
}
```
