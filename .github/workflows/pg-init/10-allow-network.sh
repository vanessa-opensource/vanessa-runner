#!/bin/bash
# initdb-скрипт для whitemanprk/postgres-1c.
# Образ не обрабатывает PG_ALLOWED_HOSTS / PG_HBA_METHOD сам - нужно
# вручную дописать правила в pg_hba.conf. Применяется один раз при initdb.
#
# Открываем доступ отовсюду с md5 (CI-окружение, контейнер эфемерный).
# Используется для подключения 1С-сервера с host через docker bridge (172.x.x.x).
set -e

PG_HBA="${PGDATA}/pg_hba.conf"

echo "host all all 0.0.0.0/0 md5" >> "$PG_HBA"
echo "host all all ::/0       md5" >> "$PG_HBA"

echo "[ci-init] pg_hba.conf обновлён: разрешены подключения отовсюду (md5)"
