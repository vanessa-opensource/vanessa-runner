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

Функция ПолучитьПарсерКоманднойСтроки()

	Парсер = Новый ПарсерАргументовКоманднойСтроки();

	МенеджерКомандПриложения.ЗарегистрироватьКоманды(Парсер);

	Возврат Парсер;

КонецФункции // ПолучитьПарсерКоманднойСтроки

Функция ВыполнениеКоманды()

	ПроверитьПодключениеВанессаАДД();

	ПараметрыЗапуска = РазобратьАргументыКоманднойСтроки();

	Если Не ЗначениеЗаполнено(ПараметрыЗапуска) Тогда

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

	Возврат МенеджерКомандПриложения.ВыполнитьКоманду(Команда, ЗначенияПараметров);

КонецФункции // ВыполнениеКоманды()

Процедура ПроверитьПодключениеВанессаАДД()
	ДопТекстОшибки = "Команда тестирования xunit недоступна
	|Команда проверки поведения vanessa недоступна";
	ОбщиеМетоды.ЗагрузитьВанессаАДД(ДопТекстОшибки);
КонецПроцедуры

Процедура ВывестиВерсию()

	Сообщить(СтрШаблон("%1 v%2", ПараметрыСистемы.ИмяПродукта(), ПараметрыСистемы.ВерсияПродукта()));

КонецПроцедуры

Функция РазобратьАргументыКоманднойСтроки()

	Парсер = ПолучитьПарсерКоманднойСтроки();
	Возврат Парсер.Разобрать(АргументыКоманднойСтроки);

КонецФункции

Функция Форматировать(Знач Уровень, Знач Сообщение) Экспорт

	Возврат СтрШаблон("%1: %2 - %3", ТекущаяДата(), УровниЛога.НаименованиеУровня(Уровень), Сообщение);

КонецФункции

///////////////////////////////////////////////////////////////////

Инициализация();

ЛогУжеЗакрыт = Ложь;

Попытка

	КодВозврата = ВыполнениеКоманды();

	ВременныеФайлы.Удалить();

	Лог.Закрыть();
	ЛогУжеЗакрыт = Истина;

	ЗавершитьРаботу(КодВозврата);

Исключение

	ИнфоОшибки = ИнформацияОбОшибке();
	Если Не ЛогУжеЗакрыт Тогда
		Если ЗначениеЗаполнено(ИнфоОшибки.Параметры) Тогда
			Если ЗначениеЗаполнено(ИнфоОшибки.Параметры.Предупреждение) Тогда
				Лог.Предупреждение(ИнфоОшибки.Параметры.Предупреждение);
			КонецЕсли;
			Лог.Ошибка(ИнфоОшибки.Описание);
		Иначе
			Лог.КритичнаяОшибка(ОписаниеОшибки());
		КонецЕсли;
	КонецЕсли;

	ВременныеФайлы.Удалить();
	Если Не ЛогУжеЗакрыт Тогда
		Лог.Закрыть();
	КонецЕсли;

	ЗавершитьРаботу(МенеджерКомандПриложения.РезультатыКоманд().ОшибкаВремениВыполнения);

КонецПопытки;
