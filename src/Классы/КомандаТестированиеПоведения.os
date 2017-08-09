///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Запуск тестирования через фреймворк vanessa-behavior
//
// Пример строки запуска:
// 	oscript src/main.os vanessa --pathvanessa ".\vanessa-behavior\vanessa-behavior.epf" --ibname /F./build/ib --vanessasettings ./examples\.vb-conf.json
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
#Использовать asserts
#Использовать json

Перем Лог;

///////////////////////////////////////////////////////////////////////////////////////////////////
// Прикладной интерфейс

Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт

	ТекстОписания = 
		"     Запуск тестирования через фреймворк vanessa-behavior
		|     ";

	ОписаниеКоманды = Парсер.ОписаниеКоманды(ПараметрыСистемы.ВозможныеКоманды().ТестироватьПоведение, 
		ТекстОписания);

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--pathvanessa", 
		"[env RUNNER_PATHVANESSA] путь к внешней обработке, по умолчанию vendor/vanessa-behavior/vanessa-behavior.epf
		|           или переменная окружения RUNNER_PATHVANESSA");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--vanessasettings", 
		"[env RUNNER_VANESSASETTINGS] путь к файлу настроек");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--workspace", 
		"[env RUNNER_WORKSPACE] путь к папке, относительно которой будут определятся макросы $workspace.
		|                 по умолчанию текущий.");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--additional", 
		"Дополнительные параметры для запуска предприятия.");
	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--no-wait", 
		"Не ожидать завершения запущенной команды/действия");

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

	ЗапускатьТолстыйКлиент = ОбщиеМетоды.УказанПараметрТолстыйКлиент(ПараметрыКоманды["--ordinaryapp"], Лог);
	ОжидатьЗавершения = Не ПараметрыКоманды["--no-wait"];

	ЗапуститьТестироватьПоведение(ОбщиеМетоды.ПолныйПуть(ПараметрыКоманды["--workspace"]),
					ДанныеПодключения.СтрокаПодключения, ДанныеПодключения.Пользователь, ДанныеПодключения.Пароль,
					ОбщиеМетоды.ПолныйПуть(ПараметрыКоманды["--vanessasettings"]), 
					ОбщиеМетоды.ПолныйПуть(ПараметрыКоманды["--pathvanessa"]),
					ЗапускатьТолстыйКлиент, ОжидатьЗавершения,
					ПараметрыКоманды["--additional"], ПараметрыКоманды["--v8version"]
					);

	Возврат МенеджерКомандПриложения.РезультатыКоманд().Успех;
КонецФункции // ВыполнитьКоманду

// Выполняем запуск тестов для vannessa 
//
// Параметры:
//	РабочийКаталогПроекта - <Строка> - Путь к каталогу с проектом, по умолчанию каталог ./build/out
//  СтрокаПодключения - <Строка> - Строка подключения к БД
//  Пользователь - <Строка> - Пользователь
//  Пароль - <Строка> - Пароль для пользователя
//  ПутьКНастройкам - <Строка> - Путь к файлу настроек запуска тестов
//  ПутьКИнструментам - <Строка> - путь к инструментам, по умолчанию ./vendor/vanessa-behavior
//  ТолстыйКлиент - <Булево> - признак запуска толстого клиента
//  ДопПараметры - <Строка> - дополнительные параметры для передачи в параметры запуска 1с, например /DebugURLtcp://localhost
//  ВерсияПлатформы - <Строка> - Версия платформы
//
Процедура ЗапуститьТестироватьПоведение(Знач РабочийКаталогПроекта = "./build/out", 
										Знач СтрокаПодключения, Знач Пользователь="", Знач Пароль="", 
										Знач ПутьКНастройкам = "", Знач ПутьКИнструментам="", Знач ТолстыйКлиент = Ложь, 
										Знач ОжидатьЗавершения = Истина, Знач ДопПараметры="", Знач ВерсияПлатформы = "") 

	Лог.Информация("Тестирую поведение с помощью фреймворка vanessa-behavior");
	Ожидаем.Что(СтрокаПодключения, "Ожидаем, что строка подключения к ИБ задана, а это не так").Заполнено();

	Конфигуратор = Новый УправлениеКонфигуратором();

	Если РабочийКаталогПроекта = Неопределено Тогда 
		РабочийКаталогПроекта = "./build/out";
	КонецЕсли;
	РабочийКаталогПроекта = ОбщиеМетоды.ПолныйПуть(РабочийКаталогПроекта);
	
	КаталогВременнойИБ = ВременныеФайлы.СоздатьКаталог();
	Конфигуратор.КаталогСборки(КаталогВременнойИБ);
	
	Конфигуратор.УстановитьКонтекст(СтрокаПодключения, Пользователь, Пароль);
	Если НЕ ПустаяСтрока(ВерсияПлатформы) Тогда
		Конфигуратор.ИспользоватьВерсиюПлатформы(ВерсияПлатформы);
	КонецЕсли;
	//Конфигуратор.ПутьКПлатформе1С(Конфигуратор.ПутьКТонкомуКлиенту1С());
	Если ПустаяСтрока(ПутьКИнструментам) Тогда
		ПутьКИнструментам = "./vanessa-behavior/vanessa-behavior.epf";
	КонецЕсли;

	ПутьКИнструментам = ОбщиеМетоды.ПолныйПуть(ПутьКИнструментам);
	
	Настройки = ПрочитатьНастройки(ПутьКНастройкам);

	ПутьКФайлуСтатусаВыполнения = ПолучитьНастройку(Настройки, "ПутьКФайлуДляВыгрузкиСтатусаВыполненияСценариев", 
								"./build/buildstatus.log", РабочийКаталогПроекта, "путь к файлу статуса выполнения");

	ПутьЛогаВыполненияСценариев = ПолучитьНастройку(Настройки, "ИмяФайлаЛогВыполненияСценариев", 
								"./build/vanessaonline.txt", РабочийКаталогПроекта, "путь к лог-файлу выполнения");

	ОбщиеМетоды.УдалитьФайлЕслиОнСуществует(ПутьКФайлуСтатусаВыполнения);
	ОбщиеМетоды.УдалитьФайлЕслиОнСуществует(ПутьЛогаВыполненияСценариев);

	КлючЗапуска = """StartFeaturePlayer;VBParams=" + ПутьКНастройкам +";workspaceRoot=" + РабочийКаталогПроекта + """";
	Лог.Отладка(КлючЗапуска);
	ДополнительныеКлючи = " /Execute""" + ПутьКИнструментам + """ /TESTMANAGER ";
	
	Попытка
		ПараметрыСвязиСБазой = Конфигуратор.ПолучитьПараметрыЗапуска();
		ПараметрыСвязиСБазой[0] = "ENTERPRISE";
		ПараметрыСвязиСБазой.Удалить(2);
		ПараметрыСвязиСБазой.Добавить("/C"+КлючЗапуска);

		путьДамп = ПолучитьИмяВременногоФайла("txt");
		ПараметрыСвязиСБазой.Добавить("/out"""+путьДамп+"""");

		Если ДополнительныеКлючи <> Неопределено Тогда
			ПараметрыСвязиСБазой.Добавить(ДополнительныеКлючи);
		КонецЕсли;

		СтрокаЗапуска = ""; СтрокаДляЛога = "";
		Для Каждого Параметр Из ПараметрыСвязиСБазой Цикл
			СтрокаЗапуска = СтрокаЗапуска + " " + Параметр;
			Если Лев(Параметр,2) <> "/P" и Лев(Параметр,25) <> "/ConfigurationRepositoryP" Тогда
				СтрокаДляЛога = СтрокаДляЛога + " " + Параметр;
			КонецЕсли;
		КонецЦикла;
		СтрокаЗапуска = СтрокаЗапуска + ДопПараметры;

		Приложение = Конфигуратор.ПутьКТонкомуКлиенту1С();
		Если ТолстыйКлиент Тогда
			Приложение = Конфигуратор.ПутьКПлатформе1С();
		КонецЕсли;

		Если Найти(Приложение, " ") > 0 Тогда 
			Приложение = ОбщиеМетоды.ОбернутьПутьВКавычки(Приложение);
		КонецЕсли;
		Приложение = Приложение + " "+СтрокаЗапуска;
		Попытка
			ЗапуститьПроцессВанессы(Приложение, ОжидатьЗавершения, ПутьЛогаВыполненияСценариев );
		Исключение
			Сообщить(ОписаниеОшибки());
		КонецПопытки;
		Результат = ОбщиеМетоды.ПрочитатьФайлИнформации(путьДамп);
		Лог.Информация(Результат);

		Результат = ОбщиеМетоды.ПрочитатьФайлИнформации(ПутьКФайлуСтатусаВыполнения);
		Если СокрЛП(Результат) <> "0" Тогда
			ВызватьИсключение "Результат работы не равен 0 "+ Результат;
		КонецЕсли;

	Исключение
		Лог.Ошибка(Конфигуратор.ВыводКоманды());
		Лог.Ошибка("Ошибка:"+ОписаниеОшибки());
		ВызватьИсключение "ЗапуститьТестироватьПоведение";
	КонецПопытки;

	Лог.Информация("Тестирование поведения завершено");

КонецПроцедуры // ЗапуститьТестироватьПоведение()

Процедура ЗапуститьПроцессВанессы(Знач СтрокаЗапуска, Знач ОжидатьЗавершения, Знач ПутьКФайлуЛога)

	ПериодОпросаВМиллисекундах = 1000;
	
	НадоЧитатьЛог = Истина;
	КолСтрокЛогаПрочитано = 0;

	Процесс = СоздатьПроцесс(СтрокаЗапуска);
	Процесс.Запустить();

	Если ОжидатьЗавершения Тогда

		Приостановить(10000);

		Пока НЕ Процесс.Завершен Цикл
			Если ПериодОпросаВМиллисекундах <> 0 Тогда
				Приостановить(ПериодОпросаВМиллисекундах);
			КонецЕсли;

			// Попытка
			// 	Если Процесс.ПотокВывода.ЕстьДанные Тогда 
					//ОчереднаяСтрокаВывода = Процесс.ПотокВывода.Прочитать();
			// 	КонецЕсли;
			// Исключение
			// 	ОчереднаяСтрокаВывода = "";
			// КонецПопытки;
			
			// Если Процесс.ПотокОшибок.ЕстьДанные Тогда 
				//ОчереднаяСтрокаОшибок = Процесс.ПотокОшибок.Прочитать();
			// КонецЕсли;
			ОчереднаяСтрокаВывода = "";
			ОчереднаяСтрокаОшибок = "";

			Если Не ПустаяСтрока(ОчереднаяСтрокаВывода) Тогда
				//Лог.Информация()
				ОчереднаяСтрокаВывода = СтрЗаменить(ОчереднаяСтрокаВывода, Символы.ВК, "");
				Если ОчереднаяСтрокаВывода <> "" Тогда
					Лог.Информация("%2%1", ОчереднаяСтрокаВывода, Символы.ПС);
				КонецЕсли;
			КонецЕсли;

			Если Не ПустаяСтрока(ОчереднаяСтрокаОшибок) Тогда
				ОчереднаяСтрокаОшибок = СтрЗаменить(ОчереднаяСтрокаОшибок, Символы.ВК, "");
				Если ОчереднаяСтрокаОшибок <> "" Тогда
					Лог.Ошибка("%2%1", ОчереднаяСтрокаОшибок, Символы.ПС);
				КонецЕсли;
			КонецЕсли;

			Если НадоЧитатьЛог Тогда
				ВывестиНовыеСообщения(ПутьКФайлуЛога, КолСтрокЛогаПрочитано);
			КонецЕсли;	 
		
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры //ЗапуститьПроцессВанессы

Процедура ВывестиНовыеСообщения(ИмяФайлаЛога, КолСтрокЛогаПрочитано)
	Попытка                     
		МассивСтрок = ПолучитьНовыеСтрокиЛога(ИмяФайлаЛога, КолСтрокЛогаПрочитано);
		Для Каждого Стр Из МассивСтрок Цикл
			Если СокрЛП(Стр) = "" Тогда
				Продолжить;
			КонецЕсли;	 
			Лог.Информация(СокрЛП(Стр));
			//Сообщить(СокрП(Стр));
		КонецЦикла;	
	Исключение
		Лог.Ошибка(ОписаниеОшибки());
	КонецПопытки;
		
КонецПроцедуры

Функция ПолучитьНовыеСтрокиЛога(Знач ИмяФайла, КолСтрокЛогаПрочитано)
	Файл = Новый Файл(ИмяФайла);
	Если Не Файл.Существует() Тогда
		Возврат Новый Массив;
	КонецЕсли;	
	
	Текст = Новый ЧтениеТекста;
	Текст.Открыть(ИмяФайла,"UTF-8");
	
	ВесьТекст = Текст.Прочитать();
	
	Текст.Закрыть();
	
	Массив = Новый Массив();
	
	МассивСтрок = СтрРазделить(ВесьТекст,Символы.ПС,Истина);
	Если МассивСтрок[МассивСтрок.Количество()-1] = "" Тогда
		МассивСтрок.Удалить(МассивСтрок.Количество()-1);
	КонецЕсли;
	
	Для Ккк = (КолСтрокЛогаПрочитано+1) По МассивСтрок.Количество() Цикл
		Массив.Добавить(МассивСтрок[Ккк-1]);
	КонецЦикла;	
	
	
	КолСтрокЛогаПрочитано = МассивСтрок.Количество();
	
	Возврат Массив;
КонецФункции //ПолучитьНовыеСтрокиЛога	

Функция ПрочитатьНастройки(Знач ПутьКНастройкам)
	Рез = Неопределено;

	Если Не ПустаяСтрока(ПутьКНастройкам) Тогда
		Лог.Отладка("Читаю настройки vanessa-behavior из файла %1", ПутьКНастройкам);

		ФайлНастроек = Новый Файл(ОбщиеМетоды.ПолныйПуть(ПутьКНастройкам));
		СообщениеОшибки = СтрШаблон("Ожидали, что файл настроек %1 существует, а его нет.");
		Ожидаем.Что(ФайлНастроек.Существует(), СообщениеОшибки).ЭтоИстина();

		ЧтениеТекста = Новый ЧтениеТекста(ФайлНастроек.ПолноеИмя, КодировкаТекста.UTF8);
		
		СтрокаJSON = ЧтениеТекста.Прочитать();
		ЧтениеТекста.Закрыть();

		ПарсерJSON = Новый ПарсерJSON();
		Рез = ПарсерJSON.ПрочитатьJSON(СтрокаJSON);
		
		Лог.Отладка("Успешно прочитали настройки");
		Лог.Отладка("Настройки из файла:");
		Для каждого КлючЗначение Из Рез Цикл
			Лог.Отладка("	%1 = %2", КлючЗначение.Ключ, КлючЗначение.Значение);
		КонецЦикла;
	Иначе
		Лог.Отладка("Файл настроек не передан. Использую значение по умолчанию.")
	КонецЕсли;
	Возврат Рез;
КонецФункции

Функция ПолучитьНастройку(Знач Настройки, Знач ИмяНастройки, Знач ЗначениеПоУмолчанию, 
		Знач РабочийКаталогПроекта, Знач ОписаниеНастройки, Знач ПолучатьПолныйПуть = Истина)

	Рез = ЗначениеПоУмолчанию;
	Если Настройки <> Неопределено Тогда
		Рез_Врем = Настройки.Получить(ИмяНастройки);
		Если Рез_Врем <> Неопределено Тогда
			Рез = Заменить_workspaceRoot_на_РабочийКаталогПроекта(Рез_Врем, РабочийКаталогПроекта);

			Лог.Отладка("В настройках нашли %1 %2", ОписаниеНастройки, Рез);
		КонецЕсли;
	КонецЕсли;
	Лог.Отладка("Использую %1 %2", ОписаниеНастройки, Рез);
	
	Если ПолучатьПолныйПуть Тогда
		Рез = ОбщиеМетоды.ПолныйПуть(Рез);
		Лог.Отладка("Использую %1 (полный путь) %2", ОписаниеНастройки, Рез);
	КонецЕсли;
	Возврат Рез;
КонецФункции

Функция Заменить_workspaceRoot_на_РабочийКаталогПроекта(Знач ИсходнаяСтрока, Знач РабочийКаталогПроекта)
	Возврат СтрЗаменить(ИсходнаяСтрока, "$workspaceRoot", РабочийКаталогПроекта);
КонецФункции
