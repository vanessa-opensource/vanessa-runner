///////////////////////////////////////////////////////////////////
//
// Служебный модуль с набором методов работы с командами приложения
//
// Структура модуля реализована в соответствии с рекомендациями
// oscript-app-template (C) EvilBeaver
//
///////////////////////////////////////////////////////////////////

#Использовать logos
#Использовать tempfiles

///////////////////////////////////////////////////////////////////

Перем ИсполнителиКоманд;
Перем РегистраторКоманд;
Перем ДополнительныеПараметры;

///////////////////////////////////////////////////////////////////

Процедура ЗарегистрироватьКоманды(Знач Парсер) Экспорт

	РегистраторКоманд.ПриРегистрацииГлобальныхПараметровКоманд(Парсер);

	КомандыИРеализация = Новый Соответствие;
	РегистраторКоманд.ПриРегистрацииКомандПриложения(КомандыИРеализация);

	Для Каждого КлючИЗначение Из КомандыИРеализация Цикл

		ДобавитьКоманду(КлючИЗначение.Ключ, КлючИЗначение.Значение, Парсер);

	КонецЦикла;

КонецПроцедуры // ЗарегистрироватьКоманды

Процедура РегистраторКоманд(Знач ОбъектРегистратор) Экспорт

	ИсполнителиКоманд = Новый Соответствие;
	РегистраторКоманд = ОбъектРегистратор;
	ДополнительныеПараметры = Новый Структура;

	ДополнительныеПараметры.Вставить("Лог", Логирование.ПолучитьЛог(ПараметрыСистемы.ИмяЛогаСистемы()));

КонецПроцедуры // РегистраторКоманд

Функция ПолучитьКоманду(Знач ИмяКоманды) Экспорт

	КлассРеализации = ИсполнителиКоманд[ИмяКоманды];
	Если КлассРеализации = Неопределено Тогда

		ВызватьИсключение "Неверная операция. Команда '" + ИмяКоманды + "' не предусмотрена.";

	КонецЕсли;

	Возврат КлассРеализации;

КонецФункции // ПолучитьКоманду

Функция ВыполнитьКоманду(Знач ИмяКоманды, Знач ПараметрыКоманды) Экспорт

	Команда = ПолучитьКоманду(ИмяКоманды);
	ДополнитьЗначенияПараметров(ИмяКоманды, ПараметрыКоманды);
	ВключитьВыводОтладочногоЛогаВОтдельныйФайл(ПараметрыКоманды);
	КодВозврата = Команда.ВыполнитьКоманду(ПараметрыКоманды, ДополнительныеПараметры);

	Возврат КодВозврата;

КонецФункции // ВыполнитьКоманду

Процедура ПоказатьСправкуПоКомандам(ИмяКоманды = Неопределено) Экспорт

	ПараметрыКоманды = Новый Соответствие;
	Если ИмяКоманды <> Неопределено Тогда

		ПараметрыКоманды.Вставить("Команда", ИмяКоманды);

	КонецЕсли;

	ВыполнитьКоманду(ПараметрыСистемы.ВозможныеКоманды().Помощь, ПараметрыКоманды);

КонецПроцедуры // ПоказатьСправкуПоКомандам

Процедура ДобавитьКоманду(Знач ИмяКоманды, Знач КлассРеализации, Знач Парсер)

	Попытка
		РеализацияКоманды = Новый(КлассРеализации);
		РеализацияКоманды.ЗарегистрироватьКоманду(ИмяКоманды, Парсер);
		ИсполнителиКоманд.Вставить(ИмяКоманды, РеализацияКоманды);
	Исключение
		ДополнительныеПараметры.Лог.Ошибка("Не удалось выполнить команду %1 для класса %2", ИмяКоманды, КлассРеализации);
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры

Функция Лог() Экспорт
	Возврат ДополнительныеПараметры.Лог;
КонецФункции

///////////////////////////////////////////////////////////////////

Функция РезультатыКоманд() Экспорт

	РезультатыКоманд = Новый Структура;
	РезультатыКоманд.Вставить("Успех", 0);
	РезультатыКоманд.Вставить("НеверныеПараметры", 5);
	РезультатыКоманд.Вставить("ОшибкаВремениВыполнения", 1);

	Возврат РезультатыКоманд;

КонецФункции // РезультатыКоманд

Функция КодВозвратаКоманды(Знач Команда) Экспорт

	Возврат Число(Команда);

КонецФункции // КодВозвратаКоманды

#Область СлужебныеПроцедурыИФункции

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
	СоответствиеПеременных.Вставить("RUNNER_ROOT", "--root");
	СоответствиеПеременных.Вставить("RUNNER_WORKSPACE", "--workspace");
	СоответствиеПеременных.Вставить("RUNNER_PATHVANESSA", "--pathvanessa");
	СоответствиеПеременных.Вставить("RUNNER_PATHXUNIT", "--pathxunit");
	СоответствиеПеременных.Вставить("RUNNER_VANESSASETTINGS", "--vanessasettings");
	СоответствиеПеременных.Вставить("RUNNER_NOCACHEUSE", "--nocacheuse");
	СоответствиеПеременных.Вставить("RUNNER_LOCALE", "--locale");
	СоответствиеПеременных.Вставить("RUNNER_LANGUAGE", "--language");

	СоответствиеПеременных.Вставить("RUNNER_V8VERSION", "--v8version");
	СоответствиеПеременных.Вставить("RUNNER_ADDITIONAL", "--additional");
	СоответствиеПеременных.Вставить("RUNNER_UCCODE", "--uccode");
	СоответствиеПеременных.Вставить("RUNNER_COMMAND", "--command");
	СоответствиеПеременных.Вставить("RUNNER_EXECUTE", "--execute");
	СоответствиеПеременных.Вставить("RUNNER_STORAGE_NAME", "--storage-name");
	СоответствиеПеременных.Вставить("RUNNER_STORAGE_USER", "--storage-user");
	СоответствиеПеременных.Вставить("RUNNER_STORAGE_PWD", "--storage-pwd");
	СоответствиеПеременных.Вставить("RUNNER_STORAGE_VER", "--storage-ver");
	СоответствиеПеременных.Вставить("RUNNER_TESTSPATH", "testsPath");
	СоответствиеПеременных.Вставить("RUNNER_CLUSTERADMIN_USER", "--cluster-admin");
	СоответствиеПеременных.Вставить("RUNNER_CLUSTERADMIN_PWD", "--cluster-pwd");

	Возврат Новый ФиксированноеСоответствие(СоответствиеПеременных);
КонецФункции

Функция НайтиКаталогТекущегоПроекта(Знач Путь)
	Рез = "";
	Если ПустаяСтрока(Путь) Тогда
		Попытка
			Команда = Новый Команда;
			Команда.УстановитьСтрокуЗапуска("git rev-parse --show-toplevel");
			Команда.УстановитьКодировкуВывода(КодировкаТекста.UTF8);
			Команда.УстановитьПравильныйКодВозврата(0);
			Команда.Исполнить();
			Рез = СокрЛП(Команда.ПолучитьВывод());
		Исключение // BSLLS:MissingCodeTryCatchEx-off
			// некуда выдавать ошибку, логи еще не доступны
		КонецПопытки;
	Иначе
		Рез = Путь;
	КонецЕсли;
	Возврат Рез;
КонецФункции // НайтиКаталогТекущегоПроекта()

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

	Если ЗначениеЗаполнено(НастройкиИзФайла) Тогда
		ОбщиеМетоды.ДополнитьАргументыИзФайлаНастроек(Команда, ЗначенияПараметровНизкийПриоритет, НастройкиИзФайла);
	КонецЕсли;

	СоответствиеПеременных = СоответствиеПеременныхОкруженияПараметрамКоманд();

	ОбщиеМетоды.ЗаполнитьЗначенияИзПеременныхОкружения(ЗначенияПараметровНизкийПриоритет, СоответствиеПеременных);

	ОбщиеМетоды.ДополнитьСоответствиеСУчетомПриоритета(ЗначенияПараметров, ЗначенияПараметровНизкийПриоритет);

	// на случай переопределения этой настройки повторная установка
	ТекущийКаталогПроекта = НайтиКаталогТекущегоПроекта(ЗначениеПараметра_КаталогПроекта(ЗначенияПараметров));

	ПараметрыСистемы.КорневойПутьПроекта = ТекущийКаталогПроекта;

	ПроверитьНаличиеСлешаКакПоследнегоСимволаВПараметрах(ЗначенияПараметров);
	ДобавитьДанныеПодключения(ЗначенияПараметров);

	НастройкиДля1С.ДобавитьШаблоннуюПеременную("workspaceRoot", ТекущийКаталогПроекта);
	НастройкиДля1С.ДобавитьШаблоннуюПеременную("runnerRoot", ОбщиеМетоды.КаталогПроекта());

	НастройкиДля1С.ЗаменитьШаблонныеПеременныеВКоллекции(ЗначенияПараметров);

	ПроверитьНаличиеСлешаКакПоследнегоСимволаВПараметрах(ЗначенияПараметров);

КонецПроцедуры // ДополнитьЗначенияПараметров

Процедура ВключитьВыводОтладочногоЛогаВОтдельныйФайл(Знач ЗначенияПараметров)

	Лог = Лог();

	ПутьФайлаВывода = "";
	Если ЗначенияПараметров["--debuglogfile"] <> Неопределено Тогда
		ПутьФайлаВывода = ЗначенияПараметров["--debuglogfile"];
		ФайлВывода = Новый Файл(ОбъединитьПути(ТекущийКаталог(), ПутьФайлаВывода));
		ФС.ОбеспечитьКаталог(ФайлВывода.Путь);
	ИначеЕсли ЗначенияПараметров["--debuglog"] Тогда
		// специально не через ВременныеФайлы для возможности сохранения файла после завершения
		ПутьФайлаВывода = ПолучитьИмяВременногоФайла(".log"); // BSLLS:MissingTemporaryFileDeletion-off
		ФайлВывода = Новый Файл(ПутьФайлаВывода);
		ПутьФайлаВывода = ОбъединитьПути(ФайлВывода.Путь, "vrunner-" + ФайлВывода.Имя); // BSLLS:MissingTemporaryFileDeletion-off
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

Процедура ДобавитьДанныеПодключения(ЗначенияПараметров)

	Лог = ДополнительныеПараметры.Лог;

	ИмяСтрокаСоединения = "--ibconnection";
	ИмяСтрокаСоединенияСтарое = "--ibname";
	СтрокаПодключения = ЗначенияПараметров[ИмяСтрокаСоединения];
	ИмяБазы = ЗначенияПараметров[ИмяСтрокаСоединенияСтарое];

	Если ЗначениеЗаполнено(СтрокаПодключения) И ЗначениеЗаполнено(ИмяБазы) Тогда
		ВызватьИсключение СтрШаблон("Запрещено одновременно задавать ключи %1 и %2", ИмяСтрокаСоединения, "--ibname");
	КонецЕсли;

	Если ЗначениеЗаполнено(СтрокаПодключения) Тогда
		ЗначенияПараметров.Вставить(ИмяСтрокаСоединенияСтарое, СтрокаПодключения);
	Иначе
		ЗначенияПараметров.Вставить(ИмяСтрокаСоединения, ИмяБазы);

		Если ЗначениеЗаполнено(ИмяБазы) Тогда
			Лог.Предупреждение("------------------------------------------------------------------");
			Лог.Предупреждение("Параметр --ibname устарел. Используйте --ibconnection вместо него!");
			Лог.Предупреждение("------------------------------------------------------------------");
		КонецЕсли;
	КонецЕсли;

	Если ЗначениеЗаполнено(ЗначенияПараметров[ИмяСтрокаСоединенияСтарое]) Тогда
		ЗначенияПараметров.Вставить(ИмяСтрокаСоединенияСтарое,
						ОбщиеМетоды.ПереопределитьПолныйПутьВСтрокеПодключения(ЗначенияПараметров[ИмяСтрокаСоединенияСтарое]));

		ИсходнаяСтрокаПодключения = ЗначенияПараметров[ИмяСтрокаСоединенияСтарое];

		НоваяСтрокаПодключения = МенеджерСпискаБаз.ПолучитьСтрокуПодключенияСКэшем(
						ИсходнаяСтрокаПодключения,
						ЗначенияПараметров["--nocacheuse"]);

		ЗначенияПараметров.Вставить(ИмяСтрокаСоединенияСтарое, НоваяСтрокаПодключения);
		ЗначенияПараметров.Вставить(ИмяСтрокаСоединения, ИсходнаяСтрокаПодключения);

	КонецЕсли;

	ЗначенияПараметров.Вставить("ДанныеПодключения", ДанныеПодключения(ЗначенияПараметров));
КонецПроцедуры

Функция ДанныеПодключения(ЗначенияПараметров)
	СтруктураПодключения = Новый Структура;

	// здесь может находиться и имя базы и строка подключения
	СтруктураПодключения.Вставить("СтрокаПодключения", ЗначенияПараметров["--ibname"]);

	// если ИспользоватьВременнуюБазу, тогда используется временная база,
	// что важно для некоторых команд, например, при работе с хранилищем
	СтруктураПодключения.Вставить("ИспользоватьВременнуюБазу", Ложь);

	// здесь может находиться только строка подключения в виде пути к базе
	СтруктураПодключения.Вставить("ПутьБазы", ЗначенияПараметров["--ibconnection"]);

	СтруктураПодключения.Вставить("Пользователь", ЗначенияПараметров["--db-user"]);
	СтруктураПодключения.Вставить("Пароль", ЗначенияПараметров["--db-pwd"]);
	СтруктураПодключения.Вставить("КодЯзыка", ЗначенияПараметров["--language"]);
	СтруктураПодключения.Вставить("КодЯзыкаСеанса", ЗначенияПараметров["--locale"]);
	СтруктураПодключения.Вставить("ВерсияПлатформы", ЗначенияПараметров["--v8version"]);
	СтруктураПодключения.Вставить("РазрядностьПлатформы", ЗначенияПараметров["--bitness"]);

	Рез = Новый Структура;
	Для каждого КлючЗначение Из СтруктураПодключения Цикл
		Значение = КлючЗначение.Значение;
		Если Значение = Неопределено Тогда
			Значение = "";
		КонецЕсли;
		Рез.Вставить(КлючЗначение.Ключ, Значение);
	КонецЦикла;

	Возврат Новый ФиксированнаяСтруктура(Рез);
КонецФункции

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

#КонецОбласти
