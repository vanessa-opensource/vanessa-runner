#Использовать asserts
#Использовать logos
#Использовать tempfiles
#Использовать fs
#Использовать json
#Использовать ParserFileV8i

Перем Лог;

// Функция запускает отдельный процесс системы и дожидается его выполнения.
//	Параметры:
//		СтрокаВыполнения - Строка - строка для выполнения.
//
//	Возвращаемое значение:
//		Текст - текст со стандартным выводом процесса.
Функция ЗапуститьПроцесс(Знач СтрокаВыполнения) Экспорт
	Перем ПаузаОжиданияЧтенияБуфера;

	ПаузаОжиданияЧтенияБуфера = 10;

	Лог = ПолучитьЛог();
	Лог.Отладка(СтрокаВыполнения);
	Процесс = СоздатьПроцесс(СтрокаВыполнения, , Истина);
	Процесс.Запустить();

	ТекстБазовый = "";
	Счетчик = 0;
	МаксСчетчикЦикла = 100000;

	Пока Истина Цикл
		Текст = Процесс.ПотокВывода.Прочитать();
		Лог.Отладка("Цикл ПотокаВывода " + Текст);
		Если Текст = Неопределено ИЛИ ПустаяСтрока(СокрЛП(Текст))  Тогда
			Прервать;
		КонецЕсли;
		Счетчик = Счетчик + 1;
		Если Счетчик > МаксСчетчикЦикла Тогда
			Прервать;
		КонецЕсли;
		ТекстБазовый = ТекстБазовый + Текст;

		sleep(ПаузаОжиданияЧтенияБуфера); // Подождем, надеюсь буфер не переполнится.

	КонецЦикла;

	Процесс.ОжидатьЗавершения();

	Если Процесс.КодВозврата = 0 Тогда
		Текст = Процесс.ПотокВывода.Прочитать();
		Если Текст <> Неопределено И Не ПустаяСтрока(Текст) Тогда
			ТекстБазовый = ТекстБазовый + Текст;
		КонецЕсли;
		Лог.Отладка(ТекстБазовый);
		Возврат ТекстБазовый;
	Иначе
		ВызватьИсключение "Сообщение от процесса
		| код:" + Процесс.КодВозврата + " процесс: " + Процесс.ПотокОшибок.Прочитать();
	КонецЕсли;

КонецФункции

// Читает текстовый файл по переданному пути, обертка для проверки существования файла.
//	Параметры:
//		ПутьКФайлу - Строка - путь к файлу для чтения.
//	Возвращаемое значение:
//		Строка - строка, с содержимым файла.
Функция ПрочитатьФайлИнформации(Знач ПутьКФайлу) Экспорт

	Текст = "";
	Файл = Новый Файл(ПутьКФайлу);
	Если Файл.Существует() Тогда
		Текст  = ПрочитатьФайл(ПутьКФайлу, КодировкаТекста.ANSI);
	Иначе
		Текст = "Не найден файл статуса " + ПутьКФайлу;
	КонецЕсли;

	Лог = ПолучитьЛог();
	Лог.Отладка("файл статуса:
	|<" + Текст + ">");
	Возврат Текст;

КонецФункции

Процедура ЗаполнитьЗначенияИзПеременныхОкружения(ЗначенияПараметров, Знач СоответствиеПеременных) Экспорт
	ПолучитьЛог();

	Для каждого Элемент Из СоответствиеПеременных Цикл
		ЗначениеПеременной = ПолучитьПеременнуюСреды(ВРег(Элемент.Ключ));
		Если ЗначениеПеременной <> Неопределено Тогда
			Если ЗначениеПеременной = """""" Или ЗначениеПеременной = "''" Тогда
				ЗначениеПеременной = "";
			КонецЕсли;
			ЗначенияПараметров.Вставить(Элемент.Значение, ЗначениеПеременной);

			Лог.Отладка("Из переменных среды получен параметр: <%1> = <%2>", Элемент.Значение, ЗначениеПеременной);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

// Возвращает стандартное имя файла настроек - "env.json"
//
//  Возвращаемое значение:
//   Строка - "env.json"
//
Функция ИмяФайлаНастроек() Экспорт
	Возврат "env.json";
КонецФункции

Процедура ДополнитьАргументыИзФайлаНастроек(Знач Команда, ЗначенияПараметров, Знач НастройкиИзФайла) Экспорт
	Перем КлючПоУмолчанию;
	КлючПоУмолчанию = "default";

	ДополнитьСоответствиеСУчетомПриоритета(ЗначенияПараметров, НастройкиИзФайла.Получить(Команда));
	ДополнитьСоответствиеСУчетомПриоритета(ЗначенияПараметров, НастройкиИзФайла.Получить(КлючПоУмолчанию));

	ПолучитьЛог();
	Для каждого Элемент Из ЗначенияПараметров Цикл
		Лог.Отладка("Получен параметр <%1> = <%2>", Элемент.Ключ, Элемент.Значение);
	КонецЦикла;

КонецПроцедуры // ДополнитьАргументыИзФайлаНастроек

Процедура ДополнитьСоответствиеСУчетомПриоритета(КоллекцияОсновная, Знач КоллекцияДоп) Экспорт
	Если КоллекцияДоп = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Для Каждого Элемент Из КоллекцияДоп Цикл
		Значение = КоллекцияОсновная.Получить(Элемент.Ключ);
		Если Значение = Неопределено Тогда
			КоллекцияОсновная.Вставить(Элемент.Ключ, Элемент.Значение);
		ИначеЕсли ТипЗнч(Значение) = Тип("Булево") И НЕ Значение Тогда
			Если ТипЗнч(Элемент.Значение) = Тип("Строка") Тогда
				Если Элемент.Значение = "1" ИЛИ Нрег(Элемент.Значение) = "истина" ИЛИ Нрег(Элемент.Значение) = "true" Тогда
					КоллекцияОсновная.Вставить(Элемент.Ключ, Истина);
				КонецЕсли;
			ИначеЕсли ТипЗнч(Элемент.Значение) = Тип("Булево") И Элемент.Значение Тогда
				КоллекцияОсновная.Вставить(Элемент.Ключ, Истина);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры // ДополнитьСоответствиеСУчетомПриоритета

Функция ПереопределитьПолныйПутьВСтрокеПодключения(Знач СтрокаПодключения) Экспорт
	ПолучитьЛог().Отладка("СтрокаПодключения %1", СтрокаПодключения);
	Если Лев(СтрокаПодключения, 2) = "/F" Тогда
		ПутьКБазе = УбратьКавычкиВокругПути(Сред(СтрокаПодключения, 3));
		ПутьКБазе = ПолныйПуть(ПутьКБазе);
		СтрокаПодключения = "/F""" + ПутьКБазе + """";
		ПолучитьЛог().Отладка("Дополненная строка подключения %1", СтрокаПодключения);
	КонецЕсли;
	Возврат СтрокаПодключения;
КонецФункции // ПереопределитьПолныйПутьВСтрокеПодключения()

Функция ПрочитатьНастройкиФайлJSON(Знач ТекущийКаталогПроекта, Знач ПутьКФайлу, Знач ПутьФайлаПоУмолчанию ) Экспорт
	ПолучитьЛог();

	Лог.Отладка("Передан путь к файлу настроек <%1>", ПутьКФайлу);
	Если ПутьКФайлу = Неопределено ИЛИ НЕ ЗначениеЗаполнено(ПутьКФайлу) Тогда
		ПутьКФайлу = ПутьФайлаПоУмолчанию;
		Лог.Отладка("Не задан путь к файлу настроек, использую путь по умолчанию " + ПутьКФайлу);
	ИначеЕсли Лев(Строка(ПутьКФайлу), 1) = "." Тогда
		ПутьКФайлу = ОбъединитьПути(ТекущийКаталогПроекта, ПутьКФайлу);
	КонецЕсли;

	Возврат ПрочитатьФайлJSON(ПутьКФайлу);
КонецФункции

Функция ПрочитатьФайлJSON(Знач ИмяФайла) Экспорт
	Лог.Отладка("Читаю настройки из json-файла %1", ИмяФайла);
	ФайлСуществующий = Новый Файл(ИмяФайла);
	Если Не ФайлСуществующий.Существует() Тогда
		Возврат Новый Соответствие;
	КонецЕсли;
	JsonСтрока  = ПрочитатьФайл(ИмяФайла);

	ПарсерJSON  = Новый ПарсерJSON();
	Результат   = ПарсерJSON.ПрочитатьJSON(JsonСтрока);

	Возврат Результат;
КонецФункции

// TODO возможно, лучше просто передавать параметры для инкапсуляции знания об "--ordinaryapp" в одном месте
Функция УказанПараметрТолстыйКлиент(Знач ПараметрТолстыйКлиентИзКоманднойСтроки, Знач Лог) Экспорт
	Если ПараметрТолстыйКлиентИзКоманднойСтроки = Неопределено Тогда
		ЗапускатьТолстыйКлиент = Ложь;
		ОписаниеПараметра = "Не задан параметр --ordinaryapp";
	Иначе
		ЗапускатьТолстыйКлиент = (
			(ТипЗнч(ПараметрТолстыйКлиентИзКоманднойСтроки) = Тип("Булево") И ПараметрТолстыйКлиентИзКоманднойСтроки)
			ИЛИ (СокрЛП(Строка(ПараметрТолстыйКлиентИзКоманднойСтроки)) = "1")
			);
		Если Не ЗапускатьТолстыйКлиент И СокрЛП(Строка(ПараметрТолстыйКлиентИзКоманднойСтроки)) = "-1" Тогда
				ЗапускатьТолстыйКлиент = Неопределено;
		КонецЕсли;
		ОписаниеПараметра = СтрШаблон("Передан параметр --ordinaryapp, равный %1,", ПараметрТолстыйКлиентИзКоманднойСтроки);
	КонецЕсли;

	Лог.Отладка(СтрШаблон("%1 для выбора режима толстого/тонкого клиента", ОписаниеПараметра));
	Если ЗапускатьТолстыйКлиент = Истина Тогда
		Лог.Отладка("Выбран режим запуска - толстый клиент 1С.");
	ИначеЕсли ЗапускатьТолстыйКлиент = Ложь Тогда
		Лог.Отладка("Выбран режим запуска - тонкий клиент 1С.");
	Иначе
		Лог.Отладка("Выбран режим запуска - без указания режима.");
	КонецЕсли;

	Возврат ЗапускатьТолстыйКлиент;
КонецФункции

Функция ПрочитатьФайл(Знач ИмяФайла, Знач Кодировка = Неопределено) Экспорт
	Лог.Отладка("Читаю из файла %1", ИмяФайла);
	Если Не ЗначениеЗаполнено(Кодировка) Тогда
		Кодировка = КодировкаТекста.UTF8;
	КонецЕсли;

	Чтение = Новый ЧтениеТекста(ИмяФайла, Кодировка, , , Ложь);
	Результат  = Чтение.Прочитать();
	Чтение.Закрыть();

	Возврат Результат;
КонецФункции

Функция ПолучитьИмяВременногоФайлаВКаталоге(Знач Каталог, Знач Расширение = "") Экспорт
	ПревКаталог = ВременныеФайлы.БазовыйКаталог;
	ВременныеФайлы.БазовыйКаталог = Каталог;
	ИмяВременногоФайла = ВременныеФайлы.НовоеИмяФайла(Расширение);
	ВременныеФайлы.БазовыйКаталог = ПревКаталог;
	Возврат ИмяВременногоФайла;
КонецФункции

// TODO перенести в библиотеку ФС/fs
Процедура УдалитьФайлЕслиОнСуществует(Знач ПутьФайла) Экспорт
	Ожидаем.Что(ПутьФайла, "УдалитьФайлЕслиОнСуществует: Путь файла должен быть заполнен, а это не так!").Заполнено();

	ПутьФайла = ОбъединитьПути(ТекущийКаталог(), ПутьФайла);
	Файл = Новый Файл(ПутьФайла);
	Если Файл.Существует() Тогда
		УдалитьФайлы(ПутьФайла);
	КонецЕсли;
КонецПроцедуры

Процедура ОбеспечитьПустойКаталог(Знач ФайлОбъектКаталога) Экспорт

	// TODO заменить ОбеспечитьПустойКаталог на ФС.ОбеспечитьПустойКаталог
	ФС.ОбеспечитьПустойКаталог(ФайлОбъектКаталога.ПолноеИмя);

КонецПроцедуры

Функция ОбернутьПутьВКавычки(Знач Путь) Экспорт

	Результат = Путь;
	Если Прав(Результат, 1) = "\" ИЛИ Прав(Результат, 1) = "/" Тогда
		Результат = Лев(Результат, СтрДлина(Результат) - 1);
	КонецЕсли;

	Результат = """" + Результат + """";

	Возврат Результат;

КонецФункции

Функция УбратьКавычкиВокругПути(Знач Путь) Экспорт
	// NOTICE: https://github.com/xDrivenDevelopment/precommit1c
	// Apache 2.0
	ОбработанныйПуть = Путь;

	Если Лев(ОбработанныйПуть, 1) = """" Тогда
		ОбработанныйПуть = Прав(ОбработанныйПуть, СтрДлина(ОбработанныйПуть) - 1);
	КонецЕсли;
	Если Прав(ОбработанныйПуть, 1) = """" Тогда
		ОбработанныйПуть = Лев(ОбработанныйПуть, СтрДлина(ОбработанныйПуть) - 1);
	КонецЕсли;

	Возврат ОбработанныйПуть;

КонецФункции

Функция ПолныйПуть(Знач Путь, Знач КаталогПроекта = "") Экспорт
	Перем ФайлПуть;

	ПолучитьЛог();

	Если ПустаяСтрока(Путь) Тогда
		Возврат Путь;
	КонецЕсли;

	Если ПустаяСтрока(КаталогПроекта) Тогда
		КаталогПроекта = ПараметрыСистемы.КорневойПутьПроекта;
		Лог.Отладка("Использован системный корневой путь проекта - <%1>", КаталогПроекта);
	КонецЕсли;

	Если Лев(Путь, 1) = "." И КаталогПроекта <> Путь Тогда
		Путь = ОбъединитьПути(КаталогПроекта, Путь);
		Лог.Отладка("Нашли абсолютный путь проекта - <%1>", Путь);
	КонецЕсли;

	ФайлПуть = Новый Файл(Путь);

	Возврат ФайлПуть.ПолноеИмя;

КонецФункции // ПолныйПуть()

Функция КаталогПроекта() Экспорт
	ФайлИсточника = Новый Файл(ТекущийСценарий().Источник);
	Возврат ОбъединитьПути(ФайлИсточника.Путь, "..", "..");
КонецФункции

Функция ПолучитьЛог()
	Если Лог = Неопределено Тогда
		Лог = Логирование.ПолучитьЛог(ПараметрыСистемы.ИмяЛогаСистемы());
	КонецЕсли;
	Возврат Лог;
КонецФункции

Функция ТипФайлаПоддерживается(Знач Файл) Экспорт
	Если ПустаяСтрока(Файл.Расширение) Тогда
		Возврат Ложь;
	КонецЕсли;

	Поз = Найти(".epf,.erf,", Файл.Расширение + ",");
	Возврат Поз > 0;

КонецФункции

// Получает одно из значений ключа, которое не Неопределено
//	Параметры:
//		Параметры - Соответствие
//		Ключ1 - Строка - ключ соответствия
//		Ключ2 - Строка - ключ соответствия
//	Возвращаемое значение:
//		Произвольное
//
Функция ПолучитьПараметры(Параметры, Ключ1, Ключ2) Экспорт
	Возврат Параметр(Параметры, Ключ1, Параметры[Ключ2]);
КонецФункции

// Получает значение ключа или значение по умолчанию, если значение ключа = Неопределено
//	Параметры:
//		Параметры - Соответствие
//		Ключ1 - Строка - ключ соответствия
//		ЗначениеПоУмолчанию - ЛюбоеЗначение -
//	Возвращаемое значение:
//		Произвольное
//
Функция Параметр(Параметры, Ключ1, ЗначениеПоУмолчанию) Экспорт
	Возврат ?(Параметры[Ключ1] = Неопределено, ЗначениеПоУмолчанию, Параметры[Ключ1]);
КонецФункции

// Показать параметры командной строки через Лог.Отладка()
//
// Параметры:
//   ПараметрыКоманды - Соответствие - параметры командной строки
//
Процедура ПоказатьПараметрыВРежимеОтладки(Знач ПараметрыКоманды) Экспорт
	Для Каждого КЗ Из ПараметрыКоманды Цикл
		Лог.Отладка(КЗ.Ключ + " = " + КЗ.Значение);
	КонецЦикла;
КонецПроцедуры

// Загрузить библиотеку для использования Ванесса-АДД
//
//  Возвращаемое значение:
//   Сценарий, Неопределено - oscript-библиотека из пакета Ванесса-АДД или Неопределено, если пакет не установлен
//
Функция ЗагрузитьВанессаАДД(Знач ДопТекст = Неопределено) Экспорт
	Попытка
		Возврат ЗагрузитьСценарий(ПутьВанессаАДД());
	Исключение
		Если ЗначениеЗаполнено(ДопТекст) Тогда
			ТекстОшибки = ОписаниеОшибки();
			Если Найти(ТекстОшибки, "System.IO.DirectoryNotFoundException") <> 0
					Или Найти(ТекстОшибки, "System.IO.FileNotFoundException") <> 0 Тогда
				ТекстПредупреждения = "Не установлен пакет Vanessa-ADD.
				|ВАЖНО - %1
				|
				|Установите пакет, выполнив команду opm install add
				|";
				ПолучитьЛог().Предупреждение(ТекстПредупреждения,  ДопТекст);
			КонецЕсли;
		КонецЕсли;
	КонецПопытки;

	Возврат Неопределено;
КонецФункции

Функция ПутьВанессаАДД()
	Результат = ОбъединитьПути(КаталогПрограммы(), "..", "lib");
	Возврат ОбъединитьПути(Результат,  "add", "ospx", "addospx.os");
КонецФункции

Процедура ОбеспечитьСуществованиеКаталогов(Знач НаборПутей, Знач СообщениеОшибки) Экспорт
	ОбеспечитьСуществованиеКаталоговДляПутей(Ложь, НаборПутей, СообщениеОшибки);
КонецПроцедуры

Процедура ОбеспечитьСуществованиеРодительскихКаталоговДляПутей(Знач НаборПутей, Знач СообщениеОшибки) Экспорт
	ОбеспечитьСуществованиеКаталоговДляПутей(Истина, НаборПутей, СообщениеОшибки);
КонецПроцедуры

Процедура ОбеспечитьСуществованиеКаталоговДляПутей(Знач ПроверятьРодителя, Знач НаборПутей, Знач СообщениеОшибки)
	ЕстьОшибка = Ложь;
	Для каждого Путь Из НаборПутей Цикл
		Лог.Отладка("Проверяю путь <%1>", Путь);
		Файл = Новый Файл(Путь);
		Если ПроверятьРодителя Тогда
			НужныйПуть = Файл.Путь;
			Если ПустаяСтрока(НужныйПуть) Тогда
				Возврат;
			КонецЕсли;
		Иначе
			НужныйПуть = Файл.ПолноеИмя;
		КонецЕсли;
		Лог.Отладка("Определили проверяемый путь <%1>", НужныйПуть);
		ОбъектКаталог = Новый Файл(НужныйПуть);

		ФС.ОбеспечитьКаталог(ОбъектКаталог.ПолноеИмя);

		Если Не ОбъектКаталог.Существует() Тогда
			ЕстьОшибка = Истина;
			СообщениеОшибки = СтрШаблон("%1	%2", СообщениеОшибки, ОбъектКаталог.ПолноеИмя);
		КонецЕсли;
	КонецЦикла;
	Если ЕстьОшибка Тогда
		ВызватьИсключение СообщениеОшибки;
	КонецЕсли;
КонецПроцедуры

// Обновить конфигурацию БД с учетом различных режимов реструктуризации
//
// Параметры:
//   МенеджерКонфигуратора - МенеджерКонфигуратора
//   Первый - Булево - включен или нет
//   Второй - Булево - включен или нет
//   ДинамическоеОбновление - Булево - использовать или нет
//
Процедура ОбновитьКонфигурациюБД(МенеджерКонфигуратора, Первый, Второй, ДинамическоеОбновление = Ложь) Экспорт
	РеструктуризацияНаСервере = Первый Или Второй;

	Попытка
		Если РеструктуризацияНаСервере Тогда
			РежимРеструктуризации = Неопределено;
			УправлениеКонфигуратором = Новый УправлениеКонфигуратором();
			РежимыРеструктуризации = УправлениеКонфигуратором.РежимыРеструктуризации();

			Если Второй Тогда
				РежимРеструктуризации = РежимыРеструктуризации.Второй;
			ИначеЕсли Первый Тогда
				РежимРеструктуризации = РежимыРеструктуризации.Первый;
			КонецЕсли;
			МенеджерКонфигуратора.ОбновитьКонфигурациюБазыДанныхНаСервере(РежимРеструктуризации);
		Иначе
			МенеджерКонфигуратора.ОбновитьКонфигурациюБазыДанных(ДинамическоеОбновление);
		КонецЕсли;
	Исключение
		МенеджерКонфигуратора.Деструктор();
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;

КонецПроцедуры

// Дополнить разделителем пути
//
// Параметры:
//   Путь - Строка - путь файла или каталога
//
//  Возвращаемое значение:
//   Строка - путь с разделителем пути в конце строки, если его там не было, иначе сам путь
//
Функция ДополнитьРазделителемПути(Знач Путь) Экспорт
	Если Прав(Путь, 1) <> ПолучитьРазделительПути() Тогда
		Возврат Путь + ПолучитьРазделительПути();
	КонецЕсли;
	Возврат Путь;
КонецФункции

// из-за особенностей загрузки модуль ОбщиеМетоды грузится раньше ПараметрыСистемы,
// поэтому сразу в конце кода модуля использовать ПараметрыСистемы нельзя
