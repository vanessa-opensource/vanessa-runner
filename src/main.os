///////////////////////////////////////////////////////////////////
//
// Рекомендованная структура модуля точки входа приложения
//
///////////////////////////////////////////////////////////////////

#Использовать cmdline
#Использовать logos
#Использовать 1commands

#Использовать "."

///////////////////////////////////////////////////////////////////

Перем Лог;

///////////////////////////////////////////////////////////////////

Процедура Инициализация()
	Лог = Логирование.ПолучитьЛог(ПараметрыСистемы.ИмяЛогаСистемы());

	СистемнаяИнформация = Новый СистемнаяИнформация;
	ПараметрыСистемы.ЭтоWindows = Найти(ВРег(СистемнаяИнформация.ВерсияОС), "WINDOWS") > 0;

	МенеджерКомандПриложения.РегистраторКоманд(ПараметрыСистемы);

КонецПроцедуры

Функция СоответствиеПеременныхОкруженияПараметрамКоманд()
	СоответствиеПеременных = Новый Соответствие();

	СоответствиеПеременных.Вставить("RUNNER_IBCONNECTION", "--ibconnection");
	СоответствиеПеременных.Вставить("RUNNER_IBNAME", "--ibname");
	СоответствиеПеременных.Вставить("RUNNER_DBUSER", "--db-user");
	СоответствиеПеременных.Вставить("RUNNER_DBPWD", "--db-pwd");
	СоответствиеПеременных.Вставить("RUNNER_v8version", "--v8version");
	СоответствиеПеременных.Вставить("RUNNER_uccode", "--uccode");
	СоответствиеПеременных.Вставить("RUNNER_command", "--command");
	СоответствиеПеременных.Вставить("RUNNER_execute", "--execute");
	СоответствиеПеременных.Вставить("RUNNER_storage-user", "--storage-user");
	СоответствиеПеременных.Вставить("RUNNER_storage-pwd", "--storage-pwd");
	СоответствиеПеременных.Вставить("RUNNER_storage-ver", "--storage-ver");
	СоответствиеПеременных.Вставить("RUNNER_storage-name", "--storage-name");
	СоответствиеПеременных.Вставить("RUNNER_extension", "--extension");
	СоответствиеПеременных.Вставить("RUNNER_ROOT", "--root");
	СоответствиеПеременных.Вставить("RUNNER_WORKSPACE", "--workspace");
	СоответствиеПеременных.Вставить("RUNNER_PATHVANESSA", "--pathvanessa");
	СоответствиеПеременных.Вставить("RUNNER_PATHXUNIT", "--pathxunit");
	СоответствиеПеременных.Вставить("RUNNER_VANESSASETTINGS", "--vanessasettings");
	СоответствиеПеременных.Вставить("RUNNER_NOCACHEUSE", "--nocacheuse");
	СоответствиеПеременных.Вставить("RUNNER_LOCALE", "--locale");
	СоответствиеПеременных.Вставить("RUNNER_LANGUAGE", "--language");

	СоответствиеПеременных.Вставить("RUNNER_V8VERSION", "--v8version");
	СоответствиеПеременных.Вставить("RUNNER_UCCODE", "--uccode");
	СоответствиеПеременных.Вставить("RUNNER_COMMAND", "--command");
	СоответствиеПеременных.Вставить("RUNNER_EXECUTE", "--execute");
	СоответствиеПеременных.Вставить("RUNNER_STORAGE_NAME", "--storage-name");
	СоответствиеПеременных.Вставить("RUNNER_STORAGE_USER", "--storage-user");
	СоответствиеПеременных.Вставить("RUNNER_STORAGE_PWD", "--storage-pwd");
	СоответствиеПеременных.Вставить("RUNNER_STORAGE_VER", "--storage-ver");

	Возврат Новый ФиксированноеСоответствие(СоответствиеПеременных);
КонецФункции

Функция НайтиКаталогТекущегоПроекта(Знач Путь)
	Рез = "";
	Если ПустаяСтрока(Путь) Тогда
		Попытка
			Команда = Новый Команда;
			Команда.УстановитьСтрокуЗапуска("git rev-parse --show-toplevel");
			Команда.УстановитьПравильныйКодВозврата(0);
			Команда.Исполнить();
			Рез = СокрЛП(Команда.ПолучитьВывод());
		Исключение
			// некуда выдавать ошибку, логи еще не доступны
		КонецПопытки;
	Иначе
		Рез = Путь;
	КонецЕсли;
	Возврат Рез;
КонецФункции // НайтиКаталогТекущегоПроекта()

Функция ПолучитьПарсерКоманднойСтроки()

	Парсер = Новый ПарсерАргументовКоманднойСтроки();

	МенеджерКомандПриложения.ЗарегистрироватьКоманды(Парсер);

	Возврат Парсер;

КонецФункции // ПолучитьПарсерКоманднойСтроки

Функция ВыполнениеКоманды()

	ПроверитьПодключениеВанессаАДД();

	ПараметрыЗапуска = РазобратьАргументыКоманднойСтроки();

	Если ПараметрыЗапуска = Неопределено ИЛИ ПараметрыЗапуска.Количество() = 0 Тогда

		ВывестиВерсию();
		Лог.Ошибка("Некорректные аргументы командной строки");
		МенеджерКомандПриложения.ПоказатьСправкуПоКомандам();
		Возврат МенеджерКомандПриложения.РезультатыКоманд().ОшибкаВремениВыполнения;

	КонецЕсли;

	Команда = "";
	ЗначенияПараметров = Неопределено;

	Если ТипЗнч(ПараметрыЗапуска) = Тип("Структура") Тогда

		// это команда
		Команда				= ПараметрыЗапуска.Команда;
		ЗначенияПараметров	= ПараметрыЗапуска.ЗначенияПараметров;

		Лог.Отладка("Выполняю команду продукта %1", Команда);

	ИначеЕсли ЗначениеЗаполнено(ПараметрыСистемы.ИмяКомандыПоУмолчанию()) Тогда

		// это команда по-умолчанию
		Команда				= ПараметрыСистемы.ИмяКомандыПоУмолчанию();
		ЗначенияПараметров	= ПараметрыЗапуска;

		Лог.Отладка("Выполняю команду продукта по умолчанию %1", Команда);

	Иначе

		ВызватьИсключение "Некорректно настроено имя команды по-умолчанию.";

	КонецЕсли;

	Если Команда <> ПараметрыСистемы.ИмяКомандыВерсия() Тогда
		ВывестиВерсию();
	КонецЕсли;

	ДополнитьЗначенияПараметров(Команда, ЗначенияПараметров);

	ВключитьВыводОтладочногоЛогаВОтдельныйФайл(ЗначенияПараметров);

	Возврат МенеджерКомандПриложения.ВыполнитьКоманду(Команда, ЗначенияПараметров);

КонецФункции // ВыполнениеКоманды()

Процедура ПроверитьПодключениеВанессаАДД()
	ДопТекстОшибки = "Команда тестирования xunit недоступна
	|Команда проверки поведения vanessa недоступна";
	ВанессаАДД = ОбщиеМетоды.ЗагрузитьВанессаАДД(ДопТекстОшибки);
КонецПроцедуры

Процедура ДополнитьЗначенияПараметров(Знач Команда, ЗначенияПараметров)
	Перем ЗначениеПараметраФайлНастроек, ПутьКФайлуНастроекПоУмолчанию, ФайлОбщихНастроек;
	Перем ЗначенияПараметровНизкийПриоритет, СоответствиеПеременных, НастройкиИзФайла;

	ТекущийКаталогПроекта = НайтиКаталогТекущегоПроекта( ЗначениеПараметра_КаталогПроекта(ЗначенияПараметров) );

	ПараметрыСистемы.КорневойПутьПроекта = ТекущийКаталогПроекта;

	ПутьКФайлуНастроекПоУмолчанию = ОбъединитьПути(ТекущийКаталогПроекта, ОбщиеМетоды.ИмяФайлаНастроек());

	ЗначениеПараметраФайлНастроек = ЗначенияПараметров["--settings"];
	Если ЗначениеЗаполнено(ЗначениеПараметраФайлНастроек) Тогда
		ФайлОбщихНастроек = Новый Файл(ОбщиеМетоды.ПолныйПуть(ЗначениеПараметраФайлНастроек));
		Ожидаем.Что(ФайлОбщихНастроек.Существует(),
			СтрШаблон("Ожидаем, что указанный в --settings <%1> файл по пути <%2> существует, а его нет!",
				ЗначениеПараметраФайлНастроек,
				ФайлОбщихНастроек.ПолноеИмя)
			).ЭтоИстина();
	КонецЕсли;

	НастройкиИзФайла = ОбщиеМетоды.ПрочитатьНастройкиФайлJSON(ТекущийКаталогПроекта,
			ЗначениеПараметраФайлНастроек, ПутьКФайлуНастроекПоУмолчанию);

	ЗначенияПараметровНизкийПриоритет = Новый Соответствие;

	Если НастройкиИзФайла.Количество() > 0 Тогда
		ОбщиеМетоды.ДополнитьАргументыИзФайлаНастроек(Команда, ЗначенияПараметровНизкийПриоритет, НастройкиИзФайла);
	КонецЕсли;

	СоответствиеПеременных = СоответствиеПеременныхОкруженияПараметрамКоманд();

	ОбщиеМетоды.ЗаполнитьЗначенияИзПеременныхОкружения(ЗначенияПараметровНизкийПриоритет, СоответствиеПеременных);

	ОбщиеМетоды.ДополнитьСоответствиеСУчетомПриоритета(ЗначенияПараметров, ЗначенияПараметровНизкийПриоритет);

	// на случай переопределения этой настройки повторная установка
	ТекущийКаталогПроекта = НайтиКаталогТекущегоПроекта(ЗначениеПараметра_КаталогПроекта(ЗначенияПараметров));

	ПараметрыСистемы.КорневойПутьПроекта = ТекущийКаталогПроекта;

	ДобавитьДанныеПодключения(ЗначенияПараметров);

	НастройкиДля1С.ДобавитьШаблоннуюПеременную("workspaceRoot", ТекущийКаталогПроекта);
	НастройкиДля1С.ДобавитьШаблоннуюПеременную("runnerRoot", ОбщиеМетоды.КаталогПроекта());

	НастройкиДля1С.ЗаменитьШаблонныеПеременныеВКоллекции(ЗначенияПараметров);

	ПроверитьНаличиеСлешаКакПоследнегоСимволаВПараметрах(ЗначенияПараметров);

КонецПроцедуры // ДополнитьЗначенияПараметров

Процедура ДобавитьДанныеПодключения(ЗначенияПараметров)
	СтрокаПодключения = ЗначенияПараметров["--ibconnection"];
	ИмяБазы = ЗначенияПараметров["--ibname"];

	Если ЗначениеЗаполнено(СтрокаПодключения) И ЗначениеЗаполнено(ИмяБазы) Тогда
		ВызватьИсключение СтрШаблон("Запрещено одновременно задавать ключи %1 и %2", "--ibconnection", "--ibname");
	КонецЕсли;

	Если ЗначениеЗаполнено(СтрокаПодключения) Тогда
		ЗначенияПараметров.Вставить("--ibname", СтрокаПодключения);
	Иначе
		ЗначенияПараметров.Вставить("--ibconnection", ИмяБазы);

		Если ЗначениеЗаполнено(ИмяБазы) Тогда
			Лог.Предупреждение("------------------------------------------------------------------");
			Лог.Предупреждение("Параметр --ibname устарел. Используйте --ibconnection вместо него!");
			Лог.Предупреждение("------------------------------------------------------------------");
		КонецЕсли;
	КонецЕсли;

	Если ЗначениеЗаполнено(ЗначенияПараметров["--ibname"]) Тогда
		ЗначенияПараметров.Вставить("--ibname",
						ОбщиеМетоды.ПереопределитьПолныйПутьВСтрокеПодключения(ЗначенияПараметров["--ibname"]));

		ИсходнаяСтрокаПодключения = ЗначенияПараметров["--ibname"];

		НоваяСтрокаПодключения = МенеджерСпискаБаз.ПолучитьСтрокуПодключенияСКэшем(
						ИсходнаяСтрокаПодключения,
						ЗначенияПараметров["--nocacheuse"]);

		ЗначенияПараметров.Вставить("--ibname", НоваяСтрокаПодключения);
		ЗначенияПараметров.Вставить("--ibconnection", ИсходнаяСтрокаПодключения);

	КонецЕсли;

	ЗначенияПараметров.Вставить("ДанныеПодключения", ДанныеПодключения(ЗначенияПараметров));
КонецПроцедуры

Функция ДанныеПодключения(ЗначенияПараметров)
	СтруктураПодключения = Новый Структура;

	// здесь может находиться и имя базы и строка подключения
	СтруктураПодключения.Вставить("СтрокаПодключения", ЗначенияПараметров["--ibname"]);

	// здесь может находиться только строка подключения в виде пути к базе
	СтруктураПодключения.Вставить("ПутьБазы", ЗначенияПараметров["--ibconnection"]);

	СтруктураПодключения.Вставить("Пользователь", ЗначенияПараметров["--db-user"]);
	СтруктураПодключения.Вставить("Пароль", ЗначенияПараметров["--db-pwd"]);
	СтруктураПодключения.Вставить("КодЯзыка", ЗначенияПараметров["--language"]);
	СтруктураПодключения.Вставить("КодЯзыкаСеанса", ЗначенияПараметров["--locale"]);

	Рез = Новый Структура;
	Для каждого КлючЗначение Из СтруктураПодключения Цикл
		Значение = КлючЗначение.Значение;
		Если Значение = Неопределено Тогда
			Значение = "";
		КонецЕсли;
		Рез.Вставить(КлючЗначение.Ключ, Значение);
	КонецЦикла;

	Возврат Новый ФиксированнаяСтруктура(Рез);
КонецФункции // ДанныеПодключения(ЗначенияПараметров)

Функция ЗначениеПараметра_КаталогПроекта(Знач ЗначенияПараметров)
	Рез = ЗначенияПараметров["--root"];
	Если Не ЗначениеЗаполнено(Рез) Тогда
		Рез = ЗначенияПараметров["--workspace"];
		Если Не ЗначениеЗаполнено(Рез) Тогда
			Рез = "";
		КонецЕсли;
	КонецЕсли;
	Возврат Рез;
КонецФункции

Процедура ПроверитьНаличиеСлешаКакПоследнегоСимволаВПараметрах(ЗначенияПараметров)
	Если Не ПараметрыСистемы.ЭтоWindows Тогда
		Возврат;
	КонецЕсли;
	РегулярноеВыражение = Новый РегулярноеВыражение("[\\\/]\s*$");
	РегулярноеВыражение.Многострочный = Истина;
	Для каждого КлючЗначение Из ЗначенияПараметров Цикл
		Значение = КлючЗначение.Значение;
		Если ЗначениеЗаполнено(Значение) И РегулярноеВыражение.Совпадает(Значение) Тогда
			ВызватьИсключение СтрШаблон(
				"Запрещено использование слешей как последних символов в параметрах.%1" +
				" Это может привести к проблемам при запуске в командной строке.%1%1 Ключ %2 = %3",
				Символы.ПС, КлючЗначение.Ключ, Значение);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ВключитьВыводОтладочногоЛогаВОтдельныйФайл(Знач ЗначенияПараметров)
	ПутьФайлаВывода = "";
	Если ЗначенияПараметров["--debuglogfile"] <> Неопределено Тогда
		ПутьФайлаВывода = ЗначенияПараметров["--debuglogfile"];
	ИначеЕсли ЗначенияПараметров["--debuglog"] <> Неопределено Тогда
		// специально не через ВременныеФайлы для возмножности сохранения файла после завершения
		ПутьФайлаВывода = ПолучитьИмяВременногоФайла(".log");
		ФайлВывода = Новый Файл(ПутьФайлаВывода);
		ПутьФайлаВывода = ОбъединитьПути(ФайлВывода.Путь, "vrunner-" + ФайлВывода.Имя);
	Иначе
		Возврат;
	КонецЕсли;

	ФайлЖурнала = Новый ВыводЛогаВФайл;
	ФайлЖурнала.ОткрытьФайл(ПутьФайлаВывода);

	Если Не Лог.ДобавленыСобственныеСпособыВывода() Тогда
		ВыводПоУмолчанию = Новый ВыводЛогаВКонсоль();
		Лог.ДобавитьСпособВывода(ВыводПоУмолчанию);
	КонецЕсли;

	Лог.ДобавитьСпособВывода(ФайлЖурнала, УровниЛога.Отладка);

	Лог.Отладка("Подключил вывод отладочного лога в отдельный файл %1", ПутьФайлаВывода);
КонецПроцедуры

Процедура ВывестиВерсию()

	Сообщить(СтрШаблон("%1 v%2", ПараметрыСистемы.ИмяПродукта(), ПараметрыСистемы.ВерсияПродукта()));

КонецПроцедуры // ВывестиВерсию()

Функция РазобратьАргументыКоманднойСтроки()

	Парсер = ПолучитьПарсерКоманднойСтроки();
	Возврат Парсер.Разобрать(АргументыКоманднойСтроки);

КонецФункции // РазобратьАргументыКоманднойСтроки

Функция Форматировать(Знач Уровень, Знач Сообщение) Экспорт

	Возврат СтрШаблон("%1: %2 - %3", ТекущаяДата(), УровниЛога.НаименованиеУровня(Уровень), Сообщение);

КонецФункции

///////////////////////////////////////////////////////////////////

Инициализация();

Попытка

	КодВозврата = ВыполнениеКоманды();

	ВременныеФайлы.Удалить();

	ЗавершитьРаботу(КодВозврата);

Исключение

	ИнфоОшибки = ИнформацияОбОшибке();
	Если ЗначениеЗаполнено(ИнфоОшибки.Параметры) Тогда
		Если ЗначениеЗаполнено(ИнфоОшибки.Параметры.Предупреждение) Тогда
			Лог.Предупреждение(ИнфоОшибки.Параметры.Предупреждение);
		КонецЕсли;
		Лог.Ошибка(ИнфоОшибки.Описание);
	Иначе
		Лог.КритичнаяОшибка(ОписаниеОшибки());
	КонецЕсли;

	ВременныеФайлы.Удалить();

	ЗавершитьРаботу(МенеджерКомандПриложения.РезультатыКоманд().ОшибкаВремениВыполнения);

КонецПопытки;
