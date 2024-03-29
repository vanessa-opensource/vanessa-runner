///////////////////////////////////////////////////////////////////////////////////////////////////
// Прикладной интерфейс

#Область ОписаниеПеременных

Перем Лог;
Перем Настройки;
Перем МенеджерRac;

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт

	ТекстОписанияКоманды = "     Создать информационную базу через ras\rac.";
	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды, ТекстОписанияКоманды);

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--ras", "Сетевой адрес RAS. Необязательный. По умолчанию localhost:1545");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--rac", "Команда запуска RAC. Необязательный. По умолчанию находим в каталоге установки 1с");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--name", "Имя информационной базы. Обязательный.");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--dbms", "тип СУБД, в которой размещается информационная база. Обязательный. MSSQLServer|PostgreSQL|IBMDB2|OracleDatabase");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--db-server", "Имя сервера БД. Обязательный.");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--db-name", "Имя базы данных. Необязательный. По умолчанию устанавливается в имя ИБ из --name.");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--db-admin", "Пользователь БД. Обязательный.");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--db-admin-pwd", "Пароль пользователя БД. Обязательный.");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--descr", "Описание ИБ");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--db-locale", "Идентификатор национальных настроек информационной базы. По умолчанию ru");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--cluster-admin", "Администратор кластера");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--cluster-pwd", "Пароль администратора кластера");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--cluster", "Идентификатор кластера");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--cluster-name", "Имя кластера");
	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--create-database-deny", "При создании информационной базы не создавать БД. По умолчанию БД создается");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--date-offset", "Смещение дат в ИБ. По умолчанию 2000.");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--security-level", "Уровень безопасности установки соединений с ИБ");
	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--scheduled-jobs-deny", "Выполнение регламентных заданий запрещено. По умолчанию регламентные задания разрешены");
	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--license-distribution-deny", "Выдача лицензий сервером 1С запрещена. По умолчанию выдача лицензий разрешена.");

	Парсер.ДобавитьКоманду(ОписаниеКоманды);

КонецПроцедуры

Функция ВыполнитьКоманду(Знач ПараметрыКоманды, Знач ДополнительныеПараметры = Неопределено) Экспорт

	Попытка
		Лог = ДополнительныеПараметры.Лог;
	Исключение
		Лог = Логирование.ПолучитьЛог(ПараметрыСистемы.ИмяЛогаСистемы());
	КонецПопытки;

	Настройки = ПрочитатьПараметры(ПараметрыКоманды);

	Если Не ПараметрыВведеныКорректно() Тогда
		Возврат МенеджерКомандПриложения.РезультатыКоманд().НеверныеПараметры;
	КонецЕсли;

	СоздатьИнформационнуюБазу();
	Возврат МенеджерКомандПриложения.РезультатыКоманд().Успех;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПрочитатьПараметры(Знач ПараметрыКоманды)

	Результат = Новый Структура;

	ОбщиеМетоды.ПоказатьПараметрыВРежимеОтладки(ПараметрыКоманды);
	ДанныеПодключения = ПараметрыКоманды["ДанныеПодключения"];

	Результат.Вставить("АдресСервераАдминистрирования", ОбщиеМетоды.Параметр(ПараметрыКоманды, "--ras", "localhost:1545"));
	Результат.Вставить("АдминистраторИБ", ДанныеПодключения.Пользователь);
	Результат.Вставить("ПарольАдминистратораИБ", ДанныеПодключения.Пароль);
	Результат.Вставить("АдминистраторКластера", ПараметрыКоманды["--cluster-admin"]);
	Результат.Вставить("ПарольАдминистратораКластера", ПараметрыКоманды["--cluster-pwd"]);
	Результат.Вставить("ИдентификаторКластера", ПараметрыКоманды["--cluster"]);
	Результат.Вставить("ИмяКластера", ПараметрыКоманды["--cluster-name"]);
	Результат.Вставить("ИспользуемаяВерсияПлатформы", ПараметрыКоманды["--v8version"]);

	Результат.Вставить("СоздаватьНовуюИБ", НЕ ПараметрыКоманды["--create-database-deny"]);
	Результат.Вставить("ВыдаватьЛицензииСервером", Не ПараметрыКоманды["--license-distribution-deny"]);

	Результат.Вставить("ИмяИБ", ПараметрыКоманды["--name"]);
	Результат.Вставить("ИмяБазыДанных", ОбщиеМетоды.Параметр(ПараметрыКоманды, "--db-name", Результат.ИмяИБ));

	Результат.Вставить("Локаль", ОбщиеМетоды.Параметр(ПараметрыКоманды, "--db-locale", "ru"));
	Результат.Вставить("ТипСУБД", ПараметрыКоманды["--dbms"]);
	Результат.Вставить("ИмяСервераБД", ПараметрыКоманды["--db-server"]);
	Результат.Вставить("АдминистраторБД", ПараметрыКоманды["--db-admin"]);
	Результат.Вставить("ПарольАдминистраторБД", ПараметрыКоманды["--db-admin-pwd"]);
	Результат.Вставить("ОписаниеИБ", ПараметрыКоманды["--descr"]);
	Результат.Вставить("СмещениеДат", ОбщиеМетоды.Параметр(ПараметрыКоманды, "--date-offset", "2000"));
	Результат.Вставить("УровеньБезопасности", ПараметрыКоманды["--security-level"]);
	Результат.Вставить("БлокироватьРегламентныеЗадания", ПараметрыКоманды["--scheduled-jobs-deny"]);

	Результат.Вставить("ПутьКлиентаАдминистрирования", "");

	МенеджерRac = Новый МенеджерRAC(Результат, ПараметрыКоманды, Лог);

	// Получим путь к платформе, если вдруг не установленна
	Результат.Вставить("ПутьКлиентаАдминистрирования", МенеджерRac.ПолучитьПутьRAC());

	Возврат Результат;
КонецФункции

Функция ПараметрыВведеныКорректно()

	Успех = Истина;

	Если Не ЗначениеЗаполнено(Настройки.АдресСервераАдминистрирования) Тогда
		Лог.Ошибка("Не указан сервер администрирования");
		Успех = Ложь;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(Настройки.ПутьКлиентаАдминистрирования) Тогда
		Лог.Ошибка("Не указан путь к RAC. Найти подходящий путь также не удалось.");
		Успех = Ложь;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Настройки.ИмяИБ) Тогда
		Лог.Ошибка("Не указано имя создаваемой ИБ");
		Успех = Ложь;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(Настройки.ИмяБазыДанных) Тогда
		Лог.Ошибка("Не указано имя базы данных");
		Успех = Ложь;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Настройки.ТипСУБД) Тогда
		Лог.Ошибка("Не указан тип СУБД");
		Успех = Ложь;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Настройки.ИмяСервераБД) Тогда
		Лог.Ошибка("Не указано имя сервера БД");
		Успех = ЛОжь;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Настройки.Локаль) Тогда
		Лог.Ошибка("Не указан идентификатор национальных настроек ИБ");
		Успех = Ложь;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Настройки.АдминистраторБД) Тогда
		Лог.Ошибка("Не указан пользователь БД");
		Успех = Ложь;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Настройки.ПарольАдминистраторБД) Тогда
		Лог.Ошибка("Не указан пароль пользователя БД");
		Успех = Ложь;
	КонецЕсли;

	Возврат Успех;

КонецФункции

#Область ВзаимодействиеСКластером

Процедура СоздатьИнформационнуюБазу()

	Лог.Информация("Создаю клиент-серверную информационную базу");

	КомандаВыполнения = МенеджерRac.СтрокаЗапускаКлиента() + "infobase create ";

	Если Настройки.СоздаватьНовуюИБ Тогда
		КомандаВыполнения = КомандаВыполнения + "--create-database ";
	КонецЕсли;

	ОписаниеКластера = МенеджерRac.ОписаниеКластера();
	ИдентификаторКластера = МенеджерRac.ИдентификаторКластера(ОписаниеКластера);
	КомандаВыполнения = КомандаВыполнения + "--cluster=""" + ИдентификаторКластера + """ ";

	КомандаВыполнения = КомандаВыполнения + МенеджерRac.КлючиАвторизацииВКластере();
	Если ЗначениеЗаполнено(Настройки.ИмяИБ) Тогда
		КомандаВыполнения = КомандаВыполнения + "--name=""" + Настройки.ИмяИБ + """ ";
	КонецЕсли;
	Если ЗначениеЗаполнено(Настройки.ТипСУБД) Тогда
		КомандаВыполнения = КомандаВыполнения + "--dbms=""" + Настройки.ТипСУБД + """ ";
	КонецЕсли;
	Если ЗначениеЗаполнено(Настройки.ИмяСервераБД) Тогда
		КомандаВыполнения = КомандаВыполнения + "--db-server=""" + Настройки.ИмяСервераБД + """ ";
	КонецЕсли;
	Если ЗначениеЗаполнено(Настройки.ИмяБазыДанных) Тогда
		КомандаВыполнения = КомандаВыполнения + "--db-name=""" + Настройки.ИмяБазыДанных + """ ";
	КонецЕсли;
	Если ЗначениеЗаполнено(Настройки.Локаль) Тогда
		КомандаВыполнения = КомандаВыполнения + "--locale=""" + Настройки.Локаль + """ ";
	КонецЕсли;
	Если ЗначениеЗаполнено(Настройки.АдминистраторБД) Тогда
		КомандаВыполнения = КомандаВыполнения + "--db-user=""" + Настройки.АдминистраторБД + """ ";
	КонецЕсли;
	Если ЗначениеЗаполнено(Настройки.ПарольАдминистраторБД) Тогда
		КомандаВыполнения = КомандаВыполнения + "--db-pwd=""" + Настройки.ПарольАдминистраторБД + """ ";
	КонецЕсли;
	Если ЗначениеЗаполнено(Настройки.ОписаниеИБ) Тогда
		КомандаВыполнения = КомандаВыполнения + "--descr=""" + Настройки.ОписаниеИБ + """ ";
	КонецЕсли;
	Если ЗначениеЗаполнено(Настройки.СмещениеДат) Тогда
		КомандаВыполнения = КомандаВыполнения + "--date-offset=""" + Настройки.СмещениеДат + """ ";
	КонецЕсли;
	Если ЗначениеЗаполнено(Настройки.УровеньБезопасности) Тогда
		КомандаВыполнения = КомандаВыполнения + "--security-level=""" + Настройки.УровеньБезопасности + """ ";
	КонецЕсли;
	Если Настройки.БлокироватьРегламентныеЗадания Тогда
		КомандаВыполнения = КомандаВыполнения + "--scheduled-jobs-deny=on ";
	КонецЕсли;
	Если Настройки.ВыдаватьЛицензииСервером Тогда
		ЗначениеВыдаватьЛицензииСервером = "allow";
	Иначе
		ЗначениеВыдаватьЛицензииСервером = "deny";
	КонецЕсли;
	КомандаВыполнения = КомандаВыполнения + "--license-distribution=" + ЗначениеВыдаватьЛицензииСервером + " ";

	КомандаВыполнения = КомандаВыполнения + " " + Настройки.АдресСервераАдминистрирования;
	ОбщиеМетоды.ЗапуститьПроцесс(КомандаВыполнения);

	Лог.Информация("Клиент-серверная информационная база создана: Сервер ИБ: %4:%5, Сервер БД: %1; Имя БД: %2; Имя ИБ:%3",
		Настройки.ИмяСервераБД, Настройки.ИмяБазыДанных, Настройки.ИмяИБ, ОписаниеКластера.Хост, ОписаниеКластера.Порт);
КонецПроцедуры

#КонецОбласти

#КонецОбласти
