///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Захват объектов в хранилище 1С.
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
		"     Захват объектов в хранилище 1С.";

	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды, ТекстОписания);
	
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--storage-name", "Строка подключения к хранилищу");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--storage-user", "Пользователь хранилища");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--storage-pwd", "Пароль");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--objects",	"Имя файла со списком объектов. 
	|              Путь к файлу формата XML со списком объектов. 
	|              Если опция используется, будет выполнена попытка захватить только объекты, указанные в файле.
	|              Если опция не используется, будут захвачены все объекты конфигурации. 
	|              Если в списке указаны объекты, захваченные другим пользователем, эти объекты не будут захвачены и будет выдана ошибка. При этом доступные для захвата объекта будут захвачены.
	|              Подробнее о формате файла см в документации http://its.1c.ru/db/v8310doc#bookmark:adm:TI000000564 .");
	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--revised", "Получать захваченные объекты");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--extension", "Имя расширения");

	Парсер.ДобавитьКоманду(ОписаниеКоманды);
	
КонецПроцедуры // ЗарегистрироватьКоманду

// Выполняет логику команды
// 
// Параметры:
//   ПараметрыКоманды - Соответствие - Соответствие ключей командной строки и их значений
//   ДополнительныеПараметры - Соответствие - дополнительные параметры (необязательно)
//
// Возвращаемое значение:
//   Булево - Истина, если команда выполнена успешно
Функция ВыполнитьКоманду(Знач ПараметрыКоманды, Знач ДополнительныеПараметры = Неопределено) Экспорт
	
	Лог = ДополнительныеПараметры.Лог;
	
	ДанныеПодключения = ПараметрыКоманды["ДанныеПодключения"];
	
	МенеджерКонфигуратора = Новый МенеджерКонфигуратора;
	
	МенеджерКонфигуратора.Инициализация( ДанныеПодключения.СтрокаПодключения,
		ДанныеПодключения.Пользователь,
		ДанныеПодключения.Пароль,
		ПараметрыКоманды["--v8version"],
		ПараметрыКоманды["--uccode"],
		ДанныеПодключения.КодЯзыка);

Попытка
	
	// сперва получим все изменения
	МенеджерКонфигуратора.ЗапуститьОбновлениеИзХранилища(
		ПараметрыКоманды["--storage-name"],
		ПараметрыКоманды["--storage-user"],
		ПараметрыКоманды["--storage-pwd"], ,
		ПараметрыКоманды["--extension"]);
	МенеджерКонфигуратора.ЗахватитьОбъектыВХранилище(
		ПараметрыКоманды["--storage-name"],
		ПараметрыКоманды["--storage-user"],
		ПараметрыКоманды["--storage-pwd"],
		ПараметрыКоманды["--objects"],
		ПараметрыКоманды["--revised"],
		ПараметрыКоманды["--extension"]);
	
Исключение
	
	МенеджерКонфигуратора.Деструктор();
	ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	
КонецПопытки;

	МенеджерКонфигуратора.Деструктор();

	Возврат МенеджерКомандПриложения.РезультатыКоманд().Успех;

КонецФункции // ВыполнитьКоманду
