﻿
Процедура ЗаполнитьНаборТестов(НаборТестов) Экспорт
	НаборТестов.Добавить("ТестOK");	
КонецПроцедуры

Процедура ТестOK(Ванесса) Экспорт 
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = "Тест OK!";
	Сообщение.Сообщить();
	
КонецПроцедуры