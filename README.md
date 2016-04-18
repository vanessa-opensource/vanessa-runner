=Примеры автоматизации базовых операций 

Пример автоматизации различных операции для работы с cf/cfe/epf файлами и простой запуск vanessa-behavior и xunitfor1c тестов. 
Основной код сосредоточен в tools/runner.os , ключ --help покажет справку по параметрам. 

В папке tools так же расположенны примеры bat файлов для легкого запуска определенных действий. 
Основной принцип - запустили bat файл с настроенными командами и получили результат.

К папке epf несколько обработок позволяющих упростить деплой для конфигураций основанных на БСП. 

**ЗакрытьПредприятие** позволяет после обнволения конфигурации запустить обновление в монопольном режиме и после окончания автоматом закрыть предприятие, не дожидаясь действий пользователя. 
Пример запуска 
```
chcp 1251
set OSCRIPT=C:\SOFT\onescript\bin\oscript.exe
set DEPLOYKA=C:\SOFT\onescript\deployka\src\
set EPFROOT=C:\SOFT\onescript\epf
set STORAGEPATH=tcp://server-1cerp/erp21
set DATABASENAME=ERP
set DATABASE=/S"server-1cerp\%DATABASENAME%"
set VERSION=8.3.7.2008

%OSCRIPT% %DEPLOYKA%\console-entry-point.os loadrepo %DATABASE% %STORAGEPATH% -storage-user base -storage-pwd "234567890" -v8version %VERSION%
%OSCRIPT% %DEPLOYKA%\console-entry-point.os session lock -ras server-1cerp -rac "C:\Program Files\1cv8\%VERSION%\bin\rac.exe" -db %DATABASENAME% -lockmessage "Плановое обновление" -lockstartat 60 -lockuccode test
timeout /t 50
%OSCRIPT% %DEPLOYKA%\console-entry-point.os session kill -ras localhost -rac "C:\Program Files\1cv8\%VERSION%\bin\rac.exe" -db %DATABASENAME% -lockuccode test -lockmessage "Плановое обновление, 5 мин"
%OSCRIPT% %DEPLOYKA%\console-entry-point.os dbupdate %DATABASE% -uccode test -v8version %VERSION%
%OSCRIPT% %DEPLOYKA%\console-entry-point.os run %DATABASE% -uccode test -command "ПодтверждениеЛицензии.cfe;loadПодтверждениеЛицензии.log;" -execute %EPFROOT%\ЗагрузитьРасширение.epf -v8version %VERSION%
%OSCRIPT% %DEPLOYKA%\console-entry-point.os run %DATABASE% -uccode test -command "ЗапуститьОбновлениеИнформационнойБазы;ЗавершитьРаботуСистемы;" -execute %EPFROOT%\ЗакрытьПердприятие.epf -v8version %VERSION%
%OSCRIPT% %DEPLOYKA%\console-entry-point.os run %DATABASE% -uccode test -command "restapi10.cfe;loadrestapi10.log;" -execute %EPFROOT%\ЗагрузитьРасширение.epf -v8version %VERSION%
%OSCRIPT% %DEPLOYKA%\console-entry-point.os run %DATABASE% -uccode test -command "restapi20.cfe;loadrestapi20.log;" -execute %EPFROOT%\ЗагрузитьРасширение.epf -v8version %VERSION%

%OSCRIPT% %DEPLOYKA%\console-entry-point.os session unlock -ras server-1cerp -rac "C:\Program Files\1cv8\%VERSION%\bin\rac.exe" -db %DATABASENAME%

``` 
Основной пример это передача через параметры /C комманды "ЗапуститьОбновлениеИнформационнойБазы;ЗавершитьРаботуСистемы" и одновременно выполняем через /Execute"ЗакрытьПредприятие.epf", т.е. при запуске с такими ключами подключается обработчик ожидания проверят наличие формы с заголовком обновление и при окончании обновления завершает предприятие. Данное действие необходимо, для полного обновления предприятия, пока действует блокировка на фоновые задачи и запуск пользователей.

**ЗагрузитьРасширение** позволяет подключать разрешение в режиме предприятия и получать результат ошибки. Предназначенно для подключения в конфигурациях основаных на БСП. В параметрах /C передается путь к расширению и путь к файлу лога подключения. 
**ЗагрузитьВнешниеОбработки** позволяет загрузить все внешние обработки и подключить в справочник "Дополнительные отчеты и обработки", т.к. их очень много то первым параметром идет каталог, вторым параметром путь к файлу лога. Все обработки обновляются согласно версиям.
 
 
 
