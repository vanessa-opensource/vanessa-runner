# language: ru

Функционал: Установка номера версии или сборки файлов конфигурации, расширений, внешних обработок, отчетов
	Как Разработчик/Инженер по тестированию
	Я Хочу иметь возможность автоматической\автоматизированной установки номеров версий или сборок файлов 1С
    Чтобы быстро выпускать новые релизы или собирать артефакты, отличающиеся номерами

Контекст:
    Допустим я подготовил репозиторий и рабочий каталог проекта

    И Я сохраняю значение "INFO" в переменную окружения "LOGOS_LEVEL"
    Дано Я очищаю параметры команды "oscript" в контексте

Сценарий: Изменение версии конфигурации, указан путь Configuration.xml для конфигурации

    # И Я сохраняю значение "DEBUG" в переменную окружения "LOGOS_LEVEL"
    Дано Я копирую каталог "cf" из каталога "tests/fixtures" проекта в рабочий каталог
    Тогда файл "cf/Configuration.xml" содержит "<Version>1.0.0.0</Version>"

    Когда Я добавляю параметр "<КаталогПроекта>/src/main.os set-version" для команды "oscript"
    И Я добавляю параметр "--new-version 2.0.0.0" для команды "oscript"
    И Я добавляю параметр "--src cf/Configuration.xml" для команды "oscript"
    И Я добавляю параметр "--debuglogfile build/a.log" для команды "oscript"

    Когда Я выполняю команду "oscript"
    И Я сообщаю вывод команды "oscript"
    И я показываю текст файла "build/a.log"

    Тогда Вывод команды "oscript" содержит
    | Изменяю версию в исходниках конфигурации или внешнего файла 1С на 2.0.0.0 |
    |     Старая версия 1.0.0.0 |

    И Код возврата команды "oscript" равен 0

    Тогда файл "cf/Configuration.xml" содержит "<Version> 2.0.0.0</Version>"

Сценарий: Изменение версии конфигурации, указан путь Configuration.xml для расширения

    Дано Я копирую каталог "cfe" из каталога "tests/fixtures" проекта в рабочий каталог
    Тогда файл "cfe/Configuration.xml" содержит "<Version>1.1.0.0</Version>"

    Когда Я добавляю параметр "<КаталогПроекта>/src/main.os set-version" для команды "oscript"
    И Я добавляю параметр "--new-version 2.0.0.0" для команды "oscript"
    И Я добавляю параметр "--src cfe/Configuration.xml" для команды "oscript"

    Когда Я выполняю команду "oscript"
    Тогда Вывод команды "oscript" содержит
    | Изменяю версию в исходниках конфигурации или внешнего файла 1С на 2.0.0.0 |
    |     Старая версия 1.1.0.0 |

    И Код возврата команды "oscript" равен 0

    Тогда файл "cfe/Configuration.xml" содержит "<Version> 2.0.0.0</Version>"

Сценарий: Изменение версии конфигурации, указан каталог корня исходников конфигурации

    Дано Я копирую каталог "cf" из каталога "tests/fixtures" проекта в рабочий каталог
    Когда Я добавляю параметр "<КаталогПроекта>/src/main.os set-version" для команды "oscript"
    И Я добавляю параметр "--new-version 2.0.0.0" для команды "oscript"
    И Я добавляю параметр "--src cf" для команды "oscript"
    И Я добавляю параметр "--debuglogfile build/a.log" для команды "oscript"

    Когда Я выполняю команду "oscript"
    И Я сообщаю вывод команды "oscript"
    И я показываю текст файла "build/a.log"
    Тогда Вывод команды "oscript" содержит
    | Изменяю версию в исходниках конфигурации или внешнего файла 1С на 2.0.0.0 |
    |     Старая версия 1.0.0.0 |

    И Код возврата команды "oscript" равен 0

    Тогда файл "cf/Configuration.xml" содержит "<Version> 2.0.0.0</Version>"

Сценарий: Изменение версии конфигурации, указан каталог корня исходников расширения

    Дано Я копирую каталог "cfe" из каталога "tests/fixtures" проекта в рабочий каталог

    Когда Я добавляю параметр "<КаталогПроекта>/src/main.os set-version" для команды "oscript"
    И Я добавляю параметр "--new-version 2.0.0.0" для команды "oscript"
    И Я добавляю параметр "--src cfe" для команды "oscript"

    Когда Я выполняю команду "oscript"
    Тогда Вывод команды "oscript" содержит
    | Изменяю версию в исходниках конфигурации или внешнего файла 1С на 2.0.0.0 |
    |     Старая версия 1.1.0.0 |

    И Код возврата команды "oscript" равен 0

    Тогда файл "cfe/Configuration.xml" содержит "<Version> 2.0.0.0</Version>"

Сценарий: Изменение версии и конфигурации и расширения, указан каталог корня проекта

    Дано Я копирую каталог "cf" из каталога "tests/fixtures" проекта в рабочий каталог
    Дано Я копирую каталог "cfe" из каталога "tests/fixtures" проекта в рабочий каталог

    Когда Я добавляю параметр "<КаталогПроекта>/src/main.os set-version" для команды "oscript"
    И Я добавляю параметр "--new-version 2.0.0.0" для команды "oscript"
    И Я добавляю параметр "--src ." для команды "oscript"
    # И Я добавляю параметр "--debuglogfile build/a.log" для команды "oscript"

    Когда Я выполняю команду "oscript"
    # И Я сообщаю вывод команды "oscript"
    # И я показываю текст файла "build/a.log"
    Тогда Вывод команды "oscript" содержит
    | Изменяю версию в исходниках конфигурации или внешнего файла 1С на 2.0.0.0 |
    |     Старая версия 1.0.0.0 |
    |     Старая версия 1.1.0.0 |

    И Код возврата команды "oscript" равен 0

    Тогда файл "cf/Configuration.xml" содержит "<Version> 2.0.0.0</Version>"
    Тогда файл "cfe/Configuration.xml" содержит "<Version> 2.0.0.0</Version>"

Сценарий: Изменение версии, если в файле не задана версия

    Дано Я копирую каталог "cfe_without_version" из каталога "tests/fixtures" проекта в рабочий каталог

    Когда Я добавляю параметр "<КаталогПроекта>/src/main.os set-version" для команды "oscript"
    И Я добавляю параметр "--new-version 2.0.0.0" для команды "oscript"
    И Я добавляю параметр "--src cfe_without_version" для команды "oscript"

    Когда Я выполняю команду "oscript"
    Тогда Вывод команды "oscript" содержит
    | Изменяю версию в исходниках конфигурации или внешнего файла 1С на 2.0.0.0 |
    |     Старая версия  |

    И Код возврата команды "oscript" равен 0

    Тогда файл "cfe_without_version/Configuration.xml" содержит "<Version>2.0.0.0</Version>"

Сценарий: Изменение версии внешней обработки из комментария, указан путь каталога исходников обработки

    Дано Я копирую каталог "xdd_test" из каталога "tests/fixtures" проекта в подкаталог "build" рабочего каталога
    И я создаю файл "build/xdd_test/xdd_test.xml" с текстом
    """
        <?xml version="1.0" encoding="UTF-8"?>
        <MetaDataObject xmlns="http://v8.1c.ru/8.3/MDClasses" xmlns:app="http://v8.1c.ru/8.2/managed-application/core" xmlns:cfg="http://v8.1c.ru/8.1/data/enterprise/current-config" xmlns:cmi="http://v8.1c.ru/8.2/managed-application/cmi" xmlns:ent="http://v8.1c.ru/8.1/data/enterprise" xmlns:lf="http://v8.1c.ru/8.2/managed-application/logform" xmlns:style="http://v8.1c.ru/8.1/data/ui/style" xmlns:sys="http://v8.1c.ru/8.1/data/ui/fonts/system" xmlns:v8="http://v8.1c.ru/8.1/data/core" xmlns:v8ui="http://v8.1c.ru/8.1/data/ui" xmlns:web="http://v8.1c.ru/8.1/data/ui/colors/web" xmlns:win="http://v8.1c.ru/8.1/data/ui/colors/windows" xmlns:xen="http://v8.1c.ru/8.3/xcf/enums" xmlns:xpr="http://v8.1c.ru/8.3/xcf/predef" xmlns:xr="http://v8.1c.ru/8.3/xcf/readable" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.4">
            <ExternalDataProcessor uuid="b24065c7-de41-4c5a-a404-ddb9a46084ff">
                <InternalInfo>
                    <xr:ContainedObject>
                        <xr:ClassId>c3831ec8-d8d5-4f93-8a22-f9bfae07327f</xr:ClassId>
                        <xr:ObjectId>645cde0d-2357-42ea-8a8b-12cff526f0bd</xr:ObjectId>
                    </xr:ContainedObject>
                    <xr:GeneratedType name="ExternalDataProcessorObject.xdd_test" category="Object">
                        <xr:TypeId>9506ef93-ef46-43e1-b089-9f25add335b2</xr:TypeId>
                        <xr:ValueId>a3f477fd-3fcc-4e25-9f24-0566b2d830fc</xr:ValueId>
                    </xr:GeneratedType>
                </InternalInfo>
                <Properties>
                    <Name>xdd_test</Name>
                    <Synonym/>
                    <Comment>Xdd test v1.2.3.44</Comment>
                </Properties>
                <ChildObjects/>
            </ExternalDataProcessor>
        </MetaDataObject>
    """

    И Я сохраняю значение "DEBUG" в переменную окружения "LOGOS_LEVEL"
    Когда Я добавляю параметр "<КаталогПроекта>/src/main.os set-version" для команды "oscript"
    И Я добавляю параметр "--new-version 2.0.0.0" для команды "oscript"
    И Я добавляю параметр "--for-meta-comment" для команды "oscript"
    И Я добавляю параметр "--src build/xdd_test" для команды "oscript"
    И Я добавляю параметр "--debuglogfile build/a.log" для команды "oscript"

    Когда Я выполняю команду "oscript"
    И Я сообщаю вывод команды "oscript"
    И я показываю текст файла "build/a.log"
    Тогда Вывод команды "oscript" содержит
    | Изменяю версию в исходниках конфигурации или внешнего файла 1С на 2.0.0.0 |
    |     Старая версия 1.2.3.44 |

    И Код возврата команды "oscript" равен 0

    Тогда файл "build/xdd_test/xdd_test.xml" содержит "<Comment>Xdd test v 2.0.0.0</Comment>"

Сценарий: Изменение версии внешней обработки из пустого комментария, указан путь каталога исходников обработки

    Дано Я копирую каталог "xdd_test" из каталога "tests/fixtures" проекта в подкаталог "build" рабочего каталога
    И я создаю файл "build/xdd_test/xdd_test.xml" с текстом
    """
        <?xml version="1.0" encoding="UTF-8"?>
        <MetaDataObject xmlns="http://v8.1c.ru/8.3/MDClasses" xmlns:app="http://v8.1c.ru/8.2/managed-application/core" xmlns:cfg="http://v8.1c.ru/8.1/data/enterprise/current-config" xmlns:cmi="http://v8.1c.ru/8.2/managed-application/cmi" xmlns:ent="http://v8.1c.ru/8.1/data/enterprise" xmlns:lf="http://v8.1c.ru/8.2/managed-application/logform" xmlns:style="http://v8.1c.ru/8.1/data/ui/style" xmlns:sys="http://v8.1c.ru/8.1/data/ui/fonts/system" xmlns:v8="http://v8.1c.ru/8.1/data/core" xmlns:v8ui="http://v8.1c.ru/8.1/data/ui" xmlns:web="http://v8.1c.ru/8.1/data/ui/colors/web" xmlns:win="http://v8.1c.ru/8.1/data/ui/colors/windows" xmlns:xen="http://v8.1c.ru/8.3/xcf/enums" xmlns:xpr="http://v8.1c.ru/8.3/xcf/predef" xmlns:xr="http://v8.1c.ru/8.3/xcf/readable" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.4">
            <ExternalDataProcessor uuid="b24065c7-de41-4c5a-a404-ddb9a46084ff">
                <InternalInfo>
                    <xr:ContainedObject>
                        <xr:ClassId>c3831ec8-d8d5-4f93-8a22-f9bfae07327f</xr:ClassId>
                        <xr:ObjectId>645cde0d-2357-42ea-8a8b-12cff526f0bd</xr:ObjectId>
                    </xr:ContainedObject>
                    <xr:GeneratedType name="ExternalDataProcessorObject.xdd_test" category="Object">
                        <xr:TypeId>9506ef93-ef46-43e1-b089-9f25add335b2</xr:TypeId>
                        <xr:ValueId>a3f477fd-3fcc-4e25-9f24-0566b2d830fc</xr:ValueId>
                    </xr:GeneratedType>
                </InternalInfo>
                <Properties>
                    <Name>xdd_test</Name>
                    <Synonym/>
                    <Comment/>
                </Properties>
                <ChildObjects/>
            </ExternalDataProcessor>
        </MetaDataObject>
    """

    Когда Я добавляю параметр "<КаталогПроекта>/src/main.os set-version" для команды "oscript"
    И Я добавляю параметр "--new-version 2.0.0.0" для команды "oscript"
    И Я добавляю параметр "--for-meta-comment" для команды "oscript"
    И Я добавляю параметр "--src build/xdd_test" для команды "oscript"

    Когда Я выполняю команду "oscript"
    И Я сообщаю вывод команды "oscript"
    Тогда Вывод команды "oscript" содержит
    | Изменяю версию в исходниках конфигурации или внешнего файла 1С на 2.0.0.0 |
    |     Старая версия |

    И Код возврата команды "oscript" равен 0

    Тогда файл "build/xdd_test/xdd_test.xml" содержит "<Comment>2.0.0.0</Comment>"

Сценарий: Изменение версии внешних обработок из комментария, указан путь к каталогу, внутри которого находятся обработки

    Дано я создаю каталог "build/1"
    Дано я создаю каталог "build/2"
    Дано Я копирую каталог "xdd_test" из каталога "tests/fixtures" проекта в подкаталог "build/1" рабочего каталога
    Дано Я копирую каталог "xdd_test" из каталога "tests/fixtures" проекта в подкаталог "build/2" рабочего каталога
    И я создаю файл "build/1/xdd_test/xdd_test.xml" с текстом
    """
        <?xml version="1.0" encoding="UTF-8"?>
        <MetaDataObject xmlns="http://v8.1c.ru/8.3/MDClasses" xmlns:app="http://v8.1c.ru/8.2/managed-application/core" xmlns:cfg="http://v8.1c.ru/8.1/data/enterprise/current-config" xmlns:cmi="http://v8.1c.ru/8.2/managed-application/cmi" xmlns:ent="http://v8.1c.ru/8.1/data/enterprise" xmlns:lf="http://v8.1c.ru/8.2/managed-application/logform" xmlns:style="http://v8.1c.ru/8.1/data/ui/style" xmlns:sys="http://v8.1c.ru/8.1/data/ui/fonts/system" xmlns:v8="http://v8.1c.ru/8.1/data/core" xmlns:v8ui="http://v8.1c.ru/8.1/data/ui" xmlns:web="http://v8.1c.ru/8.1/data/ui/colors/web" xmlns:win="http://v8.1c.ru/8.1/data/ui/colors/windows" xmlns:xen="http://v8.1c.ru/8.3/xcf/enums" xmlns:xpr="http://v8.1c.ru/8.3/xcf/predef" xmlns:xr="http://v8.1c.ru/8.3/xcf/readable" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.4">
            <ExternalDataProcessor uuid="b24065c7-de41-4c5a-a404-ddb9a46084ff">
                <InternalInfo>
                    <xr:ContainedObject>
                        <xr:ClassId>c3831ec8-d8d5-4f93-8a22-f9bfae07327f</xr:ClassId>
                        <xr:ObjectId>645cde0d-2357-42ea-8a8b-12cff526f0bd</xr:ObjectId>
                    </xr:ContainedObject>
                    <xr:GeneratedType name="ExternalDataProcessorObject.xdd_test" category="Object">
                        <xr:TypeId>9506ef93-ef46-43e1-b089-9f25add335b2</xr:TypeId>
                        <xr:ValueId>a3f477fd-3fcc-4e25-9f24-0566b2d830fc</xr:ValueId>
                    </xr:GeneratedType>
                </InternalInfo>
                <Properties>
                    <Name>xdd_test</Name>
                    <Synonym/>
                    <Comment>Xdd test v1.2.3.44</Comment>
                </Properties>
                <ChildObjects/>
            </ExternalDataProcessor>
        </MetaDataObject>
    """
    И я создаю файл "build/2/xdd_test/xdd_test.xml" с текстом
    """
        <?xml version="1.0" encoding="UTF-8"?>
        <MetaDataObject xmlns="http://v8.1c.ru/8.3/MDClasses" xmlns:app="http://v8.1c.ru/8.2/managed-application/core" xmlns:cfg="http://v8.1c.ru/8.1/data/enterprise/current-config" xmlns:cmi="http://v8.1c.ru/8.2/managed-application/cmi" xmlns:ent="http://v8.1c.ru/8.1/data/enterprise" xmlns:lf="http://v8.1c.ru/8.2/managed-application/logform" xmlns:style="http://v8.1c.ru/8.1/data/ui/style" xmlns:sys="http://v8.1c.ru/8.1/data/ui/fonts/system" xmlns:v8="http://v8.1c.ru/8.1/data/core" xmlns:v8ui="http://v8.1c.ru/8.1/data/ui" xmlns:web="http://v8.1c.ru/8.1/data/ui/colors/web" xmlns:win="http://v8.1c.ru/8.1/data/ui/colors/windows" xmlns:xen="http://v8.1c.ru/8.3/xcf/enums" xmlns:xpr="http://v8.1c.ru/8.3/xcf/predef" xmlns:xr="http://v8.1c.ru/8.3/xcf/readable" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.4">
            <ExternalDataProcessor uuid="b24065c7-de41-4c5a-a404-ddb9a46084ff">
                <InternalInfo>
                    <xr:ContainedObject>
                        <xr:ClassId>c3831ec8-d8d5-4f93-8a22-f9bfae07327f</xr:ClassId>
                        <xr:ObjectId>645cde0d-2357-42ea-8a8b-12cff526f0bd</xr:ObjectId>
                    </xr:ContainedObject>
                    <xr:GeneratedType name="ExternalDataProcessorObject.xdd_test" category="Object">
                        <xr:TypeId>9506ef93-ef46-43e1-b089-9f25add335b2</xr:TypeId>
                        <xr:ValueId>a3f477fd-3fcc-4e25-9f24-0566b2d830fc</xr:ValueId>
                    </xr:GeneratedType>
                </InternalInfo>
                <Properties>
                    <Name>xdd_test</Name>
                    <Synonym/>
                    <Comment>Xdd test v1.2.3.45</Comment>
                </Properties>
                <ChildObjects/>
            </ExternalDataProcessor>
        </MetaDataObject>
    """

    И Я сохраняю значение "DEBUG" в переменную окружения "LOGOS_LEVEL"
    Когда Я добавляю параметр "<КаталогПроекта>/src/main.os set-version" для команды "oscript"
    И Я добавляю параметр "--new-version 2.0.0.0" для команды "oscript"
    И Я добавляю параметр "--for-meta-comment" для команды "oscript"
    И Я добавляю параметр "--src build" для команды "oscript"
    И Я добавляю параметр "--debuglogfile build/a.log" для команды "oscript"

    Когда Я выполняю команду "oscript"
    И Я сообщаю вывод команды "oscript"
    И я показываю текст файла "build/a.log"
    Тогда Вывод команды "oscript" содержит
    | Изменяю версию в исходниках конфигурации или внешнего файла 1С на 2.0.0.0 |
    |     Старая версия 1.2.3.44 |
    |     Старая версия 1.2.3.45 |

    И Код возврата команды "oscript" равен 0

    Тогда файл "build/1/xdd_test/xdd_test.xml" содержит "<Comment>Xdd test v 2.0.0.0</Comment>"
    Тогда файл "build/2/xdd_test/xdd_test.xml" содержит "<Comment>Xdd test v 2.0.0.0</Comment>"

Сценарий: Изменение версии и конфигурации и расширения и внешнего файла, указан каталог корня проекта

    Дано Я копирую каталог "cf" из каталога "tests/fixtures" проекта в рабочий каталог
    Дано Я копирую каталог "cfe" из каталога "tests/fixtures" проекта в рабочий каталог
    Дано Я копирую каталог "xdd_test" из каталога "tests/fixtures" проекта в подкаталог "build" рабочего каталога
    И я создаю файл "build/xdd_test/xdd_test.xml" с текстом
    """
        <?xml version="1.0" encoding="UTF-8"?>
        <MetaDataObject xmlns="http://v8.1c.ru/8.3/MDClasses" xmlns:app="http://v8.1c.ru/8.2/managed-application/core" xmlns:cfg="http://v8.1c.ru/8.1/data/enterprise/current-config" xmlns:cmi="http://v8.1c.ru/8.2/managed-application/cmi" xmlns:ent="http://v8.1c.ru/8.1/data/enterprise" xmlns:lf="http://v8.1c.ru/8.2/managed-application/logform" xmlns:style="http://v8.1c.ru/8.1/data/ui/style" xmlns:sys="http://v8.1c.ru/8.1/data/ui/fonts/system" xmlns:v8="http://v8.1c.ru/8.1/data/core" xmlns:v8ui="http://v8.1c.ru/8.1/data/ui" xmlns:web="http://v8.1c.ru/8.1/data/ui/colors/web" xmlns:win="http://v8.1c.ru/8.1/data/ui/colors/windows" xmlns:xen="http://v8.1c.ru/8.3/xcf/enums" xmlns:xpr="http://v8.1c.ru/8.3/xcf/predef" xmlns:xr="http://v8.1c.ru/8.3/xcf/readable" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.4">
            <ExternalDataProcessor uuid="b24065c7-de41-4c5a-a404-ddb9a46084ff">
                <InternalInfo>
                    <xr:ContainedObject>
                        <xr:ClassId>c3831ec8-d8d5-4f93-8a22-f9bfae07327f</xr:ClassId>
                        <xr:ObjectId>645cde0d-2357-42ea-8a8b-12cff526f0bd</xr:ObjectId>
                    </xr:ContainedObject>
                    <xr:GeneratedType name="ExternalDataProcessorObject.xdd_test" category="Object">
                        <xr:TypeId>9506ef93-ef46-43e1-b089-9f25add335b2</xr:TypeId>
                        <xr:ValueId>a3f477fd-3fcc-4e25-9f24-0566b2d830fc</xr:ValueId>
                    </xr:GeneratedType>
                </InternalInfo>
                <Properties>
                    <Name>xdd_test</Name>
                    <Synonym/>
                    <Comment>Xdd test v1.2.3.44</Comment>
                </Properties>
                <ChildObjects/>
            </ExternalDataProcessor>
        </MetaDataObject>
    """

    Когда Я добавляю параметр "<КаталогПроекта>/src/main.os set-version" для команды "oscript"
    И Я добавляю параметр "--new-version 2.0.0.0" для команды "oscript"
    И Я добавляю параметр "--src ." для команды "oscript"
    И Я добавляю параметр "--for-meta-comment" для команды "oscript"
    И Я добавляю параметр "--debuglogfile build/a.log" для команды "oscript"

    Когда Я выполняю команду "oscript"
    И Я сообщаю вывод команды "oscript"
    И я показываю текст файла "build/a.log"
    Тогда Вывод команды "oscript" содержит
    | Изменяю версию в исходниках конфигурации или внешнего файла 1С на 2.0.0.0 |
    |     Старая версия 1.0.0.0 |
    |     Старая версия 1.1.0.0 |
    |     Старая версия 1.2.3.44 |

    И Код возврата команды "oscript" равен 0

    Тогда файл "cf/Configuration.xml" содержит "<Version> 2.0.0.0</Version>"
    Тогда файл "cfe/Configuration.xml" содержит "<Version> 2.0.0.0</Version>"
    Тогда файл "build/xdd_test/xdd_test.xml" содержит "<Comment>Xdd test v 2.0.0.0</Comment>"
