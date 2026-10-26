---
title: decompile
---

# vrunner decompile

Разборка `.cf` в XML-исходники. В 3.0 — `vrunner cf decompile <OUT>`: [документация](../команды/cf#decompile).

## Соответствие

| 2.x | 3.0 |
|-----|-----|
| `vrunner decompile` | `vrunner cf decompile [опции] <OUT>` |
| `--out ./cf` | позиционный аргумент `OUT` (в командной строке или ключ `out` в файле настроек) |
| `--in ./build/1Cv8.cf` | `--cf-file ./build/1Cv8.cf` (`VRUNNER_CF_FILE`): без `--ibconnection` файл загружается во временную базу, с ней (в том числе из настроек или `VRUNNER_IBCONNECTION`) — в указанную, её конфигурация заменяется; без `--cf-file` выгружается конфигурация базы из `--ibconnection` |
| `--current` (`-c`) | не нужен: без `--cf-file` выгружается конфигурация базы `--ibconnection` |
| `--ibcmd`, `--dbms-*` | без изменений |
| `-i`, `-o`, `--versions` (`-v`), `--userenames` | убраны |
| Секция настроек `decompile` | `vrunner.cf.decompile`; ключ `in` → `cf-file` переименуйте вручную |

## Пример

Было (2.x):

```bash
vrunner decompile \
  --in ./build/1Cv8.cf \
  --out ./cf
```

Стало (3.0):

```bash
# Из файла cf через ibcmd
vrunner cf decompile --cf-file ./build/1Cv8.cf --ibcmd ./cf

# Конфигурация базы через конфигуратор
vrunner cf decompile --ibconnection /F./build/ib ./cf
```

Файл настроек — было (`env.json`):

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
