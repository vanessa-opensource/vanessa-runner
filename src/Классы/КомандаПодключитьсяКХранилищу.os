///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Подключение ИБ к хранилищу конфигурации 1С.
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

Перем Лог;

///////////////////////////////////////////////////////////////////////////////////////////////////
// Прикладной интерфейс

Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт

	ТекстОписания = 
		"     Подключение ИБ к хранилищу конфигурации 1С.";

	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды, 
		ТекстОписания);
	
//	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "ПутьПодключаемогоХранилища", 
//		"Строка подключения к хранилищу
//		|	(возможно указание как файлового пути, так и пути через http или tcp)");
//	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "Логин", "Логин пользователя хранилища 1С");
//	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "Пароль", "Пароль пользователя хранилища 1С");
	
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--storage-name", "Строка подключения к хранилищу");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--storage-user", "Пользователь хранилища");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--storage-pwd", "Пароль");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--storage-ver",
		"Номер версии, по умолчанию берем последнюю");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--extension",
		"Имя расширения, которое нужно обновить");
	
	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--BindAlreadyBindedUser", 
		"Флаг игнорирования наличия уже у пользователя уже подключенной базы данных.");
	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--NotReplaceCfg", 
		"Флаг запрета замены конфигурации БД на конфигурацию хранилища.");
	
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--extension", "Имя расширения, которое нужно подключить");
	
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
	СтрокаПодключения = ДанныеПодключения.СтрокаПодключения;
	Если Не ЗначениеЗаполнено(СтрокаПодключения) Тогда
		СтрокаПодключения = "/F";
	КонецЕсли;
	
	МенеджерКонфигуратора = Новый МенеджерКонфигуратора;

	МенеджерКонфигуратора.Инициализация(
		СтрокаПодключения, ДанныеПодключения.Пользователь, ДанныеПодключения.Пароль,
		ПараметрыКоманды["--v8version"], ПараметрыКоманды["--uccode"],
		ДанныеПодключения.КодЯзыка
		);

	ИгнорироватьНаличиеПодключеннойБД = ПараметрыКоманды["--BindAlreadyBindedUser"];
	ЗаменитьКонфигурациюБД = Не ПараметрыКоманды["--NotReplaceCfg"];

	Попытка
		МенеджерКонфигуратора.ПодключитьсяКХранилищу(
//			ПараметрыКоманды["ПутьПодключаемогоХранилища"], ПараметрыКоманды["Логин"], 
//			ПараметрыКоманды["Пароль"], ИгнорироватьНаличиеПодключеннойБД,
			ПараметрыКоманды["--storage-name"], ПараметрыКоманды["--storage-user"],
			ПараметрыКоманды["--storage-pwd"], ИгнорироватьНаличиеПодключеннойБД,
			ЗаменитьКонфигурациюБД, ПараметрыКоманды["--extension"]);
	Исключение
		МенеджерКонфигуратора.Деструктор();
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;

	МенеджерКонфигуратора.Деструктор();

	Возврат МенеджерКомандПриложения.РезультатыКоманд().Успех;
КонецФункции // ВыполнитьКоманду
