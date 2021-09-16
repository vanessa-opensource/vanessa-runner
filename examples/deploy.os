// BSLLS-off
#Использовать 1commands

#Область ОписаниеПеременных

Перем RUNNER_v8version;
Перем RASSERVER;
Перем RASPORT;
Перем RACPATH;
Перем RUNNER_IBNAME;
Перем RUNNER_DBUSER;
Перем RUNNER_DBPWD;
Перем LOCKMESSAGE;
Перем RUNNER_uccode;
Перем LOCKSTARTAT;
Перем RUNNER_storage_name;
Перем RUNNER_storage_user;
Перем RUNNER_storage_pwd;
Перем IBCONNECTION;

#КонецОбласти

Процедура Пауза(Знач КоличествоСекунд)
	Приостановить(КоличествоСекунд * 1000);
КонецПроцедуры

Функция ИсполнитьКоманду(Знач СтрокаВыполнения, Знач КодировкаВывода = "")
	
	Команда = Новый Команда;
	
	Команда.ПоказыватьВыводНемедленно(Истина);
	Если Не ПустаяСтрока(КодировкаВывода) Тогда
		Команда.УстановитьКодировкуВывода(КодировкаВывода);
	КонецЕсли;
	
	Команда.УстановитьПравильныйКодВозврата(0);
	
	СтрокаВыполнения = ЗаменитьПараметрыСтрокиВыполнения(СтрокаВыполнения);
	
	Команда.УстановитьСтрокуЗапуска(СтрокаВыполнения);
	Команда.Исполнить();
	
	Возврат Команда.ПолучитьВывод();
КонецФункции


Функция ЗаменитьПараметрыСтрокиВыполнения(Знач СтрокаВыполнения)
	
	СтрокаВыполнения = СтрЗаменить(СтрокаВыполнения, "RASSERVER", RASSERVER);
	СтрокаВыполнения = СтрЗаменить(СтрокаВыполнения, "RACPATH", RACPATH);
	СтрокаВыполнения = СтрЗаменить(СтрокаВыполнения, "RASPORT", RASPORT);
	СтрокаВыполнения = СтрЗаменить(СтрокаВыполнения, "RUNNER_IBNAME", RUNNER_IBNAME);
	СтрокаВыполнения = СтрЗаменить(СтрокаВыполнения, "RUNNER_DBUSER", RUNNER_DBUSER);
	СтрокаВыполнения = СтрЗаменить(СтрокаВыполнения, "RUNNER_DBPWD", RUNNER_DBPWD);
	СтрокаВыполнения = СтрЗаменить(СтрокаВыполнения, "LOCKSTARTAT", LOCKSTARTAT);
	СтрокаВыполнения = СтрЗаменить(СтрокаВыполнения, "LOCKMESSAGE", LOCKMESSAGE);
	СтрокаВыполнения = СтрЗаменить(СтрокаВыполнения, "RUNNER_v8version", RUNNER_v8version);
	СтрокаВыполнения = СтрЗаменить(СтрокаВыполнения, "RUNNER_uccode", RUNNER_uccode);
	
	СтрокаВыполнения = СтрЗаменить(СтрокаВыполнения, "RUNNER_storage_name", RUNNER_storage_name);
	СтрокаВыполнения = СтрЗаменить(СтрокаВыполнения, "RUNNER_storage_user", RUNNER_storage_user);
	СтрокаВыполнения = СтрЗаменить(СтрокаВыполнения, "RUNNER_storage_pwd", RUNNER_storage_pwd);
	СтрокаВыполнения = СтрЗаменить(СтрокаВыполнения, "IBCONNECTION", IBCONNECTION);
	
	Возврат СтрокаВыполнения;
	
КонецФункции

#Область Команды

Функция ОстановкаРегламентныхЗаданий()
	Возврат "vrunner scheduledjobs lock --ras ""RASSERVER"":""RASPORT"" --rac ""RACPATH"" --db ""RUNNER_IBNAME"" --db-user ""RUNNER_DBUSER"" --db-pwd ""RUNNER_DBPWD"""; // BSLLS:LineLength-off
КонецФункции

Функция БлокировкаСеансов()
	Возврат "vrunner session lock --ras ""RASSERVER"":""RASPORT"" --rac ""RACPATH"" --db ""RUNNER_IBNAME"" --db-user ""RUNNER_DBUSER"" --db-pwd ""RUNNER_DBPWD"" --lockstartat ""LOCKSTARTAT"" --lockendclear --lockmessage ""LOCKMESSAGE"" --uccode ""RUNNER_uccode"" --v8version ""RUNNER_v8version"""; // BSLLS:LineLength-off
КонецФункции

Функция СтрокаОстановкиРегламентныхЗаданий()
	Возврат "vrunner scheduledjobs lock --ras ""RASSERVER"":""RASPORT"" --rac ""RACPATH"" --db ""RUNNER_IBNAME"" --db-user ""RUNNER_DBUSER"" --db-pwd ""RUNNER_DBPWD"""; // BSLLS:LineLength-off
КонецФункции

Функция ЗавершениеСеансаКонфигуратора()
	// Завершаем сеанс только Кофигуратора, чтобы выполнить обновление --filter appid=Designer
	Возврат "vrunner session kill --filter appid=Designer --ras ""RASSERVER"":""RASPORT"" --rac ""RACPATH"" --db ""RUNNER_IBNAME"" --db-user ""RUNNER_DBUSER"" --db-pwd ""RUNNER_DBPWD"" --lockstartat ""LOCKSTARTAT"" --lockendclear --lockmessage ""LOCKMESSAGE"" --uccode ""RUNNER_uccode"" --v8version ""RUNNER_v8version"""; // BSLLS:LineLength-off
КонецФункции

Функция ПолучениеИзмененийИзХранилища()
	Возврат "vrunner loadrepo --storage-name ""RUNNER_storage_name"" --storage-user ""RUNNER_storage_user"" --storage-pwd ""RUNNER_storage_pwd"" --ibconnection ""IBCONNECTION"" --db-user ""RUNNER_DBUSER"" --db-pwd ""RUNNER_DBPWD"" --v8version ""RUNNER_v8version"" --uccode ""RUNNER_uccode"""; // BSLLS:LineLength-off
КонецФункции

Функция ЗавершениеАктивныхСеансов()
	Возврат "vrunner session kill  --ras ""RASSERVER"":""RASPORT"" --rac ""RACPATH"" --db ""RUNNER_IBNAME"" --db-user ""RUNNER_DBUSER"" --db-pwd ""RUNNER_DBPWD"" --v8version ""RUNNER_v8version"" --uccode ""RUNNER_uccode"""; // BSLLS:LineLength-off
КонецФункции

Функция ОбновлениеБазыДанных()
	Возврат "vrunner updatedb --ibconnection ""IBCONNECTION"" --db-user ""RUNNER_DBUSER"" --db-pwd ""RUNNER_DBPWD"" --v8version ""RUNNER_v8version"" --uccode ""RUNNER_uccode"""; // BSLLS:LineLength-off
КонецФункции

Функция ОбновлениеВРежимеПредприятия()
	Возврат "vrunner run --ibconnection ""IBCONNECTION"" --db-user ""RUNNER_DBUSER"" --db-pwd ""RUNNER_DBPWD"" --v8version ""RUNNER_v8version"" --uccode ""RUNNER_uccode"" --nocacheuse --command ЗапуститьОбновлениеИнформационнойБазы;ЗавершитьРаботуСистемы; --execute ""$runnerRoot/epf/ЗакрытьПредприятие.epf""" // BSLLS:LineLength-off
КонецФункции

Функция ЗапускРегламентныхЗаданий()
	Возврат "vrunner scheduledjobs unlock --ras ""RASSERVER"":""RASPORT"" --rac ""RACPATH"" --db ""RUNNER_IBNAME"" --db-user ""RUNNER_DBUSER"" --db-pwd ""RUNNER_DBPWD""";
КонецФункции

Функция СнятиеБлокировкиСеансов()
	Возврат "vrunner session unlock --ras ""RASSERVER"":""RASPORT"" --rac ""RACPATH"" --db ""RUNNER_IBNAME"" --db-user ""RUNNER_DBUSER"" --db-pwd ""RUNNER_DBPWD"" --uccode ""RUNNER_uccode""";	
КонецФункции

#КонецОбласти

Процедура ИнициализацияПеременных()
	
	RASSERVER = "localhost";
	RUNNER_v8version = "8.3.18.1334";
	RASPORT = 1545;
	RACPATH = "C:\Program Files\1cv8\%V8VERSION%\bin\rac.exe";
	RUNNER_IBNAME = "";
	RUNNER_DBUSER = "";
	RUNNER_DBPWD = "";
	LOCKMESSAGE = "Уважаемые пользователи. В данный момент проводится плановое обновление базы данных.";
	RUNNER_uccode = "";
	LOCKSTARTAT = 10;
	RUNNER_storage_name = "tcp://127.0.0.1/ERP";
	RUNNER_storage_user = "STORAGEUSER";
	RUNNER_storage_pwd = "STORAGEPWD";
	IBCONNECTION = "/Slocalhost/erp";
	
КонецПроцедуры

Функция ВыполнитьОбновление()
	
	ИсполнитьКоманду(ОстановкаРегламентныхЗаданий());
	
	ИсполнитьКоманду(БлокировкаСеансов());
	
	ИсполнитьКоманду(ЗавершениеСеансаКонфигуратора());
	
	ИсполнитьКоманду(ПолучениеИзмененийИзХранилища());
	
	ПаузаСекунд = LOCKSTARTAT;
	
	Сообщить(СтрШаблон("Ожидание завершения пользователей %1 сек.", ПаузаСекунд));
	
	Пауза(ПаузаСекунд);
	
	ИсполнитьКоманду(ЗавершениеАктивныхСеансов());
	
	ИсполнитьКоманду(ОбновлениеБазыДанных());
	ИсполнитьКоманду(ОбновлениеВРежимеПредприятия());
	
	ИсполнитьКоманду(ЗапускРегламентныхЗаданий());
	ИсполнитьКоманду(СнятиеБлокировкиСеансов());
	
	Возврат Истина;
	
КонецФункции


Попытка
	ИнициализацияПеременных();
	ВыполнитьОбновление();
Исключение
	Сообщить(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	ЗавершитьРаботу(1);
КонецПопытки;