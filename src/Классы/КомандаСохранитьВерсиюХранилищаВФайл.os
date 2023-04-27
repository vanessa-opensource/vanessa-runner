///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Выгрузить файл конфигурации определенной версии из хранилища 1С
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
		"     Выгрузка файла конфигурации определенной версии из хранилища 1С.";

	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды,
		ТекстОписания);

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--storage-name", "Строка подключения к хранилищу");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--storage-user", "Пользователь хранилища");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--storage-pwd", "Пароль");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--storage-ver",
		"Номер версии, по умолчанию берем последнюю");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--out", "Путь к файлу cf (*.cf), --out=./1Cv8.cf");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "-o",
		"Краткая команда 'Путь к файлу cf --out', пример: -o ./1Cv8.cf");

	Парсер.ДобавитьКоманду(ОписаниеКоманды);

КонецПроцедуры

// Выполняет логику команды
//
// Параметры:
//   ПараметрыКоманды - Соответствие - Соответствие ключей командной строки и их значений
//   ДополнительныеПараметры - Соответствие - дополнительные параметры (необязательно)
//
Функция ВыполнитьКоманду(Знач ПараметрыКоманды, Знач ДополнительныеПараметры = Неопределено) Экспорт

	Лог = ДополнительныеПараметры.Лог;

	ЛогинПользователя = ПараметрыКоманды["--storage-user"];
	ПарольПользователя = ПараметрыКоманды["--storage-pwd"];

	ПутьИсходящий = ОбщиеМетоды.ПолныйПуть(ОбщиеМетоды.ПараметрФлагКоманды(ПараметрыКоманды,"-o", "--out"));


	Ожидаем.Что(ЛогинПользователя, " не задан логин создаваемого пользователя хранилища").Заполнено();
	Ожидаем.Что(ПарольПользователя, " не задан пароль создаваемого пользователя хранилища").Заполнено();

	ДанныеПодключения = ПараметрыКоманды["ДанныеПодключения"];

	МенеджерКонфигуратора = Новый МенеджерКонфигуратора;
	МенеджерКонфигуратора.КонструкторДляНеобязательнойСтрокиСоединения(ДанныеПодключения, ПараметрыКоманды);

	Попытка
		МенеджерКонфигуратора.СохранитьВерсиюХранилищаВФайл(
			ПараметрыКоманды["--storage-name"], ЛогинПользователя, ПарольПользователя,
			ПараметрыКоманды["--storage-ver"], ПутьИсходящий);
	Исключение
		МенеджерКонфигуратора.Деструктор();
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;

	МенеджерКонфигуратора.Деструктор();

	Возврат МенеджерКомандПриложения.РезультатыКоманд().Успех;
КонецФункции
