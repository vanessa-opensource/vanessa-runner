# language: ru

Функционал: Проверка запуска и работы xunit-тестов через Ванесса-АДД
	Как Разработчик/Инженер по тестированию
	Я Хочу иметь возможность автоматической проверки запуска тестов через Ванесса-АДД
    Чтобы удостовериться в качестве подготовленной конфигурации

Контекст:
    Допустим я подготовил репозиторий и рабочий каталог проекта
    И я подготовил рабочую базу проекта "./build/ib" по умолчанию

    И Я копирую каталог "xdd_test" из каталога "tests/fixtures" проекта в подкаталог "build" рабочего каталога
    И Я копирую каталог "feature" из каталога "tests/fixtures" проекта в подкаталог "build" рабочего каталога
    И Я копирую файл "xUnitParams.json" из каталога "tests/fixtures" проекта в подкаталог "build" рабочего каталога

    Дано Я очищаю параметры команды "oscript" в контексте
    И Я сохраняю значение "INFO" в переменную окружения "LOGOS_LEVEL"

Сценарий: Запуск тестирования xunit с указанием логина, пароля пользователя

    Дано файл "build/xdd_test.epf" не существует
    Дано Я очищаю параметры команды "oscript" в контексте
    Когда Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os compileepf build/xdd_test build --language ru"
    И Я очищаю параметры команды "oscript" в контексте
    Дано файл "build/xdd_test.epf" существует

    Когда Я создаю файл "build/env.json" с текстом
        """
        {
        "default": {
            "--db-user":"Пользователь",
            "--db-pwd":"Пароль"
        }
        }
        """
            # "--additional": " /DisplayAllFunctions /Lru /iTaxi /TESTMANAGER /Debug /DebuggerURL tcp://localhost:1560",

    И Я сохраняю значение "DEBUG" в переменную окружения "LOGOS_LEVEL"

    Когда Я добавляю параметр "<КаталогПроекта>/src/main.os xunit" для команды "oscript"
    И Я добавляю параметр "build/xdd_test.epf" для команды "oscript"
    И Я добавляю параметр "--ibconnection /Fbuild/ib" для команды "oscript"
    И Я добавляю параметр "--workspace ./build" для команды "oscript"
    И Я добавляю параметр "--xddConfig build/xUnitParams.json" для команды "oscript"
    И Я добавляю параметр "--xddExitCodePath ./build/xddExitCodePath.txt" для команды "oscript"
    И Я добавляю параметр "--testclient ::" для команды "oscript"
    И Я добавляю параметр "--language ru" для команды "oscript"

    Когда Я выполняю команду "oscript"
    И Я сообщаю вывод команды "oscript"
    Тогда Вывод команды "oscript" содержит
    | Выполняю тесты  с помощью фреймворка Vanessa-ADD (Vanessa Automation Driven Development) |
    | Пользователь ИБ не идентифицирован |

    И Код возврата команды "oscript" равен 255

Сценарий: Запуск тестирования xunit

    Дано файл "build/xdd_test.epf" не существует
    Дано Я очищаю параметры команды "oscript" в контексте
    Когда Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os compileepf build/xdd_test build --language ru"
    И Я очищаю параметры команды "oscript" в контексте
    Дано файл "build/xdd_test.epf" существует
    И файл "build/junitreport/*.xml" не существует
    И файл "build/allurereport/*-result.json" не существует
    И Я создаю каталог "build/junitreport"
    И Я создаю каталог "build/allurereport"
    И Я создаю файл "build/junitreport/dummy-for-delete.xml"
    И Я создаю файл "build/allurereport/dummy-for-delete-result.json"

    Когда Я добавляю параметр "<КаталогПроекта>/src/main.os xunit" для команды "oscript"
    И Я добавляю параметр "build/xdd_test.epf" для команды "oscript"
    И Я добавляю параметр "--settings build/feature/env.json" для команды "oscript"
    Когда Я выполняю команду "oscript"
    И Я сообщаю вывод команды "oscript"
    Тогда Вывод команды "oscript" содержит
    | Выполняю тесты  с помощью фреймворка Vanessa-ADD (Vanessa Automation Driven Development) |
    | -->> тест ТестДолжен_ЧтоТоСделать |
    | ИНФОРМАЦИЯ - Все тесты выполнены! |
    | Выполнение тестов завершено |
    И я вижу в консоли вывод "Сформирован отчет тестирования <РабочийКаталог>\build\junitreport\xddreport.xml"
    И я вижу в консоли вывод "Сформирован отчет тестирования <РабочийКаталог>\build\allurereport\allure-testsuite.xml"

    И Код возврата команды "oscript" равен 0
    Тогда файл "build/junitreport/*.xml" существует
    И файл "build/allurereport/*-result.json" существует
    И файл "build/junitreport/dummy-for-delete.xml" существует
    И файл "build/allurereport/dummy-for-delete-result.json" существует

Сценарий: Падающий серверный тест xunit возвращает код 1 и в логе консоли видна причина падения

    И Я сохраняю значение "DEBUG" в переменную окружения "LOGOS_LEVEL"

    Когда Я создаю файл "build/xUnitParams.json" с текстом
        """
        {
            "$schema":"https://raw.githubusercontent.com/silverbulleters/vanessa-runner/develop/xunit-schema.json",
            "Отладка":true,
            "ДелатьЛогВыполненияСценариевВТекстовыйФайл":true,
            "ИмяФайлаЛогВыполненияСценариев": "$workspaceRoot/build/log-xunit.txt"
        }
        """

    Дано Я создаю файл "build/xdd_test/xdd_test/Ext/ObjectModule.bsl" с текстом
    """
        Перем КонтекстЯдра;

        Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
            КонтекстЯдра = КонтекстЯдраПараметр;
        КонецПроцедуры

        Процедура ЗаполнитьНаборТестов(НаборТестов) Экспорт
            НаборТестов.Добавить("ТестДолжен_Упасть");
        КонецПроцедуры

        Процедура ТестДолжен_Упасть() Экспорт
            ВызватьИсключение "Падаю внутри теста ТестДолжен_Упасть";
        КонецПроцедуры

    """
    И файл "build/xdd_test.epf" не существует
    Дано Я очищаю параметры команды "oscript" в контексте
    Когда Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os compileepf build/xdd_test build --language ru"
    И файл "build/xdd_test.epf" существует
    И Код возврата команды "oscript" равен 0
    И Я очищаю параметры команды "oscript" в контексте

    Когда Я создаю файл "build/env.json" с текстом
        """
        {
        "default": {
            "--v8version": "8.3.10"
        }
        }
        """
            # "--additional": " /DisplayAllFunctions /Lru /iTaxi /TESTMANAGER /Debug /DebuggerURL tcp://localhost:1560",

    Когда Я добавляю параметр "<КаталогПроекта>/src/main.os xunit" для команды "oscript"
    И Я добавляю параметр "build/xdd_test.epf" для команды "oscript"
    И Я добавляю параметр "--ibconnection /Fbuild/ib" для команды "oscript"
    И Я добавляю параметр "--workspace ./build" для команды "oscript"
    И Я добавляю параметр "--xddConfig build/xUnitParams.json" для команды "oscript"
    И Я добавляю параметр "--xddExitCodePath ./build/xddExitCodePath.txt" для команды "oscript"
    И Я добавляю параметр "--language ru" для команды "oscript"
    # И Я добавляю параметр "--xdddebug" для команды "oscript"

    Когда Я выполняю команду "oscript"

    И Я показываю вывод команды
    Тогда Вывод команды "oscript" содержит
    | -->> тест ТестДолжен_Упасть |
    | Выполняю тесты  с помощью фреймворка Vanessa-ADD (Vanessa Automation Driven Development) |
    | Часть тестов упала! |
    | Падаю внутри теста ТестДолжен_Упасть |

    И Код возврата команды "oscript" равен 1

Сценарий: Отсутствующий тест xunit

    Тогда Файл "build/xdd_test/xdd_test/Ext/ObjectModule.bsl" содержит
    """
        Перем КонтекстЯдра;
        Перем Ожидаем;
        Перем Утверждения;
    """

    Дано Я создаю файл "build/xdd_test/xdd_test/Ext/ObjectModule.bsl" с текстом
    """
        Перем КонтекстЯдра;

        Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
            КонтекстЯдра = КонтекстЯдраПараметр;
        КонецПроцедуры

        Процедура ЗаполнитьНаборТестов(НаборТестов) Экспорт
            НаборТестов.Добавить("ТестДолжен_БытьПропущен");
        КонецПроцедуры

        Процедура ТестДолжен_БытьПропущен() //Экспорт специально отключен
        КонецПроцедуры

    """
    И файл "build/xdd_test.epf" не существует
    Дано Я очищаю параметры команды "oscript" в контексте
    Когда Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os compileepf build/xdd_test build --language ru"
    И файл "build/xdd_test.epf" существует
    И Код возврата команды "oscript" равен 0
    И Я очищаю параметры команды "oscript" в контексте

    Когда Я добавляю параметр "<КаталогПроекта>/src/main.os xunit" для команды "oscript"
    И Я добавляю параметр "build/xdd_test.epf" для команды "oscript"
    И Я добавляю параметр "--ibconnection /Fbuild/ib" для команды "oscript"
    И Я добавляю параметр "--workspace ./build" для команды "oscript"
    И Я добавляю параметр "--xddConfig build/xUnitParams.json" для команды "oscript"
    И Я добавляю параметр "--xddExitCodePath ./build/xddExitCodePath.txt" для команды "oscript"
    И Я добавляю параметр "--language ru" для команды "oscript"
    Когда Я выполняю команду "oscript"
    И Я сообщаю вывод команды "oscript"
    Тогда Вывод команды "oscript" содержит
    | -->> тест ТестДолжен_БытьПропущен |
    | Выполняю тесты  с помощью фреймворка Vanessa-ADD (Vanessa Automation Driven Development) |
    | ИНФОРМАЦИЯ - Все тесты выполнены! |
    | Выполнение тестов завершено |
    # | ПРЕДУПРЕЖДЕНИЕ - Ошибок при тестировании не найдено, но часть тестов еще не реализована! |

    И Код возврата команды "oscript" равен 0

Сценарий: Проверка исключения и показа лога от 1С, когда еще не успел выполниться браузер тестов

    # И Я сохраняю значение "DEBUG" в переменную окружения "LOGOS_LEVEL"

    И Я копирую каталог "fixture-epf/fixture" из каталога "tests/fixtures" проекта в подкаталог "build" рабочего каталога
    Дано я создаю каталог "build/fixture/Тест1/Forms/Форма/Ext/Form" в рабочем каталоге

    Дано Я создаю файл "build/fixture/Тест1/Forms/Форма/Ext/Form/Module.bsl" с текстом
    """
        &НаКлиенте
        Процедура ПриОткрытии(Отказ)
            Сообщить("хочу видеть сообщение в логе выполнения - Сообщить");
            ПодключитьОбработчикОжидания("ОБработчикОжиданимя", 0.5, Истина);
        КонецПроцедуры

        &НаКлиенте
        Процедура ОБработчикОжиданимя()
            Сообщить("хочу видеть сообщение в логе выполнения - Сообщить 2");
            ЗавершитьРаботуСистемы(Ложь);
        КонецПроцедуры
    """

    И файл "fixture/Тест1.epf" не существует
    Дано Я очищаю параметры команды "oscript" в контексте
    Когда Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os compileepf  build/fixture build --language ru"
    И файл "build/Тест1.epf" существует
    И Код возврата команды "oscript" равен 0
    И Я очищаю параметры команды "oscript" в контексте

    Когда Я добавляю параметр "<КаталогПроекта>/src/main.os xunit" для команды "oscript"
    И Я добавляю параметр "build/Тест1.epf" для команды "oscript"
    И Я добавляю параметр "--ibconnection /Fbuild/ib" для команды "oscript"
    И Я добавляю параметр "--workspace ./build" для команды "oscript"
    И Я добавляю параметр "--pathxunit build/Тест1.epf" для команды "oscript"
    И Я добавляю параметр "--xddConfig build/xUnitParams.json" для команды "oscript"
    И Я добавляю параметр "--xddExitCodePath ./build/xddExitCodePath.txt" для команды "oscript"
    И Я добавляю параметр "--language ru" для команды "oscript"
    Когда Я выполняю команду "oscript"
    И Я сообщаю вывод команды "oscript"
    Тогда Вывод команды "oscript" содержит
        | Управляемое приложение |
        | Обработка Тест1 |
        | хочу видеть сообщение в логе выполнения - Сообщить |
        | хочу видеть сообщение в логе выполнения - Сообщить 2 |
        | Выполняю тесты  с помощью фреймворка Vanessa-ADD (Vanessa Automation Driven Development) |
        | Получен неожиданный/неверный результат работы - Не найден файл статуса |

    И Код возврата команды "oscript" равен 255

Сценарий: Запуск тестирования xunit с очисткой каталогов отчетов

    Дано файл "build/xdd_test.epf" не существует
    Когда Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os compileepf build/xdd_test build --language ru"
    И Я очищаю параметры команды "oscript" в контексте
    Дано файл "build/xdd_test.epf" существует
    И файл "build/junitreport/*.xml" не существует
    И файл "build/allurereport/*-result.json" не существует
    И Я создаю каталог "build/junitreport"
    И Я создаю каталог "build/allurereport"
    И Я создаю файл "build/junitreport/dummy-for-delete.xml"
    И Я создаю файл "build/allurereport/dummy-for-delete-result.json"

    Когда Я добавляю параметр "<КаталогПроекта>/src/main.os xunit" для команды "oscript"
    И Я добавляю параметр "build/xdd_test.epf" для команды "oscript"
    И Я добавляю параметр "--settings build/feature/env.json" для команды "oscript"
    И Я добавляю параметр "--clear-reports" для команды "oscript"
    Когда Я выполняю команду "oscript"
    И Я сообщаю вывод команды "oscript"
    Тогда Вывод команды "oscript" содержит
    | Выполняю тесты  с помощью фреймворка Vanessa-ADD (Vanessa Automation Driven Development) |
    | -->> тест ТестДолжен_ЧтоТоСделать |
    | ИНФОРМАЦИЯ - Все тесты выполнены! |
    | Выполнение тестов завершено |
    И я вижу в консоли вывод "Сформирован отчет тестирования <РабочийКаталог>\build\junitreport\xddreport.xml"
    И я вижу в консоли вывод "Сформирован отчет тестирования <РабочийКаталог>\build\allurereport\allure-testsuite.xml"

    И Код возврата команды "oscript" равен 0
    И файл "build/junitreport/dummy-for-delete.xml" не существует
    И файл "build/allurereport/dummy-for-delete-result.json" не существует
    Тогда файл "build/junitreport/*.xml" существует
    И файл "build/allurereport/*-result.json" существует
