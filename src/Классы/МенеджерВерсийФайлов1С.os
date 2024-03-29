#Использовать logos
#Использовать fs
#Использовать fluent

#Область ОписаниеПеременных

Перем Лог;

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Возвращает версию конфигурации из исходников конфигурации или расширения
//
// Параметры:
//   ПутьФайлаКонфигурации - Строка - путь к файлу Configuration.xml или Configuration.mdo или к каталогу, его содержащему
//
//  Возвращаемое значение:
//   Соответствие - текущая версия конфигурации
//		* Ключ - Строка - путь найденного файла Configuration.xml или Configuration.mdo
//		* Значение - Строка - предыдущая версия из этого файла
//
Функция ВерсияКонфигурации(Знач ПутьФайлаКонфигурации) Экспорт

	Лог.Отладка("читаю версию из исходников конфигурации %1", ПутьФайлаКонфигурации);

	Результат = Новый Соответствие;

	Для каждого Файл Из ФайлыИсходников(ПутьФайлаКонфигурации, Ложь) Цикл
		СтрокаXML = ПрочитатьФайл(Файл.ПолноеИмя);
		Результат.Вставить(Файл.ПолноеИмя, ВерсияКонфигурацииПоХМЛ(СтрокаXML));
	КонецЦикла;

	Возврат Результат;

КонецФункции

// Устанавливает новую версию конфигурации или расширения в исходниках
//
// Параметры:
//   ПутьИсходников - Строка - путь к файлу Configuration.xml или Configuration.mdo или к каталогу, его содержащему
//		если в каталоге нет этого файла, выполняется рекурсивный поиск всех таких файлов в подкаталогах
//   НовыйНомерВерсии - Строка - версия для установки
//   ТолькоМодулиКода - Булево - выполнять поиск в модулях конфигурации (ObjectModule.bsl или Module.bsl)
//
//  Возвращаемое значение:
//   Соответствие - текущая версия конфигурации
//		* Ключ - Строка - путь найденного файла Configuration.xml или Configuration.mdo
//		* Значение - Строка - предыдущая версия из этого файла
//
Функция УстановитьВерсиюКонфигурации(Знач ПутьИсходников, Знач НовыйНомерВерсии, Знач ТолькоМодулиКода) Экспорт

	Результат = Новый Соответствие;

	Для каждого Файл Из ФайлыИсходников(ПутьИсходников, Истина, ТолькоМодулиКода) Цикл
		ПредыдущаяВерсия = ЗаписатьНомерВерсии(Файл.ПолноеИмя, НовыйНомерВерсии, ТолькоМодулиКода);
		Результат.Вставить(Файл.ПолноеИмя, ПредыдущаяВерсия);
	КонецЦикла;

	Возврат Результат;

КонецФункции

// Устанавливает новый номер сборки версии конфигурации или расширения в исходниках. Заменяется последний разряд версии
// Например, если старая версия 5.4.3.124, а номер сборки 125, то новая версия 5.4.3.125
//
// Параметры:
//   ПутьИсходников - Строка - путь к файлу Configuration.xml или Configuration.mdo или к каталогу, его содержащему
//		если в каталоге нет этого файла, выполняется рекурсивный поиск всех таких файлов в подкаталогах
//   НовыйНомерСборки - Строка - номер сборки для установки
//
//  Возвращаемое значение:
//   Соответствие - текущая версия конфигурации
//		* Ключ - Строка - путь найденного файла Configuration.xml или Configuration.mdo
//		* Значение - Строка - предыдущая версия из этого файла
//
Функция УстановитьНомерСборкиДляКонфигурации(Знач ПутьИсходников, Знач НовыйНомерСборки) Экспорт

	Результат = Новый Соответствие;

	Для каждого Файл Из ФайлыИсходников(ПутьИсходников) Цикл
		ПредыдущаяВерсия = ЗаписатьНомерСборки(Файл.ПолноеИмя, НовыйНомерСборки);
		Результат.Вставить(Файл.ПолноеИмя, ПредыдущаяВерсия);
	КонецЦикла;

	Возврат Результат;

КонецФункции

// Поиск файла подходящего под шаблон номера версии.
//
// Параметры:
//   ПутьКФайлуКонфигурации - Строка - Файл с шаблоном номера версии. Например: 1cv8_$version.cf
//
//  Возвращаемое значение:
//   Строка - Имя файла подходящего под шаблон версии. Например: 1cv8_1.2.3.4.cf
//
Функция НайтиФайлСВерсией(Знач ПутьКФайлуКонфигурации) Экспорт

	ШаблонВерсии = "$version";

	Если СтрНайти(ПутьКФайлуКонфигурации, ШаблонВерсии) = 0 Тогда
		Возврат ПутьКФайлуКонфигурации;
	КонецЕсли;

	Файл = Новый Файл(ПутьКФайлуКонфигурации);
	Путь = Файл.Путь;
	
	ПутьКФайлу = "";
	РегулярноеВыражение = Новый РегулярноеВыражение("(\d+\.\d+\.\d+\.\d+|\d+\.\d+\.\d+)");

	Если ПустаяСтрока(Файл.Расширение) Тогда
		МаскаПоиска = ПолучитьМаскуВсеФайлы();
	Иначе
		МаскаПоиска = "*" + Файл.Расширение;
	КонецЕсли;

	Лог.Отладка("Используем каталог поиска: %1", Путь);
	Лог.Отладка("Используем маску поиска: %1", МаскаПоиска);
	 
	НайденныеФайлы = НайтиФайлы(Путь, МаскаПоиска);
	Для каждого НайденныйФайл Из НайденныеФайлы Цикл
	
		Лог.Отладка("Ищем номер версии в имени файла: %1", НайденныйФайл.Имя);
		Совпадения = РегулярноеВыражение.НайтиСовпадения(НайденныйФайл.Имя);
		Если Совпадения.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;

		ВерсияФайла = Совпадения[0].Группы[1].Значение;
		Лог.Отладка("Нашли номер версии: %1", ВерсияФайла);
		ИмяФайлаСВерсией = СтрЗаменить(Файл.Имя, ШаблонВерсии, ВерсияФайла);
		Если ИмяФайлаСВерсией = НайденныйФайл.Имя Тогда
			ПутьКФайлу = НайденныйФайл.ПолноеИмя;
			Лог.Информация("Используем файл с версией " + ПутьКФайлу);
			Прервать;
		КонецЕсли;

	КонецЦикла;

	Если ПустаяСтрока(ПутьКФайлу) Тогда
		ВызватьИсключение "Не найден файл с шаблоном версии " + ПутьКФайлуКонфигурации;
	КонецЕсли;

	Возврат ПутьКФайлу;

КонецФункции

// Подставляет номер версии в строку с шаблонной переменной $version
//
// Параметры:
//   ПутьИсходников - Строка - Путь к исходникам конфигурации для получения версии
//   СтрокаДляПодстановки - Строка - Строка для подставновки номера версии
//
//  Возвращаемое значение:
//   Строка - Итоговая строка с результатом подстановки
//
Функция ПодставитьНомерВерсии(ПутьИсходников, СтрокаДляПодстановки) Экспорт

	ШаблонВерсии = "$version";

	Если СтрНайти(СтрокаДляПодстановки, ШаблонВерсии) = 0 Тогда
		Возврат СтрокаДляПодстановки;
	КонецЕсли;

	ВерсииКонфигураций = ВерсияКонфигурации(ПутьИсходников);
	Если ВерсииКонфигураций.Количество() = 0 Тогда
		ВызватьИсключение "Не найден файл конфигурации в каталоге " + ПутьИсходников;
	КонецЕсли;

	Для Каждого КлючЗначение Из ВерсииКонфигураций Цикл
		ВерсияКонфигурации = КлючЗначение.Значение;
		Прервать;
	КонецЦикла;	

	Лог.Информация("Используем для подстановки в %1 версию %2", СтрокаДляПодстановки, ВерсияКонфигурации);
	Возврат СтрЗаменить(СтрокаДляПодстановки, ШаблонВерсии, ВерсияКонфигурации);

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПрочитатьФайл(Знач ПутьФайла)

	ТекстовыйДокумент = Новый ТекстовыйДокумент();
	ТекстовыйДокумент.Прочитать(ПутьФайла, КодировкаТекста.UTF8);
	Возврат ТекстовыйДокумент.ПолучитьТекст();

КонецФункции

Процедура ЗаписатьФайл(Знач ПутьФайла, ТекстФайла)

	ТекстовыйДокумент = Новый ТекстовыйДокумент();
	ТекстовыйДокумент.УстановитьТекст(ТекстФайла);
	ТекстовыйДокумент.Записать(ПутьФайла, КодировкаТекста.UTF8);

КонецПроцедуры

Функция ВерсияКонфигурацииПоХМЛ(Знач ХМЛСтрокаФайлаКонфигурации)

	РегулярноеВыражение = Новый РегулярноеВыражение("<Version>(\d+\.\d+\.\d+\.\d+|\d+\.\d+\.\d+)<\/Version>");
	РегулярноеВыражение.ИгнорироватьРегистр = Истина;

	Совпадения = РегулярноеВыражение.НайтиСовпадения(ХМЛСтрокаФайлаКонфигурации);
	Если Не ЗначениеЗаполнено(Совпадения) Тогда
		РегулярноеВыражение = Новый РегулярноеВыражение("<Version/>");
		РегулярноеВыражение.ИгнорироватьРегистр = Истина;

		Если РегулярноеВыражение.Совпадает(ХМЛСтрокаФайлаКонфигурации) Тогда
			Возврат "";
		КонецЕсли;

		ВызватьИсключение "Версия проекта не определена";
	КонецЕсли;

	Результат = Совпадения[0].Группы[1].Значение;

	Лог.Отладка("текущая версия %1", Результат);

	Возврат Результат;

КонецФункции

Функция ВерсияМодуля(Знач ТекстФайла)

	Совпадения = НоваяРегуляркаДляВерсииМодуля().НайтиСовпадения(ТекстФайла);
	Если Не ЗначениеЗаполнено(Совпадения) Тогда
		Возврат "";
	КонецЕсли;

	Результат = Совпадения[0].Группы[1].Значение;

	Лог.Отладка("текущая версия модуля %1", Результат);

	Возврат Результат;

КонецФункции

Функция НоваяРегуляркаДляВерсииМодуля()

	РегулярноеВыражение = Новый РегулярноеВыражение("^\s*Версия\s*=\s*""(\d+\.\d+\.\d+\.\d+|\d+\.\d+\.\d+)"";\s*$");
	РегулярноеВыражение.ИгнорироватьРегистр = Истина;
	Возврат РегулярноеВыражение;
КонецФункции

Процедура ИзменитьНомерВерсииМодуля(ПутьФайла, ТекстФайла, НомерВерсии)

	ШаблонПодстановки = СтрШаблон("  Версия = ""%1"";", НомерВерсии);
	НовыйТекстФайла = НоваяРегуляркаДляВерсииМодуля().Заменить(ТекстФайла, ШаблонПодстановки);
	ЗаписатьФайл(ПутьФайла, НовыйТекстФайла);

КонецПроцедуры

Функция ЗаписатьНомерВерсии(ПутьФайлаКонфигурацииИлиМодуля, НомерВерсии, ТолькоМодулиКода)

	Если ТолькоМодулиКода Тогда
		Лог.Отладка("устанавливаю версию %1 в исходниках модуля %2", НомерВерсии, ПутьФайлаКонфигурацииИлиМодуля);
	Иначе
		Лог.Отладка("устанавливаю версию %1 в исходниках конфигурации %2", НомерВерсии, ПутьФайлаКонфигурацииИлиМодуля);
	КонецЕсли;
	ТекстФайла = ПрочитатьФайл(ПутьФайлаКонфигурацииИлиМодуля);

	Если ТолькоМодулиКода Тогда
		ПредыдущаяВерсия = ВерсияМодуля(ТекстФайла);

		ИзменитьНомерВерсииМодуля(ПутьФайлаКонфигурацииИлиМодуля, ТекстФайла, НомерВерсии);
	Иначе
		ПредыдущаяВерсия = ВерсияКонфигурацииПоХМЛ(ТекстФайла);

		ИзменитьНомерВерсииХМЛ(ПутьФайлаКонфигурацииИлиМодуля, ТекстФайла, НомерВерсии);
	КонецЕсли;

	Возврат ПредыдущаяВерсия;

КонецФункции

Процедура ИзменитьНомерВерсииХМЛ(ПутьФайлаКонфигурации, СтрокаXML, НомерВерсии)

	ШаблонПодстановки = СтрШаблон("<Version>%1</Version>", НомерВерсии);
	РегулярноеВыражение = Новый РегулярноеВыражение("(<Version>\d+\.\d+\.\d+\.\d+<\/Version>)|(<Version>\d+\.\d+\.\d+<\/Version>)");
	РегулярноеВыражение.ИгнорироватьРегистр = Истина;
	НоваяСтрокаXML = РегулярноеВыражение.Заменить(СтрокаXML, ШаблонПодстановки);

	РегулярноеВыражение = Новый РегулярноеВыражение("(<Version/>)");
	РегулярноеВыражение.ИгнорироватьРегистр = Истина;
	НоваяСтрокаXML = РегулярноеВыражение.Заменить(НоваяСтрокаXML, ШаблонПодстановки);

	ЗаписатьФайл(ПутьФайлаКонфигурации, НоваяСтрокаXML);

КонецПроцедуры

Функция ЗаписатьНомерСборки(ПутьФайлаКонфигурации, НомерСборки)

	Лог.Отладка("устанавливаю номер сборки %1 в исходниках конфигурации %2", НомерСборки, ПутьФайлаКонфигурации);
	СтрокаXML = ПрочитатьФайл(ПутьФайлаКонфигурации);

	ПредыдущаяВерсия = ВерсияКонфигурацииПоХМЛ(СтрокаXML);

	ВерсияСоСборкой = ВерсияСоСборкой(ПредыдущаяВерсия, НомерСборки);

	ИзменитьНомерВерсииХМЛ(ПутьФайлаКонфигурации, СтрокаXML, ВерсияСоСборкой);

	Возврат ПредыдущаяВерсия;

КонецФункции

Функция ВерсияСоСборкой(Знач НомерВерсии, Знач НомерСборки)

	ШаблонПодстановки = СтрШаблон("$1.%1", НомерСборки);
	РегулярноеВыражение = Новый РегулярноеВыражение("(\d+\.\d+\.\d+)\.(\d+)|(\d+\.\d+)\.(\d+)");
	Возврат РегулярноеВыражение.Заменить(НомерВерсии, ШаблонПодстановки);

КонецФункции

Функция ФайлыИсходников(Знач ПутьФайлаИлиКаталогИсходников, Знач ИскатьВПодкаталогах = Истина,
							Знач ТолькоМодулиКода = Ложь)

	Если ТолькоМодулиКода Тогда
		Результат = ФайлыМодулей(ПутьФайлаИлиКаталогИсходников, ИскатьВПодкаталогах);
		ПоказатьИменаМодулейВРежимеОтладка(Результат);
		Результат = СвернутьМассивФайлов(Результат);
		Возврат Результат;
	КонецЕсли;

	Результат = ФайлыКонфигураций(ПутьФайлаИлиКаталогИсходников, ИскатьВПодкаталогах);
	Результат = СвернутьМассивФайлов(Результат);
	ПоказатьИменаМодулейВРежимеОтладка(Результат);
	Возврат Результат;

КонецФункции

Процедура ПоказатьИменаМодулейВРежимеОтладка(Знач Массив)
	Лог.Отладка("Найдено файлов %1", Массив.Количество()); // TODO
	Для каждого Элем Из Массив Цикл
		Лог.Отладка("	файл %1", Элем.ПолноеИмя); // TODO
	КонецЦикла;
КонецПроцедуры

Функция СвернутьМассивФайлов(Знач Массив)
	Соответствие = Новый Соответствие;
	Для каждого Элемент Из Массив Цикл
		Соответствие.Вставить(Элемент.ПолноеИмя, Элемент);
	КонецЦикла;
	Результат = Новый Массив;
	Для каждого КлючЗначение Из Соответствие Цикл
		Результат.Добавить(КлючЗначение.Значение);
	КонецЦикла;
	Возврат Результат;
	// код ниже пока не работает, жду приема ПР https://github.com/nixel2007/oscript-fluent/pull/23 и выпуска релиза -
	// Возврат ПроцессорыКоллекций.ИзКоллекции(Массив)
	// 	.Различные("Результат = Элемент1.ПолноеИмя <> Элемент2.ПолноеИмя")
	// 	.ВМассив();
КонецФункции

Функция ФайлыКонфигураций(Знач ПутьФайлаИлиКаталогИсходников, Знач ИскатьВПодкаталогах = Истина)

	Результат = Новый Массив;
	ИмяФайлаКонфигурации = "Configuration.xml";
	ИмяФайлаКонфигурацииЕДТ = "Configuration.mdo"; //TODO нужно учесть и файл для EDT

	Файл = Новый Файл(ПутьФайлаИлиКаталогИсходников);
	Если Файл.ЭтоКаталог() Тогда
		ФайлКонфигурации = Новый Файл(ОбъединитьПути(Файл.ПолноеИмя, ИмяФайлаКонфигурации));
		Если ФайлКонфигурации.Существует() Тогда
			Результат.Добавить(ФайлКонфигурации);
			Возврат Результат;
		КонецЕсли;
		ФайлКонфигурацииЕДТ = Новый Файл(ОбъединитьПути(Файл.ПолноеИмя, ИмяФайлаКонфигурацииЕДТ));
		Если ФайлКонфигурацииЕДТ.Существует() Тогда
			Результат.Добавить(ФайлКонфигурацииЕДТ);
			Возврат Результат;
		КонецЕсли;

		Если ИскатьВПодкаталогах Тогда
			Результат = НайтиФайлы(Файл.ПолноеИмя, ИмяФайлаКонфигурации, Истина);
			РезультатЕДТ = НайтиФайлы(Файл.ПолноеИмя, ИмяФайлаКонфигурацииЕДТ, Истина);
			ОбщиеМетоды.ДополнитьМассив(Результат, РезультатЕДТ);
			Возврат Результат;
		Иначе
			ВызватьИсключение СтрШаблон("В каталоге %1 не существует ни файла конфигурации %2, ни файл конфигурации EDT %3",
				Файл.ПолноеИмя, ИмяФайлаКонфигурации, ИмяФайлаКонфигурацииЕДТ);
		КонецЕсли;

	ИначеЕсли НРег(Файл.Имя) = НРег(ИмяФайлаКонфигурации) Или
				НРег(Файл.Имя) = НРег(ИмяФайлаКонфигурацииЕДТ) Тогда
		Результат.Добавить(Файл);
		Возврат Результат;
	Иначе
		ВызватьИсключение СтрШаблон("Переданный путь должен указывать на файл конфигурации %1 или файл конфигурации EDT %2
		|или на каталог, их содержащий - %3",
			ИмяФайлаКонфигурации, ИмяФайлаКонфигурацииЕДТ, ПутьФайлаИлиКаталогИсходников);
	КонецЕсли;

КонецФункции

Функция ФайлыМодулей(Знач ПутьФайлаИлиКаталогИсходников, Знач ИскатьВПодкаталогах = Истина)

	ИмяКаталогаСМодулем = "Ext";

	ИменаМодулей = Новый Массив;
	ИменаМодулей.Добавить("ObjectModule.bsl");
	ИменаМодулей.Добавить("Module.bsl");

	ФункцияМодульНаходитсяВКаталогеExt = Новый ОписаниеОповещения("МодульНаходитсяВКаталогеExt", ЭтотОбъект,
		Новый Структура("ИмяКаталогаСМодулем", ИмяКаталогаСМодулем));

	Результат = Новый Массив;

	Файл = Новый Файл(ПутьФайлаИлиКаталогИсходников);
	Лог.Отладка("Передан путь %1", Файл.ПолноеИмя);
	Если Файл.ЭтоКаталог() Тогда
		Результат = ПроцессорыКоллекций.ИзКоллекции(ИменаМодулей)
		.Обработать("Результат = Новый Файл(ОбъединитьПути(ДополнительныеПараметры.ПолноеИмяФайла, Элемент))",
			Новый Структура("ПолноеИмяФайла", Файл.ПолноеИмя))
		.Фильтровать("Результат = Элемент.Существует()")
		.Фильтровать(ФункцияМодульНаходитсяВКаталогеExt)
		.ВМассив();

		ПроцессорыКоллекций.ИзКоллекции(ИменаМодулей)
		.Обработать("Результат = Новый Файл(
					|	ОбъединитьПути(ДополнительныеПараметры.ПолноеИмяФайла,
					|				ДополнительныеПараметры.ИмяКаталогаСМодулем, Элемент))",
			Новый Структура("ПолноеИмяФайла, ИмяКаталогаСМодулем",
							Файл.ПолноеИмя, ИмяКаталогаСМодулем))
		.Фильтровать("Результат = Элемент.Существует()")
		.Фильтровать(ФункцияМодульНаходитсяВКаталогеExt)
		.ДляКаждого("ДополнительныеПараметры.Коллекция.Добавить(Элемент)",
					Новый Структура("Коллекция", Результат));

		Если ИскатьВПодкаталогах Тогда
			ПроцессорыКоллекций.ИзКоллекции(ИменаМодулей)
			.Обработать("Результат = НайтиФайлы(ДополнительныеПараметры.ПолноеИмяФайла, Элемент, Истина);",
				Новый Структура("ПолноеИмяФайла", Файл.ПолноеИмя))
			.Развернуть("Результат = ПроцессорыКоллекций.ИзКоллекции(Элемент)")
			.Фильтровать(ФункцияМодульНаходитсяВКаталогеExt)
			.ДляКаждого("ДополнительныеПараметры.Коллекция.Добавить(Элемент)",
				Новый Структура("Коллекция", Результат));

		КонецЕсли;

		Возврат Результат;
	КонецЕсли;

	НайденныеМодули = ПроцессорыКоллекций.ИзКоллекции(ИменаМодулей)
		.Фильтровать("Результат = (ДополнительныеПараметры.ИмяФайла = НРег(Элемент))",
			Новый Структура("ИмяФайла", НРег(Файл.Имя)))
		.ВМассив();
	Если ЗначениеЗаполнено(НайденныеМодули) Тогда
		Результат.Добавить(Файл);
		Возврат Результат;
	КонецЕсли;

	ВызватьИсключение СтрШаблон("Переданный путь должен указывать на файлы модулей (Ext/%1) или на каталог, их содержащий - %2",
		СтрСоединить(ИменаМодулей, ", Ext/"), ПутьФайлаИлиКаталогИсходников);

КонецФункции

Процедура МодульНаходитсяВКаталогеExt(Результат, ДополнительныеПараметры) Экспорт
	Элемент = ДополнительныеПараметры.Элемент;
	Родитель = Новый Файл(Элемент.Путь);

	Результат = (НРег(Родитель.Имя) = НРег(ДополнительныеПараметры.ИмяКаталогаСМодулем));
КонецПроцедуры

Процедура ПолучитьЛог()
	Если Лог = Неопределено Тогда
		Лог = Логирование.ПолучитьЛог(ПараметрыСистемы.ИмяЛогаСистемы());
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

ПолучитьЛог();
