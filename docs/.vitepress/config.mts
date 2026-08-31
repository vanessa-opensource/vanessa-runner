import { defineConfig } from 'vitepress'

export default defineConfig({
  title: 'vanessa-runner',
  description: 'Автоматизация повседневных операций 1С разработчика',
  lang: 'ru-RU',

  lastUpdated: true,
  cleanUrls: true,

  srcDir: '.',
  base: '/vanessa-runner/',

  markdown: {
    lineNumbers: true,
    theme: {
      light: 'github-light',
      dark: 'github-dark',
    },
  },

  themeConfig: {
    logo: '/logo.png',
    siteTitle: 'vanessa-runner',

    nav: [
      { text: 'Начало работы', link: '/product/начало-работы/10-установка' },
      { text: 'Команды', link: '/product/команды/10-cf' },
      { text: 'Настройки', link: '/product/настройка/10-настройки' },
      { text: 'MCP', link: '/product/mcp' },
      { text: 'Миграция с 2.x', link: '/product/миграция/' },
      {
        text: 'GitHub',
        link: 'https://github.com/vanessa-opensource/vanessa-runner',
      },
    ],

    sidebar: {
      '/product/': [
        {
          text: 'Начало работы',
          items: [
            { text: 'Установка', link: '/product/начало-работы/10-установка' },
            { text: 'Первые шаги', link: '/product/начало-работы/20-первые-шаги' },
          ],
        },
        {
          text: 'Справочник команд',
          items: [
            { text: 'Подключение к базе данных', link: '/product/команды/05-common-options' },
            { text: 'Отчёты о результатах', link: '/product/команды/07-reports' },
            { text: 'cf - Работа с конфигурацией', link: '/product/команды/10-cf' },
            { text: 'cfe - Работа с расширениями', link: '/product/команды/20-cfe' },
            { text: 'epf - Работа с обработками', link: '/product/команды/30-epf' },
            { text: 'infobase - Работа с инфобазой', link: '/product/команды/40-infobase' },
            { text: 'repo - Работа с хранилищем', link: '/product/команды/50-repo' },
            { text: 'cluster - Управление кластером', link: '/product/команды/60-cluster' },
            { text: 'run - Запуск платформы', link: '/product/команды/70-run' },
            { text: 'test - Тестирование', link: '/product/команды/80-test' },
            { text: 'Сбор покрытия тестами', link: '/product/команды/85-coverage' },
            { text: 'validate - Проверка кода', link: '/product/команды/90-validate' },
          ],
        },
        {
          text: 'Настройки',
          items: [
            { text: 'Файл настроек', link: '/product/настройка/10-настройки' },
            { text: 'Переменные окружения', link: '/product/настройка/20-переменные-окружения' },
          ],
        },
        {
          text: 'Интеграция с ИИ-ассистентами',
          items: [
            { text: 'MCP-сервер', link: '/product/mcp' },
          ],
        },
        {
          text: 'Миграция с 2.x',
          collapsed: true,
          items: [
            { text: 'Обзор изменений', link: '/product/миграция/' },
            { text: 'Файл настроек и переменные окружения', link: '/product/миграция/settings' },
            { text: 'vrunner vanessa', link: '/product/миграция/vanessa' },
            { text: 'vrunner xunit', link: '/product/миграция/xunit' },
            { text: 'vrunner run', link: '/product/миграция/run' },
            { text: 'vrunner loadrepo', link: '/product/миграция/loadrepo' },
            { text: 'vrunner init-dev / update-dev', link: '/product/миграция/init-dev' },
            { text: 'vrunner updatedb', link: '/product/миграция/updatedb' },
            { text: 'vrunner syntax-check', link: '/product/миграция/syntax-check' },
            { text: 'vrunner compile / compileconf', link: '/product/миграция/compile' },
            { text: 'vrunner decompile / decompileconf', link: '/product/миграция/decompile' },
            { text: 'vrunner compileepf', link: '/product/миграция/compileepf' },
            { text: 'vrunner decompileepf', link: '/product/миграция/decompileepf' },
            { text: 'vrunner compileext', link: '/product/миграция/compileext' },
            { text: 'vrunner decompileext', link: '/product/миграция/decompileext' },
            { text: 'vrunner designer', link: '/product/миграция/designer' },
            { text: 'vrunner session', link: '/product/миграция/session' },
            { text: 'vrunner scheduledjobs', link: '/product/миграция/scheduledjobs' },
            { text: 'vrunner init-project', link: '/product/миграция/init-project' },
          ],
        },
      ],
    },

    search: {
      provider: 'local',
      options: {
        translations: {
          button: { buttonText: 'Поиск', buttonAriaLabel: 'Поиск' },
          modal: {
            noResultsText: 'Нет результатов для',
            resetButtonTitle: 'Сбросить поиск',
            footer: {
              selectText: 'выбрать',
              navigateText: 'перейти',
              closeText: 'закрыть',
            },
          },
        },
      },
    },

    footer: {
      message: 'Документация vanessa-runner',
      copyright: `© ${new Date().getFullYear()} vanessa-opensource`,
    },

    socialLinks: [
      { icon: 'github', link: 'https://github.com/vanessa-opensource/vanessa-runner' },
      { icon: 'telegram', link: 'https://t.me/vanessa_opensource_chat' },
    ],

    editLink: {
      pattern:
        'https://github.com/vanessa-opensource/vanessa-runner/edit/main/docs/:path',
      text: 'Редактировать на GitHub',
    },

    lastUpdated: {
      text: 'Обновлено',
      formatOptions: { dateStyle: 'medium', timeStyle: 'short' },
    },

    outline: {
      level: [2, 3],
      label: 'На этой странице',
    },

    docFooter: {
      prev: 'Предыдущая',
      next: 'Следующая',
    },
  },
})
