# cluster - Управление кластером серверов

Группа команд `cluster` обеспечивает управление кластером серверов 1С через утилиты `rac`/`ras`: получение информации, создание и удаление кластера, управление сеансами и фоновыми заданиями.

```bash
vrunner cluster <подкоманда> [опции]
```

## Подключение и администрирование

Все подкоманды `cluster` управляют кластером через утилиту `rac`/`ras`. Подробнее о строке подключения: [Подключение к базе данных](./05-common-options).

**Опции, доступные всем подкомандам:**

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--ras` | `VRUNNER_RAS` | Сетевой адрес RAS (по умолчанию `localhost:1545`) |
| `--rac` | `VRUNNER_RAC` | Путь к утилите `rac` |
| `--db-name` | `VRUNNER_IBNAME` | Имя информационной базы в кластере |
| `--cluster` | - | Идентификатор кластера |
| `--cluster-name` | - | Имя кластера |
| `--cluster-admin` | `VRUNNER_CLUSTERADMIN_USER` | Имя администратора кластера |
| `--cluster-pwd` | `VRUNNER_CLUSTERADMIN_PWD` | Пароль администратора кластера |
| `--ibconnection` | `VRUNNER_IBCONNECTION` | Строка подключения к ИБ (для идентификации базы в кластере) |
| `--db-user` | `VRUNNER_DBUSER` | Пользователь ИБ |
| `--db-pwd` | `VRUNNER_DBPWD` | Пароль пользователя ИБ |
| `--v8version` | `VRUNNER_V8VERSION` | Версия платформы 1С |
| `--settings` | `VRUNNER_SETTINGS` | Путь к файлу настроек (JSON) |

::: tip
`cluster create` дополнительно использует опции СУБД (`--dbms-type`, `--dbms-server`, `--dbms-base`, `--dbms-user`, `--dbms-pwd`).
:::

## info

Выводит информацию об информационной базе в кластере.

```bash
vrunner cluster info [опции]
```

### Примеры

```bash
vrunner cluster info \
  --ras localhost:1545 \
  --db-name MyInfobase \
  --cluster-admin ClusterAdmin \
  --cluster-pwd secret
```

## create

Создаёт новый кластер серверов 1С.

```bash
vrunner cluster create [опции]
```

## remove

Удаляет кластер серверов 1С.

```bash
vrunner cluster remove [опции]
```

## session

Группа подкоманд для управления сеансами информационной базы.

```bash
vrunner cluster session <подкоманда> [опции]
```

### session lock

Блокирует новые сеансы для информационной базы.

```bash
vrunner cluster session lock [опции]
```

#### Опции

| Опция | Переменная окружения | Описание |
|-------|---------------------|----------|
| `--permission-code` | - | Код допуска к заблокированной ИБ |
| `--denied-message` | - | Сообщение, отображаемое при попытке начать сеанс |
| `--ras` | `VRUNNER_RAS` | Сетевой адрес RAS (по умолчанию `localhost:1545`) |
| `--rac` | `VRUNNER_RAC` | Путь к утилите `rac` |
| `--db-name` | `VRUNNER_IBNAME` | Имя ИБ в кластере |
| `--cluster` | - | Идентификатор кластера |
| `--cluster-name` | - | Имя кластера |
| `--cluster-admin` | `VRUNNER_CLUSTERADMIN_USER` | Имя администратора кластера |
| `--cluster-pwd` | `VRUNNER_CLUSTERADMIN_PWD` | Пароль администратора кластера |
| `--settings` | `VRUNNER_SETTINGS` | Путь к файлу настроек (JSON) |

#### Примеры

```bash
vrunner cluster session lock \
  --ras localhost:1545 \
  --db-name MyInfobase \
  --cluster-admin ClusterAdmin \
  --cluster-pwd secret \
  --permission-code MySecretCode \
  --denied-message "База закрыта на обслуживание. Используйте код: MySecretCode"
```

### session unlock

Снимает блокировку новых сеансов для информационной базы.

```bash
vrunner cluster session unlock [опции]
```

#### Примеры

```bash
vrunner cluster session unlock \
  --ras localhost:1545 \
  --db-name MyInfobase \
  --cluster-admin ClusterAdmin \
  --cluster-pwd secret
```

### session kill

Принудительно завершает активные сеансы информационной базы.

```bash
vrunner cluster session kill [опции]
```

#### Примеры

```bash
vrunner cluster session kill \
  --ras localhost:1545 \
  --db-name MyInfobase \
  --cluster-admin ClusterAdmin \
  --cluster-pwd secret
```

## jobs

Группа подкоманд для управления фоновыми заданиями информационной базы.

```bash
vrunner cluster jobs <подкоманда> [опции]
```

### jobs lock

Блокирует выполнение фоновых заданий для информационной базы.

```bash
vrunner cluster jobs lock [опции]
```

### jobs unlock

Снимает блокировку фоновых заданий для информационной базы.

```bash
vrunner cluster jobs unlock [опции]
```

## Типичный сценарий: обновление под нагрузкой

```bash
# 1. Заблокировать новые сеансы
vrunner cluster session lock \
  --ras localhost \
  --db-name MyIB \
  --cluster-admin admin \
  --cluster-pwd pwd \
  --permission-code UPDATE2026

# 2. Завершить активные сеансы
vrunner cluster session kill \
  --ras localhost \
  --db-name MyIB \
  --cluster-admin admin \
  --cluster-pwd pwd

# 3. Заблокировать фоновые задания
vrunner cluster jobs lock \
  --ras localhost \
  --db-name MyIB \
  --cluster-admin admin \
  --cluster-pwd pwd

# 4. ... обновление ИБ ...

# 5. Разблокировать задания и сеансы
vrunner cluster jobs unlock ...
vrunner cluster session unlock ...
```
