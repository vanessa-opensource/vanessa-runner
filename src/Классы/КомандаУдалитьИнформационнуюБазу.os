#Область ОписаниеПеременных

Перем Лог;
Перем Настройки;
Перем ОписаниеКластераКеш;
Перем ИдентификаторБазыКеш;
Перем ЭтоWindows;

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт

	ТекстОписанияКоманды = "     Удалить информационную базу через ras\rac.";
	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды, ТекстОписанияКоманды);

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--ras", "Сетевой адрес RAS. Необязательный. По умолчанию localhost:1545");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--rac", "Команда запуска RAC. Необязательный. По умолчанию находим в каталоге установки 1с");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--name", "Имя информационной базы. Обязательный.");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--cluster-admin", "Администратор кластера");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--cluster-pwd", "Пароль администратора кластера");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--cluster", "Идентификатор кластера");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--cluster-name", "Имя кластера");

	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--drop-database", "Удалить базу данных при удалении информационной базы. По умолчанию БД не удаляется.");
	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--clear-database", "Очистить базу данных при удалении информационной базы. По умолчанию не очищается");

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

	УдалитьИнформационнуюБазу();
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

	Результат.Вставить("УдалитьБД", ПараметрыКоманды["--drop-database"]);
	Результат.Вставить("ОчиститьБД", ПараметрыКоманды["--clear-database"]);
	Результат.Вставить("ИмяИБ", ПараметрыКоманды["--name"]);

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
		Лог.Ошибка("Не указано имя удаляемой ИБ");
		Успех = Ложь;
	КонецЕсли;

	Возврат Успех;

КонецФункции

/////////////////////////////////////////////////////////////////////////////////
// Взаимодействие с кластером

Процедура УдалитьИнформационнуюБазу()

	Лог.Информация("Создаю клиент-серверную информационную базу");

	ОписаниеКластера = ОписаниеКластера();
	Лог.Отладка("Найден идентификатор кластера %1", ОписаниеКластера.Идентификатор);

	ИдентификаторБазы = ИдентификаторБазы();
	КомандаВыполнения = СтрокаЗапускаКлиента() + "infobase drop ";

	Если ЗначениеЗаполнено(ИдентификаторБазы) Тогда
		Командавыполнения = КомандаВыполнения + "--infobase=""" + ИдентификаторБазы + """ ";
	КонецЕсли;

	Если Настройки.УдалитьБД Тогда
		КомандаВыполнения = КомандаВыполнения + "--drop-database ";
	ИначеЕсли Настройки.ОчиститьБД Тогда
		КомандаВыполнения = КомандаВыполнения + "--clear-database ";
	КонецЕсли; // BSLLS:IfElseIfEndsWithElse-off

	ИдентификаторКластера = ИдентификаторКластера(ОписаниеКластера);
	КомандаВыполнения = КомандаВыполнения + "--cluster=""" + ИдентификаторКластера + """ ";

	КомандаВыполнения = КомандаВыполнения + КлючиАвторизацииВКластере();
	КомандаВыполнения = КомандаВыполнения + КлючиАвторизацииВБазе();
	КомандаВыполнения = КомандаВыполнения + " " + Настройки.АдресСервераАдминистрирования;
	Лог.Отладка(КомандаВыполнения);

	ЗапуститьПроцесс(КомандаВыполнения);

	Лог.Информация("Клиент-серверная информационная база удалена: %1", Настройки.ИмяИБ);

	Если Настройки.УдалитьБД Тогда
		ТекстПоУдалениюБД = "Также удалена база данных в СУБД";
	Иначе
		ТекстПоУдалениюБД = "Внимание: не удалена база данных в СУБД";
		Если Настройки.ОчиститьБД Тогда
			ТекстПоУдалениюБД = ТекстПоУдалениюБД + "
			|база данных полностью очищена";
		Иначе
			ТекстПоУдалениюБД = ТекстПоУдалениюБД + "
			|база данных не очищена, осталась неизменной.";
		КонецЕсли;
	КонецЕсли;
	Лог.Информация(ТекстПоУдалениюБД);
КонецПроцедуры

Функция КлючиАвторизацииВБазе()
	КлючиАвторизацииВБазе = "";
	Если ЗначениеЗаполнено(Настройки.АдминистраторИБ) Тогда
		КлючиАвторизацииВБазе = КлючиАвторизацииВБазе + СтрШаблон(" --infobase-user=""%1""", Настройки.АдминистраторИБ);
	КонецЕсли;

	Если ЗначениеЗаполнено(Настройки.ПарольАдминистратораИБ) Тогда
		КлючиАвторизацииВБазе = КлючиАвторизацииВБазе + СтрШаблон(" --infobase-pwd=""%1""", Настройки.ПарольАдминистратораИБ);
	КонецЕсли;

	Возврат КлючиАвторизацииВБазе;

КонецФункции

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

Функция ИдентификаторБазы()
	Если ИдентификаторБазыКеш = Неопределено Тогда
		ИдентификаторБазыКеш = НайтиБазуВКластере();
	КонецЕсли;

	Возврат ИдентификаторБазыКеш;
КонецФункции

Функция НайтиБазуВКластере()

	ОписаниеКластера = ОписаниеКластера();
	Лог.Отладка("Найден идентификатор кластера %1", ОписаниеКластера.Идентификатор);

	КомандаВыполнения = СтрокаЗапускаКлиента() + СтрШаблон("infobase summary list --cluster=""%1""%2",
			ОписаниеКластера.Идентификатор,
			КлючиАвторизацииВКластере()) + " " + Настройки.АдресСервераАдминистрирования;

	Лог.Отладка("Получаю список баз кластера");

	СписокБазВКластере = СокрЛП(ЗапуститьПроцесс(КомандаВыполнения));
	Лог.Отладка(СписокБазВКластере);
	ЧислоСтрок = СтрЧислоСтрок(СписокБазВКластере);
	НайденаБазаВКластере = Ложь;
	Для К = 1 По ЧислоСтрок Цикл

		СтрокаРазбора = СтрПолучитьСтроку(СписокБазВКластере, К);
		ПозицияРазделителя = Найти(СтрокаРазбора, ":");
		Если Найти(СтрокаРазбора, "infobase") > 0 Тогда
			УИДИБ = СокрЛП(Сред(СтрокаРазбора, ПозицияРазделителя + 1));
		ИначеЕсли Найти(СтрокаРазбора, "name") > 0 Тогда
			ИмяБазы = СокрЛП(Сред(СтрокаРазбора, ПозицияРазделителя + 1));
			Если Нрег(ИмяБазы) = НРег(Настройки.ИмяИБ) Тогда
				Лог.Отладка("Получен УИД базы");
				НайденаБазаВКластере = Истина;
				Прервать;
			КонецЕсли;
		КонецЕсли; // BSLLS:IfElseIfEndsWithElse-off

	КонецЦикла;
	Если Не НайденаБазаВКластере Тогда
		ВызватьИсключение "База " + Настройки.ИмяИБ + " не найдена в кластере";
	КонецЕсли;

	Возврат УИДИБ;

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

Функция ПолучитьПутьКRAC(ТекущийПуть, Знач ВерсияПлатформы = "")

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

/////////////////////////////////////////////////////////////////////////////////
СистемнаяИнформация = Новый СистемнаяИнформация;
ЭтоWindows = Найти(НРег(СистемнаяИнформация.ВерсияОС), "windows") > 0;
