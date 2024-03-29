///////////////////////////////////////////////////////////////////
//
// Служебный модуль с набором методов работы с командами приложения
//
// Структура модуля реализована в соответствии с рекомендациями
// oscript-app-template (C) EvilBeaver
//
///////////////////////////////////////////////////////////////////

#Использовать v8runner
#Использовать asserts

Перем Лог;

///////////////////////////////////////////////////////////////////////////////////////////////////
// Прикладной интерфейс

Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт

	ТекстОписания =
		"     Загрузка расширения в конфигурацию из папки исходников.";

	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды, ТекстОписания);

	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "inputPath", "Путь к исходникам расширения");
	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "extensionName",
		"Имя расширения, под которым оно будет зарегистрировано в списке расширений");
	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--updatedb", "Признак обновления расширения");
	Парсер.ДобавитьКоманду(ОписаниеКоманды);

КонецПроцедуры // ЗарегистрироватьКоманду

// Выполняет логику команды
//
// Параметры:
//   ПараметрыКоманды - Соответствие - Соответствие ключей командной строки и их значений
//   ДополнительныеПараметры - Соответствие - дополнительные параметры (необязательно)
//
Функция ВыполнитьКоманду(Знач ПараметрыКоманды, Знач ДополнительныеПараметры = Неопределено) Экспорт

	Лог = ДополнительныеПараметры.Лог;

	ДанныеПодключения = ПараметрыКоманды["ДанныеПодключения"];

	Попытка
		Лог = ДополнительныеПараметры.Лог;
	Исключение
		Лог = Логирование.ПолучитьЛог(ПараметрыСистемы.ИмяЛогаСистемы());
	КонецПопытки;

	МенеджерКонфигуратора = Новый МенеджерКонфигуратора;

	Попытка
		МенеджерКонфигуратора.Конструктор(ДанныеПодключения, ПараметрыКоманды);

		МенеджерКонфигуратора.СобратьИзИсходниковРасширение(
			ОбщиеМетоды.ПолныйПуть(ПараметрыКоманды["inputPath"]),
			ПараметрыКоманды["extensionName"], ПараметрыКоманды["--updatedb"]);
	Исключение
		МенеджерКонфигуратора.Деструктор();
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;

	МенеджерКонфигуратора.Деструктор();

	Возврат МенеджерКомандПриложения.РезультатыКоманд().Успех;

КонецФункции // ВыполнитьКоманду
