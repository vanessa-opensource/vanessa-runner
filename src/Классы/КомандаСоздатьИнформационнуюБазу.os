///////////////////////////////////////////////////////////////////////////////////////////////////
// Прикладной интерфейс

#Область ОписаниеПеременных

Перем Лог;
Перем Настройки;
Перем ОписаниеКластераКеш;
Перем ЭтоWindows;

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

	// Получим путь к платформе, если вдруг не установленна
	Результат.Вставить("ПутьКлиентаАдминистрирования", ПолучитьПутьКRAC(ПараметрыКоманды["--rac"], Результат.ИспользуемаяВерсияПлатформы));

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

	КомандаВыполнения = СтрокаЗапускаКлиента() + "infobase create ";

	Если Настройки.СоздаватьНовуюИБ Тогда
		КомандаВыполнения = КомандаВыполнения + "--create-database ";
	КонецЕсли;

	ОписаниеКластера = ОписаниеКластера();
	ИдентификаторКластера = ИдентификаторКластера(ОписаниеКластера);
	КомандаВыполнения = КомандаВыполнения + "--cluster=""" + ИдентификаторКластера + """ ";

	КомандаВыполнения = КомандаВыполнения + КлючиАвторизацииВКластере();
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
	ЗапуститьПроцесс(КомандаВыполнения);

	Лог.Информация("Клиент-серверная информационная база создана: Сервер ИБ: %4:%5, Сервер БД: %1; Имя БД: %2; Имя ИБ:%3",
		Настройки.ИмяСервераБД, Настройки.ИмяБазыДанных, Настройки.ИмяИБ, ОписаниеКластераКеш.Хост, ОписаниеКластераКеш.Порт);
КонецПроцедуры

Функция ОписаниеКластера()

	Если ОписаниеКластераКеш <> Неопределено Тогда
		Возврат ОписаниеКластераКеш;
	КонецЕсли;

	Лог.Отладка("Получаю список кластеров");
	ОписаниеКластераКеш = Новый Структура("Идентификатор,Хост,Порт,Имя");

	КомандаВыполнения = СтрокаЗапускаКлиента() + "cluster list " + Настройки.АдресСервераАдминистрирования;

	СписокКластеров = ЗапуститьПроцесс(КомандаВыполнения);

	МассивКластеров = Новый Массив;
	СтруктураКластера = Новый Структура;

	МассивСтрок = СтрРазделить(СписокКластеров, Символы.ПС);
	Для Каждого Стр Из МассивСтрок Цикл
		Если СтрНачинаетсяС(Стр, "cluster") Тогда
			СтруктураКластера.Вставить("Идентификатор", СокрЛП(Сред(Стр, (СтрНайти(Стр, ": ") + 2), СтрДлина(Стр))));
		ИначеЕсли СтрНачинаетсяС(Стр, "host") Тогда
			СтруктураКластера.Вставить("Хост", СокрЛП(Сред(Стр, (СтрНайти(Стр, ": ") + 2), СтрДлина(Стр))));
		ИначеЕсли СтрНачинаетсяС(Стр, "port") Тогда
			СтруктураКластера.Вставить("Порт", СокрЛП(Сред(Стр, (СтрНайти(Стр, ": ") + 2), СтрДлина(Стр))));
		ИначеЕсли СтрНачинаетсяС(Стр, "name") Тогда
			СтруктураКластера.Вставить("Имя", СокрЛП(Сред(Стр, (СтрНайти(Стр, ": ") + 2), СтрДлина(Стр))));

			МассивКластеров.Добавить(СтруктураКластера);
			СтруктураКластера = Новый Структура;
		КонецЕсли; // BSLLS:IfElseIfEndsWithElse-off
	КонецЦикла;

	Если НЕ ПустаяСтрока(Настройки.ИдентификаторКластера) Тогда
		Для Каждого ОписаниеКластера Из МассивКластеров Цикл
			Если ОписаниеКластера.Идентификатор = Настройки.ИдентификаторКластера Тогда
				ЗаполнитьЗначенияСвойств(ОписаниеКластераКеш, ОписаниеКластера);
				Прервать;
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли НЕ ПустаяСтрока(Настройки.ИмяКластера) Тогда
		Для Каждого ОписаниеКластера Из МассивКластеров Цикл
			Если ОписаниеКластера.Имя = """" + Настройки.ИмяКластера + """" Тогда
				ЗаполнитьЗначенияСвойств(ОписаниеКластераКеш, ОписаниеКластера);
				Прервать;
			КонецЕсли;
		КонецЦикла;
	Иначе
		Если ЗначениеЗаполнено(МассивКластеров) Тогда
			ОписаниеКластера = МассивКластеров[0];
			ЗаполнитьЗначенияСвойств(ОписаниеКластераКеш, ОписаниеКластера);
		КонецЕсли;
	КонецЕсли;

	ИдентификаторКластера = ОписаниеКластераКеш.Идентификатор;
	ИдентификаторКластера = СокрЛП(СтрЗаменить(ИдентификаторКластера, Символы.ПС, ""));

	ОписаниеКластераКеш.Вставить("Идентификатор", ИдентификаторКластера);

	Лог.Отладка("Использую найденный кластер. Хост %1:%2, Идентификатор %3, Имя %4",
		ОписаниеКластераКеш.Хост, ОписаниеКластераКеш.Порт, ОписаниеКластераКеш.Идентификатор, ОписаниеКластераКеш.Имя);

	Если ПустаяСтрока(ОписаниеКластераКеш.Идентификатор) Тогда
		ВызватьИсключение "Кластер серверов не найден";
	КонецЕсли;

	Возврат ОписаниеКластераКеш;

КонецФункции

Функция ИдентификаторКластера(Знач ОписаниеКластера)
	Лог.Отладка("Найден идентификатор кластера %1", ОписаниеКластера.Идентификатор);
	Если ЗначениеЗаполнено(Настройки.ИдентификаторКластера) Тогда
		Результат = Настройки.ИдентификаторКластера;
		Лог.Отладка("Использую идентификатор кластера из переданных настроек %1 ", Результат);
	Иначе
		Результат = ОписаниеКластера.Идентификатор;
	КонецЕсли;
	Возврат Результат;
КонецФункции

Функция КлючиАвторизацииВКластере()
	КомандаВыполнения = "";
	Если ЗначениеЗаполнено(Настройки.АдминистраторКластера) Тогда
		КомандаВыполнения = КомандаВыполнения + СтрШаблон(" --cluster-user=""%1"" ", Настройки.АдминистраторКластера);
	КонецЕсли;

	Если ЗначениеЗаполнено(Настройки.ПарольАдминистратораКластера) Тогда
		КомандаВыполнения = КомандаВыполнения + СтрШаблон(" --cluster-pwd=""%1"" ", Настройки.ПарольАдминистратораКластера);
	КонецЕсли;
	Возврат КомандаВыполнения;
КонецФункции

Функция СтрокаЗапускаКлиента()
	Перем ПутьКлиентаАдминистрирования;
	Если ЭтоWindows Тогда
		ПутьКлиентаАдминистрирования = ОбщиеМетоды.ОбернутьПутьВКавычки(Настройки.ПутьКлиентаАдминистрирования);
	Иначе
		ПутьКлиентаАдминистрирования = Настройки.ПутьКлиентаАдминистрирования;
	КонецЕсли;

	Возврат ПутьКлиентаАдминистрирования + " ";

КонецФункции

Функция ЗапуститьПроцесс(Знач СтрокаВыполнения)

	Возврат ОбщиеМетоды.ЗапуститьПроцесс(СтрокаВыполнения);

КонецФункции

Функция РазобратьПоток(Знач Поток) Экспорт

	ТД = Новый ТекстовыйДокумент;
	ТД.УстановитьТекст(Поток);

	СписокОбъектов = Новый Массив;
	ТекущийОбъект = Неопределено;

	Для Сч = 1 По ТД.КоличествоСтрок() Цикл

		Текст = ТД.ПолучитьСтроку(Сч);
		Если ПустаяСтрока(Текст) ИЛИ ТекущийОбъект = Неопределено Тогда
			Если ТекущийОбъект <> Неопределено И ТекущийОбъект.Количество() = 0 Тогда
				Продолжить; // очередная пустая строка подряд
			КонецЕсли;

			ТекущийОбъект = Новый Соответствие;
			СписокОбъектов.Добавить(ТекущийОбъект);
		КонецЕсли;

		СтрокаРазбораИмя      = "";
		СтрокаРазбораЗначение = "";

		Если РазобратьНаКлючИЗначение(Текст, СтрокаРазбораИмя, СтрокаРазбораЗначение) Тогда
			ТекущийОбъект[СтрокаРазбораИмя] = СтрокаРазбораЗначение;
		КонецЕсли;

	КонецЦикла;

	Если ТекущийОбъект <> Неопределено И ТекущийОбъект.Количество() = 0 Тогда
		СписокОбъектов.Удалить(СписокОбъектов.ВГраница());
	КонецЕсли;

	Возврат СписокОбъектов;

КонецФункции

Функция ПолучитьПутьКRAC(Знач ТекущийПуть, Знач ВерсияПлатформы = "")

	Если НЕ ПустаяСтрока(ТекущийПуть) Тогда
		ФайлУтилиты = Новый Файл(ТекущийПуть);
		Если ФайлУтилиты.Существует() Тогда
			Лог.Отладка("Текущая версия rac " + ФайлУтилиты.ПолноеИмя);
			Возврат ФайлУтилиты.ПолноеИмя;
		КонецЕсли;
	КонецЕсли;

	Если ПустаяСтрока(ВерсияПлатформы) Тогда
		ВерсияПлатформы = "8.3";
	КонецЕсли;

	Конфигуратор = Новый УправлениеКонфигуратором;
	ПутьКПлатформе = Конфигуратор.ПолучитьПутьКВерсииПлатформы(ВерсияПлатформы);
	Лог.Отладка("Используемый путь для поиска rac " + ПутьКПлатформе);
	КаталогУстановки = Новый Файл(ПутьКПлатформе);
	Лог.Отладка(КаталогУстановки.Путь);

	ИмяФайла = ?(ЭтоWindows, "rac.exe", "rac");

	ФайлУтилиты = Новый Файл(ОбъединитьПути(Строка(КаталогУстановки.Путь), ИмяФайла));
	Если ФайлУтилиты.Существует() Тогда
		Лог.Отладка("Текущая версия rac " + ФайлУтилиты.ПолноеИмя);
		Возврат ФайлУтилиты.ПолноеИмя;
	КонецЕсли;

	Лог.Отладка("Не нашли rac. Использую переданный путь " + ТекущийПуть);
	Возврат ТекущийПуть;

КонецФункции

Функция РазобратьНаКлючИЗначение(Знач СтрокаРазбора, Ключ, Значение)

	ПозицияРазделителя = Найти(СтрокаРазбора, ":");
	Если ПозицияРазделителя = 0 Тогда
		Возврат Ложь;
	КонецЕсли;

	Ключ = СокрЛП(Лев(СтрокаРазбора, ПозицияРазделителя - 1));
	Значение = СокрЛП(Сред(СтрокаРазбора, ПозицияРазделителя + 1));

	Возврат Истина;

КонецФункции

#КонецОбласти

#КонецОбласти

/////////////////////////////////////////////////////////////////////////////////
СистемнаяИнформация = Новый СистемнаяИнформация;
ЭтоWindows = Найти(НРег(СистемнаяИнформация.ВерсияОС), "windows") > 0;
