Перем Конфигуратор;
Перем Лог;

///////////////////////////////////////////////////////////////////////////////////////////////////
// Прикладной интерфейс

Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт

	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды, "Централизованная проверка конфигурации, 
		|	в т.ч. полная проверка синтаксиса конфигурации");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--junitpath", "Путь отчета в формате JUnit.xml");
	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--groupbymetadata", "Группировать проверки в junit 
		| по метаданным конфигурации");
	Парсер.ДобавитьПараметрКоллекцияКоманды(ОписаниеКоманды, "--mode", 
		"Параметры проверок (через пробел). 
		|	Например, -ThinClient -WebClient -Server -ExternalConnection -ThickClientOrdinaryApplication 
		|
		|Доступны следующие опции:
		|
		|    -ConfigLogIntegrity — проверка логической целостности конфигурации. Стандартная проверка, обычно выполняемая перед обновлением базы данных;
		|    -IncorrectReferences — поиск некорректных ссылок. Поиск ссылок на удаленные объекты. Выполняется по всей конфигурации, включая права, формы, макеты, интерфейсы и т.д. Также осуществляется поиск логически неправильных ссылок;
		|    -ThinClient — синтаксический контроль модулей для режима эмуляции среды управляемого приложения (тонкий клиент), выполняемого в файловом режиме;
		|    -WebClient — синтаксический контроль модулей в режиме эмуляции среды веб-клиента;
		|    -Server — синтаксический контроль модулей в режиме эмуляции среды сервера 1С:Предприятия;
		|    -ExternalConnection — синтаксический контроль модулей в режиме эмуляции среды внешнего соединения, выполняемого в файловом режиме;
		|    -ExternalConnectionServer — синтаксический контроль модулей в режиме эмуляции среды внешнего соединения, выполняемого в клиент-серверном режиме;
		|    -MobileAppClient — синтаксический контроль модулей в режиме эмуляции среды мобильного приложения, выполняемого в клиентском режиме запуска;
		|    -MobileAppServer — синтаксический контроль модулей в режиме эмуляции среды мобильного приложения, выполняемого в серверном режиме запуска;
		|    -ThickClientManagedApplication — синтаксический контроль модулей в режиме эмуляции среды управляемого приложения (толстый клиент), выполняемого в файловом режиме;
		|    -ThickClientServerManagedApplication — синтаксический контроль модулей в режиме эмуляции среды управляемого приложения (толстый клиент), выполняемого в клиент-серверном режиме;
		|    -ThickClientOrdinaryApplication — синтаксический контроль модулей в режиме эмуляции среды обычного приложения (толстый клиент), выполняемого в файловом режиме;
		|    -ThickClientServerOrdinaryApplication — синтаксический контроль модулей в режиме эмуляции среды обычного приложения (толстый клиент), выполняемого в клиент-серверном режиме;
		|    -DistributiveModules — поставка модулей без исходных текстов. В случае, если в настройках поставки конфигурации для некоторых модулей указана поставка без исходных текстов, проверяется возможность генерации образов этих модулей;
		|    -UnreferenceProcedures — поиск неиспользуемых процедур и функций. Поиск локальных (не экспортных) процедур и функций, на которые отсутствуют ссылки. В том числе осуществляется поиск неиспользуемых обработчиков событий;
		|    -HandlersExistence — проверка существования назначенных обработчиков. Проверка существования обработчиков событий интерфейсов, форм и элементов управления;
		|    -EmptyHandlers — поиск пустых обработчиков. Поиск назначенных обработчиков событий, в которых не выполняется никаких действий. Существование таких обработчиков может привести к снижению производительности системы;
		|    -ExtendedModulesCheck — проверка обращений к методам и свойствам объектов ""через точку"" (для ограниченного набора типов); проверка правильности строковых литералов – параметров некоторых функций, таких как ПолучитьФорму();
		|    -CheckUseModality — режим поиска использования в модулях методов, связанных с модальностью. Опция используется только вместе с опцией -ExtendedModulesCheck.
		|    -UnsupportedFunctional — выполняется поиск функциональности, которая не может быть выполнена на мобильном приложении. Проверка в этом режиме показывает: 
		|
		|        наличие в конфигурации метаданных, классы которых не реализованы на мобильной платформе; 
		|        наличие в конфигурации планов обмена, у которых установлено свойство ""Распределенная информационная база""; 
		|        использование типов, которые не реализованы на мобильной платформе: 
		|            в свойствах ""Тип"" реквизитов метаданных, констант, параметров сеанса; 
		|            в свойстве ""Тип параметра команды"" метаданного ""Команда""; 
		|            в свойстве ""Тип"" реквизитов и колонок реквизита формы; 
		|        наличие форм с типом формы ""Обычная""; 
		|        наличие в форме элементов управления, которые не реализованы на мобильной платформе. Проверка не выполняется для форм, у которых свойство ""Назначение"" не предполагает использование на мобильном устройстве; 
		|        сложный состав рабочего стола (использование более чем одной формы). 
		|
		|    -Extension <Имя расширения> — обработка расширения с указанным именем. Если расширение успешно обработано возвращает код возврата 0, в противном случае (если расширение с указанным именем не существует или в процессе работы произошли ошибки) — 1;
		|    -AllExtensions — проверка всех расширений.
		|	
		|ВНИМАНИЕ, ВАЖНО: этот параметр --MODE должен быть последним среди параметров!");

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

	ПутьОтчетаВФорматеJUnitxml = ПараметрыКоманды["--junitpath"];
	Если ПутьОтчетаВФорматеJUnitxml = Неопределено Тогда
		ПутьОтчетаВФорматеJUnitxml = "";
	КонецЕсли;
	
	КоллекцияПроверок = ПараметрыКоманды["--mode"];
	ГруппироватьПоМетаданным = ПараметрыКоманды["--groupbymetadata"];

	ЛогПроверкиИзКонфигуратора = "";
	ДатаНачала = ТекущаяДата();
	ДанныеПодключения = ПараметрыКоманды["ДанныеПодключения"];

	МенеджерКонфигуратора = Новый МенеджерКонфигуратора;
	МенеджерКонфигуратора.Инициализация(
		ДанныеПодключения.СтрокаПодключения, ДанныеПодключения.Пользователь, ДанныеПодключения.Пароль,
		ПараметрыКоманды["--v8version"], ПараметрыКоманды["--uccode"],
		ДанныеПодключения.КодЯзыка
		);

	Попытка
		Успешно = МенеджерКонфигуратора.ВыполнитьСинтаксическийКонтроль(
				КоллекцияПроверок,			
				ЛогПроверкиИзКонфигуратора);
	Исключение
		МенеджерКонфигуратора.Деструктор();
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
		
	МенеджерКонфигуратора.Деструктор();
	Если ЗначениеЗаполнено(ПутьОтчетаВФорматеJUnitxml) Тогда
		Лог.Отладка("Путь к лог-файлу проверки %1", ПутьОтчетаВФорматеJUnitxml);

		ВывестиОтчетПроверкиКонфигурацииВФорматеJUnitXML(ПутьОтчетаВФорматеJUnitxml, ЛогПроверкиИзКонфигуратора, 
			Успешно, ДатаНачала, ГруппироватьПоМетаданным);

		Лог.Информация("Сформированы результаты проверки в формате JUnit.xml - %1", ПутьОтчетаВФорматеJUnitxml);
	КонецЕсли;

	РезультатыКоманд = МенеджерКомандПриложения.РезультатыКоманд();

	Возврат ?(Успешно, РезультатыКоманд.Успех, РезультатыКоманд.ОшибкаВремениВыполнения);

КонецФункции

// { приватная часть 

Процедура ВывестиОтчетПроверкиКонфигурацииВФорматеJUnitXML(Знач ПутьОтчетаВФорматеJUnitxml, 
	Знач ЛогПроверкиИзКонфигуратора, Знач НетОшибок, Знач ДатаНачала, Знач ГруппироватьПоМетаданным = Ложь)
	
	ПредставлениеНабораТестов = ПредставлениеНабораТестов(ПутьОтчетаВФорматеJUnitxml);
	
	Если НетОшибок Тогда
		ЗаписьXML = НачатьЗаписьОтчета(ПредставлениеНабораТестов, 1, 0, ДатаНачала, "passed");
		ЗаписьXML.ЗаписатьКонецЭлемента(); // testcase
	Иначе
		ТестовыеСлучаи = СтруктурироватьЛог(ЛогПроверкиИзКонфигуратора, ГруппироватьПоМетаданным);
		// Возможно ошибки и были, но отфильтровали, те которые "так и надо, мы специально"
		Если ТестовыеСлучаи.Количество() = 0 Тогда
			ЗаписьXML = НачатьЗаписьОтчета(ПредставлениеНабораТестов, 1, 0, ДатаНачала, "passed");
			ЗаписьXML.ЗаписатьКонецЭлемента(); // testcase
		Иначе
			ПредставлениеНабораТестов = ПредставлениеНабораТестов(ПутьОтчетаВФорматеJUnitxml);
			
			ЗаписьXML = НачатьЗаписьОтчета(ПредставлениеНабораТестов, ТестовыеСлучаи.Количество(), ТестовыеСлучаи.Количество(), ДатаНачала, "failure");
			
			ЗаписьXML.ЗаписатьНачалоЭлемента("failure");
			ЗаписьXML.ЗаписатьАтрибут("message", XMLСтрока(ЛогПроверкиИзКонфигуратора));
			ЗаписьXML.ЗаписатьКонецЭлемента(); // failure
			
			ЗаписьXML.ЗаписатьКонецЭлемента(); // testcase summary
			
			Для Каждого ТекТестовыйСлучай Из ТестовыеСлучаи Цикл
				ЗаписьXML.ЗаписатьНачалоЭлемента("testcase");
				ЗаписьXML.ЗаписатьАтрибут("classname", СтрШаблон("%1.Details", XMLСтрока(ПредставлениеНабораТестов)));
				ЗаписьXML.ЗаписатьАтрибут("name", XMLСтрока(ТекТестовыйСлучай.Ключ));
				ЗаписьXML.ЗаписатьАтрибут("status", "failure");
				
				ЗаписьXML.ЗаписатьНачалоЭлемента("failure");
				ЗаписьXML.ЗаписатьАтрибут("message", XMLСтрока(ТекТестовыйСлучай.Значение));
				ЗаписьXML.ЗаписатьКонецЭлемента(); // failure
				
				ЗаписьXML.ЗаписатьКонецЭлемента(); // testcase details	
			КонецЦикла;
		КонецЕсли;
	
	КонецЕсли;

	ЗаписьXML.ЗаписатьКонецЭлемента(); // testsuite
	
	ЗаписьXML.ЗаписатьКонецЭлемента(); // testsuites
	
	СтрокаХМЛ = ЗаписьXML.Закрыть();
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.ОткрытьФайл(ПутьОтчетаВФорматеJUnitxml);
	ЗаписьXML.ЗаписатьБезОбработки(СтрокаХМЛ);// таким образом файл будет записан всего один раз, и не будет проблем с обработкой на билд-сервере TeamCity
	ЗаписьXML.Закрыть();
	
	Лог.Отладка("СтрокаХМЛ %1", СтрокаХМЛ);

КонецПроцедуры

Функция НачатьЗаписьОтчета(Знач ПредставлениеНабораТестов, Знач КоличествоТестов, Знач КоличествоОшибок, Знач ДатаНачала, Знач Статус)
	
	Результат = Новый ЗаписьXML;
	Результат.УстановитьСтроку("UTF-8");
	Результат.ЗаписатьОбъявлениеXML();
	
	ВремяВыполнения = ТекущаяДата() - ДатаНачала;
	
	Результат.ЗаписатьНачалоЭлемента("testsuites");
	Результат.ЗаписатьАтрибут("name", XMLСтрока(ПредставлениеНабораТестов)); 
	Результат.ЗаписатьАтрибут("tests", XMLСтрока(КоличествоТестов));
	Результат.ЗаписатьАтрибут("time", XMLСтрока(ВремяВыполнения));
	Результат.ЗаписатьАтрибут("failures", XMLСтрока(КоличествоОшибок));
	
	Результат.ЗаписатьНачалоЭлемента("testsuite");	
	Результат.ЗаписатьАтрибут("name", XMLСтрока(ПредставлениеНабораТестов));
	Результат.ЗаписатьНачалоЭлемента("properties");	
	Результат.ЗаписатьКонецЭлемента(); // properties
	
	Результат.ЗаписатьНачалоЭлемента("testcase");
	Результат.ЗаписатьАтрибут("classname", XMLСтрока(ПредставлениеНабораТестов));
	Результат.ЗаписатьАтрибут("name", "Summary");
	Результат.ЗаписатьАтрибут("time", XMLСтрока(ВремяВыполнения));
	Результат.ЗаписатьАтрибут("status", Статус);	
	
	Возврат Результат;
	
КонецФункции

Функция СтруктурироватьЛог(Знач ЛогПроверкиИзКонфигуратора, Знач ГруппироватьПоМетаданным = Ложь)
	
	ОбработанныйЛог = СтрЗаменить(ЛогПроверкиИзКонфигуратора, Символы.ПС + Символы.Таб, Символы.Таб);
	ОбработанныйЛог = СтрЗаменить(ОбработанныйЛог, Символы.ВК + Символы.ПС + Символы.Таб, Символы.Таб);
	ОбработанныйЛог = СтрЗаменить(ОбработанныйЛог, Символы.ПС + Символы.ВК + Символы.Таб, Символы.Таб);
	ИмяТестСценарияПредыдущаяСтрока = "Синтаксическая проверка конфигурации";
	Результат = Новый Соответствие;

	Если НЕ ГруппироватьПоМетаданным Тогда
		Результат.Вставить("Синтаксическая проверка конфигурации", XMLСтрока(ОбработанныйЛог));
		Возврат Результат;
	КонецЕсли;

	// Определяем строки для исключения из ошибок 
	// См. стандарт "Обработчики событий модуля формы, подключаемые из кода"
	// https://its.1c.ru/db/v8std#content:-2145783155:hdoc
	МассивСтрокИсключений = Новый Массив();
	МассивСтрокИсключений.Добавить(Нрег("Не обнаружено ссылок на процедуру: ""Подключаемый_"));
	МассивСтрокИсключений.Добавить(Нрег("Не обнаружено ссылок на функцию: ""Подключаемый_"));
	МассивСтрокИсключений.Добавить(Нрег("Пустой обработчик: ""Подключаемый_"));
	МассивСтрокИсключений.Добавить(Нрег("No links to function found: ""Attachable_"));
	МассивСтрокИсключений.Добавить(Нрег("No links to procedure found: ""Attachable_"));
	МассивСтрокИсключений.Добавить(Нрег("Empty handler: ""Attachable_"));
	
	Для Каждого ТекСтрока Из СтрРазделить(ОбработанныйЛог, Символы.ПС) Цикл
		
		Если ИсключитьСтроку(ТекСтрока, МассивСтрокИсключений) Тогда
			Продолжить;
		КонецЕсли;
		
		ИмяТестСценария = ИмяТестСценария(ТекСтрока);

		Если ПустаяСтрока(ИмяТестСценария) Тогда
			ИмяТестСценария = ИмяТестСценарияПредыдущаяСтрока;
		КонецЕсли;
		
		Если Результат[ИмяТестСценария] = Неопределено Тогда
			Результат[ИмяТестСценария] = СокрЛП(ТекСтрока);
		Иначе
			Результат[ИмяТестСценария] = СтрШаблон(
			"%1
			|%2",
			Результат[ИмяТестСценария],
			СокрЛП(ТекСтрока));
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ИмяТестСценария(Знач СтрокаЛога)
	
	Результат = "";
	
	ЧастиСтрокиЛога = СтрРазделить(СокрЛП(СтрокаЛога), " ", Ложь);
	Если ЗначениеЗаполнено(ЧастиСтрокиЛога) Тогда
		РезультатСтрока = ЧастиСтрокиЛога[0];
	КонецЕсли;
	
	Если СтрНачинаетсяС(РезультатСтрока, "{") Тогда

		РезультатСтрока = СтрЗаменить(РезультатСтрока, "{", "");
		РезультатСтрока = СтрЗаменить(РезультатСтрока, "}", "");
		ПозицияСкобки = СтрНайти(РезультатСтрока, "(");
		Если ПозицияСкобки > 1 Тогда
			Результат = Сред(РезультатСтрока, 1, ПозицияСкобки - 1);
		КонецЕсли;
	ИначеЕсли ЧастиСтрокиЛога.Количество() > 0 Тогда
		Результат = РезультатСтрока;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПредставлениеНабораТестов(Знач ПутьОтчетаВФорматеJUnitxml)
	
	Если Не ЗначениеЗаполнено(ПутьОтчетаВФорматеJUnitxml) Тогда
		Возврат "CheckConfig";
	КонецЕсли;
	
	Файл = Новый Файл(ПутьОтчетаВФорматеJUnitxml);
	Возврат СтрШаблон("CheckConfig.%1", Файл.ИмяБезРасширения);
	
КонецФункции

//Проверяет вхождение строк из массива в проверямой строке.
//Параметры:
//	ПроверяемаяСтрока - Строка - строка для проверки.
//	МассивСтрокИсключений - Массив - массив строк, для проверки. 
//
//Возвращаемое значение:
//	Булево - Истина, в проверяемой строке содежрится один из элементов массив.
//			 Ложь, не нашли
Функция ИсключитьСтроку(Знач ПроверяемаяСтрока, Знач МассивСтрокИсключений)
	Для каждого СтрИсключения Из МассивСтрокИсключений Цикл
		Если СтрНайти(Нрег(ПроверяемаяСтрока), СтрИсключения) > 0 Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	Возврат Ложь;
КонецФункции //ИсключитьСтроку

// }

