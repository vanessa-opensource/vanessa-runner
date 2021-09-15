@echo off
@chcp 65001

SET V8VERSION=8.3.18.1334

rem Параметры rac - клиент/сервера
SET RACPATH="C:\Program Files\1cv8\%V8VERSION%\bin\rac.exe"
SET RASSERVER=localhost
SET RASPORT=1545

rem Параметры подключения к базе данных
SET DBNAME=""
SET DBUSER=""
SET DBPWD=""
SET LOCKMESSAGE="Уважаемые пользователи. В данный момент проводится плановое обновление базы данных."
SET UCCODE=UpdateDBKey
rem Значение паузы в секундах
SET LOCKSTARTAT=10

rem Параметры подключения к хранилищу
SET STORAGEPATH=tcp://127.0.0.1/ERP
SET STORAGEUSER="STORAGEUSER"
SET STORAGEPWD="STORAGEPWD"
SET IBCONNECTION="/Slocalhost/erp"

call oscript deploy.os