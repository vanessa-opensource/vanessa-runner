﻿#Область ОбработчикиСобытийФормы

&НаКлиенте
Перем ПутьКОбработке; // каталог обработки

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УбратьПодтверждениеПриЗавершенииПрограммы();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	СтрокаЗапуска = СокрЛП(ПараметрЗапуска);

	Если СтрокаЗапуска = "" Тогда
		Возврат;
	КонецЕсли;

	Попытка
		ПутьКОбработке = ПолучитьПутьОбработки();

		ПараметрыКоманднойСтроки = ПолучитьСтруктуруПараметров(СтрокаЗапуска);
		ПреобразоватьПараметрыКоторыеНачинаютсяСТочкиКНормальнымПутям(ПараметрыКоманднойСтроки);

		Если ПараметрыКоманднойСтроки.Свойство("СоздатьАдминистратора") Или
				ПараметрыКоманднойСтроки.Свойство("AdminCreate") Тогда

			Успешно = СоздатьПервогоАдминистратораПриНеобходимости(ПараметрыКоманднойСтроки.Имя);
		КонецЕсли;

		Если ПараметрыКоманднойСтроки.Свойство("ЗавершитьРаботуСистемы") Тогда
			ЗавершитьРаботуСистемы(Ложь, Ложь);
			Возврат;
		КонецЕсли;

	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		Ошибка = "Неудача при обработке параметров запуска"
			+ Символы.ВК + "Параметры: " + СтрокаЗапуска
			+ Символы.ВК + ОписаниеОшибки;
		Лог(Ошибка);
	КонецПопытки;

	// в таком варианте 1С не отдает лог в файл своего лога ( -- ПрекратитьРаботуСистемы(Ложь); 
	ЗавершитьРаботуСистемы(Ложь);
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПутьОбработки()

	Перем ФайлПути, Результат;

	Результат = ПолучитьПутьКОбработкеСервер();
	Если НЕ ПустаяСтрока(ПутьКОбработке) Тогда
		ФайлПути = Новый Файл(ПутьКОбработке);
		Результат = ФайлПути.Путь;
	КонецЕсли;

	Возврат Результат;
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УбратьПодтверждениеПриЗавершенииПрограммы()

	Попытка
		Выполнить("ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(""ОбщиеНастройкиПользователя"",
					|""ЗапрашиватьПодтверждениеПриЗавершенииПрограммы"", Ложь);");
	Исключение
		// Данного модуля и метода может не быть в конфигурации
		Лог("Неудача в УбратьПодтверждениеПриЗавершенииПрограммы");
	КонецПопытки;

КонецПроцедуры

&НаСервере
// портировано из Vanessa-ADD
Функция ПолучитьПутьКОбработкеСервер()

	ОбъектНаСервере = ОбъектНаСервере();
	ИспользуемоеИмяФайла = ОбъектНаСервере.ИспользуемоеИмяФайла;
	ПрефиксИмени = НРег(Лев(ИспользуемоеИмяФайла, 6));
    Если (ПрефиксИмени <> "e1cib/") И (ПрефиксИмени <> "e1cib\") Тогда
		Возврат ИспользуемоеИмяФайла;
	КонецЕсли;

	Возврат "";
КонецФункции

Функция ОбъектНаСервере()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции

&НаКлиенте
// портировано из Vanessa-ADD
Функция ПолучитьСтруктуруПараметров(Стр)
	Результат = Новый Структура;

	Массив = РазложитьСтрокуВМассивПодстрок(Стр, ";");
	Для каждого Элем Из Массив Цикл
		Поз = Найти(Элем, "=");
		Если Поз > 0 Тогда
			Ключ     = Лев(Элем, Поз - 1);
			Значение = Сред(Элем, Поз + 1);
			Попытка
				Результат.Вставить(Ключ, Значение);
			Исключение
				Лог("Не смог получить значение из строки запуска: " + Ключ);
			КонецПопытки;
		Иначе
			Если НЕ ПустаяСтрока(Элем) Тогда
				Попытка
					Результат.Вставить(Элем, Истина);
				Исключение
					Лог("Не смог получить значение из строки запуска: " + Элем);
				КонецПопытки;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	Возврат Результат;
КонецФункции

&НаКлиенте
//&НаСервереБезКонтекста
// портировано из Vanessa-ADD
Функция РазложитьСтрокуВМассивПодстрок(Знач Строка, Знач Разделитель = ",",
		Знач ПропускатьПустыеСтроки = Неопределено) Экспорт

	Результат = Новый Массив;

	// для обеспечения обратной совместимости
	Если ПропускатьПустыеСтроки = Неопределено Тогда
		ПропускатьПустыеСтроки = ?(Разделитель = " ", Истина, Ложь);
		Если ПустаяСтрока(Строка) Тогда
			Если Разделитель = " " Тогда
				Результат.Добавить("");
			КонецЕсли;
			Возврат Результат;
		КонецЕсли;
	КонецЕсли;

	Позиция = Найти(Строка, Разделитель);
	Пока Позиция > 0 Цикл
		Подстрока = Лев(Строка, Позиция - 1);
		Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Подстрока) Тогда
			Результат.Добавить(Подстрока);
		КонецЕсли;
		Строка = Сред(Строка, Позиция + СтрДлина(Разделитель));
		Позиция = Найти(Строка, Разделитель);
	КонецЦикла;

	Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Строка) Тогда
		Результат.Добавить(Строка);
	КонецЕсли;

	Возврат Результат;

КонецФункции

&НаКлиенте
// портировано из Vanessa-ADD
Процедура ПреобразоватьПараметрыКоторыеНачинаютсяСТочкиКНормальнымПутям(СтруктураПараметров)
	МассивКлючей = Новый Массив;

	Для каждого ПараметрБилда Из СтруктураПараметров Цикл
		Если Лев(ПараметрБилда.Значение, 1) = "."  Или
				Найти(ПараметрБилда.Значение, "$instrumentsRoot") > 0 Тогда

			МассивКлючей.Добавить(ПараметрБилда.Ключ);

		КонецЕсли;
	КонецЦикла;

	Для каждого Ключ Из МассивКлючей Цикл
		Было  = СтруктураПараметров[Ключ];
		Стало = ПреобразоватьПутьСТочкамиКНормальномуПути(СтруктураПараметров[Ключ]);
		Лог("Было=" + Было + ", Стало=" + Стало, "");

		СтруктураПараметров.Вставить(Ключ, Стало);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Функция ПреобразоватьПутьСТочкамиКНормальномуПути(ОригСтр)

	Если Найти(ОригСтр, "$instrumentsRoot") > 0 И НЕ ПустаяСтрока(ПутьКОбработке) Тогда
		ОригСтр = СтрЗаменить(ОригСтр, "$instrumentsRoot", ДополнитьСлешВПуть(ПутьКОбработке));
		Возврат ОригСтр;
	КонецЕсли;

	Возврат ОригСтр;

КонецФункции

// Функция ДополнитьСлешВПуть
//
// Параметры:
// ИмяКаталога
//
// Описание:
// Функция дополняет и возвращает слеш в путь в конец строки, если он отсутствует
//
// портировано из Vanessa-ADD
//
&НаКлиенте
Функция ДополнитьСлешВПуть(Знач Каталог) Экспорт
	разделитель = "\";

	Если ПустаяСтрока(Каталог) Тогда
		Возврат Каталог;
	КонецЕсли;
	СисИнфо = Новый СистемнаяИнформация;
	Если Найти(Строка(СисИнфо.ТипПлатформы), "Linux") > 0 Тогда
	//Если ЭтоLinux Тогда
		разделитель = "/";
	КонецЕсли;

	Если Прав(Каталог, 1) <> разделитель Тогда
		Каталог = Каталог + разделитель;
	КонецЕсли;
	Возврат Каталог;
КонецФункции

// портировано из Vanessa-ADD
//Функция СоздатьПервогоАдминистратораПриНеобходимости(Имя, ПараметрЗапуска)
Функция СоздатьПервогоАдминистратораПриНеобходимости(Имя)

	Если ПользователиИнформационнойБазы.ПолучитьПользователей().Количество() > 0 Тогда
		Лог("Уже существуют пользователь. Пользователь-администратор не создан!");
		Возврат Ложь;
	КонецЕсли;

	Администратор = ПользователиИнформационнойБазы.СоздатьПользователя();
	Администратор.Имя = Имя;
	Администратор.АутентификацияСтандартная = Истина;
	Администратор.ПоказыватьВСпискеВыбора = Истина;
	Администратор.ПолноеИмя = Имя;

	Если Метаданные.Роли.Найти("ПолныеПрава") <> Неопределено Тогда
		Администратор.Роли.Добавить(Метаданные.Роли.ПолныеПрава);
	КонецЕсли;

	Администратор.Язык = Метаданные.Языки.Русский;
	Администратор.Записать();

	Сообщение = СтрЗаменить("Пользователь-администратор с именем %1 создан!", "%1", Имя);
	Лог(Сообщение, "");

	Возврат Истина;

КонецФункции

&НаСервере
Процедура Лог(Знач Комментарий, Знач Уровень = "Ошибка")

	Если Не ЗначениеЗаполнено(Уровень) Тогда
		Уровень = "Информация";
	КонецЕсли;

	УровеньЖР = УровеньЖурналаРегистрации.Информация;
	Если НРег(Уровень) = "ошибка" Тогда
		УровеньЖР = УровеньЖурналаРегистрации.Ошибка;
	ИначеЕсли НРег(Уровень) = "предупреждение" Тогда
		УровеньЖР = УровеньЖурналаРегистрации.Предупреждение;
	КонецЕсли;

	СообщениеПользователю = Новый СообщениеПользователю;
	СообщениеПользователю.Текст = Уровень + ": " + Комментарий;
	СообщениеПользователю.Сообщить();

	ЗаписьЖурналаРегистрации(КлючЖР(), УровеньЖР, Неопределено, Неопределено, Комментарий);

КонецПроцедуры

&НаСервере
Функция КлючЖР()
	Возврат "VanessaRunner.СозданиеПользователей";
КонецФункции

#КонецОбласти