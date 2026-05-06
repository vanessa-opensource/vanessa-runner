# Установка

## Требования

- [OneScript](https://oscript.io/) версии 2.0 и выше
- Платформа 1С:Предприятие 8.3 (для работы с базами)

## Установка через opm

```bash
opm install vanessa-runner
```

После установки команда `vrunner` будет доступна глобально.

## Установка из исходников

```bash
git clone https://github.com/vanessa-opensource/vanessa-runner.git
cd vanessa-runner
opm install -l
```

## Проверка установки

```bash
vrunner --version
```

Ожидаемый вывод:

```
vanessa-runner 3.x.x
```

## Обновление

```bash
opm install -u vanessa-runner
```

## Установка зависимостей для разработки

```bash
opm install
```

Зависимости устанавливаются в папку `oscript_modules/`.
