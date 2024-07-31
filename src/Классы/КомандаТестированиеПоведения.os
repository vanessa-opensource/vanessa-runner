///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Запуск проверки поведения через фреймворк Vanessa-ADD
//
// Пример строки запуска:
// 	oscript src/main.os vanessa --ibconnection /F./build/ib --vanessasettings ./examples\.vb-conf.json
//
// Служебный модуль с набором методов работы с командами приложения
//
///////////////////////////////////////////////////////////////////////////////////////////////////

#Использовать asserts
#Использовать json

#Область ОписаниеПеременных

Перем Лог; // Экземпляр логгера
Перем МенеджерКонфигуратора;
Перем ВанессаАДД;

#КонецОбласти

#Область ОбработчикиСобытий

// Регистрация команды и ее аргументов/ключей
//
// Параметры:
//   ИмяКоманды - Строка - имя команды
//   Парсер - Парсер - объект парсера
//
Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт

	ВанессаАДД = ОбщиеМетоды.ЗагрузитьВанессаАДД();
	Если ВанессаАДД = Неопределено Тогда
		Возврат;
	КонецЕсли;

	НастройкиДля1С.ДобавитьШаблоннуюПеременную("addRoot", ВанессаАДД.КаталогИнструментов());

	ТекстОписания =
		"     Запуск проверки поведения (BDD) через фреймворк Vanessa-ADD (Vanessa Automation Driven Development).";

	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды,
		ТекстОписания);

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--path", "Путь для запуска тестов
		|Можно указывать как каталог с фичами, так и конкретную фичу");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--pathvanessa",
		"[env RUNNER_PATHVANESSA] путь к внешней обработке, по умолчанию <OneScript>/lib/add/bddRunner.epf
		|           или переменная окружения RUNNER_PATHVANESSA");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--vanessasettings",
		"[env RUNNER_VANESSASETTINGS] путь к файлу настроек фреймворка тестирования");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--workspace",
		"[env RUNNER_WORKSPACE] путь к папке, относительно которой будут определятся макросы $workspace.
		|                 по умолчанию текущий.");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--tags-ignore",
		"Теги игнорирования фича-файлов");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--tags-filter",
		"Теги отбор фича-файлов");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--additional-keys",
		"Дополнительные параметры, передаваемые в параметр /С.");
	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--no-wait",
		"Не ожидать завершения запущенной команды/действия");

	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--ibsrv",
		"Запуск команды с использованием утилиты ibsrv");	

	Парсер.ДобавитьКоманду(ОписаниеКоманды);

КонецПроцедуры

// Выполняет логику команды
//
// Параметры:
//   ПараметрыКоманды - Соответствие - Соответствие ключей командной строки и их значений
//   ДополнительныеПараметры - Соответствие - дополнительные параметры (необязательно)
//
//  Возвращаемое значение:
//   Число - Код возврата команды
//
Функция ВыполнитьКоманду(Знач ПараметрыКоманды, Знач ДополнительныеПараметры = Неопределено) Экспорт

	Лог = ОбщиеМетоды.ЛогКоманды(ДополнительныеПараметры);

	Действие = Новый Действие(ЭтотОбъект, "ТестированиеПоведения");
	Возврат ОбщиеМетоды.ВыполнитьКомандуСУчетомIbsrv(ПараметрыКоманды, Действие);

КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ТестированиеПоведения(Знач ПараметрыКоманды) Экспорт

	ДанныеПодключения = ПараметрыКоманды["ДанныеПодключения"];

	ЗапускатьТолстыйКлиент = ОбщиеМетоды.УказанПараметрТолстыйКлиент(ПараметрыКоманды["--ordinaryapp"], Лог);
	ОжидатьЗавершения = Не ПараметрыКоманды["--no-wait"];
	МенеджерКонфигуратора = Новый МенеджерКонфигуратора;
	МенеджерКонфигуратора.Конструктор(ДанныеПодключения, ПараметрыКоманды);

	ПутьКФичам = "";
	Если ПараметрыКоманды.Получить("--path") <> Неопределено Тогда
		ПутьКФичам = ПараметрыКоманды["--path"];

		Ожидаем.Что(ЗапускатьТолстыйКлиент = Истина,
			"Нельзя одновременно указывать ключи запуска --ordinaryapp 1 и --path ПутьХХХ,
			|	т.к. Vanessa-ADD в толстом клиенте для обычных форм не поддерживает указание фич через командную строку.")
			.ЭтоЛожь();
	КонецЕсли;

	Попытка
		ЗапуститьТестироватьПоведение(
			ПутьКФичам,
			ОбщиеМетоды.ПолныйПуть(ПараметрыКоманды["--workspace"]),
			ОбщиеМетоды.ПолныйПуть(ПараметрыКоманды["--vanessasettings"]),
			ОбщиеМетоды.ПолныйПуть(ПараметрыКоманды["--pathvanessa"]),
			ЗапускатьТолстыйКлиент, ОжидатьЗавершения,
			ПараметрыКоманды["--additional"],
			ПараметрыКоманды["--tags-ignore"],
			ПараметрыКоманды["--tags-filter"],
			ПараметрыКоманды["--additional-keys"]
	);

	Исключение
		МенеджерКонфигуратора.Деструктор();
		ВызватьИсключение;
	КонецПопытки;

	МенеджерКонфигуратора.Деструктор();

	Возврат МенеджерКомандПриложения.РезультатыКоманд().Успех;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняем запуск тестов для vannessa
//
//	Параметры:
//		ПутьКФичам - <Строка> - Путь к фичам, может быть пустым
//		РабочийКаталогПроекта - <Строка> - Путь к каталогу с проектом, по умолчанию каталог ./
//		ПутьКНастройкам - <Строка> - Путь к файлу настроек запуска тестов
//		ПутьКИнструментам - <Строка> - пут Булево, Неопределено к инструментам, по умолчанию ВанессаАДД.ПутьИнструментаБДД()
//		ТолстыйКлиент - Булево, Неопределено - признак запуска толстого клиента
//		ОжидатьЗавершения - <Булево> - признак запуска ожидания, пока 1С завершится,
//				для разработки освобождения командной строки надо ставить Ложь;
//		ДопПараметры - <Строка> - дополнительные параметры для передачи в параметры запуска 1с, например /DebugURLtcp://localhost
//		ТегиОтбор - <Строка> - Теги игнорирования фича-файлов
//		ТегиФильтр - <Строка> - Теги отбор фича-файлов
//		ДопКлючи - <Строка> - дополнительные параметры для передачи в параметры запуска 1с /С, например NoLoadTestClientsTable
Процедура ЗапуститьТестироватьПоведение(Знач ПутьКФичам = Неопределено,
										Знач РабочийКаталогПроекта = Неопределено,
										Знач ПутьКНастройкам = "", Знач ПутьКИнструментам = "", Знач ТолстыйКлиент = Ложь,
										Знач ОжидатьЗавершения = Истина, Знач ДопПараметры = "",
										Знач ТегиОтбор = "", Знач ТегиФильтр = "",
										Знач ДопКлючи = "")

	Лог.Информация("Тестирую поведение с помощью фреймворка Vanessa-ADD (Vanessa Automation Driven Development)");

	Лог.Отладка("РабочийКаталогПроекта <%1>", РабочийКаталогПроекта);
	Если РабочийКаталогПроекта = Неопределено Тогда
		РабочийКаталогПроекта = ".";
	КонецЕсли;
	РабочийКаталогПроекта = ОбщиеМетоды.ПолныйПуть(РабочийКаталогПроекта);
	Лог.Отладка("Абсолютный путь РабочийКаталогПроекта <%1>", РабочийКаталогПроекта);

	Если ПутьКФичам <> Неопределено Тогда
		ПутьКФичам = ОбщиеМетоды.ПолныйПуть(ПутьКФичам);
		Лог.Отладка("Абсолютный путь ПутьКФичам <%1>", ПутьКФичам);

		УстановитьПеременнуюСреды("VANESSA_FEATUREPATH", ПутьКФичам);
	КонецЕсли;

	Если ПустаяСтрока(ПутьКИнструментам) Тогда
		ПутьКИнструментам = ВанессаАДД.ПутьИнструментаБДД();
		Лог.Отладка("Не задан путь к запускателю bdd-тестов. Использую путь по умолчанию %1", ПутьКИнструментам);
	КонецЕсли;

	ПутьКИнструментам = ОбщиеМетоды.ПолныйПуть(ПутьКИнструментам);
	Лог.Отладка("Путь к запускателю bdd-тестов. %1", ПутьКИнструментам);

	ФайлСуществует = Новый Файл(ПутьКИнструментам).Существует();
	Ожидаем.Что(ФайлСуществует, СтрШаблон("Ожидаем, что файл <%1> существует, а его нет!", ПутьКИнструментам)).ЭтоИстина();

	НастройкиДля1С.ДобавитьШаблоннуюПеременную("workspaceRoot", РабочийКаталогПроекта);

	Настройки = НастройкиДля1С.ПрочитатьНастройки(ПутьКНастройкам);

	ПутьКФайлуСтатусаВыполнения = НастройкиДля1С.ПолучитьНастройку(Настройки,
			"ПутьКФайлуДляВыгрузкиСтатусаВыполненияСценариев",
			"./build/buildstatus.log", "путь к файлу статуса выполнения");

	ПутьЛогаВыполненияСценариев = НастройкиДля1С.ПолучитьНастройку(Настройки, "ИмяФайлаЛогВыполненияСценариев",
								"./build/vanessaonline.txt", "путь к лог-файлу выполнения");

	КлючиЗапуска = Новый Массив;
	КлючиЗапуска.Добавить("StartFeaturePlayer");
	КлючиЗапуска.Добавить("workspaceRoot=" + РабочийКаталогПроекта);

	Если ЗначениеЗаполнено(ПутьКНастройкам) Тогда
		КлючиЗапуска.Добавить("VBParams=" + ПутьКНастройкам);	
	КонецЕсли;

	Если ЗначениеЗаполнено(ТегиОтбор) Тогда
		КлючиЗапуска.Добавить("TagsIgnore=" + ТегиОтбор);
	КонецЕсли;

	Если ЗначениеЗаполнено(ТегиФильтр) Тогда
		КлючиЗапуска.Добавить("TagsFilter=" + ТегиФильтр);
	КонецЕсли;

	Если ЗначениеЗаполнено(ДопКлючи) Тогда
		КлючиЗапуска.Добавить(ДопКлючи);
	КонецЕсли;

	КлючЗапуска = СтрШаблон("""%1""", СтрСоединить(КлючиЗапуска, ";"));

	Лог.Отладка(КлючЗапуска);

	ДополнительныеКлючи = " /TESTMANAGER " + ДопПараметры;

	ДопСообщения = МенеджерКонфигуратора.НовыеДопСообщенияДляЗапускаПредприятия();
	ДопСообщения.Ключ = "ЗапуститьТестироватьПоведение";
	ДопСообщения.ПоказыватьДополнительноЛогПредприятия = Ложь;
	ДопСообщения.СообщениеВСлучаеУспеха = "Все фичи/сценарии выполнены!";
	ДопСообщения.СообщениеВСлучаеПадения = "Часть фич/сценариев упала!";
	ДопСообщения.СообщениеВСлучаеПропуска =
		"Ошибок при проверке поведения не найдено, но часть сценариев еще не реализована!";

	МенеджерКонфигуратора.ЗапуститьВРежимеПредприятияСПроверкойВыполнения(
		ДопСообщения,
		КлючЗапуска, ПутьКИнструментам,
		ТолстыйКлиент, ДополнительныеКлючи, ОжидатьЗавершения,
		ПутьЛогаВыполненияСценариев, ПутьКФайлуСтатусаВыполнения);

	Лог.Информация("Тестирование поведения завершено");

КонецПроцедуры

#КонецОбласти
