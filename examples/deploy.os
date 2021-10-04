// BSLLS-off
#Использовать 1commands

#Область ОписаниеПеременных

Перем Версия1С;
Перем RASSERVER;
Перем RASPORT;
Перем RACPATH;
Перем ИмяБазыДанных;
Перем ПользовательБазыДанных;
Перем ПарольБазыДанных;
Перем СообщениеБлокировки;
Перем КодБлокировки;
Перем КоличествоСекундПередСтартомБлокировки;
Перем ПутьКХранилищу;
Перем ПользовательХранилища;
Перем ПарольХранилища;
Перем СтрокаСоединенияБазыДанных;

#КонецОбласти

Процедура Пауза(Знач КоличествоСекунд)
	Приостановить(КоличествоСекунд * 1000);
КонецПроцедуры

Процедура ИсполнитьКоманду(Знач СтрокаВыполнения, Знач КодировкаВывода = "")
	
	Команда = Новый Команда;
	
	Команда.ПоказыватьВыводНемедленно(Истина);
	Если Не ПустаяСтрока(КодировкаВывода) Тогда
		Команда.УстановитьКодировкуВывода(КодировкаВывода);
	КонецЕсли;
	
	Команда.УстановитьПравильныйКодВозврата(0);
	
	СтрокаВыполнения = ЗаменитьПараметрыСтрокиВыполнения(СтрокаВыполнения);
	
	Команда.УстановитьСтрокуЗапуска(СтрокаВыполнения);
	Команда.Исполнить();
	
КонецПроцедуры


Функция ЗаменитьПараметрыСтрокиВыполнения(Знач СтрокаВыполнения)
	
	СтрокаВыполнения = СтрЗаменить(СтрокаВыполнения, "RASSERVER", RASSERVER);
	СтрокаВыполнения = СтрЗаменить(СтрокаВыполнения, "RACPATH", RACPATH);
	СтрокаВыполнения = СтрЗаменить(СтрокаВыполнения, "RASPORT", RASPORT);
	СтрокаВыполнения = СтрЗаменить(СтрокаВыполнения, "RUNNER_IBNAME", ИмяБазыДанных);
	СтрокаВыполнения = СтрЗаменить(СтрокаВыполнения, "RUNNER_DBUSER", ПользовательБазыДанных);
	СтрокаВыполнения = СтрЗаменить(СтрокаВыполнения, "RUNNER_DBPWD", ПарольБазыДанных);
	СтрокаВыполнения = СтрЗаменить(СтрокаВыполнения, "LOCKSTARTAT", КоличествоСекундПередСтартомБлокировки);
	СтрокаВыполнения = СтрЗаменить(СтрокаВыполнения, "LOCKMESSAGE", СообщениеБлокировки);
	СтрокаВыполнения = СтрЗаменить(СтрокаВыполнения, "RUNNER_v8version", Версия1С);
	СтрокаВыполнения = СтрЗаменить(СтрокаВыполнения, "RUNNER_uccode", КодБлокировки);
	СтрокаВыполнения = СтрЗаменить(СтрокаВыполнения, "RUNNER_storage_name", ПутьКХранилищу);
	СтрокаВыполнения = СтрЗаменить(СтрокаВыполнения, "RUNNER_storage_user", ПользовательХранилища);
	СтрокаВыполнения = СтрЗаменить(СтрокаВыполнения, "RUNNER_storage_pwd", ПарольХранилища);
	СтрокаВыполнения = СтрЗаменить(СтрокаВыполнения, "IBCONNECTION", СтрокаСоединенияБазыДанных);
	
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
	// Завершаем сеанс только Конфигуратора, чтобы выполнить обновление --filter appid=Designer
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
	Версия1С = "8.3.18.1334";
	RASPORT = 1545;
	RACPATH = "C:\Program Files\1cv8\Версия1С\bin\rac.exe";
	RACPATH = СтрЗаменить(RACPATH, "Версия1С", Версия1С);
	ИмяБазыДанных = "";
	ПользовательБазыДанных = "";
	ПарольБазыДанных = "";
	СообщениеБлокировки = "Уважаемые пользователи, в данный момент проводится плановое обновление базы данных.";
	КодБлокировки = "";
	КоличествоСекундПередСтартомБлокировки = 10;
	ПутьКХранилищу = "tcp://127.0.0.1/ERP";
	ПользовательХранилища = "STORAGEUSER";
	ПарольХранилища = "STORAGEPWD";
	СтрокаСоединенияБазыДанных = "/Slocalhost/erp";
	
КонецПроцедуры

Процедура ВыполнитьОбновление()
	
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
	
КонецПроцедуры


Попытка
	ИнициализацияПеременных();
	ВыполнитьОбновление();
Исключение
	Сообщить(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	ЗавершитьРаботу(1);
КонецПопытки;