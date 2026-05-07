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
      { text: 'Начало работы', link: '/product/getting-started/10-about' },
      { text: 'Команды', link: '/product/commands/10-cf' },
      { text: 'Настройки', link: '/product/configuration/10-settings' },
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
            { text: 'О проекте', link: '/product/getting-started/10-about' },
            { text: 'Установка', link: '/product/getting-started/20-installation' },
            { text: 'Первые шаги', link: '/product/getting-started/30-first-steps' },
          ],
        },
        {
          text: 'Справочник команд',
          items: [
            { text: 'Подключение к базе данных', link: '/product/commands/05-common-options' },
            { text: 'cf - Работа с конфигурацией', link: '/product/commands/10-cf' },
            { text: 'cfe - Работа с расширениями', link: '/product/commands/20-cfe' },
            { text: 'epf - Работа с обработками', link: '/product/commands/30-epf' },
            { text: 'infobase - Работа с инфобазой', link: '/product/commands/40-infobase' },
            { text: 'repo - Работа с хранилищем', link: '/product/commands/50-repo' },
            { text: 'cluster - Управление кластером', link: '/product/commands/60-cluster' },
            { text: 'run - Запуск платформы', link: '/product/commands/70-run' },
            { text: 'test - Тестирование', link: '/product/commands/80-test' },
            { text: 'validate - Проверка кода', link: '/product/commands/90-validate' },
          ],
        },
        {
          text: 'Настройки',
          items: [
            { text: 'Файл настроек', link: '/product/configuration/10-settings' },
            { text: 'Переменные окружения', link: '/product/configuration/20-env' },
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
