///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Выполнение загрузки cf файла в базу данных
//
// TODO добавить фичи для проверки команды
//
// Служебный модуль с набором методов работы с командами приложения
//
// Структура модуля реализована в соответствии с рекомендациями
// oscript-app-template (C) EvilBeaver
//
///////////////////////////////////////////////////////////////////////////////////////////////////

#Использовать logos
#Использовать v8runner

Перем Лог;
Перем МенеджерКонфигуратора;

///////////////////////////////////////////////////////////////////////////////////////////////////
// Прикладной интерфейс

Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт

	ТекстОписания =
		"     Загрузка cf-файла в базу.";

	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды,
		ТекстОписания);

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--src", "Путь к файлу cf, пример: --src=./1Cv8.cf");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "-s",
		"Краткая команда 'путь к cf --src', пример: -s ./1Cv8.cf
		|       В пути файла можно указать шаблонную переменную $version для подстановки в нее версии конфигурации
		|       Пример: 1Cv8_$version.cf выгрузит файл вида 1Cv8_1.2.3.4.cf");

	Парсер.ДобавитьКоманду(ОписаниеКоманды);

КонецПроцедуры // ЗарегистрироватьКоманду

// Выполняет логику команды
//
// Параметры:
//   ПараметрыКоманды - Соответствие - Соответствие ключей командной строки и их значений
//   ДополнительныеПараметры - Соответствие - дополнительные параметры (необязательно)
//
// Возвращаемое значение:
//	Число - Результат выполенения команды
//
Функция ВыполнитьКоманду(Знач ПараметрыКоманды, Знач ДополнительныеПараметры = Неопределено) Экспорт

	Попытка
		Лог = ДополнительныеПараметры.Лог;
	Исключение
		Лог = Логирование.ПолучитьЛог(ПараметрыСистемы.ИмяЛогаСистемы());
	КонецПопытки;

	ДанныеПодключения = ПараметрыКоманды["ДанныеПодключения"];

	ПутьВходящий = ОбщиеМетоды.ПолныйПуть(ОбщиеМетоды.ПолучитьПараметры(ПараметрыКоманды, "-s", "--src"));
	МенеджерВерсий = Новый МенеджерВерсийФайлов1С();
	ПутьВходящийСВерсией = МенеджерВерсий.НайтиФайлСВерсией(ПутьВходящий);

	МенеджерКонфигуратора = Новый МенеджерКонфигуратора;

	Попытка
		МенеджерКонфигуратора.Конструктор(ДанныеПодключения, ПараметрыКоманды);

		МенеджерКонфигуратора.ЗагрузитьФайлКонфигурации(ПутьВходящийСВерсией);
	Исключение
		МенеджерКонфигуратора.Деструктор();
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;

	МенеджерКонфигуратора.Деструктор();

	Возврат МенеджерКомандПриложения.РезультатыКоманд().Успех;
КонецФункции
