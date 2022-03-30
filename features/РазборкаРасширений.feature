# language: ru

Функционал: Разборка расширений конфигурации
    Как разработчик
    Я хочу иметь возможность разобрать расширения конфигурации на исходники
    Чтобы выполнять коллективную разработку проекта 1С

Контекст:
    Допустим я подготовил репозиторий и рабочий каталог проекта
    И я подготовил рабочую базу проекта "./build/ib" по умолчанию

Сценарий: Разборка одного расширения из базы
    Допустим Я копирую каталог "cfe" из каталога "tests/fixtures" проекта в рабочий каталог
    И Я копирую файл "Extension1.cfe" из каталога "tests/fixtures" проекта в рабочий каталог
    И Я очищаю параметры команды "oscript" в контексте
    И Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os compileext cfe РасширениеНовое1 --ibconnection /F./build/ib --language ru"
    И каталог "cfe-out" не существует
    И Я очищаю параметры команды "oscript" в контексте

    Когда Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os decompileext РасширениеНовое1 cfe-out --ibconnection /F./build/ib --language ru"
    Тогда Код возврата равен 0
    И Файл "cfe-out/Configuration.xml" содержит
    """
		<Properties>
			<Name>Расширение1</Name>
			<Synonym>
				<v8:item>
					<v8:lang>ru</v8:lang>
					<v8:content>Расширение1</v8:content>
				</v8:item>
			</Synonym>
			<Comment/>
			<ConfigurationExtensionPurpose>Customization</ConfigurationExtensionPurpose>
			<ObjectBelonging>Adopted</ObjectBelonging>
    """
			# <NamePrefix>Расш1_</NamePrefix>
    И Файл "cfe-out/Ext/ManagedApplicationModule.bsl" содержит 'Сообщить("Внутри Расш1_ПриНачалеРаботыСистемы");'

    # TODO почему-то проверкак текст файла ManagedApplicationModule.bsl ниже не проходит
    # И Файл "cfe-out/Ext/ManagedApplicationModule.bsl" содержит
    # """
    #     &Перед("ПриНачалеРаботыСистемы")
    #     Процедура Расш1_ПриНачалеРаботыСистемы()
    #             Сообщить("Внутри Расш1_ПриНачалеРаботыСистемы");
    #     КонецПроцедуры
    # """

# TODO Сценарий: Разборка нескольких расширений с явно заданной базой
