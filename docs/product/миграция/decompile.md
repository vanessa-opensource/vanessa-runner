---
title: decompile
---

# vrunner decompile / vrunner decompileconf

Разборка `.cf` в XML-исходники. В 3.0 — `vrunner cf decompile <OUT>`: [документация](../команды/cf#decompile).

## Соответствие

| 2.x | 3.0 |
|-----|-----|
| `vrunner decompile`, `vrunner decompileconf` | `vrunner cf decompile [опции] <OUT>` |
| `--out ./cf` | позиционный аргумент `OUT` (в командной строке или ключ `out` в файле настроек) |
| `--in ./build/1Cv8.cf` | `--cf-file ./build/1Cv8.cf` (`VRUNNER_CF_FILE`); без неё выгружается конфигурация базы из `--ibconnection` |
| — | `--ibcmd`: разборка утилитой ibcmd вместо конфигуратора |
| Секции настроек `decompile`, `decompileconf` | `vrunner.cf.decompile`; ключ `in` → `cf-file` переименуйте вручную |

## Пример

Было (2.x):

```bash
vrunner decompile \
  --in ./build/1Cv8.cf \
  --out ./cf \
  --ibconnection /F./build/tmp-ib
```

Стало (3.0):

```bash
# Из файла cf через ibcmd
vrunner cf decompile --cf-file ./build/1Cv8.cf --ibcmd ./cf

# Конфигурация базы через конфигуратор
vrunner cf decompile --ibconnection /F./build/ib ./cf
```

Файл настроек — было (`vrunner.json`):

```json
{
  "decompile": {
    "--in": "./build/1Cv8.cf",
    "--out": "./cf"
  }
}
```

Стало (`autumn-properties.json`):

```json
{
  "vrunner": {
    "cf": {
      "decompile": {
        "cf-file": "./build/1Cv8.cf",
        "out": "./cf"
      }
    }
  }
}
```
