
#Использовать json
#Использовать fs

Перем КэшМетаданных;

// СформироватьОтчетВФорматеJUnit
//	Создает отчет об ошибках в формате JUnit
// Параметры:
//   РезультатТестирования - Структура - Набор параметров результата тестирования
//   ПутьОтчетаВФорматеJUnitxml - Строка - Путь к создаваемому файлу отчета
//   РасширениеНабора - Строка - Базовая часть набора тестов
//
Процедура СформироватьОтчетВФорматеJUnit(РезультатТестирования, ПутьОтчетаВФорматеJUnitxml, РасширениеНабора = "") Экспорт

	ПредставлениеНабораТестов = "CheckConfig";
	Если ЗначениеЗаполнено(РасширениеНабора) Тогда

		ПредставлениеНабораТестов = СтрШаблон("%2.%1", РасширениеНабора, ПредставлениеНабораТестов);

	КонецЕсли;

	ПредставлениеНабораТестовXML = XMLСтрока(ПредставлениеНабораТестов);

	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку("UTF-8");
	ЗаписьXML.ЗаписатьОбъявлениеXML();

	ВремяВыполнения = ТекущаяДата() - РезультатТестирования.ДатаНачала;

	ЗаписьXML.ЗаписатьНачалоЭлемента("testsuites");
	ЗаписьXML.ЗаписатьАтрибут("name", ПредставлениеНабораТестовXML);

	КоличествоТестов = РезультатТестирования.КоличествоПроверок;
	Если КоличествоТестов = 0 Тогда
		КоличествоТестов = 1;
	КонецЕсли;

	ЗаписьXML.ЗаписатьАтрибут("tests", XMLСтрока(КоличествоТестов));
	ЗаписьXML.ЗаписатьАтрибут("failures", XMLСтрока(РезультатТестирования.КоличествоУпало));
	ЗаписьXML.ЗаписатьАтрибут("skipped", XMLСтрока(РезультатТестирования.КоличествоПропущено));
	ЗаписьXML.ЗаписатьАтрибут("time", XMLСтрока(ВремяВыполнения));

	ЗаписьXML.ЗаписатьНачалоЭлемента("testsuite");
	ЗаписьXML.ЗаписатьАтрибут("name", ПредставлениеНабораТестовXML);
	ЗаписьXML.ЗаписатьНачалоЭлемента("properties");
	ЗаписьXML.ЗаписатьКонецЭлемента(); // properties

	Если НЕ РезультатТестирования.Ошибки.Количество() Тогда

		ЗаписьXML.ЗаписатьНачалоЭлемента("testcase");
		ЗаписьXML.ЗаписатьАтрибут("classname", ПредставлениеНабораТестовXML);
		ЗаписьXML.ЗаписатьАтрибут("name", XMLСтрока("Все сообщения"));
		ЗаписьXML.ЗаписатьАтрибут("time", XMLСтрока(ВремяВыполнения));
		Если РезультатТестирования.КоличествоУпало = 0 Тогда

			ЗаписьXML.ЗаписатьАтрибут("status", "passed");

		Иначе

			ЗаписьXML.ЗаписатьАтрибут("status", "failure");

		КонецЕсли;

		Если НЕ ПустаяСтрока(РезультатТестирования.ВсеОшибки) Тогда

			ЗаписьXML.ЗаписатьНачалоЭлемента("failure");
			ЗаписьXML.ЗаписатьАтрибут("message", XMLСтрока(РезультатТестирования.ВсеОшибки));
			ЗаписьXML.ЗаписатьКонецЭлемента(); // failure

		КонецЕсли;

	Иначе

		Для Каждого ГруппыОбъектов Из РезультатТестирования.Ошибки Цикл

			Для Каждого ГруппыТипов Из ГруппыОбъектов.Значение Цикл

				ЗаписьXML.ЗаписатьНачалоЭлемента("testcase");
				ЗаписьXML.ЗаписатьАтрибут("classname", СтрШаблон("%1.%2", ПредставлениеНабораТестовXML, ГруппыТипов.Ключ));
				ЗаписьXML.ЗаписатьАтрибут("name", XMLСтрока(ГруппыОбъектов.Ключ));
				ТекстОшибки = "";
				Для Каждого ТестовыйСлучай Из ГруппыТипов.Значение Цикл
					ТекстОшибки = ТекстОшибки + ?(ПустаяСтрока(ТекстОшибки), "", Символы.ПС)
					+ ?(ЗначениеЗаполнено(ТестовыйСлучай.НомерСтроки), "Строка " + ТестовыйСлучай.НомерСтроки + ": ", "") + ТестовыйСлучай.ТекстОшибки;
				КонецЦикла;

				Если ГруппыТипов.Ключ = "Пропущено" Тогда

					ЗаписьXML.ЗаписатьНачалоЭлемента("skipped");
					ЗаписьXML.ЗаписатьКонецЭлемента();
					ЗаписьXML.ЗаписатьНачалоЭлемента("system-out");
					ЗаписьXML.ЗаписатьТекст(XMLСтрока(ТекстОшибки));
					ЗаписьXML.ЗаписатьКонецЭлемента();

				Иначе

					ЗаписьXML.ЗаписатьНачалоЭлемента("failure");
					Если ГруппыТипов.Ключ = "Ошибка" Тогда

						ЗаписьXML.ЗаписатьАтрибут("type", "ERROR");

					Иначе

						ЗаписьXML.ЗаписатьАтрибут("type", "WARNING");

					КонецЕсли;

					ЗаписьXML.ЗаписатьАтрибут("message", XMLСтрока(ТекстОшибки));
					ЗаписьXML.ЗаписатьКонецЭлемента(); // failure

				КонецЕсли;

				ЗаписьXML.ЗаписатьКонецЭлемента();

			КонецЦикла;

		КонецЦикла;

	КонецЕсли;

	ЗаписьXML.ЗаписатьКонецЭлемента(); // testsuite
	ЗаписьXML.ЗаписатьКонецЭлемента(); // testsuites

	СтрокаХМЛ = ЗаписьXML.Закрыть();

	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.ОткрытьФайл(ПутьОтчетаВФорматеJUnitxml);
	ЗаписьXML.ЗаписатьБезОбработки(СтрокаХМЛ); // таким образом файл будет записан всего один раз, и не будет проблем с обработкой на билд-сервере TeamCity
	ЗаписьXML.Закрыть();

КонецПроцедуры

// СформироватьОтчетВФорматеAllure
//	Создает отчет об ошибках в формате Allure
// Параметры:
//   ДатаНачала - ДатаВремя - Дата начала формирования отчета
//   РезультатТестирования - Структура - Набор параметров результата тестирования
//   КаталогОтчетовAllure - Строка - Путь к каталогу отчетов
//   РасширениеНабора - Строка - Базовая часть набора тестов
//
Процедура СформироватьОтчетВФорматеAllure(ДатаНачала, РезультатТестирования, КаталогОтчетовAllure, РасширениеНабора = "") Экспорт

	Если НЕ РезультатТестирования.Ошибки.Количество() Тогда

		Возврат;

	КонецЕсли;

	ФС.ОбеспечитьПустойКаталог(КаталогОтчетовAllure);

	ВремяСтарта = РезультатТестирования.ДатаНачала;
	ВремяОкончания = ТекущаяДата();

	ПредставлениеНабораТестов = "Синтаксическая проверка конфигурации";
	Если ЗначениеЗаполнено(РасширениеНабора) Тогда

		ПредставлениеНабораТестов = СтрШаблон("%2. %1", РасширениеНабора, ПредставлениеНабораТестов);

	КонецЕсли;

	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку("UTF-8");
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	ЗаписьXML.ЗаписатьНачалоЭлемента("test-suite", "");
	ЗаписьXML.ЗаписатьСоответствиеПространстваИмен("", "urn:model.allure.qatools.yandex.ru");
	ЗаписьXML.ЗаписатьСоответствиеПространстваИмен("xs", "http://www.w3.org/2001/XMLSchema");
	ЗаписьXML.ЗаписатьСоответствиеПространстваИмен("xsi", "http://www.w3.org/2001/XMLSchema-instance");
	ЗаписьXML.ЗаписатьНачалоЭлемента("name");
	ЗаписьXML.ЗаписатьТекст(XMLСтрока(ПредставлениеНабораТестов));
	ЗаписьXML.ЗаписатьКонецЭлемента();

	ЗаписьXML.ЗаписатьНачалоЭлемента("test-cases");
	ВажностьНабора = "minor";

	Для Каждого ГруппыОбъектов Из РезультатТестирования.Ошибки Цикл

		Для Каждого ГруппыТипов Из ГруппыОбъектов.Значение Цикл

			ТекстОшибки = "";
			ВажностьТекстКейса = "minor";
			КонтекстыОшибки = Новый Соответствие();
			Для Каждого ТестовыйСлучай Из ГруппыТипов.Значение Цикл

				ТекстОшибки = ТекстОшибки + ?(ПустаяСтрока(ТекстОшибки), "", Символы.ПС)
				+ ?(ЗначениеЗаполнено(ТестовыйСлучай.НомерСтроки), "Строка " + ТестовыйСлучай.НомерСтроки + ": ", "") + ТестовыйСлучай.ТекстОшибки;

				ЗаполнитьКонтекстыОшибки(КонтекстыОшибки, ТестовыйСлучай.ТекстОшибки);

			КонецЦикла;

			ЗаписьXML.ЗаписатьНачалоЭлемента("test-case");
			ЗаписьXML.ЗаписатьАтрибут("start", ДатаВLong(ВремяСтарта));
			ЗаписьXML.ЗаписатьАтрибут("stop", ДатаВLong(ВремяОкончания));

			Статус = "skipped";
			Если ГруппыТипов.Ключ = "Ошибка" Тогда

				Статус = "failed";
				ВажностьНабора = "critical";
				ВажностьТекстКейса = "critical";

			ИначеЕсли ГруппыТипов.Ключ = "Предупреждение" Тогда

				Статус = "broken";

			ИначеЕсли ГруппыТипов.Ключ = "Пропущено" Тогда

				Статус = "skipped";

			ИначеЕсли ГруппыТипов.Ключ = "Исправлено" Тогда

				Статус = "passed";

			КонецЕсли;
			ЗаписьXML.ЗаписатьАтрибут("status", Статус);
			ЗаписьXML.ЗаписатьНачалоЭлемента("name");
			ЗаписьXML.ЗаписатьТекст(XMLСтрока(ГруппыОбъектов.Ключ + "." + ГруппыТипов.Ключ));
			ЗаписьXML.ЗаписатьКонецЭлемента();

			Если Статус = "failed" ИЛИ Статус = "broken" Тогда
				ЗаписьXML.ЗаписатьНачалоЭлемента("failure");
				ЗаписьXML.ЗаписатьНачалоЭлемента("message");
				ЗаписьXML.ЗаписатьТекст(XMLСтрока(ТекстОшибки));
				ЗаписьXML.ЗаписатьКонецЭлемента();
				ЗаписьXML.ЗаписатьКонецЭлемента();
			КонецЕсли;

			ЗаписьXML.ЗаписатьНачалоЭлемента("labels");
			ЗаписьXML.ЗаписатьНачалоЭлемента("label");
			ЗаписьXML.ЗаписатьАтрибут("name", "package");
			ЗаписьXML.ЗаписатьАтрибут("value", XMLСтрока(ГруппыОбъектов.Ключ));
			ЗаписьXML.ЗаписатьКонецЭлемента();

			Для Каждого КонтекстОшибки Из КонтекстыОшибки Цикл
				ЗаписьXML.ЗаписатьНачалоЭлемента("label");
				ЗаписьXML.ЗаписатьАтрибут("name", "tag");
				ЗаписьXML.ЗаписатьАтрибут("value", КонтекстОшибки.Ключ);
				ЗаписьXML.ЗаписатьКонецЭлемента();
			КонецЦикла;

			Для Каждого ТестовыйСлучай Из ГруппыТипов.Значение Цикл

				ЗаписьXML.ЗаписатьНачалоЭлемента("label");
				ЗаписьXML.ЗаписатьАтрибут("name", "story");
				ЗаписьXML.ЗаписатьАтрибут("value", XMLСтрока(ОписаниеФункциональности(ТестовыйСлучай.ТекстОшибки)));
				ЗаписьXML.ЗаписатьКонецЭлемента();

			КонецЦикла;

			ЗаписьXML.ЗаписатьНачалоЭлемента("label");
			ЗаписьXML.ЗаписатьАтрибут("name", "severity");
			ЗаписьXML.ЗаписатьАтрибут("value", ВажностьТекстКейса);
			ЗаписьXML.ЗаписатьКонецЭлемента();
			ЗаписьXML.ЗаписатьКонецЭлемента();
			ЗаписьXML.ЗаписатьКонецЭлемента();

		КонецЦикла;

	КонецЦикла;

	ЗаписьXML.ЗаписатьКонецЭлемента();
	ЗаписьXML.ЗаписатьНачалоЭлемента("labels");
	ЗаписьXML.ЗаписатьНачалоЭлемента("label");
	ЗаписьXML.ЗаписатьАтрибут("name", "severity");
	ЗаписьXML.ЗаписатьАтрибут("value", ВажностьНабора);
	ЗаписьXML.ЗаписатьКонецЭлемента();
	ЗаписьXML.ЗаписатьКонецЭлемента();

	РеальноеИмяФайла = ОбъединитьПути(КаталогОтчетовAllure, "" + (Новый УникальныйИдентификатор()) + "-testsuite.xml");

	СтрокаХМЛ = ЗаписьXML.Закрыть();
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.УстановитьТекст(СтрокаХМЛ);
	ТекстовыйДокумент.Записать(РеальноеИмяФайла, КодировкаТекста.UTF8NoBOM);

КонецПроцедуры

// СформироватьОтчетВФорматеAllure2
//	Создает отчет об ошибках в формате Allure2
// Параметры:
//   ДатаНачала - ДатаВремя - Дата начала формирования отчета
//   РезультатТестирования - Структура - Набор параметров результата тестирования
//   КаталогОтчетовAllure - Строка - Путь к каталогу отчетов
//   РасширениеНабора - Строка - Базовая часть набора тестов
//   ПутьКФайламПроекта - Строка - Путь к файлам проекта в репозитории для генерации ссылок для перехода к строке
//			Пример: https://github.com/1C-Company/GitConverter/tree/master/GitConverter/src
//
Процедура СформироватьОтчетВФорматеAllure2(ДатаНачала, РезультатТестирования, КаталогОтчетовAllure, РасширениеНабора = "", ПутьКФайламПроекта = "") Экспорт

	Если НЕ РезультатТестирования.Ошибки.Количество() Тогда

		Возврат;

	КонецЕсли;

	ФС.ОбеспечитьПустойКаталог(КаталогОтчетовAllure);

	ПарсерJSON  = Новый ПарсерJSON();
	ВремяСтарта = РезультатТестирования.ДатаНачала;
	Если ЗначениеЗаполнено(ВремяСтарта) Тогда
		ВремяОкончания = ТекущаяУниверсальнаяДата(); // UTC
	Иначе
		ВремяОкончания = Неопределено;
	КонецЕсли;

	Если РазделитьВремя И РезультатТестирования.КоличествоПроверок <> 0 Тогда
		ВремяВыполнения = Окр((ВремяОкончания - ВремяСтарта) * 1000 / РезультатТестирования.КоличествоПроверок);
	КонецЕсли;

	Для Каждого ГруппыОбъектов Из РезультатТестирования.Ошибки Цикл

		Для Каждого ГруппыТипов Из ГруппыОбъектов.Значение Цикл

			Для Каждого ТестовыйСлучай Из ГруппыТипов.Значение Цикл

				ОписаниеФункциональности = ОписаниеФункциональности(ТестовыйСлучай.ТекстОшибки);
				ОписаниеСценария = ПолучитьОписаниеСценарияАллюр2();
				ОписаниеСценария.name = ГруппыОбъектов.Ключ + ". "
										+ ?(ЗначениеЗаполнено(ТестовыйСлучай.НомерСтроки), "" + ТестовыйСлучай.НомерСтроки + ": ", "")
										+ ОписаниеФункциональности;
				ОписаниеСценария.fullName = ОписаниеСценария.name;
				ОписаниеСценария.historyId = ОписаниеСценария.name;
				
				Если ЗначениеЗаполнено(ВремяСтарта) Тогда
					ОписаниеСценария.start = ДатаВLong(ВремяСтарта);
				КонецЕсли;

				Если РазделитьВремя Тогда
					ВремяОкончания = ДатаВLong(ВремяСтарта) + ВремяВыполнения;
					ВремяСтарта = ВремяОкончания;
				КонецЕсли;

				Если ЗначениеЗаполнено(ВремяОкончания) Тогда
					ОписаниеСценария.stop = ДатаВLong(ВремяОкончания);
				КонецЕсли;
				
				ОписаниеСценария.description = ?(ЗначениеЗаполнено(ТестовыйСлучай.НомерСтроки), "Строка " + ТестовыйСлучай.НомерСтроки + ": ", "")
													+ ТестовыйСлучай.ТекстОшибки;

				Если ГруппыТипов.Ключ = "Ошибка" Тогда

					ОписаниеСценария.status = "failed";

				ИначеЕсли ГруппыТипов.Ключ = "Предупреждение" Тогда

					ОписаниеСценария.status = "broken";

				ИначеЕсли ГруппыТипов.Ключ = "Пропущено" Тогда

					ОписаниеСценария.status = "skipped";

				ИначеЕсли ГруппыТипов.Ключ = "Исправлено" Тогда

					ОписаниеСценария.status = "passed";

				КонецЕсли;

				ОписаниеСценария.labels.Добавить(Новый Структура("name, value", "package", ГруппыОбъектов.Ключ));
				ОписаниеСценария.labels.Добавить(Новый Структура("name, value", "story", ОписаниеФункциональности));

				КонтекстыОшибки = Новый Соответствие();
				ЗаполнитьКонтекстыОшибки(КонтекстыОшибки, ТестовыйСлучай.ТекстОшибки);
				Для Каждого КонтекстОшибки Из КонтекстыОшибки Цикл

					ОписаниеСценария.labels.Добавить(Новый Структура("name, value", "tag", КонтекстОшибки.Ключ));

				КонецЦикла;

				СсылкаНаСтрокуИсходников = ПолучитьСсылкуНаСтрокуИсходников(ГруппыОбъектов.Ключ, ТестовыйСлучай.НомерСтроки, ПутьКФайламПроекта);

				Если ЗначениеЗаполнено(СсылкаНаСтрокуИсходников) Тогда

					ОписаниеСсылки = Новый Структура("name, url, type");
					ОписаниеСсылки.name = "Перейти на строку с ошибкой";
					ОписаниеСсылки.url = СсылкаНаСтрокуИсходников;
					ОписаниеСсылки.type = "";

					ОписаниеСценария.links.Добавить(ОписаниеСсылки);

				КонецЕсли;

				РеальноеИмяФайла = ОбъединитьПути(КаталогОтчетовAllure, "" + ОписаниеСценария.uuid + "-result.json" );

				ТекстовыйДокумент = Новый ТекстовыйДокумент;
				ТекстовыйДокумент.УстановитьТекст(ПарсерJSON.ЗаписатьJSON(ОписаниеСценария));
				ТекстовыйДокумент.Записать(РеальноеИмяФайла, КодировкаТекста.UTF8NoBOM);

			КонецЦикла;

		КонецЦикла;

	КонецЦикла;

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////////////////////

Процедура ЗаполнитьКонтекстыОшибки(КонтекстыОшибки, Знач ОписаниеОшибки)

	ПозНачалоКонфигуратор = СтрНайти(ОписаниеОшибки, " (Проверка");
	ПозНачалоEDT = СтрНайти(ОписаниеОшибки, "[");

	Если ПозНачалоКонфигуратор Тогда // Формат конфигуратора

		ТекстОшибки = Сред(ОписаниеОшибки, ПозНачалоКонфигуратор);

		Если СтрНайти(ТекстОшибки, "Проверка толстого клиента (обычное приложение)") Тогда

			КонтекстыОшибки.Вставить("Толстый клиент (обычное приложение)");

		ИначеЕсли СтрНайти(ТекстОшибки, "Проверка: Веб-клиент") Тогда

			КонтекстыОшибки.Вставить("Web-клиент");

		ИначеЕсли СтрНайти(ТекстОшибки, "Проверка: Тонкий клиент") Тогда

			КонтекстыОшибки.Вставить("Тонкий клиент");

		ИначеЕсли СтрНайти(ТекстОшибки, "Проверка: Внешнее соединение ") Тогда

			КонтекстыОшибки.Вставить("Внешнее соединение");

		ИначеЕсли СтрНайти(ТекстОшибки, "Проверка: Толстый клиент ") Тогда

			КонтекстыОшибки.Вставить("Толстый клиент (управляемое приложение)");

		КонецЕсли;

	ИначеЕсли ПозНачалоEDT Тогда

		ПозКонецEDT = СтрНайти(ОписаниеОшибки, "]", НаправлениеПоиска.СКонца);
		Если ПозКонецEDT > ПозНачалоEDT Тогда

			КонтекстИсполнения = Сред(ОписаниеОшибки, ПозНачалоEDT + 1, ПозКонецEDT - ПозНачалоEDT - 1);

			Если СтрНайти(КонтекстИсполнения, "Внешнее соединение") Тогда

				КонтекстыОшибки.Вставить("Внешнее соединение");

			КонецЕсли;

			Если СтрНайти(КонтекстИсполнения, "Сервер,") Тогда

				КонтекстыОшибки.Вставить("Сервер");

			КонецЕсли;

			Если СтрНайти(КонтекстИсполнения, "Тонкий клиент") Тогда

				КонтекстыОшибки.Вставить("Тонкий клиент");

			КонецЕсли;

			Если СтрНайти(КонтекстИсполнения, "Толстый клиент (управляемое приложение)") Тогда

				КонтекстыОшибки.Вставить("Толстый клиент (управляемое приложение)");

			КонецЕсли;

			Если СтрНайти(КонтекстИсполнения, "Web-клиент") Тогда

				КонтекстыОшибки.Вставить("Web-клиент");

			КонецЕсли;

			Если СтрНайти(КонтекстИсполнения, "Толстый клиент (обычное приложение)") Тогда

				КонтекстыОшибки.Вставить("Толстый клиент (обычное приложение)");

			КонецЕсли;

		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

Функция ДатаВLong(ИсходнаяДата)

	Если ТипЗнч(ИсходнаяДата) = Тип("Дата") Тогда

		Возврат Окр((ИсходнаяДата - Дата(1970, 1, 1)) * 1000); // Unix-time

	Иначе // уже число

		Возврат ИсходнаяДата;

	КонецЕсли;

КонецФункции

Функция ПолучитьОписаниеСценарияАллюр2()

	СтруктураРезультата = Новый Структура();
	СтруктураРезультата.Вставить("uuid", Строка(Новый УникальныйИдентификатор()));
	СтруктураРезультата.Вставить("historyId", Неопределено);
	СтруктураРезультата.Вставить("name", Неопределено);
	СтруктураРезультата.Вставить("fullName", Неопределено);
	СтруктураРезультата.Вставить("start", Неопределено);
	СтруктураРезультата.Вставить("stop", Неопределено);
	СтруктураРезультата.Вставить("statusDetails", Новый Структура("known, muted,flaky", Ложь, Ложь, Ложь));
	СтруктураРезультата.Вставить("status", Неопределено);
	СтруктураРезультата.Вставить("stage", "finished");
	СтруктураРезультата.Вставить("steps", Новый Массив);
	СтруктураРезультата.Вставить("parameters", Новый Массив);
	СтруктураРезультата.Вставить("labels", Новый Массив);
	СтруктураРезультата.Вставить("links", Новый Массив);
	СтруктураРезультата.Вставить("attachments", Новый Массив);
	СтруктураРезультата.Вставить("description", Неопределено);

	Возврат СтруктураРезультата;

КонецФункции

Функция ОписаниеФункциональности(Знач ОписаниеОшибки)

	ПозНачалоКонфигуратор = СтрНайти(ОписаниеОшибки, " (Проверка");
	ПозНачалоEDT = СтрНайти(ОписаниеОшибки, "[");

	Если ПозНачалоКонфигуратор Тогда // Формат конфигуратора

		ОписаниеОшибки = Лев(ОписаниеОшибки, ПозНачалоКонфигуратор - 1);

	ИначеЕсли ПозНачалоEDT Тогда

		ОписаниеОшибки = Лев(ОписаниеОшибки, ПозНачалоEDT - 1);

	КонецЕсли;

	ПозТаб = СтрНайти(ОписаниеОшибки, "#>");
	Если ПозТаб Тогда
		ОписаниеОшибки = Лев(ОписаниеОшибки, ПозТаб - 1);
	КонецЕсли;

	ЗаменитьПараметрыМетода(ОписаниеОшибки, "(", ")");
	ЗаменитьПараметрыМетода(ОписаниеОшибки, """");
	ЗаменитьПараметрыМетода(ОписаниеОшибки, "'");
	ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, " <> ", " ");
	ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "(<>)", "");
	ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, " <>", "");
	ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "  ", " ");
	ОписаниеОшибки = СокрЛП(ОписаниеОшибки);

	Если СтрЗаканчиваетсяНа(ОписаниеОшибки, ":") Тогда
		ОписаниеОшибки = Лев(ОписаниеОшибки, СтрДлина(ОписаниеОшибки) - 1);
	КонецЕсли;

	Если СтрНайти(ОписаниеОшибки, "Отсутствует обработчик") Тогда
		// Группировка для замечаний: Отсутствует обработчик: "ИмяОбработчика"
		ОписаниеОшибки = "Отсутствует обработчик";
	КонецЕсли;

	Возврат СокрЛП(ОписаниеОшибки);

КонецФункции

Процедура ЗаменитьПараметрыМетода(ОписаниеОшибки, РазделительНачало, РазделительКонец = "")

	Если РазделительКонец = "" Тогда
		РазделительКонец = РазделительНачало;
	КонецЕсли;

	ПозицияКавычки = СтрНайти(ОписаниеОшибки, РазделительНачало);
	Если ПозицияКавычки = 0 Тогда
		Возврат;
	КонецЕсли;

	Пока ПозицияКавычки > 0 Цикл

		ПозицияЗакрывающейКавычки = СтрНайти(Сред(ОписаниеОшибки, ПозицияКавычки + 1), РазделительКонец) + ПозицияКавычки;

		Если ПозицияЗакрывающейКавычки = 0 Тогда

			Прервать;

		КонецЕсли;

		ОписаниеОшибки = Лев(ОписаниеОшибки, ПозицияКавычки - 1) + "<>" + Сред(ОписаниеОшибки, ПозицияЗакрывающейКавычки + 1);
		ПозицияКавычки = СтрНайти(ОписаниеОшибки, РазделительНачало);

	КонецЦикла;

	ЗаменитьПараметрыМетода(ОписаниеОшибки, РазделительНачало, РазделительКонец);

КонецПроцедуры

Функция ПолучитьСсылкуНаСтрокуИсходников(Знач МетаданныеОбъекта, Знач НомерСтроки, Знач ПутьКФайламПроекта)

	Если Не ЗначениеЗаполнено(ПутьКФайламПроекта) Тогда

		Возврат "";

	КонецЕсли;

	Если Не ЗначениеЗаполнено(НомерСтроки) Тогда

		Возврат "";

	КонецЕсли;

	СоставМетаданных = СтрРазделить(МетаданныеОбъекта, ".");

	Если СоставМетаданных.Количество() = 0 Тогда

		Возврат "";

	КонецЕсли;

	Если СоставМетаданных.Количество() < 3 Тогда

		Возврат "";

	КонецЕсли;

	СоставСсылки = Новый Массив;
	СоставСсылки.Добавить(ПутьКФайламПроекта);

	КаталогМетаданных = ПолучитьКаталогПоИмениМетаданных(СоставМетаданных[0]);
	Если НЕ ЗначениеЗаполнено(КаталогМетаданных) Тогда

		Возврат "";

	КонецЕсли;

	СоставСсылки.Добавить(КаталогМетаданных);
	СоставСсылки.Добавить(СоставМетаданных[1]); // имя
	ИмяФайла = ПолучитьИмяФайлаПоИмениМодуля(СоставМетаданных[2]);

	Если ЗначениеЗаполнено(ИмяФайла) Тогда

		СоставСсылки.Добавить(ИмяФайла);

	ИначеЕсли СоставМетаданных.Количество() > 3 Тогда

		Если СтрСравнить(СоставМетаданных[2], "Форма") = 0 Тогда

			СоставСсылки.Добавить("Forms");
			СоставСсылки.Добавить(СоставМетаданных[3]);

			Если СоставМетаданных.Количество() > 5
				И СтрСравнить(СоставМетаданных[4], "Форма") = 0
				И СтрСравнить(СоставМетаданных[5], "Модуль") = 0 Тогда

				СоставСсылки.Добавить("Module.bsl");

			КонецЕсли;

		ИначеЕсли СтрСравнить(СоставМетаданных[2], "Команда") = 0 Тогда

			СоставСсылки.Добавить("Commands");
			СоставСсылки.Добавить(СоставМетаданных[3]);

			Если СоставМетаданных.Количество() > 4
				И СтрСравнить(СоставМетаданных[4], "МодульКоманды") = 0 Тогда

				СоставСсылки.Добавить("CommandModule.bsl");

			КонецЕсли;

		КонецЕсли;

	КонецЕсли;

	Возврат СтрСоединить(СоставСсылки, "/") + "#L" + НомерСтроки;

КонецФункции

Функция ПолучитьКаталогПоИмениМетаданных(ИмяОбъекта)

	Если КэшМетаданных = Неопределено Тогда
		КэшМетаданных = Новый Соответствие();
	КонецЕсли;

	КэшКаталогов = КэшМетаданных.Получить("КэшКаталогов");
	Если КэшКаталогов = Неопределено Тогда

		КэшКаталогов = Новый Соответствие();
		КэшКаталогов.Вставить("РегистрБухгалтерии", "AccountingRegisters");
		КэшКаталогов.Вставить("РегистрНакопления", "AccumulationRegisters");
		КэшКаталогов.Вставить("БизнесПроцесс", "BusinessProcesses");
		КэшКаталогов.Вставить("РегистрРасчета", "CalculationRegisters");
		КэшКаталогов.Вставить("Справочник", "Catalogs");
		КэшКаталогов.Вставить("ПланСчетов", "ChartsOfAccounts");
		КэшКаталогов.Вставить("ПланВидовРасчета", "ChartsOfCalculationTypes");
		КэшКаталогов.Вставить("ПланВидовХарактеристик", "ChartsOfCharacteristicTypes");
		КэшКаталогов.Вставить("ОбщаяГруппа", "CommandGroups");
		КэшКаталогов.Вставить("ОбщийРеквизит", "CommonAttributes");
		КэшКаталогов.Вставить("ОбщаяКоманда", "CommonCommands");
		КэшКаталогов.Вставить("ОбщаяФорма", "CommonForms");
		КэшКаталогов.Вставить("ОбщийМодуль", "CommonModules");
		КэшКаталогов.Вставить("ОбщаяКартинка", "CommonPictures");
		КэшКаталогов.Вставить("ОбщийМакет", "CommonTemplates");
		КэшКаталогов.Вставить("Константа", "Constants");
		КэшКаталогов.Вставить("Обработка", "DataProcessors");
		КэшКаталогов.Вставить("ОпределяемыйТип", "DefinedTypes");
		КэшКаталогов.Вставить("ЖурналДокумента", "DocumentJournals");
		КэшКаталогов.Вставить("Нумератор", "DocumentNumerators");
		КэшКаталогов.Вставить("Документ", "Documents");
		КэшКаталогов.Вставить("Перечисление", "Enums");
		КэшКаталогов.Вставить("ПодпискаНаСобытие", "EventSubscriptions");
		КэшКаталогов.Вставить("ПланОбмена", "ExchangePlans");
		КэшКаталогов.Вставить("ВнешнийИсточник", "ExternalDataSources");
		КэшКаталогов.Вставить("КритерийОтбора", "FilterCriteria");
		КэшКаталогов.Вставить("ФункциональнаяОпция", "FunctionalOptions");
		КэшКаталогов.Вставить("ПарамертФункциональыхОпций", "FunctionalOptionsParameters");
		КэшКаталогов.Вставить("HTTPСервис", "HTTPServices");
		КэшКаталогов.Вставить("РегистрСведений", "InformationRegisters");
		КэшКаталогов.Вставить("Язык", "Languages");
		КэшКаталогов.Вставить("Отчет", "Reports");
		КэшКаталогов.Вставить("Роль", "Roles");
		КэшКаталогов.Вставить("РегламентноеЗадание", "ScheduledJobs");
		КэшКаталогов.Вставить("Последовательность", "Sequences");
		КэшКаталогов.Вставить("ПарамертСеанса", "SessionParameters");
		КэшКаталогов.Вставить("ХранилищеНастроек", "SettingsStorages");
		КэшКаталогов.Вставить("ЭлементСтиля", "StyleItems");
		КэшКаталогов.Вставить("Подсистема", "Subsystems");
		КэшКаталогов.Вставить("Задача", "Tasks");
		КэшКаталогов.Вставить("WebСервис", "WebServices");
		КэшКаталогов.Вставить("XDTOПакет", "XDTOPackages");

		КэшМетаданных.Вставить("КэшКаталогов", КэшКаталогов);

	КонецЕсли;

	Возврат КэшКаталогов.Получить(ИмяОбъекта);

КонецФункции

Функция ПолучитьИмяФайлаПоИмениМодуля(ИмяМодуля)

	Если КэшМетаданных = Неопределено Тогда
		КэшМетаданных = Новый Соответствие();
	КонецЕсли;

	КэшМодулей = КэшМетаданных.Получить("КэшМодулей");
	Если КэшМодулей = Неопределено Тогда

		КэшМодулей = Новый Соответствие();
		КэшМодулей.Вставить("МодульОбъекта", "ObjectModule.bsl");
		КэшМодулей.Вставить("Модуль", "Module.bsl");
		КэшМодулей.Вставить("МодульМенеджера", "ManagerModule.bsl");
		КэшМодулей.Вставить("МодульНабораЗаписей", "RecordSetModule.bsl");
		КэшМодулей.Вставить("МодульКоманды", "CommandModule.bsl");

	КонецЕсли;

	Возврат КэшМодулей.Получить(ИмяМодуля);

КонецФункции
