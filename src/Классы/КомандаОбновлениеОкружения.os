///////////////////////////////////////////////////////////////////
//
// Служебный модуль с набором методов работы с командами приложения
//
// Структура модуля реализована в соответствии с рекомендациями
// oscript-app-template (C) EvilBeaver
//
///////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

Перем Лог; // Экземпляр логгера
Перем КорневойПутьПроекта;

Перем ДанныеПодключения;
Перем ПараметрыХранилища;
Перем РежимыРеструктуризации;
Перем РежимРазработчика;
Перем ПутьКИсходникам;
Перем ПутьКФайлуВыгрузки;
Перем ИнкрементальнаяЗагрузкаGit;
Перем СниматьСПоддержки;

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт

	ТекстОписания =
		"     Обновление ИБ 1С.
		|";

	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды, ТекстОписания);

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--src", "Путь к папке исходников
	|
	|Схема работы:
	|		Указываем путь к исходникам с конфигурацией,
	|		указываем версию платформы, которую хотим использовать,
	|		и получаем по пути build\ib готовую базу для тестирования.");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--dt", "Путь к файлу с dt выгрузкой");
	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--dev",
		"Признак dev режима, создаем и загружаем автоматом структуру конфигурации");
	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--disable-support",
		"Снимает конфигурации с поддержки перед загрузкой исходников");

	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--git-increment",
		СтрШаблон("Инкременальная загрузка по git diff
		|	Схема работы
		| 		При загрузке в каталоге исходников (--src) ищется файл
		| 		%1 (необходимо добавить в .gitignore).
		| 		Если файл найден, получается дифф изменений относительно
		| 		последнего загруженного коммиту к HEAD.
		| 		Если файл не найден, происходит полная загрузка.
		| 		После загрузки создается\обновляется файл %1
		|", ИмяФайлаПредыдущегоГитКоммита()));

	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--storage", "Признак обновления из хранилища");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--storage-name", "Строка подключения к хранилищу");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--storage-user", "Пользователь хранилища");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--storage-pwd", "Пароль");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--storage-ver",
		"Номер версии, по умолчанию берем последнюю");

	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--v1",
		"Поддержка режима реструктуризации -v1 на сервере");
	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--v2",
		"Поддержка режима реструктуризации -v2 на сервере");

	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--ibcmd",
		"Использовать утилиту ibcmd вместо конфигуратора");

	Парсер.ДобавитьКоманду(ОписаниеКоманды);

КонецПроцедуры // ЗарегистрироватьКоманду

// Выполняет логику команды
//
// Параметры:
//   ПараметрыКоманды - Соответствие - Соответствие ключей командной строки и их значений
//   ДополнительныеПараметры - Структура - дополнительные параметры (необязательно)
//
//  Возвращаемое значение:
//   Число - Код возврата команды.
//
Функция ВыполнитьКоманду(Знач ПараметрыКоманды, Знач ДополнительныеПараметры = Неопределено) Экспорт

	Лог = ОбщиеМетоды.ЛогКоманды(ДополнительныеПараметры);
	КорневойПутьПроекта = ПараметрыСистемы.КорневойПутьПроекта;

	ДанныеПодключения = ПараметрыКоманды["ДанныеПодключения"];

	ПараметрыХранилища = Новый Структура;
	ПараметрыХранилища.Вставить("СтрокаПодключения", ПараметрыКоманды["--storage-name"]);
	ПараметрыХранилища.Вставить("Пользователь", ПараметрыКоманды["--storage-user"]);
	ПараметрыХранилища.Вставить("Пароль", ПараметрыКоманды["--storage-pwd"]);
	ПараметрыХранилища.Вставить("Версия", ПараметрыКоманды["--storage-ver"]);
	ПараметрыХранилища.Вставить("РежимОбновления", ПараметрыКоманды["--storage"]);

	РежимыРеструктуризации = Новый Структура;
	РежимыРеструктуризации.Вставить("Первый", ПараметрыКоманды["--v1"]);
	РежимыРеструктуризации.Вставить("Второй", ПараметрыКоманды["--v2"]);

	ПутьКИсходникам = ОбщиеМетоды.ПолныйПуть(ПараметрыКоманды["--src"]);
	ПутьКФайлуВыгрузки = ОбщиеМетоды.ПолныйПуть(ПараметрыКоманды["--dt"]);

	ИнкрементальнаяЗагрузкаGit = ПараметрыКоманды["--git-increment"];
	СниматьСПоддержки = ПараметрыКоманды["--disable-support"];
	РежимРазработчика = ПараметрыКоманды["--dev"];

	ОбновитьБазуДанных(ПараметрыКоманды);

	Возврат МенеджерКомандПриложения.РезультатыКоманд().Успех;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбновитьБазуДанных(ПараметрыКоманды)

	ТекущаяПроцедура = "Запускаем обновление";

	Если ПустаяСтрока(ДанныеПодключения.ПутьБазы) Тогда
		ДанныеПодключения = СоздатьДанныеПодключения(ДанныеПодключения);
	КонецЕсли;

	СтрокаПодключения = ДанныеПодключения.ПутьБазы;

	Лог.Отладка("ИнициализироватьБазуДанных СтрокаПодключения:" + СтрокаПодключения);

	Если ОбщиеМетоды.ЭтоФайловаяИБ(СтрокаПодключения) Тогда
		КаталогБазы = ОбщиеМетоды.КаталогФайловойИБ(СтрокаПодключения);
		Ожидаем.Что(ФС.КаталогСуществует(КаталогБазы), ТекущаяПроцедура + " папка с базой существует").ЭтоИстина();
	КонецЕсли;

	МенеджерСборки = НовыйМенеджерСборки(ПараметрыКоманды);
	МенеджерСборки.Конструктор(ДанныеПодключения, ПараметрыКоманды);

	Если ЗначениеЗаполнено(ПутьКИсходникам) Тогда
		ЗагрузкаИзИсходников(МенеджерСборки);
	ИначеЕсли ЗначениеЗаполнено(ПутьКФайлуВыгрузки) Тогда
		ЗагрузкаИзФайлаВыгрузки(МенеджерСборки);
	ИначеЕсли ПараметрыХранилища.РежимОбновления Тогда
		ЗагрузкаИзХранилища(МенеджерСборки);
	Иначе
		Лог.Ошибка("Информационная база не обновлялась!");
	КонецЕсли;

	ОбновитьКонфигурациюБД(МенеджерСборки);

	МенеджерСборки.Деструктор();

КонецПроцедуры

Функция ПолучитьСтрокуИзмененныхФайлов(Знач ПутьИсходников)

	Хэш = ПолучитьХэшПоследнегоЗагруженногоКоммита(ПутьИсходников);

	Если ПустаяСтрока(Хэш) Тогда
		Лог.Отладка("Не найден хэш последнего загруженного коммита для инкрементальной загрузки");
		Возврат "";
	КонецЕсли;

	ТекущийКаталог = КорневойПутьПроекта;
	Лог.Отладка("ТекущийКаталог %1", ТекущийКаталог);

	ОтносительныйПутьИсходников = ФС.ОтносительныйПуть(КорневойПутьПроекта, ПутьИсходников, "/");

	КоманднаяСтрока = СтрШаблон("git diff --name-only %1 HEAD", Хэш);
	Лог.Отладка("Запускаю команду git получить измененные файлы %1", КоманднаяСтрока);

	Процесс = СоздатьПроцесс(КоманднаяСтрока, ТекущийКаталог, Истина, , КодировкаТекста.UTF8);
	Процесс.Запустить();

	Процесс.ОжидатьЗавершения();

	СтрокаИзмененныхФайлов = "";
	Пока Процесс.ПотокВывода.ЕстьДанные Цикл

		СтрокаВывода = Процесс.ПотокВывода.ПрочитатьСтроку();
		Лог.Отладка("  Строка вывода команды: %1", СтрокаВывода);
		Если СтрНачинаетсяС(СтрокаВывода, ОтносительныйПутьИсходников)
			И Не ФайлВСпискеИсключений(СтрокаВывода) Тогда

			СтрокаВывода = СкорректироватьПутьКИзменениюФормы(СтрокаВывода);

			ТекущаяСтрока = ОбъединитьПути(ТекущийКаталог, СтрокаВывода);
			ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока, "/", ПолучитьРазделительПути());

			Если СтрНайти(СтрокаИзмененныхФайлов, ТекущаяСтрока) = 0
				И Новый Файл(ТекущаяСтрока).Существует() Тогда

				СтрокаИзмененныхФайлов = СтрокаИзмененныхФайлов + ТекущаяСтрока + ";";

			КонецЕсли;

		КонецЕсли;

	КонецЦикла;
	Лог.Отладка("Ошибки от процесса
		|%1", Процесс.ПотокОшибок.Прочитать());

	Если ЗначениеЗаполнено(СтрокаИзмененныхФайлов) Тогда
		СтрокаИзмененныхФайлов = Лев(СтрокаИзмененныхФайлов, СтрДлина(СтрокаИзмененныхФайлов) - 1);

		ИзменныеФайлыЛог = СтрСоединить(СтрРазделить(СтрокаИзмененныхФайлов, ";"), Символы.ПС);
		Лог.Информация(	"Будет выполнена инкрементальная загрузка
			|Измененные файлы:
	 		|%1",
	 		ИзменныеФайлыЛог
		);
	Иначе
		Лог.Отладка("Не получена строка измененных файлов для инкрементальной загрузки");
	КонецЕсли;

	Возврат СтрокаИзмененныхФайлов;

КонецФункции

Функция ПолучитьХэшПоследнегоЗагруженногоКоммита(Знач ПутьИсходников)

	ИмяФайла = ФайлПредыдущегоГитКоммита(ПутьИсходников).ПолноеИмя;
	Лог.Отладка("Путь файла предыдущего коммита git %1", ИмяФайла);

	Если Не ФС.ФайлСуществует(ИмяФайла) Тогда
		Лог.Отладка("Не существует файл предыдущего коммита git %1", ИмяФайла);
		Возврат "";
	КонецЕсли;

	ЧтениеТекста = Новый ЧтениеТекста(ИмяФайла, КодировкаТекста.UTF8NoBOM);
	Хэш = ЧтениеТекста.Прочитать();
	ЧтениеТекста.Закрыть();

	Возврат СокрЛП(Хэш);

КонецФункции

Процедура ЗаписатьХэшПоследнегоЗагруженногоКоммита(Знач ПутьИсходников)

	ИмяФайла = ФайлПредыдущегоГитКоммита(ПутьИсходников).ПолноеИмя;

	ТекущийКаталог = КорневойПутьПроекта;

	КоманднаяСтрока = "git rev-parse --short HEAD";

	Процесс = СоздатьПроцесс(КоманднаяСтрока, ТекущийКаталог, Истина, , КодировкаТекста.UTF8);
	Процесс.Запустить();

	Процесс.ОжидатьЗавершения();

	Если Процесс.ПотокВывода.ЕстьДанные Тогда

		Хэш = Процесс.ПотокВывода.ПрочитатьСтроку();

		ЗаписьТекста = Новый ЗаписьТекста(ИмяФайла, КодировкаТекста.UTF8NoBOM);
		ЗаписьТекста.Записать(Хэш);
		ЗаписьТекста.Закрыть();

	КонецЕсли;

КонецПроцедуры

Функция СкорректироватьПутьКИзменениюФормы(СтрокаИзмененныхФайлов)

	Паттерн = "(.*Forms\/.*)\/Ext.*";

	РегулярноеВыражение = Новый РегулярноеВыражение(Паттерн);

	КоллекцияСовпаденийРегулярногоВыражения = РегулярноеВыражение.НайтиСовпадения(СтрокаИзмененныхФайлов);

	Если КоллекцияСовпаденийРегулярногоВыражения.Количество() = 1
		И КоллекцияСовпаденийРегулярногоВыражения[0].Группы.Количество() = 2 Тогда

		Возврат РегулярноеВыражение.Заменить(СтрокаИзмененныхФайлов, "$1.xml");

	КонецЕсли;

	Возврат СтрокаИзмененныхФайлов;
КонецФункции

Функция ФайлВСпискеИсключений(ПутьКФайлу)

	Возврат СтрЗаканчиваетсяНа(ПутьКФайлу, "ConfigDumpInfo.xml")
		Или СтрЗаканчиваетсяНа(ПутьКФайлу, "AUTHORS")
		Или СтрЗаканчиваетсяНа(ПутьКФайлу, "VERSION");

КонецФункции

Функция ФайлПредыдущегоГитКоммита(Знач ПутьИсходников)

	Возврат Новый Файл(ОбъединитьПути(КорневойПутьПроекта, ПутьИсходников, ИмяФайлаПредыдущегоГитКоммита()));

КонецФункции

Функция ИмяФайлаПредыдущегоГитКоммита()
	Возврат "lastUploadedCommit.txt";
КонецФункции

Функция НовыйМенеджерСборки(ПараметрыКоманды)

	Если ПараметрыХранилища.РежимОбновления Тогда
		Возврат ОбщиеМетоды.НовыйМенеджерКонфигуратора();
	Иначе
		Возврат ОбщиеМетоды.ФабрикаМенеджераСборки(ПараметрыКоманды);
	КонецЕсли;

КонецФункции

Функция СоздатьДанныеПодключения(ДанныеПодключения)

	_ДанныеПодключения = Новый Структура(ДанныеПодключения);
	ЗаполнитьЗначенияСвойств(_ДанныеПодключения, ДанныеПодключения);
	КаталогБазы = ОбъединитьПути(КорневойПутьПроекта, ?(РежимРазработчика = Истина, "./build/ibservice", "./build/ib"));
	Файл = Новый Файл(КаталогБазы);
	_ДанныеПодключения.ПутьБазы = "/F""" + Файл.ПолноеИмя + """";
	_ДанныеПодключения.СтрокаПодключения = "/F""" + Файл.ПолноеИмя + """";

	Возврат _ДанныеПодключения;

КонецФункции

Процедура ЗагрузкаИзИсходников(МенеджерСборки)

	Лог.Информация("Запускаем обновление конфигурации из исходников...");
	Если ИнкрементальнаяЗагрузкаGit Тогда
	 	СписокФайлов = ПолучитьСтрокуИзмененныхФайлов(ПутьКИсходникам);
	Иначе
	 	СписокФайлов = "";
	КонецЕсли;

	Попытка
		МенеджерСборки.СобратьИзИсходниковТекущуюКонфигурацию(ПутьКИсходникам, СписокФайлов, СниматьСПоддержки);
	Исключение
		МенеджерСборки.Деструктор();
		ВызватьИсключение;
	КонецПопытки;

	Если ИнкрементальнаяЗагрузкаGit Тогда
	 	ЗаписатьХэшПоследнегоЗагруженногоКоммита(ПутьКИсходникам);
	КонецЕсли;

	Лог.Информация("Информационная база обновлена из исходников.");

КонецПроцедуры

Процедура ЗагрузкаИзФайлаВыгрузки(МенеджерСборки)

	Лог.Информация("Запускаем обновление конфигурации из dt-файла...");
	Попытка
		МенеджерСборки.ЗагрузитьИнфобазуИзФайла(ПутьКФайлуВыгрузки);
	Исключение
		МенеджерСборки.Деструктор();
		ВызватьИсключение;
	КонецПопытки;
	Лог.Информация("Информационная база обновлена из файла выгрузки.");

КонецПроцедуры

Процедура ЗагрузкаИзХранилища(МенеджерКонфигуратора)

	Лог.Информация("Обновляем из хранилища");
	Попытка
		МенеджерКонфигуратора.ЗапуститьОбновлениеИзХранилища(
			ПараметрыХранилища.СтрокаПодключения,  ПараметрыХранилища.Пользователь, ПараметрыХранилища.Пароль,
			ПараметрыХранилища.Версия);
	Исключение
		МенеджерКонфигуратора.Деструктор();
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры

Процедура ОбновитьКонфигурациюБД(МенеджерСборки)

	Попытка
		Если РежимРазработчика = Ложь Или РежимыРеструктуризации.Первый Или РежимыРеструктуризации.Второй Тогда
			ОбщиеМетоды.ОбновитьКонфигурациюБД(МенеджерСборки,
				РежимыРеструктуризации.Первый, РежимыРеструктуризации.Второй);
		КонецЕсли;
	Исключение
		МенеджерСборки.Деструктор();
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры

#КонецОбласти
