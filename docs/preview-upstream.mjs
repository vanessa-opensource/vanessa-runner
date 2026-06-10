// Собирает документацию ТЕМ ЖЕ способом, что и боевой сайт
// https://autumn-library.github.io (репозиторий autumn-library/autumn-library.github.io).
//
// Зачем: боевой сайт — это агрегатор. Он подключает docs/product каждого продукта
// как docs/products/<NNN>-<repo>, а обработчик ссылок (`rewrites` в его config.mts)
// вырезает числовые префиксы сортировки (`\d+-`) и сегмент `products/` из URL.
// Поэтому внутренние ссылки в наших доках пишутся БЕЗ префиксов: `./command-options`,
// `./edt`, `./команды/cf` и т.п. Локальный standalone-билд из docs/.vitepress этого
// обработчика не знает и даёт ложные «битые ссылки». Этот скрипт строит ровно как прод.
//
// Что делает:
//   1. клонирует (или обновляет) репозиторий агрегатора в build/docs-site;
//   2. ставит зависимости агрегатора;
//   3. запускает его `npm run sync` — подтягивает остальные продукты (autumn и пр.),
//      чтобы собрался весь сайт и отработала реальная проверка ссылок;
//   4. переключает слот products/<NNN>-vanessa-runner на ЛОКАЛЬНУЮ копию docs/product;
//   5. запускает реальный `npm run docs:build` (или `docs:dev` с флагом --serve).
//
// Запуск:
//   node docs/preview-upstream.mjs            # полная сборка (проверка битых ссылок)
//   node docs/preview-upstream.mjs --serve    # локальный dev-сервер с нашими доками
//   node docs/preview-upstream.mjs --skip-sync # без повторного клонирования соседей
//                                              # (только после хотя бы одной полной сборки)
//
// Требования: Node.js >= 20, git. Symlink'и: на Windows используется junction
// (права администратора не нужны).

import { execSync } from 'node:child_process'
import fs from 'node:fs'
import path from 'node:path'
import { fileURLToPath } from 'node:url'

const __dirname = path.dirname(fileURLToPath(import.meta.url))
const REPO_ROOT = path.resolve(__dirname, '..')
const LOCAL_PRODUCT_DOCS = path.join(REPO_ROOT, 'docs', 'product')
const AGGREGATOR_URL = 'https://github.com/autumn-library/autumn-library.github.io.git'
const WORK_DIR = path.join(REPO_ROOT, 'build', 'docs-site') // build/ уже в .gitignore
const REPO_NAME = 'vanessa-runner'

const args = process.argv.slice(2)
const serve = args.includes('--serve') || args.includes('--preview')
const skipSync = args.includes('--skip-sync')

function run(cmd, cwd) {
  console.log(`\n$ ${cmd}${cwd ? `   (cwd: ${cwd})` : ''}`)
  execSync(cmd, { cwd, stdio: 'inherit' })
}

// 1. клон / обновление агрегатора
if (!fs.existsSync(path.join(WORK_DIR, '.git'))) {
  fs.mkdirSync(path.dirname(WORK_DIR), { recursive: true })
  run(`git clone --depth 1 ${AGGREGATOR_URL} "${WORK_DIR}"`)
} else {
  console.log(`\nАгрегатор уже склонирован в ${WORK_DIR}, обновляю...`)
  run('git pull --ff-only', WORK_DIR)
}

// 2. зависимости агрегатора
run('npm install', WORK_DIR)

// 3. подтянуть остальные продукты, чтобы собрался весь сайт
if (!skipSync) {
  run('npm run sync', WORK_DIR)
} else {
  console.log('\n--skip-sync: пропускаю клонирование соседних продуктов.')
}

// 4. переключить слот vanessa-runner на ЛОКАЛЬНУЮ копию docs/product
const productsDir = path.join(WORK_DIR, 'docs', 'products')
fs.mkdirSync(productsDir, { recursive: true })

// sync создаёт каталог вида "013-vanessa-runner"; находим его, иначе берём запасной префикс
const existing = fs
  .readdirSync(productsDir)
  .find((name) => name.replace(/^\d+-/, '') === REPO_NAME)
const linkName = existing || `999-${REPO_NAME}`
const linkPath = path.join(productsDir, linkName)

if (fs.existsSync(linkPath) || fs.lstatSync(linkPath, { throwIfNoEntry: false })) {
  fs.rmSync(linkPath, { recursive: true, force: true })
}
const linkType = process.platform === 'win32' ? 'junction' : 'dir'
fs.symlinkSync(LOCAL_PRODUCT_DOCS, linkPath, linkType)
console.log(`\nСлот документации: ${linkPath}\n           ← ${LOCAL_PRODUCT_DOCS}`)

// 5. сборка / dev-сервер реальным конфигом агрегатора (с обработчиком ссылок)
run(serve ? 'npm run docs:dev' : 'npm run docs:build', WORK_DIR)

if (!serve) {
  const dist = path.join(WORK_DIR, '.vitepress', 'dist')
  console.log(`\n✓ Сборка завершена. Битых ссылок нет — иначе vitepress упал бы выше.`)
  console.log(`  Результат: ${dist}`)
  console.log(`  Предпросмотр: (cd "${WORK_DIR}" && npm run docs:preview)`)
}
