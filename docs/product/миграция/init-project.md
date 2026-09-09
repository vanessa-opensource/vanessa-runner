---
title: init-project
---

# vrunner init-project

Создавала структуру нового проекта по шаблону: клонировала Git-репозиторий и предлагала установить пакеты `gitsync`, `gitrules`, `precommit1c`.

В 3.0 аналога нет. Секция `init-project` файла настроек скриптом конвертации не переносится.

Вместо команды клонируйте шаблон и установите пакеты вручную:

```bash
git clone https://github.com/vanessa-opensource/vanessa-bootstrap.git my-project
cd my-project
opm install vanessa-runner
opm install gitsync
```
