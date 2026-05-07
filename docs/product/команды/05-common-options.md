---
title: Подключение к базе данных
---

# Подключение к базе данных

Большинство команд vanessa-runner работают с информационной базой 1С. На этой странице объясняется, как указать нужную базу и когда какие опции подключения нужны.

## Строка подключения (--ibconnection)

Опция `--ibconnection` указывает, **к какой базе** подключиться.

**Файловая ИБ:**

```bash
--ibconnection /F<путь>
```

Примеры: `--ibconnection /F./ib`, `--ibconnection /FD:/bases/MyProject`

**Серверная ИБ (1С:Сервер предприятия):**

```bash
--ibconnection "/S<хост>\<имя-ИБ>"
```

Пример: `--ibconnection "/SMyServer\MyInfobase"`

### Учётные данные ИБ

`--db-user` и `--db-pwd` - пользователь и пароль, созданные в 1С (не пользователь ОС или СУБД). Если база не требует аутентификации - можно не указывать.

## Конфигуратор или ibcmd?

По умолчанию vanessa-runner использует **Конфигуратор** (`1cv8.exe DESIGNER`).

Флаг `--ibcmd` переключает на утилиту **ibcmd**, которая работает напрямую с файлами базы без запуска сервера. Это быстрее и удобнее в CI/CD.

| | Конфигуратор | ibcmd |
|---|---|---|
| Нужен работающий кластер | Для серверных ИБ | Нет |
| СУБД-опции для серверной ИБ | Не нужны | Нужны |
| Скорость | Стандартная | Быстрее |

## Когда нужны опции СУБД (--dbms-*)

`--dbms-type`, `--dbms-server`, `--dbms-base`, `--dbms-user`, `--dbms-pwd` нужны в одном случае:

**ibcmd + серверная ИБ:**  
ibcmd подключается к СУБД напрямую, минуя 1С-сервер - нужны учётные данные СУБД.

::: tip
Для **файловых баз** или при работе через **Конфигуратор** опции `--dbms-*` **не нужны**.
:::

## Когда база необязательна (временная ИБ)

Некоторые команды работают без готовой базы - они автоматически создают временную ИБ, выполняют операцию и удаляют её:

| Команда | Поведение без `--ibconnection` |
|---------|-------------------------------|
| `cf compile`, `cfe compile`, `epf compile` | Создаётся временная файловая ИБ (удаляется после) |
| `cf decompile`, `cfe decompile`, `epf decompile` | То же самое |
| `infobase init` | Создаётся файловая ИБ в `build/ib` (не удаляется) |

Для всех остальных команд `--ibconnection` **обязателен**.

## Примеры

### Файловая ИБ

```bash
vrunner cf load ./src \
  --ibconnection /F./ib \
  --db-user Admin \
  --db-pwd secret
```

### Серверная ИБ через Конфигуратор

```bash
vrunner cf load ./src \
  --ibconnection "/SMyServer\MyIB" \
  --db-user Admin \
  --db-pwd secret
```

### Серверная ИБ через ibcmd

```bash
vrunner cf compile ./build/App.cf \
  --ibcmd \
  --ibconnection "/SMyServer\MyIB" \
  --dbms-type PostgreSQL \
  --dbms-server db.example.com \
  --dbms-base my_db \
  --dbms-user postgres \
  --dbms-pwd db_password
```

### Без базы (временная ИБ)

```bash
# ibcmd создаёт и удаляет временную базу автоматически
vrunner cf compile ./build/App.cf --ibcmd
```

### Загрузка в существующую серверную ИБ через ibcmd

::: warning
`infobase init` **не создаёт** серверную ИБ. Создайте базу заранее - через консоль кластера 1С или `ibcmd infobase create`, затем загрузите конфигурацию:
:::

```bash
vrunner infobase init \
  --ibconnection "/SMyServer\MyNewIB" \
  --ibcmd \
  --dbms-type MSSQLServer \
  --dbms-server sql.example.com \
  --dbms-base MyNewDB \
  --dbms-user sa \
  --dbms-pwd secret \
  --source ./build/App.cf
```
