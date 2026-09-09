---
title: repo
---

# repo - Работа с хранилищем конфигурации

Команды `repo` работают с хранилищем конфигурации 1С через Конфигуратор: создание хранилища, подключение базы, получение и помещение изменений, захват объектов, пользователи хранилища.

```bash
vrunner repo <подкоманда> [опции] [аргументы]
```

Адрес хранилища, пользователь, пароль и номер версии задаются общими опциями `--storage-name`, `--storage-user`, `--storage-pwd`, `--storage-ver` - см. [Хранилище конфигурации](./common-options#хранилище-конфигурации). Командам `create`, `create-user`, `copy-user` и `save-cf` информационная база не нужна: без `--ibconnection` создаётся временная файловая ИБ. Остальные команды работают с базой из `--ibconnection`.

## create

Создаёт хранилище конфигурации по адресу `--storage-name`; `--storage-user` и `--storage-pwd` становятся его администратором.

```bash
vrunner repo create [опции]
```

> Общие опции: [подключение к ИБ](./common-options#подключение-к-информационной-базе), [платформа](./common-options#платформа), [СУБД](./common-options#опции-субд), [хранилище](./common-options#хранилище-конфигурации), [файл настроек](./common-options#файл-настроек).

### Примеры

```bash
vrunner repo create \
  --storage-name D:/repos/MyProject \
  --storage-user Администратор \
  --storage-pwd secret
```

## bind

Подключает информационную базу к хранилищу. По умолчанию конфигурация базы заменяется конфигурацией хранилища.

```bash
vrunner repo bind [опции]
```

### Опции

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--ignore-already-bound` | - | Не считать ошибкой, что пользователь уже подключён к хранилищу |
| `--do-not-replace-cfg` | - | Не заменять конфигурацию базы конфигурацией хранилища |

> Общие опции: [подключение к ИБ](./common-options#подключение-к-информационной-базе), [платформа](./common-options#платформа), [СУБД](./common-options#опции-субд), [хранилище](./common-options#хранилище-конфигурации), [файл настроек](./common-options#файл-настроек).

### Примеры

```bash
vrunner repo bind \
  --storage-name D:/repos/MyProject \
  --storage-user DevUser \
  --storage-pwd secret \
  --ignore-already-bound \
  --ibconnection /F./ib
```

## unbind

Отключает информационную базу от хранилища. Опции хранилища не нужны.

```bash
vrunner repo unbind [опции]
```

> Общие опции: [подключение к ИБ](./common-options#подключение-к-информационной-базе), [платформа](./common-options#платформа), [СУБД](./common-options#опции-субд), [файл настроек](./common-options#файл-настроек).

### Примеры

```bash
vrunner repo unbind --ibconnection /F./ib
```

## load

Обновляет конфигурацию базы из хранилища: до версии `--storage-ver` или до последней. Конфигурация БД при этом не обновляется - выполните [`infobase update`](./infobase#update).

```bash
vrunner repo load [опции]
```

> Общие опции: [подключение к ИБ](./common-options#подключение-к-информационной-базе), [платформа](./common-options#платформа), [СУБД](./common-options#опции-субд), [хранилище](./common-options#хранилище-конфигурации), [файл настроек](./common-options#файл-настроек).

### Примеры

```bash
# Последняя версия хранилища
vrunner repo load \
  --storage-name D:/repos/MyProject \
  --storage-user DevUser \
  --storage-pwd secret \
  --ibconnection /F./ib

# Конкретная версия
vrunner repo load --storage-name D:/repos/MyProject --storage-user DevUser --storage-pwd secret --storage-ver 42 --ibconnection /F./ib
```

## lock

Захватывает объекты в хранилище: все или перечисленные в XML-файле `--objects`.

```bash
vrunner repo lock [опции]
```

### Опции

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--objects` | - | Путь к XML-файлу со списком объектов |
| `--revised` | - | Получить захваченные объекты из хранилища (`-revised`) |

> Общие опции: [подключение к ИБ](./common-options#подключение-к-информационной-базе), [платформа](./common-options#платформа), [СУБД](./common-options#опции-субд), [хранилище](./common-options#хранилище-конфигурации), [файл настроек](./common-options#файл-настроек).

### Примеры

```bash
vrunner repo lock \
  --objects ./objects.xml \
  --storage-name D:/repos/MyProject \
  --storage-user DevUser \
  --storage-pwd secret \
  --ibconnection /F./ib
```

## unlock

Отменяет захват объектов: всех или перечисленных в XML-файле `--objects`.

```bash
vrunner repo unlock [опции]
```

### Опции

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--objects` | - | Путь к XML-файлу со списком объектов |
| `--force` | - | Отменить захват, даже если объекты изменены локально |

> Общие опции: [подключение к ИБ](./common-options#подключение-к-информационной-базе), [платформа](./common-options#платформа), [СУБД](./common-options#опции-субд), [хранилище](./common-options#хранилище-конфигурации), [файл настроек](./common-options#файл-настроек).

### Примеры

```bash
vrunner repo unlock \
  --force \
  --storage-name D:/repos/MyProject \
  --storage-user DevUser \
  --storage-pwd secret \
  --ibconnection /F./ib
```

## commit

Помещает изменения захваченных объектов в хранилище: всех или перечисленных в XML-файле `--objects`.

```bash
vrunner repo commit [опции]
```

### Опции

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--objects` | - | Путь к XML-файлу со списком объектов |
| `--comment` | - | Комментарий к помещаемым объектам |
| `--keep-locked` | - | Оставить объекты захваченными после помещения |
| `--force` | - | Игнорировать удалённые объекты |

> Общие опции: [подключение к ИБ](./common-options#подключение-к-информационной-базе), [платформа](./common-options#платформа), [СУБД](./common-options#опции-субд), [хранилище](./common-options#хранилище-конфигурации), [файл настроек](./common-options#файл-настроек).

### Примеры

```bash
vrunner repo commit \
  --comment "Задача #123: добавлены новые справочники" \
  --storage-name D:/repos/MyProject \
  --storage-user DevUser \
  --storage-pwd secret \
  --ibconnection /F./ib
```

## save-cf

Сохраняет конфигурацию из хранилища в файл `.cf`: версию `--storage-ver` или последнюю.

```bash
vrunner repo save-cf [опции] <OUT>
```

### Аргументы

| Аргумент | Переменная окружения | Описание |
|----------|---------------------|----------|
| `OUT` | - | Путь к создаваемому файлу `.cf` (**обязательный**; в файле настроек - ключ `out`) |

> Общие опции: [подключение к ИБ](./common-options#подключение-к-информационной-базе), [платформа](./common-options#платформа), [СУБД](./common-options#опции-субд), [хранилище](./common-options#хранилище-конфигурации), [файл настроек](./common-options#файл-настроек).

### Примеры

```bash
vrunner repo save-cf \
  --storage-name D:/repos/MyProject \
  --storage-user DevUser \
  --storage-pwd secret \
  --storage-ver 100 \
  ./build/MyApp.cf
```

## create-user

Создаёт пользователя хранилища; у `--storage-user` должны быть права администрирования хранилища.

```bash
vrunner repo create-user [опции]
```

### Опции

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--new-user-name` | - | Логин нового пользователя (**обязательная**) |
| `--new-user-pwd` | - | Пароль нового пользователя |
| `--new-user-role` | - | Роль: `ReadOnly` (по умолчанию), `LockObjects`, `ManageConfigurationVersions`, `Administration` |

> Общие опции: [подключение к ИБ](./common-options#подключение-к-информационной-базе), [платформа](./common-options#платформа), [СУБД](./common-options#опции-субд), [хранилище](./common-options#хранилище-конфигурации), [файл настроек](./common-options#файл-настроек).

### Примеры

```bash
vrunner repo create-user \
  --new-user-name DevUser \
  --new-user-pwd secret \
  --new-user-role LockObjects \
  --storage-name D:/repos/MyProject \
  --storage-user Администратор \
  --storage-pwd secret
```

## copy-user

Копирует пользователей из другого хранилища (`--source-storage-*`) в хранилище `--storage-name`.

```bash
vrunner repo copy-user [опции]
```

### Опции

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--source-storage-name` | - | Адрес хранилища-источника (**обязательная**) |
| `--source-storage-user` | - | Пользователь хранилища-источника |
| `--source-storage-pwd` | - | Пароль хранилища-источника |
| `--restore-deleted` | - | Восстановить удалённых пользователей |

> Общие опции: [подключение к ИБ](./common-options#подключение-к-информационной-базе), [платформа](./common-options#платформа), [СУБД](./common-options#опции-субд), [хранилище](./common-options#хранилище-конфигурации), [файл настроек](./common-options#файл-настроек).

### Примеры

```bash
vrunner repo copy-user \
  --source-storage-name D:/repos/OldProject \
  --source-storage-user Администратор \
  --source-storage-pwd secret \
  --storage-name D:/repos/MyProject \
  --storage-user Администратор \
  --storage-pwd secret
```
