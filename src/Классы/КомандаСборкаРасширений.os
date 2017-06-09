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
		"     загружаем расширение в конфигурацию из папки исходников
		|     ";

	ОписаниеКоманды = Парсер.ОписаниеКоманды(ПараметрыСистемы.ВозможныеКоманды().СборкаРасширений, ТекстОписания);

	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "inputPath", "Путь к исходникам расширения");
	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "extensionName", "Имя расширения, под которым оно будет зарегистрировано в списке расширений");
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

	СобратьИзИсходниковРасширение(ОбщиеМетоды.ПолныйПуть(ПараметрыКоманды["inputPath"]), 
					ПараметрыКоманды["extensionName"],
					ПараметрыКоманды["--ibname"], ПараметрыКоманды["--db-user"], ПараметрыКоманды["--db-pwd"],
					ПараметрыКоманды["--v8version"]);

	Возврат МенеджерКомандПриложения.РезультатыКоманд().Успех;
КонецФункции // ВыполнитьКоманду

Процедура СобратьИзИсходниковРасширение(Каталог, ИмяРасширения, Знач СтрокаПодключения="", Знач Пользователь="", Знач Пароль="", Знач ВерсияПлатформы="")

	Лог.Информация("Выполняю сборку/загрузку расширения %1 из каталога %2", ИмяРасширения, Каталог);
	Ожидаем.Что(СтрокаПодключения, "Ожидаем, что строка подключения к ИБ задана, а это не так").Заполнено();

	МенеджерКонфигуратора = Новый МенеджерКонфигуратора;
	МенеджерКонфигуратора.Инициализация(СтрокаПодключения, Пользователь, Пароль, ВерсияПлатформы);

	УправлениеКонфигуратором = МенеджерКонфигуратора.УправлениеКонфигуратором();
	
	ПараметрыЗапуска = УправлениеКонфигуратором.ПолучитьПараметрыЗапуска();
	ПараметрыЗапуска.Добавить("/Visible");
	ПараметрыЗапуска.Добавить("/LoadConfigFromFiles """ + Каталог + """");
	ПараметрыЗапуска.Добавить("-Extension """ + ИмяРасширения + """");
	ПараметрыЗапуска.Добавить("/UpdateDBCfg");
	УправлениеКонфигуратором.ВыполнитьКоманду(ПараметрыЗапуска);

	Лог.Информация("Сборка/загрузка расширения завершена");

	МенеджерКонфигуратора.ПоказатьСписокВсехРасширенийКонфигурации();
	
	МенеджерКонфигуратора.Деструктор();
КонецПроцедуры
