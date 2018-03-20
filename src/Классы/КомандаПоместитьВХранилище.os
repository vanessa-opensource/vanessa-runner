///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Помещение объектов в хранилище 1С.
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
		"     Помещение изменений объектов в хранилище конфигурации.
		|     ";

	ОписаниеКоманды = Парсер.ОписаниеКоманды(ПараметрыСистемы.ВозможныеКоманды().ПоместитьВХранилище, 
		ТекстОписания);
	
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--storage-name", "Строка подключения к хранилище");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--storage-user", "Пользователь хранилища");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--storage-pwd", "Пароль");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--objects",	"Имя файла со списком объектов. 
	|              Путь к файлу формата XML со списком объектов.
	|              Если опция используется, будет выполнена попытка поместить только объекты, указанные в файле.
	|              Если опция не используется, будут помещены изменения всех объектов конфигурации.
	|              При наличии в списке объектов, не захваченных текущим пользователем или захваченных другим пользователем, ошибка выдана не будет.
	|              Подробнее о формате файла см в документации http://its.1c.ru/db/v838doc#bookmark:adm:TI000000564");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--comment", "Текст комментария");
	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--keepLocked", "Оставлять захват для помещенных объектов");
	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--force", "если опция используется, при обнаружении ссылок на удаленные объекты будет выполнена попытка их очистить.
	|               Если опция не указана, при обнаружении ссылок на удаленные объекты будет выдана ошибка");

	Парсер.ДобавитьКоманду(ОписаниеКоманды);
	
КонецПроцедуры // ЗарегистрироватьКоманду

// Выполняет логику команды
// 
// Параметры:
//   ПараметрыКоманды - Соответствие - Соответствие ключей командной строки и их значений
//   ДополнительныеПараметры (необязательно) - Соответствие - дополнительные параметры
//
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
	
	МенеджерКонфигуратора.ПоместитьИзмененияОбъектовВХранилище(
		ПараметрыКоманды["--storage-name"],
		ПараметрыКоманды["--storage-user"],
		ПараметрыКоманды["--storage-pwd"],
		ПараметрыКоманды["--objects"],
		ПараметрыКоманды["--comment"],
		ПараметрыКоманды["--keepLocked"],
		ПараметрыКоманды["--force"]);
	
Исключение
	
	МенеджерКонфигуратора.Деструктор();
	ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	
КонецПопытки;

	МенеджерКонфигуратора.Деструктор();

	Возврат МенеджерКомандПриложения.РезультатыКоманд().Успех;

КонецФункции // ВыполнитьКоманду
