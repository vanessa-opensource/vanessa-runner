#Использовать asserts
#Использовать tempfiles
#Использовать "utils"
#Использовать "..\.."

#Область ОписаниеПеременных

Перем НакопленныеВременныеФайлы; // фиксация накопленных времнных файлов для сброса

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

&Тест
Процедура ТестДолжен_ЗагузитьКонфигурациюИзФайлаIbcmd() Экспорт

	// Дано
	Исполнитель = Новый Тест_ИсполнительКоманд("load");
	Исполнитель.УстановитьКонтекстПустаяИБ();
	ФайлCf = Исполнитель.ПутьТестовыхДанных("1cv8.cf");
	Исполнитель.ДобавитьПараметр("--src", ФайлCf);
	Исполнитель.ДобавитьФлаг("--ibcmd");
	
	// Когда
	Исполнитель.ВыполнитьКоманду();

	// Тогда
	Исполнитель.ОжидаемЧтоВыводСодержит("Используется ibcmd");
	Исполнитель.ОжидаемЧтоВыводСодержит("Загрузка конфигурации из cf завершена.");
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗапускомТеста() Экспорт
	
	НакопленныеВременныеФайлы = ВременныеФайлы.Файлы();
	
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт
	
	ВременныеФайлы.УдалитьНакопленныеВременныеФайлы(НакопленныеВременныеФайлы);
	
КонецПроцедуры

#КонецОбласти
