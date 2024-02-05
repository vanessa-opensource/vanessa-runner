///////////////////////////////////////////////////////////////////
//
// Служебный модуль с набором методов работы с командами приложения
//
// Структура модуля реализована в соответствии с рекомендациями
// oscript-app-template (C) EvilBeaver
//
///////////////////////////////////////////////////////////////////

#Использовать asserts

Перем Лог;

///////////////////////////////////////////////////////////////////////////////////////////////////
// Прикладной интерфейс

Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт

	ТекстОписания =
		"     Разборка конфигурации в исходники.";

	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды, ТекстОписания);

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--out",
		"Путь к каталогу с исходниками, пример: --out=./cf");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "-o",
		"Краткая команда 'путь к исходникам --out', пример: -o ./cf");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--in", "Путь к файлу cf (*.cf), --in=./1Cv8.cf");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "-i",
		"Краткая команда 'Путь к файлу cf --in', пример: -i ./1Cv8.cf");
	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--current", "Флаг выгрузки из текущей базы или -с");
	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "-c", "Флаг выгрузки из текущей базы, краткая форма от --current");
	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--userenames", "Использовать файл переименований renames");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "-v", "Путь к файлу версии (ConfigDumpInfo.xml или его копия), краткая от --versions");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--versions", "Путь к файлу версии (ConfigDumpInfo.xml или его копия) или -v");

	Парсер.ДобавитьКоманду(ОписаниеКоманды);

КонецПроцедуры // ЗарегистрироватьКоманду

// Выполняет логику команды
//
// Параметры:
//   ПараметрыКоманды - Соответствие - Соответствие ключей командной строки и их значений
//   ДополнительныеПараметры - Соответствие - дополнительные параметры (необязательно)
//
Функция ВыполнитьКоманду(Знач ПараметрыКоманды, Знач ДополнительныеПараметры = Неопределено) Экспорт

	Попытка
		Лог = ДополнительныеПараметры.Лог;
	Исключение
		Лог = Логирование.ПолучитьЛог(ПараметрыСистемы.ИмяЛогаСистемы());
	КонецПопытки;

	ДанныеПодключения = ПараметрыКоманды["ДанныеПодключения"];

	ПутьВходящий = ОбщиеМетоды.ПолныйПуть(ОбщиеМетоды.ПолучитьПараметры(ПараметрыКоманды, "-i", "--in"));
	ПутьИсходящий = ОбщиеМетоды.ПолныйПуть(ОбщиеМетоды.ПолучитьПараметры(ПараметрыКоманды, "-o", "--out"));
	ВерсияПлатформы = ПараметрыКоманды["--v8version"];
	ФайлВерсии = ОбщиеМетоды.ПолныйПуть(ОбщиеМетоды.ПолучитьПараметры(ПараметрыКоманды, "-v", "--versions"));
	СтрокаПодключения = ДанныеПодключения.СтрокаПодключения;
	ИспользоватьПереименования = ПараметрыКоманды["--userenames"];

	МенеджерКонфигуратора = Новый МенеджерКонфигуратора;

	Попытка
		ИзТекущейКонфигурации = ОбщиеМетоды.ЕстьФлагКоманды(ПараметрыКоманды, "-c", "--current");
		ИзТекущейКонфигурации = ?(ИзТекущейКонфигурации, ИзТекущейКонфигурации,
			НЕ (ЗначениеЗаполнено(ПутьВходящий) И Новый Файл(ПутьВходящий).Существует()));
		ИзТекущейКонфигурации = ИзТекущейКонфигурации
			Или (Не ЗначениеЗаполнено(ПутьВходящий) ИЛИ Не Новый Файл(ПутьВходящий).Существует());

		ТолькоИзмененные = ?(ИспользоватьПереименования, Ложь, Истина);
		Если ИзТекущейКонфигурации Тогда

			Лог.Информация("Запускаю выгрузку конфигурации в исходники");

			МенеджерКонфигуратора.Конструктор(ДанныеПодключения, ПараметрыКоманды);

			МенеджерКонфигуратора.РазобратьНаИсходникиТекущуюКонфигурацию(ПутьИсходящий, ФайлВерсии,
				ТолькоИзмененные, ИспользоватьПереименования);

		Иначе

			КаталогВременнойИБ = ВременныеФайлы.СоздатьКаталог();
			СтрокаПодключения = "/F" + КаталогВременнойИБ;
			МенеджерКонфигуратора.Инициализация(ПараметрыКоманды, СтрокаПодключения, , ,
				ВерсияПлатформы, ПараметрыКоманды["--uccode"],
				ДанныеПодключения.КодЯзыка, ДанныеПодключения.КодЯзыкаСеанса);
			МенеджерКонфигуратора.УправлениеКонфигуратором().СоздатьФайловуюБазу(КаталогВременнойИБ);

			МенеджерКонфигуратора.ВыгрузитьКонфигурациюВИсходники(ПутьВходящий, ПутьИсходящий, ФайлВерсии,
				ИспользоватьПереименования);
			ВременныеФайлы.УдалитьФайл(КаталогВременнойИБ);

		КонецЕсли;

	Исключение
		МенеджерКонфигуратора.Деструктор();
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;

	МенеджерКонфигуратора.Деструктор();

	Возврат МенеджерКомандПриложения.РезультатыКоманд().Успех;
КонецФункции // ВыполнитьКоманду
