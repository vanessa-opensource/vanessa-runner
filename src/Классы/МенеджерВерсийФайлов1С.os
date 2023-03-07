#Использовать logos
#Использовать fs

#Область ОписаниеПеременных

Перем Лог;

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Возвращает версию конфигурации из исходников конфигурации или расширения
//
// Параметры:
//   ПутьФайлаКонфигурации - Строка - путь к файлу Configuration.xml или к каталогу, его содержащему
//
//  Возвращаемое значение:
//   Соответствие - текущая версия конфигурации
//		* Ключ - Строка - путь найденного файла Configuration.xml
//		* Значение - Строка - предыдущая версия из этого файла
//
Функция ВерсияКонфигурации(Знач ПутьФайлаКонфигурации) Экспорт

	Лог.Отладка("читаю версию из исходников конфигурации %1", ПутьФайлаКонфигурации);

	Результат = Новый Соответствие;

	Для Каждого Файл Из ФайлыКонфигураций(ПутьФайлаКонфигурации, Ложь) Цикл
		СтрокаXML = ПрочитатьФайл(Файл.ПолноеИмя);
		Результат.Вставить(Файл.ПолноеИмя, ВерсияКонфигурацииПоХМЛ(СтрокаXML));
	КонецЦикла;

	Возврат Результат;

КонецФункции

// Устанавливает новую версию конфигурации или расширения в исходниках
//
// Параметры:
//   ПутьИсходников - Строка - путь к файлу Configuration.xml или к каталогу, его содержащему
//		если в каталоге нет этого файла, выполняется рекурсивный поиск всех таких файлов в подкаталогах
//   НовыйНомерВерсии - Строка - версия для установки
//   НастройкиУстановки - Структура - Разные варианты установки для внешних файлов. Может быть пустой коллекцией.
//		* ВерсияВКомментарииМетаданного - Булево - По умолчанию. Искать\устанавливать версию в комментарии внешнего файла
//
//  Возвращаемое значение:
//   Соответствие - текущая версия конфигурации
//		* Ключ - Строка - путь найденного файла Configuration.xml
//		* Значение - Строка - предыдущая версия из этого файла
//
Функция УстановитьВерсиюКонфигурации(Знач ПутьИсходников, Знач НовыйНомерВерсии, Знач НастройкиУстановки) Экспорт

	Результат = Новый Соответствие;
	ВнешниеФайлы = Неопределено;

	Попытка
		Для Каждого Файл Из ФайлыКонфигураций(ПутьИсходников) Цикл
			ПредыдущаяВерсия = УстановитьВерсиюВХМЛ(Файл.ПолноеИмя, НовыйНомерВерсии);
			Результат.Вставить(Файл.ПолноеИмя, ПредыдущаяВерсия);
		КонецЦикла;
	Исключение
		ВнешниеФайлы = ВнешниеФайлы(ПутьИсходников);
		Если Не ЗначениеЗаполнено(ВнешниеФайлы) Тогда
			ВызватьИсключение;
		КонецЕсли;
	КонецПопытки;

	Если ВнешниеФайлы = Неопределено Тогда
		ВнешниеФайлы = ВнешниеФайлы(ПутьИсходников);
	КонецЕсли;
	МенятьХМЛ = Не ЗначениеЗаполнено(НастройкиУстановки) Или НастройкиУстановки.ВерсияВКомментарииМетаданного;
	Если Не МенятьХМЛ Тогда
		Лог.Предупреждение("Найдены xml-исходники внешних обработок\отчетов 1С, но в команде не указан вариант указания версии.")
	Иначе
		Для Каждого Файл Из ВнешниеФайлы Цикл
			ИмяФайла = Файл.ПолноеИмя;
			Попытка
				ПредыдущаяВерсия = УстановитьВерсиюВнешнегоФайла(ИмяФайла, НовыйНомерВерсии);
				Результат.Вставить(ИмяФайла, ПредыдущаяВерсия);
			Исключение
				ИнфоОшибки = ИнформацияОбОшибке();
				Лог.Отладка("Пропускаю файл из-за ошибки чтения или определения версии. %1
				|%2", ИмяФайла, КраткоеПредставлениеОшибки(ИнфоОшибки));
			КонецПопытки;
		КонецЦикла;
	КонецЕсли;

	Возврат Результат;
КонецФункции

// Устанавливает новый номер сборки версии конфигурации или расширения в исходниках. Заменяется последний разряд версии
// Например, если старая версия 5.4.3.124, а номер сборки 125, то новая версия 5.4.3.125
//
// Параметры:
//   ПутьИсходников - Строка - путь к файлу Configuration.xml или к каталогу, его содержащему
//		если в каталоге нет этого файла, выполняется рекурсивный поиск всех таких файлов в подкаталогах
//   НовыйНомерСборки - Строка - номер сборки для установки
//
//  Возвращаемое значение:
//   Соответствие - текущая версия конфигурации
//		* Ключ - Строка - путь найденного файла Configuration.xml
//		* Значение - Строка - предыдущая версия из этого файла
//
Функция УстановитьНомерСборкиДляКонфигурации(Знач ПутьИсходников, Знач НовыйНомерСборки) Экспорт

	Результат = Новый Соответствие;

	Для Каждого Файл Из ФайлыКонфигураций(ПутьИсходников) Цикл
		ПредыдущаяВерсия = ЗаписатьНомерСборки(Файл.ПолноеИмя, НовыйНомерСборки);
		Результат.Вставить(Файл.ПолноеИмя, ПредыдущаяВерсия);
	КонецЦикла;

	Возврат Результат;

КонецФункции

// Устанавливает новый номер сборки версии внешней обработки\отчета в исходниках. Заменяется последний разряд версии
// Например, если старая версия 5.4.3.124, а номер сборки 125, то новая версия 5.4.3.125
//
// Параметры:
//   ПутьИсходников - Строка - путь к корневому xml-файлу или к каталогу, его содержащему
//		если в каталоге нет этого файла, выполняется рекурсивный поиск всех таких файлов в подкаталогах
//   НовыйНомерСборки - Строка - номер сборки для установки
//   НастройкиУстановки - Структура - Разные варианты установки для внешних файлов. Может быть пустой коллекцией.
//		* ВерсияВКомментарииМетаданного - Булево - По умолчанию. Искать\устанавливать версию в комментарии внешнего файла
//
//  Возвращаемое значение:
//   Соответствие - текущая версия конфигурации
//		* Ключ - Строка - путь найденного xml-файла
//		* Значение - Строка - предыдущая версия из этого файла
//
Функция УстановитьНомерСборкиДляВнешнегоФайла(Знач ПутьИсходников, Знач НовыйНомерСборки, Знач НастройкиУстановки) Экспорт

	Результат = Новый Соответствие;

	Если НастройкиУстановки.ВерсияВКомментарииМетаданного Тогда
		Для Каждого Файл Из ВнешниеФайлы(ПутьИсходников) Цикл
			ПредыдущаяВерсия = ЗаписатьНомерСборкиВнешнегоФайла(Файл.ПолноеИмя, НовыйНомерСборки);
			Результат.Вставить(Файл.ПолноеИмя, ПредыдущаяВерсия);
		КонецЦикла;
	КонецЕсли;

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПрочитатьФайл(Знач ПутьФайлаКонфигурации)

	ТекстовыйДокумент = Новый ТекстовыйДокумент();
	ТекстовыйДокумент.Прочитать(ПутьФайлаКонфигурации, КодировкаТекста.UTF8);
	Возврат ТекстовыйДокумент.ПолучитьТекст();

КонецФункции

Процедура ЗаписатьФайл(Знач ПутьФайла, Знач НоваяСтрокаXML)
	ТекстовыйДокумент = Новый ТекстовыйДокумент();
	ТекстовыйДокумент.УстановитьТекст(НоваяСтрокаXML);
	ТекстовыйДокумент.Записать(ПутьФайла, КодировкаТекста.UTF8);
КонецПроцедуры

Функция ВерсияКонфигурацииПоХМЛ(Знач ХМЛСтрокаФайла)
	Возврат ВерсияПоХМЛ(ХМЛСтрокаФайла, "Version");
КонецФункции

Функция ВерсияПоХМЛ(Знач ХМЛСтрокаФайла, Знач ИмяТегаСВерсией)

	РегулярноеВыражение = РегуляркаПоискаВерсии(ИмяТегаСВерсией);

	Совпадения = РегулярноеВыражение.НайтиСовпадения(ХМЛСтрокаФайла);
	Если ЗначениеЗаполнено(Совпадения) Тогда
		Результат = Совпадения[0].Группы[2].Значение;
		Лог.Отладка("текущая версия %1", Результат);
		Возврат Результат;
	КонецЕсли;

	РегулярноеВыражение = РегуляркаПоискаПустойВерсии(ИмяТегаСВерсией);
	Если РегулярноеВыражение.Совпадает(ХМЛСтрокаФайла) Тогда
		Возврат "";
	КонецЕсли;

	ВызватьИсключение "Версия в файле не найдена. Неверный файл?";

КонецФункции

Функция УстановитьВерсиюВнешнегоФайла(ПутьВнешнегоФайла, НомерВерсии)

	Лог.Отладка("устанавливаю версию %1 в исходниках внешнего файла %2", НомерВерсии, ПутьВнешнегоФайла);
	СтрокаXML = ПрочитатьФайл(ПутьВнешнегоФайла);

	ИМЯ_ТЕГА_С_ВЕРСИЕЙ = "Comment";
	ПредыдущаяВерсия = ВерсияПоХМЛ(СтрокаXML, ИМЯ_ТЕГА_С_ВЕРСИЕЙ);

	НоваяСтрокаXML = ИзменитьВерсиюВХМЛ(СтрокаXML, НомерВерсии, ИМЯ_ТЕГА_С_ВЕРСИЕЙ);
	ЗаписатьФайл(ПутьВнешнегоФайла, НоваяСтрокаXML);

	Возврат ПредыдущаяВерсия;

КонецФункции

Функция УстановитьВерсиюВХМЛ(ПутьФайлаКонфигурации, НомерВерсии)

	Лог.Отладка("устанавливаю версию %1 в исходниках конфигурации %2", НомерВерсии, ПутьФайлаКонфигурации);
	СтрокаXML = ПрочитатьФайл(ПутьФайлаКонфигурации);

	ПредыдущаяВерсия = ВерсияКонфигурацииПоХМЛ(СтрокаXML);

	НоваяСтрокаXML = ИзменитьВерсиюКонфигурации(СтрокаXML, НомерВерсии);
	ЗаписатьФайл(ПутьФайлаКонфигурации, НоваяСтрокаXML);

	Возврат ПредыдущаяВерсия;

КонецФункции

Функция ИзменитьВерсиюКонфигурации(СтрокаXML, НомерВерсии)
	Возврат ИзменитьВерсиюВХМЛ(СтрокаXML, НомерВерсии, "Version");
КонецФункции

Функция ИзменитьВерсиюВХМЛ(СтрокаXML, НомерВерсии, Знач ИмяТегаСВерсией)

	ШаблонПодстановки = СтрШаблон("<%1>$1 %2$3</%1>", ИмяТегаСВерсией, НомерВерсии);
	ШаблонПодстановкиДляПустойВерсии = СтрШаблон("<%1>%2</%1>", ИмяТегаСВерсией, НомерВерсии);

	РегулярноеВыражение = РегуляркаПоискаВерсии(ИмяТегаСВерсией);
	НоваяСтрокаXML = РегулярноеВыражение.Заменить(СтрокаXML, ШаблонПодстановки);

	РегулярноеВыражение = РегуляркаПоискаПустойВерсии(ИмяТегаСВерсией);
	Результат = РегулярноеВыражение.Заменить(НоваяСтрокаXML, ШаблонПодстановкиДляПустойВерсии);
	Возврат СтрЗаменить(Результат, "  ", " "); // 2 пробела на один пробел

КонецФункции

Функция ЗаписатьНомерСборки(ПутьФайлаКонфигурации, НомерСборки)
	Возврат ЗаписатьНомерСборкиВХмл(ПутьФайлаКонфигурации, НомерСборки, "Version");
КонецФункции

Функция ЗаписатьНомерСборкиВнешнегоФайла(ПутьФайлаКонфигурации, НомерСборки)
	Возврат ЗаписатьНомерСборкиВХмл(ПутьФайлаКонфигурации, НомерСборки, "Comment");
КонецФункции

Функция ЗаписатьНомерСборкиВХмл(ПутьФайлаКонфигурации, НомерСборки, ИмяТегаСВерсией)

	Лог.Отладка("устанавливаю номер сборки %1 в исходниках %2", НомерСборки, ПутьФайлаКонфигурации);
	СтрокаXML = ПрочитатьФайл(ПутьФайлаКонфигурации);

	ПредыдущаяВерсия = ВерсияПоХМЛ(СтрокаXML, ИмяТегаСВерсией);
	Лог.Отладка("Найдена предыдущая версия %1", ПредыдущаяВерсия);

	ВерсияСоСборкой = ВерсияСоСборкой(ПредыдущаяВерсия, НомерСборки);

	НоваяСтрокаXML = ИзменитьВерсиюВХМЛ(СтрокаXML, ВерсияСоСборкой, ИмяТегаСВерсией);
	ЗаписатьФайл(ПутьФайлаКонфигурации, НоваяСтрокаXML);

	Возврат ПредыдущаяВерсия;

КонецФункции

Функция ВерсияСоСборкой(Знач НомерВерсии, Знач НомерСборки)

	Если ПустаяСтрока(НомерВерсии) Тогда
		Возврат "1.0.0." + НомерСборки;
	КонецЕсли;
	ШаблонПодстановки = СтрШаблон("$1.%1", НомерСборки);
	РегулярноеВыражение = Новый РегулярноеВыражение("(\d+.\d+.\d+).(\d+)");
	Возврат РегулярноеВыражение.Заменить(НомерВерсии, ШаблонПодстановки);

КонецФункции

Функция ФайлыКонфигураций(Знач ПутьФайлаИлиКаталогИсходников, Знач ИскатьВПодкаталогах = Истина)

	Результат = Новый Массив;
	ИмяФайлаКонфигурации = ИмяФайлаКонфигурации();

	Файл = Новый Файл(ПутьФайлаИлиКаталогИсходников);
	Если Файл.ЭтоКаталог() Тогда
		ФайлКонфигурации = Новый Файл(ОбъединитьПути(Файл.ПолноеИмя, ИмяФайлаКонфигурации));
		Если Не ФайлКонфигурации.Существует() Тогда
			Если ИскатьВПодкаталогах Тогда
				Возврат НайтиФайлы(Файл.ПолноеИмя, ИмяФайлаКонфигурации, Истина);
			Иначе
				ВызватьИсключение СтрШаблон("В каталоге %1 не существует файл конфигурации %2",
					Файл.ПолноеИмя, ИмяФайлаКонфигурации);
			КонецЕсли;
		КонецЕсли;

		Результат.Добавить(ФайлКонфигурации);
		Возврат Результат;
	ИначеЕсли НРег(Файл.Имя) = НРег(ИмяФайлаКонфигурации) Тогда
		Результат.Добавить(Файл);
		Возврат Результат;
	Иначе
// todo выбрасывать ли исключение, если не нашли подходящих файлов ?
		ВызватьИсключение СтрШаблон("Переданный путь должен указывать на файл конфигурации %1 или на каталог, его содержащий - %2",
			ИмяФайлаКонфигурации, ПутьФайлаИлиКаталогИсходников);
	КонецЕсли;

КонецФункции

Функция ВнешниеФайлы(Знач ПутьФайлаИлиКаталогИсходников, Знач ИскатьВПодкаталогах = Истина)
	Результат = Новый Массив;
	ИгнорируемыеВнешниеФайлы = ИгнорируемыеВнешниеФайлы();
	Файл = Новый Файл(ПутьФайлаИлиКаталогИсходников);
	Если Файл.ЭтоФайл() Тогда
		Если Файл.Расширение = ".xml" И ИгнорируемыеВнешниеФайлы.Получить(НРег(Файл.Имя)) = Неопределено Тогда
			Лог.Отладка("Нашли xml-файл %1", Файл.ПолноеИмя);
			Результат.Добавить(Файл);
		КонецЕсли;
		Возврат Результат;
	ИначеЕсли Файл.ЭтоКаталог() Тогда
		ХмлФайлы = НайтиВнешниеХМЛФайлыВКаталогеИПодкаталогах(Файл.ПолноеИмя, ИскатьВПодкаталогах, ИгнорируемыеВнешниеФайлы);
		Для Каждого ХмлФайл Из ХмлФайлы Цикл
			Результат.Добавить(ХмлФайл);
		КонецЦикла;
		Лог.Отладка("Нашли внешние xml-файлы. Количество %1", Результат.Количество());
		Возврат Результат;
// todo выбрасывать ли исключение, если не нашли подходящих файлов ?
	// Иначе
	// 	ВызватьИсключение СтрШаблон("Переданный путь должен указывать на внешний файл 1С или на каталог, его содержащий - %1",
	// 		ПутьФайлаИлиКаталогИсходников);
	КонецЕсли;
	Возврат Результат;
КонецФункции

// поиск по подкаталог без рекурсии, только если на текущем уровне не найдено ни одного хмл-файла
Функция НайтиВнешниеХМЛФайлыВКаталогеИПодкаталогах(Знач ПутьКаталога, Знач ИскатьВПодкаталогах, Знач ИгнорируемыеВнешниеФайлы)
	Результат = Новый Массив;
	ХмлФайлы = НайтиФайлы(ПутьКаталога, "*.xml");
	Для Каждого Файл Из ХмлФайлы Цикл
		Если ИгнорируемыеВнешниеФайлы.Получить(НРег(Файл.Имя)) = Неопределено Тогда
			Лог.Отладка("Нашли xml-файл %1", Файл.ПолноеИмя);
			Результат.Добавить(Файл);
		КонецЕсли;
	КонецЦикла;
	Лог.Отладка("Нашли внешние xml-файлы. Количество %1 в каталоге %2", Результат.Количество(), ПутьКаталога);

	Если Не ЗначениеЗаполнено(Результат) И ИскатьВПодкаталогах Тогда
		ВсеФайлы = НайтиФайлы(ПутьКаталога, ПолучитьМаскуВсеФайлы());
		Для Каждого Файл Из ВсеФайлы Цикл
			Если Не Файл.ЭтоКаталог() Тогда
				Продолжить;
			КонецЕсли;
			ХмлФайлы = НайтиВнешниеХМЛФайлыВКаталогеИПодкаталогах(Файл.ПолноеИмя, ИскатьВПодкаталогах, ИгнорируемыеВнешниеФайлы);
			Для Каждого ХмлФайл Из ХмлФайлы Цикл
				Результат.Добавить(ХмлФайл);
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	Возврат Результат;
КонецФункции

Функция РегуляркаПоискаВерсии(ИмяТегаСВерсией)
	Шаблон = СтрШаблон("<%1>(.*)(\d+.\d+.\d+.\d+)(.*)<\/%1>", ИмяТегаСВерсией);
	Возврат Новый РегулярноеВыражение(Шаблон);
КонецФункции

Функция РегуляркаПоискаПустойВерсии(ИмяТегаСВерсией)
	Возврат Новый РегулярноеВыражение(СтрШаблон("(<%1/>)", ИмяТегаСВерсией));;
КонецФункции

Функция ИмяФайлаКонфигурации()
	Возврат "Configuration.xml";
КонецФункции

Функция ИгнорируемыеВнешниеФайлы()
	Результат = Новый Соответствие();
	Результат.Вставить(НРег(ИмяФайлаКонфигурации()), ИмяФайлаКонфигурации());
	Результат.Вставить("configdumpinfo.xml", "ConfigDumpInfo.xml");
	Возврат Результат;
КонецФункции

Процедура ПолучитьЛог()
	Если Лог = Неопределено Тогда
		Лог = Логирование.ПолучитьЛог(ПараметрыСистемы.ИмяЛогаСистемы());
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

ПолучитьЛог();
