
///////////////////////////////////////////////////////////////////////////////////////////////////
// Прикладной интерфейс

Перем мНастройки;
Перем Лог;
Перем мИдентификаторКластера;
Перем мИдентификаторБазы;
Перем ЭтоWindows;
Перем мЭтоУправлениеСеансами, мЭтоУправлениеРегламентнымиЗаданиями, мЭтоПолучениеИнформацииИБ;

Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт
	
	ТекстОписанияКоманды = Неопределено;
	ОпределитьНазначениеКоманды(ИмяКоманды, ТекстОписанияКоманды);
	
	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды, ТекстОписанияКоманды);
	
	Если мЭтоУправлениеРегламентнымиЗаданиями Или мЭтоУправлениеСеансами Тогда
		Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "Действие", 
			?(мЭтоУправлениеСеансами, "lock|unlock|kill|closed
			|Действие kill по умолчанию также устанавливает блокировку начала сеансов пользователей. Для подавления этого эффекта используется ключ -with-nolock.
			|Действие closed предназначено для проверки отсутствия сеансов. Например, может применяться для проверки того, что после блокировки, все регламенты завершили свою работу.
			|Если сеансы оказались найдены, то происходит завершение работы скрипта с ошибкой.", 
			"lock|unlock")
		);
	КонецЕсли;
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--ras", "Сетевой адрес RAS, по умолчанию localhost:1545");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--rac", "Команда запуска RAC, по умолчанию находим в каталоге установки 1с");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--db", "Имя информационной базы");
	
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
		"--cluster-admin",
		"Администратор кластера");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
		"--cluster-pwd",
		"Пароль администратора кластера");
	
	Если мЭтоУправлениеСеансами Тогда
	
		Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
			"--lockmessage",
			"Сообщение блокировки");
			
		Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
			"--lockstart",
			"Время старта блокировки пользователей, время указываем как '2040-12-31T23:59:59'");
		
		Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
			"--lockstartat",
			"Время старта блокировки через n сек");

		Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды,
			"--try",
			"Число попыток обращения по протоколу rac/ras");
				
		Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, 
			"--with-nolock",
			"Не блокировать сеансы (y/n). Может применяться для действия kill, т.к. по умолчанию, при его выполнении автоматически блокируется начало сеансов.
			|Пример: ... kill --with-nolock ...");
	
		Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
			"--filter",
			"Фильтр поиска сеансов. Предполагает возможность указания множественных вариантов фильтрации. Задается в формате '[filter1]|[filter2]|...|[filterN]'.
			|Составляющая фильтра задается в формате [[appid=приложение1[;приложение2]][[name=username1[;username2]]'. 
			|Пока предусмотрено только два фильтра - по имени приложения (appid) и по имени пользователя 1С (name).
			|Для фильтра по приложению доступны следующие имена: 1CV8 1CV8C WebClient Designer COMConnection WSConnection BackgroundJob WebServerExtension.
			|Использование wildchar/regex пока не предусмотрено. Регистронечувствительно. Параметры должны разделяться через |. 
			|Действует для команд kill и closed.
			|Пример: ... kill -filter appid=Designer|name=регламент;администратор ...");
	
	КонецЕсли;
	
	Парсер.ДобавитьКоманду(ОписаниеКоманды);
	
КонецПроцедуры

Процедура ОпределитьНазначениеКоманды(Знач ИмяКоманды, ТекстОписанияКоманды)
	
	мЭтоУправлениеСеансами = НРег(ИмяКоманды)=ПараметрыСистемы.ВозможныеКоманды().УправлениеСеансами;
	мЭтоУправлениеРегламентнымиЗаданиями = НРег(ИмяКоманды)=ПараметрыСистемы.ВозможныеКоманды().УправлениеРегламентнымиЗаданиями;
	мЭтоПолучениеИнформацииИБ = НРег(ИмяКоманды)=ПараметрыСистемы.ВозможныеКоманды().ЗапроситьПараметрыБД;

	Если Не мЭтоПолучениеИнформацииИБ И Не мЭтоУправлениеРегламентнымиЗаданиями И Не мЭтоУправлениеСеансами Тогда
		ВызватьИсключение("Непредусмотренное имя команды: " + ИмяКоманды)
	КонецЕсли;

	Если мЭтоПолучениеИнформацииИБ Тогда
		ТекстОписанияКоманды = 
		"     Получение информации о базе данных (выводится в консоль выполнения скрипта).
		|     Может применяться для проверки работы RAS/RAC.
		|     ";
	ИначеЕсли мЭтоУправлениеРегламентнымиЗаданиями Тогда
		ТекстОписанияКоманды =
		"     Управление возможностью работы регламентных заданий
		|     ";
	ИначеЕсли мЭтоУправлениеСеансами Тогда
		ТекстОписанияКоманды =
		"     Управление сеансами информационной базы
		|     ";
	КонецЕсли;

КонецПроцедуры

Функция ВыполнитьКоманду(Знач ПараметрыКоманды, Знач ДополнительныеПараметры = Неопределено) Экспорт

	Попытка
		Лог = ДополнительныеПараметры.Лог;
	Исключение
		Лог = Логирование.ПолучитьЛог(ПараметрыСистемы.ИмяЛогаСистемы());
	КонецПопытки;
	Лог.УстановитьУровень(УровниЛога.Отладка);

	ПрочитатьПараметры(ПараметрыКоманды);
	
	Если Не ПараметрыВведеныКорректно() Тогда
		Возврат МенеджерКомандПриложения.РезультатыКоманд().НеверныеПараметры;
	КонецЕсли;
	
	Если мЭтоУправлениеСеансами И мНастройки.Действие = "lock" Тогда
		УстановитьСтатусБлокировкиСеансов(Истина);
	ИначеЕсли мЭтоУправлениеСеансами И мНастройки.Действие = "unlock" Тогда
		УстановитьСтатусБлокировкиСеансов(Ложь);
	ИначеЕсли мЭтоУправлениеСеансами И мНастройки.Действие = "kill" Тогда
		УдалитьВсеСеансыИСоединенияБазы();
	ИначеЕсли мЭтоУправлениеСеансами И мНастройки.Действие = "closed" Тогда
		Возврат ?(ПолучитьСписокСеансов().Количество()=0, 
			МенеджерКомандПриложения.РезультатыКоманд().Успех, 
			МенеджерКомандПриложения.РезультатыКоманд().ОшибкаВремениВыполнения
		);

	ИначеЕсли мЭтоУправлениеРегламентнымиЗаданиями И мНастройки.Действие = "lock" Тогда
		УстановитьСтатусБлокировкиРЗ(Истина);
	ИначеЕсли мЭтоУправлениеРегламентнымиЗаданиями И мНастройки.Действие = "unlock" Тогда
		УстановитьСтатусБлокировкиРЗ(Ложь);

	ИначеЕсли мЭтоПолучениеИнформацииИБ Тогда
		// сообщить информацию
		Информация = ПолучитьИнформациюОБазеДанных();
		Сообщить(Информация);

	Иначе
		Лог.Ошибка("Неизвестное действие: " + мНастройки.Действие);
		Возврат МенеджерКомандПриложения.РезультатыКоманд().НеверныеПараметры;
	КонецЕсли;

	Возврат МенеджерКомандПриложения.РезультатыКоманд().Успех;
	
КонецФункции

Процедура ПрочитатьПараметры(Знач ПараметрыКоманды)
	
	мНастройки = Новый Структура;
	
	Для Каждого КЗ Из ПараметрыКоманды Цикл
		Лог.Отладка(КЗ.Ключ + " = " + КЗ.Значение);
	КонецЦикла;
	
	мНастройки.Вставить("АдресСервераАдминистрирования", ПараметрыКоманды["--ras"]);
	мНастройки.Вставить("ПутьКлиентаАдминистрирования", ПараметрыКоманды["--rac"]);
	мНастройки.Вставить("ИмяБазыДанных", ПараметрыКоманды["--db"]);
	мНастройки.Вставить("АдминистраторИБ", ПараметрыКоманды["--db-user"]);
	мНастройки.Вставить("ПарольАдминистратораИБ", ПараметрыКоманды["--db-pwd"]);
	мНастройки.Вставить("АдминистраторКластера", ПараметрыКоманды["--cluster-admin"]);
	мНастройки.Вставить("ПарольАдминистратораКластера", ПараметрыКоманды["--cluster-pwd"]);
	мНастройки.Вставить("ИспользуемаяВерсияПлатформы", ПараметрыКоманды["--v8version"]);
	мНастройки.Вставить("КлючРазрешенияЗапуска", ПараметрыКоманды["--uccode"]);
	мНастройки.Вставить("СообщениеОблокировке", ПараметрыКоманды["--lockmessage"]);
	мНастройки.Вставить("ВремяСтартаБлокировки", ПараметрыКоманды["--lockstart"]);
	мНастройки.Вставить("ВремяСтартаБлокировкиЧерез", ПараметрыКоманды["--lockstartat"]);
	мНастройки.Вставить("ЧислоПопыток", ПараметрыКоманды["--try"]);
	мНастройки.Вставить("НеБлокироватьСеансы", ПараметрыКоманды["--with-nolock"]);
	мНастройки.Вставить("ФильтрСеансов", ПолучитьСоставляющиеФильтра(ПараметрыКоманды["--filter"]));
	
	мНастройки.Вставить("Действие", ПараметрыКоманды["Действие"]);
	
	//Получим путь к платформе если вдруг не установленна
	мНастройки.ПутьКлиентаАдминистрирования = ПолучитьПутьКRAC(мНастройки.ПутьКлиентаАдминистрирования, мНастройки.ИспользуемаяВерсияПлатформы);
	Если ПустаяСтрока(мНастройки.АдресСервераАдминистрирования) Тогда
		мНастройки.АдресСервераАдминистрирования = "localhost:1545";
	КонецЕсли;
	
КонецПроцедуры

Функция ПараметрыВведеныКорректно()
	
	Успех = Истина;
	
	Если Не ЗначениеЗаполнено(мНастройки.АдресСервераАдминистрирования) Тогда
		Лог.Ошибка("Не указан сервер администрирования");
		Успех = Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(мНастройки.ПутьКлиентаАдминистрирования) Тогда
		Лог.Ошибка("Не указан клиент администрирования");
		Успех = Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(мНастройки.ИмяБазыДанных) Тогда
		Лог.Ошибка("Не указано имя базы данных");
		Успех = Ложь;
	КонецЕсли;
	
	Если (мЭтоУправлениеРегламентнымиЗаданиями Или мЭтоУправлениеСеансами) И Не ЗначениеЗаполнено(мНастройки.Действие) Тогда
		Лог.Ошибка("Не указано действие lock/unlock");
		Успех = Ложь;
	КонецЕсли;

	Если мНастройки.ЧислоПопыток <> Неопределено Тогда
		Попытка
			ПопыткиЧислом = Число(мНастройки.ЧислоПопыток);
		Исключение
			Лог.Ошибка("Параметр --try не является числовым.");
			Успех = Ложь;
		КонецПопытки;

		Если Успех и ПопыткиЧислом <= 0 Тогда
			ПопыткиЧислом = 1;
			Лог.Предупреждение("Параметр --try не представляет собой число попыток. Он будет проигнорирован");
		КонецЕсли;

		Если Успех Тогда
			мНастройки.ЧислоПопыток = ПопыткиЧислом;
		Иначе
			мНастройки.ЧислоПопыток = 1;
		КонецЕсли;
	Иначе
		мНастройки.ЧислоПопыток = 1;
	КонецЕсли;
	
	Возврат Успех;
	
КонецФункции

/////////////////////////////////////////////////////////////////////////////////
// Взаимодействие с кластером

Процедура УдалитьВсеСеансыИСоединенияБазы()
	


	Если мНастройки.НеБлокироватьСеансы=Неопределено Или мНастройки.НеБлокироватьСеансы=Ложь Тогда
		УстановитьСтатусБлокировкиСеансов(Истина);
	КонецЕсли;

	Пауза_ПолСекунды = 500;
	Пауза_ДесятьСек = 10000;

	Для Сч = 1 По мНастройки.ЧислоПопыток Цикл
		Попытка
			
			ОтключитьСуществующиеСеансы();
			Приостановить(Пауза_ПолСекунды);
			Сеансы = ПолучитьСписокСеансов();
			
			Если Сеансы.Количество() Тогда
				Лог.Информация("Пауза перед отключением соединений");
				Приостановить(Пауза_ДесятьСек);
				ОтключитьСоединенияСРабочимиПроцессами();
			КонецЕсли;
			
			Прервать;

		Исключение
			Лог.Предупреждение("Попытка удаления сеансов не удалась. Текст ошибки:
			|%1", ИнформацияОбОшибке().Описание);
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьСтатусБлокировкиСеансов(Знач Блокировать)
	
	КлючиАвторизацииВБазе = КлючиАвторизацииВБазе();
	
	ИдентификаторКластера = ИдентификаторКластера();
	ИдентификаторБазы = ИдентификаторБазы();
	
	Если Блокировать Тогда
		КлючРазрешенияЗапускаПоУмолчанию = ИдентификаторБазы;
	Иначе
		КлючРазрешенияЗапускаПоУмолчанию = "";
	КонецЕсли;
	КлючРазрешенияЗапуска = ?(ПустаяСтрока(мНастройки.КлючРазрешенияЗапуска), КлючРазрешенияЗапускаПоУмолчанию, мНастройки.КлючРазрешенияЗапуска);

	ВремяБлокировки = мНастройки.ВремяСтартаБлокировки;
	Если ПустаяСтрока(ВремяБлокировки) И Не ПустаяСтрока(мНастройки.ВремяСтартаБлокировкиЧерез) Тогда
		Секунды = 0;
		Попытка
			Секунды = Число(мНастройки.ВремяСтартаБлокировкиЧерез);
		Исключение
			Лог.Предупреждение("Не удалось получить количество секунд ожидания перед блокировкой. Текст ошибки:
			|%1", ИнформацияОбОшибке().Описание);
		КонецПопытки;
		
		ВремяБлокировки = Формат(ТекущаяДата() + Секунды, "ДФ='yyyy-MM-ddTHH:mm:ss'");

	КонецЕсли;
	
	КомандаВыполнения = СтрокаЗапускаКлиента() + СтрШаблон("infobase update --infobase=""%3""%4 --cluster=""%1""%2 --sessions-deny=%5 --denied-message=""%6"" --denied-from=""%8"" --permission-code=""%7""",
		ИдентификаторКластера,
		КлючиАвторизацииВКластере(),
		ИдентификаторБазы,
		КлючиАвторизацииВБазе,
		?(Блокировать, "on", "off"), 
		мНастройки.СообщениеОблокировке, 
		КлючРазрешенияЗапуска, 
		ВремяБлокировки) + " "+мНастройки.АдресСервераАдминистрирования;
		
	Для Сч = 1 По мНастройки.ЧислоПопыток Цикл
		Попытка
			ЗапуститьПроцесс(КомандаВыполнения);
			Прервать;
		Исключение
			Лог.Предупреждение("Попытка запуска rac не удалась. Текст ошибки:
			|%1", ИнформацияОбОшибке().Описание);
		КонецПопытки;
	КонецЦикла;
	
	Лог.Информация("Сеансы " + ?(Блокировать, "запрещены", "разрешены"));
	
КонецПроцедуры

Процедура УстановитьСтатусБлокировкиРЗ(Знач Блокировать)
	
	КлючиАвторизацииВБазе = КлючиАвторизацииВБазе();
	
	ИдентификаторКластера = ИдентификаторКластера();
	ИдентификаторБазы = ИдентификаторБазы();
	
	КомандаВыполнения = СтрокаЗапускаКлиента() + 
		СтрШаблон("infobase update --infobase=""%3""%4 --cluster=""%1""%2 --scheduled-jobs-deny=%5",
			ИдентификаторКластера,
			КлючиАвторизацииВКластере(),
			ИдентификаторБазы,
			КлючиАвторизацииВБазе,
			?(Блокировать, "on", "off")
		) + " "+мНастройки.АдресСервераАдминистрирования;
		
	ЗапуститьПроцесс(КомандаВыполнения);
	
	Лог.Информация("Регламентные задания " + ?(Блокировать, "запрещены", "разрешены"));
	
КонецПроцедуры

Функция ПолучитьИнформациюОБазеДанных()
	
	КлючиАвторизацииВБазе = КлючиАвторизацииВБазе();
	
	ИдентификаторКластера = ИдентификаторКластера();
	ИдентификаторБазы = ИдентификаторБазы();
	
	КомандаВыполнения = СтрокаЗапускаКлиента() + 
		СтрШаблон("infobase info --infobase=""%3""%4 --cluster=""%1""%2",
			ИдентификаторКластера,
			КлючиАвторизацииВКластере(),
			ИдентификаторБазы,
			КлючиАвторизацииВБазе
		) + " "+мНастройки.АдресСервераАдминистрирования;
		
	Результат = ЗапуститьПроцесс(КомандаВыполнения);
	
	Возврат Результат;
	
КонецФункции

Функция КлючиАвторизацииВБазе()
	КлючиАвторизацииВБазе = "";
	Если ЗначениеЗаполнено(мНастройки.АдминистраторИБ) Тогда
		КлючиАвторизацииВБазе = КлючиАвторизацииВБазе + СтрШаблон(" --infobase-user=""%1""", мНастройки.АдминистраторИБ);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(мНастройки.ПарольАдминистратораИБ) Тогда
		КлючиАвторизацииВБазе = КлючиАвторизацииВБазе + СтрШаблон(" --infobase-pwd=""%1""", мНастройки.ПарольАдминистратораИБ);
	КонецЕсли;
	
	Возврат КлючиАвторизацииВБазе;
	
КонецФункции


Функция ИдентификаторКластера()

	Если мИдентификаторКластера = Неопределено Тогда
		Лог.Информация("Получаю список кластеров");
		
		КомандаВыполнения = СтрокаЗапускаКлиента() + "cluster list" + " "+мНастройки.АдресСервераАдминистрирования;
	   
		СписокКластеров = ЗапуститьПроцесс(КомандаВыполнения);
	   
		УИДКластера = Сред(СписокКластеров, (Найти(СписокКластеров, ":") + 1), Найти(СписокКластеров, "host") - Найти(СписокКластеров, ":") - 1);	
		мИдентификаторКластера = СокрЛП(СтрЗаменить(УИДКластера, Символы.ПС, ""));
	
	КонецЕсли;
	
	Если ПустаяСтрока(мИдентификаторКластера) Тогда
		ВызватьИсключение "Кластер серверов отсутствует";
	КонецЕсли;
	
	Возврат мИдентификаторКластера;
	
КонецФункции

Функция ИдентификаторБазы()
	Если мИдентификаторБазы = Неопределено Тогда
		мИдентификаторБазы = НайтиБазуВКластере();
	КонецЕсли;
	
	Возврат мИдентификаторБазы;
КонецФункции

Функция НайтиБазуВКластере()
	
	КомандаВыполнения = СтрокаЗапускаКлиента() + СтрШаблон("infobase summary list --cluster=""%1""%2",
	ИдентификаторКластера(), 
	КлючиАвторизацииВКластере()) + " " + мНастройки.АдресСервераАдминистрирования;
	
	Лог.Информация("Получаю список баз кластера");
	
	СписокБазВКластере = СокрЛП(ЗапуститьПроцесс(КомандаВыполнения));    
	Лог.Отладка(СписокБазВКластере);
	ЧислоСтрок = СтрЧислоСтрок(СписокБазВКластере);
	НайденаБазаВКластере = Ложь;
	Для К = 1 По ЧислоСтрок Цикл
		
		СтрокаРазбора = СтрПолучитьСтроку(СписокБазВКластере, К);   
		ПозицияРазделителя = Найти(СтрокаРазбора, ":");
		Если Найти(СтрокаРазбора, "infobase") > 0 Тогда						
			УИДИБ =  СокрЛП(Сред(СтрокаРазбора, ПозицияРазделителя + 1));	
		ИначеЕсли Найти(СтрокаРазбора, "name") > 0 Тогда 
			ИмяБазы = СокрЛП(Сред(СтрокаРазбора, ПозицияРазделителя + 1));
			Если Нрег(ИмяБазы) = НРег(мНастройки.ИмяБазыДанных) Тогда
				Лог.Информация("Получен УИД базы");
				НайденаБазаВКластере = Истина;
				Прервать;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	Если Не НайденаБазаВКластере Тогда
		ВызватьИсключение "База " + мНастройки.ИмяБазыДанных + " не найдена в кластере";
	КонецЕсли;
	
	Возврат УИДИБ;
	
КонецФункции

Функция КлючиАвторизацииВКластере()
	КомандаВыполнения = "";
	Если ЗначениеЗаполнено(мНастройки.АдминистраторКластера) Тогда
		КомандаВыполнения = КомандаВыполнения + СтрШаблон(" --cluster-user=""%1""", мНастройки.АдминистраторКластера);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(мНастройки.ПарольАдминистратораКластера) Тогда
		КомандаВыполнения = КомандаВыполнения + СтрШаблон(" --cluster-pwd=""%1""", мНастройки.ПарольАдминистратораКластера);
	КонецЕсли;
	Возврат КомандаВыполнения;
КонецФункции

Функция СтрокаЗапускаКлиента()
	Перем ПутьКлиентаАдминистрирования;
	Если ЭтоWindows Тогда 
		ПутьКлиентаАдминистрирования = ОбщиеМетоды.ОбернутьПутьВКавычки(мНастройки.ПутьКлиентаАдминистрирования);
	Иначе
		ПутьКлиентаАдминистрирования = мНастройки.ПутьКлиентаАдминистрирования;
	КонецЕсли;
	
	Возврат  ПутьКлиентаАдминистрирования + " ";
	
КонецФункции


Функция ЗапуститьПроцесс(Знач СтрокаВыполнения)
	Перем ПаузаОжиданияЧтенияБуфера;
	
	ПаузаОжиданияЧтенияБуфера = 20;
	
	Лог.Отладка(СтрокаВыполнения);
	Процесс = СоздатьПроцесс(СтрокаВыполнения, ,Истина);
	Процесс.Запустить();
	
	Текст = Новый ТекстовыйДокумент;
	
	Пока Истина Цикл
		
		ВывестиДанныеПроцесса(Процесс, Текст);
		
		Если Процесс.Завершен Тогда
			Процесс.ОжидатьЗавершения(); // финальный сброс буферов
			ВывестиДанныеПроцесса(Процесс, Текст);
			Прервать;
		КонецЕсли;
		
		Приостановить(ПаузаОжиданияЧтенияБуфера);
		
	КонецЦикла;
	
	Если Процесс.КодВозврата = 0 Тогда
		Возврат Текст.ПолучитьТекст();
	Иначе
		ВызватьИсключение "Сообщение от RAS/RAC 
		|" + Текст.ПолучитьТекст();
	КонецЕсли;	
	
КонецФункции

Процедура ВывестиДанныеПроцесса(Знач Процесс, Знач Приемник)
	Вывод = Процесс.ПотокВывода.Прочитать();
	Ошибки = Процесс.ПотокОшибок.Прочитать();
	Если СтрДлина(Строка(Вывод)) > 0 Тогда
		Приемник.ДобавитьСтроку(Вывод);
	КонецЕсли;
	Если СтрДлина(Строка(Ошибки)) > 0 Тогда
		Приемник.ДобавитьСтроку(Ошибки);
	КонецЕсли;
КонецПроцедуры

Процедура ОтключитьСуществующиеСеансы()

	Лог.Информация("Отключаю существующие сеансы");
	
	СеансыБазы = ПолучитьСписокСеансов();
	Для Каждого Сеанс Из СеансыБазы Цикл
		Попытка
			ОтключитьСеанс(Сеанс);
		Исключение
			Лог.Ошибка(ОписаниеОшибки());
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьСписокСеансов()
	
	ТаблицаСеансов = Новый ТаблицаЗначений;
	ТаблицаСеансов.Колонки.Добавить("Идентификатор");
	ТаблицаСеансов.Колонки.Добавить("Приложение");
	ТаблицаСеансов.Колонки.Добавить("Пользователь");
	ТаблицаСеансов.Колонки.Добавить("НомерСеанса");
	
	КомандаЗапуска = СтрокаЗапускаКлиента() + СтрШаблон("session list --cluster=""%1""%2 --infobase=""%3""",
		ИдентификаторКластера(), 
		КлючиАвторизацииВКластере(),
		ИдентификаторБазы()) + " " + мНастройки.АдресСервераАдминистрирования;
	
	СписокСеансовИБ = ЗапуститьПроцесс(КомандаЗапуска);	
	
	Данные = РазобратьПоток(СписокСеансовИБ);
	
	Для Каждого Элемент Из Данные Цикл
		
		Если Не СеансВФильтре(Новый Структура("Приложение, Пользователь", Элемент["app-id"], Элемент["user-name"])) Тогда
			Продолжить;
		КонецЕсли;

		ТекСтрока = ТаблицаСеансов.Добавить();
		ТекСтрока.Идентификатор = Элемент["session"];
		ТекСтрока.Пользователь  = Элемент["user-name"];
		ТекСтрока.Приложение    = Элемент["app-id"];
		ТекСтрока.НомерСеанса   = Элемент["session-id"];

	КонецЦикла;
	
	Возврат ТаблицаСеансов;
	
КонецФункции

Процедура ОтключитьСеанс(Знач Сеанс)

	СтрокаВыполнения = СтрокаЗапускаКлиента() + СтрШаблон("session terminate --cluster=""%1""%2 --session=""%3""",
		ИдентификаторКластера(),
		КлючиАвторизацииВКластере(),
		Сеанс.Идентификатор) + " " + мНастройки.АдресСервераАдминистрирования;
	
	Лог.Информация(СтрШаблон("Отключаю сеанс: %1 [%2] (%3)", Сеанс.НомерСеанса, Сеанс.Пользователь, Сеанс.Приложение));
	
	ЗапуститьПроцесс(СтрокаВыполнения);

КонецПроцедуры

Процедура ОтключитьСоединенияСРабочимиПроцессами()
	
	Процессы = ПолучитьСписокРабочихПроцессов();
	
	Для Каждого РабочийПроцесс Из Процессы Цикл
		Если РабочийПроцесс["running"] = "yes" Тогда
			
			СписокСоединений = ПолучитьСоединенияРабочегоПроцесса(РабочийПроцесс);
			Для Каждого Соединение Из СписокСоединений Цикл
				
				Попытка
					РазорватьСоединениеСПроцессом(РабочийПроцесс, Соединение);
				Исключение
					Лог.Ошибка(ОписаниеОшибки());
				КонецПопытки;
				
			КонецЦикла;
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьСписокРабочихПроцессов()
	
	КомандаЗапускаПроцессы = СтрокаЗапускаКлиента() + СтрШаблон("process list --cluster=""%1""%2",
		ИдентификаторКластера(), 
		КлючиАвторизацииВКластере()) + " " + мНастройки.АдресСервераАдминистрирования;
		
	Лог.Информация("Получаю список рабочих процессов...");
	СписокПроцессов = ВыполнитьКоманду(КомандаЗапускаПроцессы);
	
	Результат = РазобратьПоток(СписокПроцессов);

	НеВФильтре = Новый Массив;
	Для Каждого ТекПроцесс Из Результат Цикл
		Если Не СеансВФильтре(Новый Структура("Приложение, Пользователь", ТекПроцесс["app-id"], ТекПроцесс["user-name"])) Тогда
			НеВФильтре.Добавить(ТекПроцесс);
		КонецЕсли;
	КонецЦикла;

	Для Каждого Уд Из НеВФильтре Цикл
		Результат.Удалить(Уд);
	КонецЦикла;

	Возврат Результат;
	
КонецФункции

Функция ПолучитьСоединенияРабочегоПроцесса(Знач РабочийПроцесс)
	
	КомандаЗапускаСоединения = СтрокаЗапускаКлиента() + СтрШаблон("connection list --cluster=""%1""%2 --infobase=%3%4 --process=%5",
				ИдентификаторКластера(), 
				КлючиАвторизацииВКластере(),
				ИдентификаторБазы(),
				КлючиАвторизацииВБазе(),
				РабочийПроцесс["process"]) + " " + мНастройки.АдресСервераАдминистрирования;
				
	Лог.Информация("Получаю список соединений...");
	Возврат РазобратьПоток(ВыполнитьКоманду(КомандаЗапускаСоединения));
	
КонецФункции

Функция РазорватьСоединениеСПроцессом(Знач РабочийПроцесс, Знач Соединение)
	
	КомандаРазрывСоединения = СтрокаЗапускаКлиента() + СтрШаблон("connection disconnect --cluster=""%1""%2 --infobase=%3%4 --process=%5 --connection=%6",
	ИдентификаторКластера(), 
	КлючиАвторизацииВКластере(),
	ИдентификаторБазы(),
	КлючиАвторизацииВБазе(),
	РабочийПроцесс["process"],
	Соединение["connection"]) + " " + мНастройки.АдресСервераАдминистрирования;
	
	Сообщение = СтрШаблон("Отключаю соединение %1 [%2] (%3)",
	Соединение["conn-id"],
	Соединение["app-id"],
	Соединение["user-name"]);
	
	Лог.Информация(Сообщение);
	
	Возврат ВыполнитьКоманду(КомандаРазрывСоединения);
	
КонецФункции

Функция РазобратьПоток(Знач Поток) Экспорт
	
	ТД = Новый ТекстовыйДокумент;
	ТД.УстановитьТекст(Поток);
	
	СписокОбъектов = Новый Массив;
	ТекущийОбъект = Неопределено;
	
	Для Сч = 1 По ТД.КоличествоСтрок() Цикл
		
		Текст = ТД.ПолучитьСтроку(Сч);
		Если ПустаяСтрока(Текст) или ТекущийОбъект = Неопределено Тогда
			Если ТекущийОбъект <> Неопределено и ТекущийОбъект.Количество() = 0 Тогда
				Продолжить; // очередная пустая строка подряд
			КонецЕсли;
			 
			ТекущийОбъект = Новый Соответствие;
			СписокОбъектов.Добавить(ТекущийОбъект);
		КонецЕсли;
		
		СтрокаРазбораИмя      = "";
		СтрокаРазбораЗначение = "";
		
		Если РазобратьНаКлючИЗначение(Текст, СтрокаРазбораИмя, СтрокаРазбораЗначение) Тогда
			ТекущийОбъект[СтрокаРазбораИмя] = СтрокаРазбораЗначение;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ТекущийОбъект <> Неопределено и ТекущийОбъект.Количество() = 0 Тогда
		СписокОбъектов.Удалить(СписокОбъектов.ВГраница());
	КонецЕсли; 
	
	Возврат СписокОбъектов;
	
КонецФункции

Функция ПолучитьПутьКRAC(ТекущийПуть, Знач ВерсияПлатформы = "")
	
	Если НЕ ПустаяСтрока(ТекущийПуть) Тогда 
		ФайлУтилиты = Новый Файл(ТекущийПуть);
		Если ФайлУтилиты.Существует() Тогда 
			Лог.Отладка("Текущая версия rac " + ФайлУтилиты.ПолноеИмя);
			Возврат ФайлУтилиты.ПолноеИмя;
		КонецЕсли;
	КонецЕсли;
	
	Если ПустаяСтрока(ВерсияПлатформы) Тогда 
		ВерсияПлатформы = "8.3";
	КонецЕсли;
	
	Конфигуратор = Новый УправлениеКонфигуратором;
	ПутьКПлатформе = Конфигуратор.ПолучитьПутьКВерсииПлатформы(ВерсияПлатформы);
	Лог.Отладка("Используемый путь для поиска rac " + ПутьКПлатформе);
	КаталогУстановки = Новый Файл(ПутьКПлатформе);
	Лог.Отладка(КаталогУстановки.Путь);
	
	
	ИмяФайла = ?(ЭтоWindows, "rac.exe", "rac");
	
	ФайлУтилиты = Новый Файл(ОбъединитьПути(Строка(КаталогУстановки.Путь), ИмяФайла));
	Если ФайлУтилиты.Существует() Тогда 
		Лог.Отладка("Текущая версия rac " + ФайлУтилиты.ПолноеИмя);
		Возврат ФайлУтилиты.ПолноеИмя;
	КонецЕсли;
	
	Возврат ТекущийПуть;
	
КонецФункции

Функция РазобратьНаКлючИЗначение(Знач СтрокаРазбора, Ключ, Значение)
	
	ПозицияРазделителя = Найти(СтрокаРазбора, ":");
	Если ПозицияРазделителя = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Ключ     = СокрЛП(Лев(СтрокаРазбора, ПозицияРазделителя - 1));
	Значение = СокрЛП(Сред(СтрокаРазбора, ПозицияРазделителя + 1));
	
	Возврат Истина;
	
КонецФункции

Функция ПолучитьСоставляющиеФильтра(СтрокаФильтра)
	
	Результат = Новый Структура;
	СоставФильтра = СтрРазделить(СтрокаФильтра, "|", Ложь);

	Для Каждого ТекСтр Из СоставФильтра Цикл
		РазобратьСоставляющуюФильтра(Результат, ТекСтр);
	КонецЦикла;

	Возврат Результат;

КонецФункции

Процедура РазобратьСоставляющуюФильтра(РезультатСтруктура, Составляющая)

	ПозРавно = СтрНайти(Составляющая, "=");
	Если ПозРавно=0 Тогда
		Возврат;
	КонецЕсли;

	ИмяФильтра = Лев(Составляющая, ПозРавно - 1);

	Попытка
		ПроверкаИмени = Новый Структура(ИмяФильтра);
	Исключение
		Возврат;
	КонецПопытки;

	СодержаниеСтрока = Сред(Составляющая, ПозРавно + 1);
	Если ПустаяСтрока(СодержаниеСтрока) Тогда
		Возврат;
	КонецЕсли;

	СодержаниеМассив = СтрРазделить(СодержаниеСтрока, ";", Ложь);
	РезультатСтруктура.Вставить(ИмяФильтра, СодержаниеМассив);

КонецПроцедуры

Функция СеансВФильтре(Сеанс)

	Результат = Истина;

	Если Не ЗначениеЗаполнено(мНастройки.ФильтрСеансов) Тогда
		Возврат Результат;
	КонецЕсли;

	Результат = Результат И ПараметрСеансаВФильтре("appid", Сеанс.Приложение);
	Результат = Результат И ПараметрСеансаВФильтре("name", Сеанс.Пользователь);

	Возврат Результат;
	
КонецФункции

Функция ПараметрСеансаВФильтре(ИмяФильтра, ПроверяемоеЗначение)
	
	Если Не ЗначениеЗаполнено(мНастройки.ФильтрСеансов) Или Не мНастройки.ФильтрСеансов.Свойство(ИмяФильтра) Тогда
		Возврат Истина;
	КонецЕсли;
	
	ЗначенияФильтра = мНастройки.ФильтрСеансов[ИмяФильтра];
	Для Каждого ТекЗначение Из ЗначенияФильтра Цикл
		ВФильтре = ВРег(ТекЗначение)=ВРег(ПроверяемоеЗначение);
		Если ВФильтре Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;

	Возврат Ложь;

КонецФункции

/////////////////////////////////////////////////////////////////////////////////
СистемнаяИнформация = Новый СистемнаяИнформация;
ЭтоWindows = Найти(НРег(СистемнаяИнформация.ВерсияОС), "windows") > 0;
// Лог = Логирование.ПолучитьЛог("vanessa.app.deployka");
