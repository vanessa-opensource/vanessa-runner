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

	Для каждого Файл Из ФайлыКонфигураций(ПутьФайлаКонфигурации, Ложь) Цикл
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
//
//  Возвращаемое значение:
//   Соответствие - текущая версия конфигурации
//		* Ключ - Строка - путь найденного файла Configuration.xml
//		* Значение - Строка - предыдущая версия из этого файла
//
Функция УстановитьВерсиюКонфигурации(Знач ПутьИсходников, Знач НовыйНомерВерсии) Экспорт

	Результат = Новый Соответствие;

	Для каждого Файл Из ФайлыКонфигураций(ПутьИсходников) Цикл
		ПредыдущаяВерсия = ЗаписатьНомерВерсии(Файл.ПолноеИмя, НовыйНомерВерсии);
		Результат.Вставить(Файл.ПолноеИмя, ПредыдущаяВерсия);
	КонецЦикла;

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПрочитатьФайл(Знач ПутьФайлаКонфигурации)

	ТекстовыйДокумент = Новый ТекстовыйДокумент();
	ТекстовыйДокумент.Прочитать(ПутьФайлаКонфигурации, КодировкаТекста.UTF8);
	Возврат ТекстовыйДокумент.ПолучитьТекст();

КонецФункции

Функция ВерсияКонфигурацииПоХМЛ(Знач ХМЛСтрокаФайлаКонфигурации)

	РегулярноеВыражение = Новый РегулярноеВыражение("<Version>(\d+.\d+.\d+.\d+)<\/Version>");
	Совпадения = РегулярноеВыражение.НайтиСовпадения(ХМЛСтрокаФайлаКонфигурации);
	Если Совпадения.Количество() = 0 Тогда
		ВызватьИсключение "Версия проекта не определена";
	КонецЕсли;

	Результат = Совпадения[0].Группы[1].Значение;

	Лог.Отладка("текущая версия %1", Результат);

	Возврат Результат;

КонецФункции

Функция ЗаписатьНомерВерсии(ПутьФайлаКонфигурации, НомерВерсии)

	Лог.Отладка("устанавливаю версию %1 в исходниках конфигурации %2", НомерВерсии, ПутьФайлаКонфигурации);
	СтрокаXML = ПрочитатьФайл(ПутьФайлаКонфигурации);

	Результат = ВерсияКонфигурацииПоХМЛ(СтрокаXML);

	ШаблонПодстановки = СтрШаблон("<Version>%1</Version>", НомерВерсии);
	РегулярноеВыражение = Новый РегулярноеВыражение("(<Version>\d+.\d+.\d+.\d+<\/Version>)");
	НоваяСтрокаXML = РегулярноеВыражение.Заменить(СтрокаXML, ШаблонПодстановки);

	ТекстовыйДокумент = Новый ТекстовыйДокумент();
	ТекстовыйДокумент.УстановитьТекст(НоваяСтрокаXML);
	ТекстовыйДокумент.Записать(ПутьФайлаКонфигурации, КодировкаТекста.UTF8);

	Возврат Результат;

КонецФункции

Функция ВерсияСоСборкой(Знач НомерВерсии, Знач НомерСборки)

	ШаблонПодстановки = СтрШаблон("$1.%1", НомерСборки);
	РегулярноеВыражение = Новый РегулярноеВыражение("(\d+.\d+.\d+).(\d+)");
	Возврат РегулярноеВыражение.Заменить(НомерВерсии, ШаблонПодстановки);

КонецФункции

Функция ФайлыКонфигураций(Знач ПутьФайлаИлиКаталогИсходников, Знач ИскатьВПодкаталогах = Истина)

	Результат = Новый Массив;
	ИмяФайлаКонфигурации = "Configuration.xml";

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
	ИначеЕсли ИскатьВПодкаталогах Тогда
		Возврат НайтиФайлы(ПутьФайлаИлиКаталогИсходников, ИмяФайлаКонфигурации, Истина);
	Иначе
		ВызватьИсключение СтрШаблон("Переданный путь должен указывать на файл конфигурации %1 или на каталог, его содержащий - %2",
			ИмяФайлаКонфигурации, ПутьФайлаИлиКаталогИсходников);
	КонецЕсли;

КонецФункции

Функция ПолучитьЛог()
	Если Лог = Неопределено Тогда
		Лог = Логирование.ПолучитьЛог(ПараметрыСистемы.ИмяЛогаСистемы());
	КонецЕсли;
	Возврат Лог;
КонецФункции

#КонецОбласти

ПолучитьЛог();
