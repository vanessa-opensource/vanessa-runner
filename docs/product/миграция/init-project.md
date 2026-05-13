---
title: init-project
---

# vrunner init-project

Создавал структуру нового проекта: клонировал шаблон, устанавливал пакеты (gitsync, gitrules, precommit1c).

::: danger Команда удалена в 3.0
`vrunner init-project` не имеет прямого аналога в vanessa-runner 3.0.

Инициализация проекта выполняется вручную или сторонними инструментами.
:::

## Что делала команда в 2.x

```bash
# Создать проект по шаблону
vrunner init-project --template https://github.com/user/myrepo.git

# Создать по файлу настроек
vrunner init-project --settings my-path/env.json
```

- Клонировала Git-репозиторий-шаблон
- Предлагала установку пакетов: `gitsync`, `gitrules`, `precommit1c`
- Создавала структуру каталогов по шаблону

## Альтернативы в 3.0

### Ручная инициализация

Скопируйте шаблон вручную или используйте `git clone`:

```bash
git clone https://github.com/vanessa-opensource/vanessa-bootstrap.git my-project
cd my-project
```

### Установка пакетов

Пакеты устанавливаются через `opm` напрямую:

```bash
opm install vanessa-runner
opm install gitsync
opm install gitrules
```

### Шаблонные репозитории GitHub/GitLab

Используйте функционал шаблонных репозиториев на уровне платформы хостинга:
- [Template repositories (GitHub)](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-template-repository)
- [GitLab project templates](https://docs.gitlab.com/ee/user/project/working_with_projects.html#create-a-project-from-a-built-in-template)
