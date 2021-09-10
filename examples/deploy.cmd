@echo off
@chcp 65001

SET V8VERSION=8.3.18.1334

rem Параметры rac - клиент/сервера
SET RACPATH="C:\Program Files\1cv8\%V8VERSION%\bin\rac.exe"
SET RASSERVER=1c-dev
SET RASPORT=1545

rem Параметры подключения к базе данных
SET DBNAME=DEV
SET DBPWD=""
SET DBUSER=""
SET LOCKMESSAGE="Уважаемые пользователи. В данный момент проводится плановое обновление базы данных."
SET UCCODE=UpdateDBKey
rem Значение паузы в секундах
SET LOCKSTARTAT=300

rem Параметры подключения к хранилищу
SET STORAGEPATH=tcp://127.0.0.1/Dev
SET STORAGEUSER=dev_usr
SET STORAGEPWD=dev_pwd
SET IBCONNECTION="/S1c-dev/DEV"

rem Остановка регламентных заданий
@call vrunner scheduledjobs lock --ras %RASSERVER%:%RASPORT% --rac %RACPATH% --db %DBNAME% --db-user %DBUSER% --db-pwd %DBPWD%

rem Установка блокировки сеансов
@call vrunner session lock --ras %RASSERVER%:%RASPORT% --rac %RACPATH% --db %DBNAME% --db-user %DBUSER% --db-pwd %DBPWD% --lockstartat %LOCKSTARTAT% --lockendclear --lockmessage %LOCKMESSAGE% --uccode %UCCODE% --v8version %V8VERSION%

rem Завершаем сеанс только Кофигуратора, чтобы выполнить обновление --filter appid=Designer
@call vrunner session kill --filter appid=Designer --ras %RASSERVER%:%RASPORT%  --rac %RACPATH% --db %DBNAME% --db-user %DBUSER% --db-pwd %DBPWD% --lockstartat %LOCKSTARTAT% --lockendclear --lockmessage %LOCKMESSAGE% --uccode %UCCODE% --v8version %V8VERSION%

rem Получение обновлений из хранилища
@call vrunner loadrepo --storage-name %STORAGEPATH% --storage-user %STORAGEUSER% --storage-pwd %STORAGEPWD% --ibconnection %IBCONNECTION% --db-user %DBUSER% --db-pwd %DBPWD% --v8version %V8VERSION% --uccode %UCCODE%

timeout /t %LOCKSTARTAT%

rem Завершение активных сеансов
@call vrunner session kill  --ras %RASSERVER%:%RASPORT%  --rac %RACPATH% --db %DBNAME% --db-user %DBUSER% --db-pwd %DBPWD% --uccode %UCCODE% --v8version %V8VERSION%

rem Обновление базы данных
@call vrunner updatedb --ibconnection %IBCONNECTION% --db-user %DBUSER% --db-pwd %DBPWD% --v8version %V8VERSION% --uccode %UCCODE%

@rem обновление в режиме Предприятие
@call vrunner run --ibconnection %IBCONNECTION% --db-user %DBUSER% --db-pwd %DBPWD% --v8version %V8VERSION% --uccode %UCCODE% --nocacheuse --command "ЗапуститьОбновлениеИнформационнойБазы;ЗавершитьРаботуСистемы;" --execute $runnerRoot\epf\ЗакрытьПредприятие.epf %*

rem Запуск регламентных заданий
@call vrunner scheduledjobs unlock --ras %RASSERVER%:%RASPORT% --rac %RACPATH% --db %DBNAME% --db-user %DBUSER% --db-pwd %DBPWD%

rem Снятие блокировки сеансов
@call vrunner session unlock --ras %RASSERVER%:%RASPORT% --rac %RACPATH% --db %DBNAME% --db-user %DBUSER% --db-pwd %DBPWD% --uccode %UCCODE%
