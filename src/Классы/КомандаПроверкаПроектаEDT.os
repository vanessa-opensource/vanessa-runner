#Использовать fs
#Использовать 1commands
#Использовать tempfiles
#Использовать json

Перем Лог;
Перем ПарсерJSON;

Перем РабочаяОбласть;
Перем СписокПапокСПроектами;
Перем СписокИменПроектов;
Перем КаталогОтчетов;
Перем ИмяФайлаРезультата;
Перем УдалятьФайлРезультата;
Перем ИмяПредыдущегоФайлаРезультата;
Перем ИсключенияВОшибках;
Перем ПропускиВОшибках;

///////////////////////////////////////////////////////////////////////////////////////////////////
// Прикладной интерфейс

Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт
	
	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды, "Проверка проекта EDT");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--allure-results",
	"Путь к каталогу результатов Allure");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--skipped-error-file",
	"Путь файла с указанием пропускаемых ошибок
	|	Формат файла: в каждой строке файла указан текст пропускаемого исключения или его часть
	|	Кодировка: UTF-8");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--validation-result",
	"Необязательный аргумент. Путь к файлу, в который будут записаны результаты проверки проекта.");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--prev-validation-result",
	"Необязательный аргумент. Путь к файлу с предыдущими результатами проверки проекта.
	|	Если заполнен, то результат будет записан как разность новых ошибок и старых.
	|	Ошибки и предупреждения, которые есть в предыдущем файле, но которых нет в новом - будут помечены как passed (Исправлено).
	|	Ошибки и предупреждения, которые есть только в новом файле результатов - будут помечены как failed (Ошибки) и broken (Предупреждения).
	|	Все остальные ошибки и предупреждения, которые есть в обоих файлах, будут помечены как skipped (Пропущено).");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--workspace-location", "Расположение рабочей области");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--project-list", 
	"Необязательный аргумент. Список папок, откуда загрузить проекты в формате EDT для проверки.
	|	Одновременно можно использовать только один агрумент: project-list или project-name-list");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--project-name-list",
	"Необязательный аргумент. Cписок имен проектов в текущей рабочей области, откуда загрузить проекты в формате EDT для проверки.
	|	Одновременно можно использовать только один агрумент: project-list или project-name-list.
	|
	|	Пример выполнения:
	|		vanessa-runner edt-validate --project-list D:/project-1 D:/project-2 --workspace-location D:/workspace
	|
	|	ВНИМАНИЕ! Параметры, которые перечислены далее, не используются.
	|
	|");
	
	Парсер.ДобавитьКоманду(ОписаниеКоманды);
	
КонецПроцедуры

// Выполняет логику команды
// 
// Параметры:
//   ПараметрыКоманды - Соответствие - Соответствие ключей командной строки и их значений
//   ДополнительныеПараметры - Соответствие -  (необязательно) дополнительные параметры
//
Функция ВыполнитьКоманду(Знач ПараметрыКоманды, Знач ДополнительныеПараметры = Неопределено) Экспорт
	
	Лог = ДополнительныеПараметры.Лог;
	
	ПрочитатьПараметры( ПараметрыКоманды );
	
	Если ЗначениеЗаполнено( ИмяПредыдущегоФайлаРезультата ) Тогда
		
		тзРезультатПред = ПрочитатьТаблицуИзФайлаРезультата(ИмяПредыдущегоФайлаРезультата);
		
	КонецЕсли;
	
	Успешно = ВыполнитьПроверкуEDT();
	
	тзРезультат = ПрочитатьТаблицуИзФайлаРезультата( ИмяФайлаРезультата );
	
	УдалитьФайлРезультатовПриНеобходимости();
	
	Если ЗначениеЗаполнено( ИмяПредыдущегоФайлаРезультата ) Тогда
		
		тзРезультат = РазностнаяТаблицаРезультатов( тзРезультатПред, тзРезультат );
		
	КонецЕсли;
	
	СоздатьФайлыПоТаблицеПроверки(тзРезультат);
	
	РезультатыКоманд = МенеджерКомандПриложения.РезультатыКоманд();
	
	Возврат ?(Успешно, РезультатыКоманд.Успех, РезультатыКоманд.ОшибкаВремениВыполнения);
	
КонецФункции

// { приватная часть 

Процедура ПрочитатьПараметры( Знач ПараметрыКоманды )
	
	Лог.Отладка("Чтение параметров");

	КаталогОтчетов = ПараметрыКоманды["--allure-results"];

	Если КаталогОтчетов = Неопределено Тогда

		КаталогОтчетов = "";
		Лог.Отладка("	Каталог отчетов (--allure-results) не задан.");

	Иначе

		Лог.Отладка("	Каталог отчетов (--allure-results): %1", КаталогОтчетов);

	КонецЕсли;
	
	РабочаяОбласть = ПараметрыКоманды["--workspace-location"];
	СписокПапокСПроектами = ПараметрыКоманды["--project-list"];
	СписокИменПроектов = ПараметрыКоманды["--project-name-list"];
	
	Лог.Отладка("	Рабочая область (--workspace-location): %1", Строка( РабочаяОбласть ));
	Лог.Отладка("	Список папок с проектами (--project-list): %1", Строка( СписокПапокСПроектами ));
	Лог.Отладка("	Список имен проектов (--project-name-list): %1", Строка( СписокИменПроектов ));

	ИмяФайлаРезультата = ПараметрыКоманды["--validation-result"];
	УдалятьФайлРезультата = Ложь;

	Если ИмяФайлаРезультата = Неопределено Тогда

		ИмяФайлаРезультата = ПолучитьИмяВременногоФайла("out");
		УдалятьФайлРезультата = Истина;
		Лог.Отладка("	Файл результата не задан (--validation-result). Будет использован временный файл.");

	КонецЕсли;

	Лог.Отладка("	Файл результата (--validation-result): %1", ИмяФайлаРезультата);
	
	ИмяПредыдущегоФайлаРезультата = ПараметрыКоманды["--prev-validation-result"];

	Лог.Отладка("	Файл предыдущего результата (--prev-validation-result): %1", Строка( ИмяПредыдущегоФайлаРезультата ));
	
	ИсключенияВОшибках = ИсключаемыеОшибки();
	ПропускиВОшибках = СодержимоеФайлаПропускаемыхОшибок( ПараметрыКоманды["--skipped-error-file"] );

	ПарсерJSON  = Новый ПарсерJSON();
	
КонецПроцедуры

Функция ВыполнитьПроверкуEDT()
	
	Если Не ЗначениеЗаполнено( РабочаяОбласть ) Тогда
		
		Лог.Информация("Рабочая область (--workspace-location) не указана. Проверка проекта пропущена.");
		
		Возврат Истина;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено( СписокПапокСПроектами ) 
		И Не ЗначениеЗаполнено( СписокИменПроектов ) Тогда
		
		Лог.Информация("Проекты к проверке (--project-list или project-name-list) не указаны. Проверка проекта пропущена.");
		
		Возврат Истина;
		
	КонецЕсли;
	
	Попытка

		// Для EDT критично, чтобы файла не существовало
		ОбщиеМетоды.УдалитьФайлЕслиОнСуществует(ИмяФайлаРезультата);
		
		Команда = Новый Команда;
		Команда.УстановитьСтрокуЗапуска( "ring edt workspace validate" );
		Команда.УстановитьКодировкуВывода(КодировкаТекста.ANSI);
		Команда.ДобавитьПараметр( "--workspace-location " + ОбщиеМетоды.ОбернутьПутьВКавычки( РабочаяОбласть ) );
		Команда.ДобавитьПараметр( "--file " + ОбщиеМетоды.ОбернутьПутьВКавычки( ИмяФайлаРезультата ) );
		
		Если ЗначениеЗаполнено( СписокПапокСПроектами ) Тогда
			Команда.ДобавитьПараметр("--project-list " + ОбщиеМетоды.ОбернутьПутьВКавычки( СписокПапокСПроектами ) );
		КонецЕсли;
		
		Если ЗначениеЗаполнено( СписокИменПроектов ) Тогда
			Команда.ДобавитьПараметр("--project-name-list " + ОбщиеМетоды.ОбернутьПутьВКавычки( СписокИменПроектов ) );
		КонецЕсли;
		
		Лог.Информация("Начало проверки EDT-проекта");
		началоЗамера = ТекущаяДата();
		
		КодВозврата = Команда.Исполнить();
		
		Лог.Информация( "Проверка EDT-проекта завершена за %1с", Окр( ТекущаяДата()-  началоЗамера ));
		
	Исключение
		
		УдалитьФайлРезультатовПриНеобходимости();
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
	КонецПопытки;
	
	Возврат КодВозврата = 0;
	
КонецФункции

Процедура УдалитьФайлРезультатовПриНеобходимости()
	
	Если УдалятьФайлРезультата Тогда
		
		ОбщиеМетоды.УдалитьФайлЕслиОнСуществует(ИмяФайлаРезультата);
		
	КонецЕсли;
	
КонецПроцедуры

Функция СодержимоеФайлаПропускаемыхОшибок(Знач ИмяФайлаПропускаемыхОшибок)
	
	Результат = Новый Массив;
	
	Если Не ЗначениеЗаполнено(ИмяФайлаПропускаемыхОшибок) Тогда
		Лог.Информация( "Файл пропускаемых ошибок (--skipped-error-file) не указан. Пропуски не используются." );
		Возврат Результат;
	КонецЕсли;
	
	Лог.Отладка("Чтение файла пропускаемых ошибок из %1", ИмяФайлаПропускаемыхОшибок);
	
	ЧтениеТекста = Новый ЧтениеТекста(ИмяФайлаПропускаемыхОшибок, КодировкаТекста.UTF8);
	ПрочитаннаяСтрока = ЧтениеТекста.ПрочитатьСтроку();
	Пока ПрочитаннаяСтрока <> Неопределено Цикл
		Если Не ПустаяСтрока(ПрочитаннаяСтрока) Тогда
			пропуск = СокрЛП(НРег(ПрочитаннаяСтрока));
			Результат.Добавить(пропуск);
			Лог.Отладка("Добавлено в пропуски: %1", пропуск);
		КонецЕсли;
		ПрочитаннаяСтрока = ЧтениеТекста.ПрочитатьСтроку();
	КонецЦикла;
	
	Лог.Отладка("Прочитано пропусков: %1", Результат.Количество());	
	
	Возврат Результат;
	
КонецФункции

Функция ИсключаемыеОшибки()
	
	// Определяем строки для исключения из ошибок 
	// См. стандарт "Обработчики событий модуля формы, подключаемые из кода"
	// https://its.1c.ru/db/v8std#content:-2145783155:hdoc
	МассивСтрокИсключений = Новый Массив();
	МассивСтрокИсключений.Добавить(Нрег("Неиспользуемый метод ""Подключаемый_"));
	МассивСтрокИсключений.Добавить(Нрег("Пустой обработчик: ""Подключаемый_"));
	
	Возврат МассивСтрокИсключений;
	
КонецФункции


// Создание таблицы результата
Функция ПрочитатьТаблицуИзФайлаРезультата( Знач пПутьКФайлу )
	
	Лог.Отладка("Чтение файла результата %1", пПутьКФайлу);
	
	тз = Новый ТаблицаЗначений;
	тз.Колонки.Добавить( "ДатаОбнаружения" );
	тз.Колонки.Добавить( "Тип" );
	тз.Колонки.Добавить( "Проект" );
	тз.Колонки.Добавить( "Метаданные" );
	тз.Колонки.Добавить( "Положение" );
	тз.Колонки.Добавить( "Описание" );
	
	ЧтениеТекста = Новый ЧтениеТекста( пПутьКФайлу, КодировкаТекста.UTF8 );
	
	ПрочитаннаяСтрока = ЧтениеТекста.ПрочитатьСтроку();
	
	Пока Не ПрочитаннаяСтрока = Неопределено Цикл
		
		Если ПустаяСтрока( ПрочитаннаяСтрока ) Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		Если СтрокаВходитВМассив( ПрочитаннаяСтрока, ИсключенияВОшибках ) Тогда
			ПрочитаннаяСтрока = ЧтениеТекста.ПрочитатьСтроку();
			Продолжить;
		КонецЕсли;
		
		компонентыСтроки = СтрРазделить( ПрочитаннаяСтрока, "	" );
		
		новСтрока = тз.Добавить();
		
		Для ц = 0 По 4 Цикл
			
			новСтрока[ц] = компонентыСтроки[ц];
			
		КонецЦикла;
		
		// В описании могут быть и табы, по которым делим
		
		Для ц = 5 По компонентыСтроки.ВГраница() Цикл
			
			Если ЗначениеЗаполнено( новСтрока.Описание ) Тогда
				
				новСтрока.Описание = новСтрока.Описание + "	";
				
			Иначе
				
				новСтрока.Описание = "";
				
			КонецЕсли;
			
			новСтрока.Описание = новСтрока.Описание + компонентыСтроки[ц];
			
		КонецЦикла;
		
		Если СтрокаВходитВМассив( ПрочитаннаяСтрока, ПропускиВОшибках ) Тогда
			
			новСтрока.Тип = ТипОшибки_Пропущено();
			
		КонецЕсли;
		
		ПрочитаннаяСтрока = ЧтениеТекста.ПрочитатьСтроку();
		
	КонецЦикла;
	
	ЧтениеТекста.Закрыть();

	Лог.Отладка("Из файла %1 прочитано %2 строк", пПутьКФайлу, тз.Количество());
	
	Возврат тз;
	
КонецФункции

//Проверяет вхождение строк из массива в проверямой строке.
//Параметры:
//	ПроверяемаяСтрока - Строка - строка для проверки.
//	МассивСтрокИсключений - Массив - массив строк, для проверки. 
//
//Возвращаемое значение:
//	Булево - Истина, в проверяемой строке содежрится один из элементов массив.
//			 Ложь, не нашли
Функция СтрокаВходитВМассив( Знач ПроверяемаяСтрока, Знач МассивСтрокИсключений )
	
	Для каждого СтрИсключения Из МассивСтрокИсключений Цикл

		Если СтрНайти(Нрег(ПроверяемаяСтрока), СтрИсключения) > 0 Тогда

			Возврат Истина;
			
		КонецЕсли;

	КонецЦикла;

	Возврат Ложь;

КонецФункции

Функция РазностнаяТаблицаРезультатов( Знач пТЗ_пред, Знач пТЗ_нов )
	
	тз_стар = пТЗ_пред.Скопировать();
	тз_стар.Колонки.Добавить("Изменение");
	тз_стар.ЗаполнитьЗначения(1, "Изменение" );
	
	тз = пТЗ_нов.Скопировать();
	тз.Колонки.Добавить("Изменение");
	тз.ЗаполнитьЗначения(-1, "Изменение" );
	
	Для каждого цСтрока Из тз_стар Цикл
		
		ЗаполнитьЗначенияСвойств( тз.Добавить(), цСтрока );
		
	КонецЦикла;
	
	тз.Свернуть( "Тип,Проект,Метаданные,Положение,Описание" , "Изменение" );
	
	Для каждого цСтрока Из тз Цикл
		
		Если цСтрока.Изменение = 0 Тогда
			
			// есть и в старой и в новой таблице
			цСтрока.Тип = ТипОшибки_Пропущено();
			
		ИначеЕсли цСтрока.Изменение > 0 Тогда
			
			// есть только в старой
			цСтрока.Тип = ТипОшибки_Исправлено();
			
		Иначе
			
			// Внесли новую ошибку
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат тз;
	
КонецФункции

Функция ТипОшибки_Пропущено()
	Возврат "Пропущено";
КонецФункции

Функция ТипОшибки_Исправлено()
	Возврат "Исправлено";
КонецФункции

// Создание файлов для отчета Allure

Процедура СоздатьФайлыПоТаблицеПроверки(Знач пТаблицаПроверки)
	
	Если Не ЗначениеЗаполнено( КаталогОтчетов ) Тогда
		
		Лог.Отладка("Каталог отчетов (--allure-results) не указан. Создание отчета Allure пропущено.");
		
		Возврат;
		
	КонецЕсли;
	
	началоЗамера = ТекущаяДата();
	
	Лог.Отладка("Создание файлов в каталоге %1.", КаталогОтчетов);
	Лог.Отладка("	Очистка каталога %1.", КаталогОтчетов);
	
	УдалитьФайлы( КаталогОтчетов, "*.json" );
	
	Лог.Отладка("	Создание файлов json по таблице проверки в каталоге %1.", КаталогОтчетов);
		
	количествоСозданныхФайлов = 0;
	
	Для каждого цСтрока Из пТаблицаПроверки Цикл
		
		СтруктураВыгрузки           = ПолучитьОписаниеСценарияАллюр2();
		СтруктураВыгрузки.name      = цСтрока.Метаданные + ". " + цСтрока.Положение + ": " + цСтрока.Описание;
		СтруктураВыгрузки.fullName  = СтруктураВыгрузки.name;
		СтруктураВыгрузки.historyId = цСтрока.Метаданные + ". " + цСтрока.Положение + ": " + цСтрока.Описание;
		СтруктураВыгрузки.Вставить( "description", цСтрока.Описание );
		
		Если цСтрока.Тип = "Ошибка" Тогда
			
			СтруктураВыгрузки.status = "failed";
			
		ИначеЕсли цСтрока.Тип = "Предупреждение" Тогда
			
			СтруктураВыгрузки.status = "broken";
			
		ИначеЕсли цСтрока.Тип = "Пропущено" Тогда
			
			СтруктураВыгрузки.status = "skipped";
			
		ИначеЕсли цСтрока.Тип = "Исправлено" Тогда
			
			СтруктураВыгрузки.status = "passed";
			
		КонецЕсли;
		
		структ = Новый Структура( "name,value", "package", цСтрока.Метаданные );
		СтруктураВыгрузки.labels.Добавить( структ );
		
		Для каждого цКонтекст Из ПолучитьКонтексты( цСтрока.Описание ) Цикл
			
			структ = Новый Структура( "name,value", "tag", цКонтекст );
			СтруктураВыгрузки.labels.Добавить( структ );
			
		КонецЦикла;
		
		структ = Новый Структура( "name,value", "story", ОписаниеФункциональности( цСтрока.Описание ) );
		СтруктураВыгрузки.labels.Добавить( структ );
		
		РеальноеИмяФайла = ОбъединитьПути( КаталогОтчетов, "" + СтруктураВыгрузки.uuid + "-result.json" );
		
		ЗаписатьФайлJSON( РеальноеИмяФайла, СтруктураВыгрузки);
		
		количествоСозданныхФайлов = количествоСозданныхФайлов + 1;
		
	КонецЦикла;
	
	лог.Отладка( "	Созданы файлы отчетов (%1) в каталоге %2 за %3с", количествоСозданныхФайлов, КаталогОтчетов, Окр( ТекущаяДата() - началоЗамера ));

	СоздатьФайлКатегорий();
	
КонецПроцедуры

Процедура СоздатьФайлКатегорий()
	
	имяФайлаКатегорий = ОбъединитьПути( КаталогОтчетов, "categories.json" );
	
	Лог.Отладка("	Создание файла категорий %1.", имяФайлаКатегорий);
	
	категории = Новый Массив;
	
	массивСтатусов = Новый Массив;
	массивСтатусов.Добавить( "failed" );
	структ = Новый Структура( "name,matchedStatuses", "Ошибка", массивСтатусов );
	категории.Добавить( структ );
	
	массивСтатусов = Новый Массив;
	массивСтатусов.Добавить( "broken" );
	структ = Новый Структура( "name,matchedStatuses", "Предупреждение", массивСтатусов );
	категории.Добавить( структ );
	
	массивСтатусов = Новый Массив;
	массивСтатусов.Добавить( "skipped" );
	структ = Новый Структура( "name,matchedStatuses", "Пропущено", массивСтатусов );
	категории.Добавить( структ );
	
	массивСтатусов = Новый Массив;
	массивСтатусов.Добавить( "passed" );
	структ = Новый Структура( "name,matchedStatuses", "Исправлено", массивСтатусов );
	категории.Добавить( структ );
	
	ЗаписатьФайлJSON( имяФайлаКатегорий, категории);
	
КонецПроцедуры

Функция ПолучитьКонтексты( Знач пОписание )
	
	начало = СтрНайти( пОписание, "[" );
	конец  = СтрНайти( пОписание, "]", НаправлениеПоиска.СКонца );
	
	Если начало < конец
		И конец > 0 Тогда
		
		стрКонтексты = Сред( пОписание, начало + 1, конец - начало -1 );
		
		Возврат СтрРазделить( стрКонтексты, "," );
		
	Иначе
		
		Возврат Новый Массив;
		
	КонецЕсли;
	
КонецФункции

Функция ОписаниеФункциональности( Знач пОписание )
	
	начало = СтрНайти( пОписание, "[" );
	
	Если начало > 0 Тогда
		
		описаниеБезКонтекста = Лев( пОписание, начало - 1 );
		
	Иначе
		
		описаниеБезКонтекста = пОписание;
		
	КонецЕсли;
	
	ПозицияКавычки = СтрНайти( описаниеБезКонтекста, """" );
	
	Пока ПозицияКавычки > 0 Цикл
		
		ПозицияЗакрывающейКавычки = СтрНайти( Сред( описаниеБезКонтекста, ПозицияКавычки + 1 ), """" ) + ПозицияКавычки;
		
		Если ПозицияЗакрывающейКавычки = 0 Тогда
			
			Прервать;
			
		КонецЕсли;
		
		описаниеБезКонтекста = Лев( описаниеБезКонтекста, ПозицияКавычки - 1 ) + "<>" + Сред( описаниеБезКонтекста, ПозицияЗакрывающейКавычки + 1 );
		ПозицияКавычки       = СтрНайти( описаниеБезКонтекста, """" );
		
	КонецЦикла;
	
	ПозицияКавычки = СтрНайти( описаниеБезКонтекста, "'" );
	
	Пока ПозицияКавычки > 0 Цикл
		
		ПозицияЗакрывающейКавычки = СтрНайти( Сред( описаниеБезКонтекста, ПозицияКавычки + 1 ), "'" ) + ПозицияКавычки;
		
		Если ПозицияЗакрывающейКавычки = 0 Тогда
			
			Прервать;
			
		КонецЕсли;
		
		описаниеБезКонтекста = Лев( описаниеБезКонтекста, ПозицияКавычки - 1 ) + "<>" + Сред( описаниеБезКонтекста, ПозицияЗакрывающейКавычки + 1 );
		ПозицияКавычки       = СтрНайти( описаниеБезКонтекста, "'" );
		
	КонецЦикла;
	
	начало = СтрНайти( пОписание, ":", НаправлениеПоиска.СКонца );
	
	Если начало > 0 Тогда
		
		описаниеБезКонтекста = СокрЛП( Лев( описаниеБезКонтекста, начало - 1 ) );
		
	КонецЕсли;
	
	Возврат СокрЛП( описаниеБезКонтекста );
	
КонецФункции

Функция ПолучитьОписаниеСценарияАллюр2()
	
	СтруктураРезультата = Новый Структура();
	СтруктураРезультата.Вставить( "uuid", Строка( Новый УникальныйИдентификатор() ) );
	СтруктураРезультата.Вставить( "historyId", Неопределено );
	СтруктураРезультата.Вставить( "name", Неопределено );
	СтруктураРезультата.Вставить( "fullName", Неопределено );
	СтруктураРезультата.Вставить( "start", Неопределено );
	СтруктураРезультата.Вставить( "stop", Неопределено );
	СтруктураРезультата.Вставить( "statusDetails", Новый Структура( "known, muted,flaky", Ложь, Ложь, Ложь ) );
	СтруктураРезультата.Вставить( "status", Неопределено );
	СтруктураРезультата.Вставить( "stage", "finished" );
	СтруктураРезультата.Вставить( "steps", Новый Массив );
	СтруктураРезультата.Вставить( "parameters", Новый Массив );
	СтруктураРезультата.Вставить( "labels", Новый Массив );
	СтруктураРезультата.Вставить( "links", Новый Массив );
	СтруктураРезультата.Вставить( "attachments", Новый Массив );
	СтруктураРезультата.Вставить( "description", Неопределено );
	
	Возврат СтруктураРезультата;
	
КонецФункции

Процедура ЗаписатьФайлJSON(Знач ИмяФайла, Знач пЗначение)
	
	Запись = Новый ЗаписьТекста;
	Запись.Открыть(ИмяФайла);
	Запись.Записать(ПарсерJSON.ЗаписатьJSON(пЗначение));
	Запись.Закрыть();
	
КонецПроцедуры

