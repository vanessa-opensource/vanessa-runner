///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Формирование отчета о сравнении основной конфигурации с файлом или двух файлов конфигураций
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
		"     Формирование файла отчета сравнения конфигураций.";

	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды, ТекстОписания);

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--secondFile",
		"Путь к файлу cf/cfe, с которым идёт сравнение конфигурации. Обязательный параметр.");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--reportFile",
		"Путь к файлу, где должен быть сохранён отчет. Обязательный параметр.");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--reportType",
		"Тип отчёта о сравнении: по-умолчанию Full (полный) или указать Brief (краткий)");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--reportFormat",
		"Формат файла отчета: по-умолчанию txt или указать mxl");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--extensionName",
		"Имя расширения, если надо сравнить его вместо основной конфигурации");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--firstFile",
		"Путь к первому файлу cf/cfe: если не указать - используется основная конфигурация (расширение)");

	Парсер.ДобавитьКоманду(ОписаниеКоманды);

КонецПроцедуры // ЗарегистрироватьКоманду

// Выполняет логику команды
//
// Параметры:
//   ПараметрыКоманды 		 - Соответствие - Соответствие ключей командной строки и их значений
//   ДополнительныеПараметры - Соответствие - дополнительные параметры (необязательно)
//
Функция ВыполнитьКоманду(Знач ПараметрыКоманды, Знач ДополнительныеПараметры = Неопределено) Экспорт

	Попытка
		Лог = ДополнительныеПараметры.Лог;
	Исключение
		Лог = Логирование.ПолучитьЛог(ПараметрыСистемы.ИмяЛогаСистемы());
	КонецПопытки;

	Лог.Информация("Начинаю сравнение конфигураций");

	ДанныеПодключения = ПараметрыКоманды["ДанныеПодключения"];

	ПутьКФайлуКонфигурации = ОбщиеМетоды.ПолныйПуть(ПараметрыКоманды["--secondFile"]);
	ПутьКОтчету = ОбщиеМетоды.ПолныйПуть(ПараметрыКоманды["--reportFile"]);
	ТипОтчета = ПараметрыКоманды["--reportType"];
	ФорматОтчета = ПараметрыКоманды["--reportFormat"];
	ИмяРасширения = ПараметрыКоманды["--extensionName"];
	ПутьКФайлуПервойКонфигурации = ОбщиеМетоды.ПолныйПуть(ПараметрыКоманды["--firstFile"]);

	Лог.Отладка("ПутьКФайлуКонфигурации %1", ПутьКФайлуКонфигурации);
	Лог.Отладка("ТипОтчета %1", ТипОтчета);
	Лог.Отладка("ФорматОтчета %1", ФорматОтчета);
	Лог.Отладка("ПутьКОтчету %1", ПутьКОтчету);
	Лог.Отладка("ИмяРасширения %1", ИмяРасширения);
	Лог.Отладка("ПутьКФайлуПервойКонфигурации %1", ПутьКФайлуПервойКонфигурации);

	Если Не ЗначениеЗаполнено(ПутьКФайлуКонфигурации) Тогда
		ВызватьИсключение "Необходимо задать путь к файлу cf/cfe, с которым идёт сравнение,
		|Параметр --secondFile является обязательным.";
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ПутьКОтчету) Тогда
		ВызватьИсключение "Необходимо задать путь к файлу сохранения отчета,
		|Параметр --reportFile является обязательным.";
	КонецЕсли;

	МенеджерКонфигуратора = Новый МенеджерКонфигуратора;

	Попытка
		МенеджерКонфигуратора.Конструктор(ДанныеПодключения, ПараметрыКоманды);

		УправлениеКонфигуратором = МенеджерКонфигуратора.УправлениеКонфигуратором();

		Если ЗначениеЗаполнено(ТипОтчета) И НРег(ТипОтчета) <> "full" Тогда
			ТипОтчета = ТипыОтчетовОСравнении.Краткий;
		Иначе
			ТипОтчета = ТипыОтчетовОСравнении.Полный;
		КонецЕсли;

		Если ЗначениеЗаполнено(ФорматОтчета) И НРег(ФорматОтчета) <> "txt" Тогда
			ФорматОтчета = "mxl";
		Иначе
			ФорматОтчета = "txt";
		КонецЕсли;

		Если НЕ ЗначениеЗаполнено(ПутьКФайлуПервойКонфигурации) Тогда
			ПутьКФайлуПервойКонфигурации = Неопределено;
		КонецЕсли;

		УправлениеКонфигуратором.ПолучитьОтчетОСравненииКонфигурацииСФайлом(ПутьКФайлуКонфигурации, ПутьКОтчету,
				ТипОтчета, ФорматОтчета, ИмяРасширения, ПутьКФайлуПервойКонфигурации);	

		Лог.Информация(УправлениеКонфигуратором.ВыводКоманды());

		Лог.Информация("Успешно завершено сравнение конфигураций");

	Исключение
		МенеджерКонфигуратора.Деструктор();
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;

	МенеджерКонфигуратора.Деструктор();

	Возврат МенеджерКомандПриложения.РезультатыКоманд().Успех;

КонецФункции // ВыполнитьКоманду
