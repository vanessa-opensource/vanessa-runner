# language: ru

Функционал: Проверка синтаксиса
	Как Разработчик/Инженер по тестированию
	Я Хочу иметь возможность автоматической проверки синтаксиса конфигурации
    Чтобы удостовериться в качестве подготовленной конфигурации

Контекст:
    Допустим я подготовил репозиторий и рабочий каталог проекта
    И я подготовил рабочую базу проекта "./build/ib" по умолчанию
    
Сценарий: Синтаксическая проверка временной файловой базы
    # Допустим  я включаю отладку лога с именем "oscript.app.vanessa-runner"
    Допустим Я очищаю параметры команды "oscript" в контексте 
    
    Когда Я добавляю параметр "<КаталогПроекта>/src/main.os syntax-check" для команды "oscript"
    И Я добавляю параметр "--ibconnection /Fbuild/ib" для команды "oscript"
    И Я добавляю параметр "--mode -ThinClient -WebClient -Server -ExternalConnection -ThickClientOrdinaryApplication" для команды "oscript"
    Когда Я выполняю команду "oscript"
    # И Я сообщаю вывод команды "oscript"
    И Код возврата команды "oscript" равен 0
    Тогда Вывод команды "oscript" содержит
    # | /CheckConfig -ThinClient -WebClient -Server -ExternalConnection -ThickClientOrdinaryApplication |
    | Результат синтакс-контроля: Ошибок не обнаружено |

    # Тогда в лог-файле запуска продукта есть строка 'testsuite name="Синтаксическая проверка конфигурации"'
    
Сценарий: Синтаксическая проверка временной файловой базы с результатами в формате JUnit
    # Допустим  я включаю отладку лога с именем "oscript.app.vanessa-runner"
    Допустим Я очищаю параметры команды "oscript" в контексте 
    
    Когда Я добавляю параметр "<КаталогПроекта>/src/main.os syntax-check" для команды "oscript"
    И Я добавляю параметр "--junitpath junit.xml" для команды "oscript"
    И Я добавляю параметр "--ibconnection /Fbuild/ib" для команды "oscript"
    И Я добавляю параметр "--mode -ThinClient -WebClient -Server -ExternalConnection -ThickClientOrdinaryApplication" для команды "oscript"
    Когда Я выполняю команду "oscript"
    # И Я сообщаю вывод команды "oscript"
    И Код возврата команды "oscript" равен 0
    И Файл "junit.xml" содержит
    """
    <testsuite name="CheckConfig.base">
    """
    И Файл "junit.xml" содержит 'status="passed"'
    # Тогда в лог-файле запуска продукта есть строка 'testsuite name="Синтаксическая проверка конфигурации"'

Сценарий: Синтаксическая проверка временной файловой базы с результатами в формате JUnit с группировкой
    # Допустим  я включаю отладку лога с именем "oscript.app.vanessa-runner"
    Допустим Я очищаю параметры команды "oscript" в контексте 
    
    Когда Я добавляю параметр "<КаталогПроекта>/src/main.os syntax-check" для команды "oscript"
    И Я добавляю параметр "--junitpath junit.xml" для команды "oscript"
    И Я добавляю параметр "--groupbymetadata" для команды "oscript"
    И Я добавляю параметр "--ibconnection /Fbuild/ib" для команды "oscript"
    И Я добавляю параметр "--mode -ThinClient -WebClient -Server -ExternalConnection -ThickClientOrdinaryApplication" для команды "oscript"
    Когда Я выполняю команду "oscript"
    # И Я сообщаю вывод команды "oscript"
    И Код возврата команды "oscript" равен 0
    И Файл "junit.xml" содержит
    """
    <testsuite name="CheckConfig.base">
    """
    И Файл "junit.xml" содержит 'status="passed"'
    # Тогда в лог-файле запуска продукта есть строка 'testsuite name="Синтаксическая проверка конфигурации"'

Сценарий: Синтаксическая проверка базы с ошибками с результатами в формате JUnit с группировкой
    # Допустим  я включаю отладку лога с именем "oscript.app.vanessa-runner"
    Допустим Я очищаю параметры команды "oscript" в контексте 
    
    И Я копирую каталог "cfbad" из каталога "tests/fixtures" проекта в рабочий каталог
    И Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os init-dev --src ./cfbad --nocacheuse --ibconnection /F./build/ib"
    
    Когда Я очищаю параметры команды "oscript" в контексте
    Когда Я добавляю параметр "<КаталогПроекта>/src/main.os syntax-check" для команды "oscript"
    И Я добавляю параметр "--junitpath junit.xml" для команды "oscript"
    И Я добавляю параметр "--groupbymetadata" для команды "oscript"
    И Я добавляю параметр "--ibconnection /Fbuild/ib" для команды "oscript"
    И Я добавляю параметр "--mode -ThinClient -WebClient -Server -ExternalConnection -ThickClientOrdinaryApplication" для команды "oscript"
    Когда Я выполняю команду "oscript"
    И Код возврата равен 1
    И файл "junit.xml" существует
    И Файл "junit.xml" содержит
    """
    <testsuite name="CheckConfig.base">
    """
    И Файл "junit.xml" содержит '<failure type="ERROR"'

Сценарий: Синтаксическая проверка базы с ошибками с результатами в формате JUnit БЕЗ группировки
    # Допустим  я включаю отладку лога с именем "oscript.app.vanessa-runner"
    Допустим Я очищаю параметры команды "oscript" в контексте 
    
    И Я копирую каталог "cfbad" из каталога "tests/fixtures" проекта в рабочий каталог
    И Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os init-dev --src ./cfbad --nocacheuse --ibconnection /F./build/ib"
    
    Когда Я очищаю параметры команды "oscript" в контексте
    Когда Я добавляю параметр "<КаталогПроекта>/src/main.os syntax-check" для команды "oscript"
    И Я добавляю параметр "--junitpath junit.xml" для команды "oscript"
    И Я добавляю параметр "--ibconnection /Fbuild/ib" для команды "oscript"
    И Я добавляю параметр "--mode -ThinClient -WebClient -Server -ExternalConnection -ThickClientOrdinaryApplication" для команды "oscript"
    Когда Я выполняю команду "oscript"
    И Код возврата равен 1
    И файл "junit.xml" существует
    И Файл "junit.xml" содержит
    """
    <testsuite name="CheckConfig.base">
    """
    И Файл "junit.xml" содержит '<failure type="ERROR"'

Сценарий: Синтаксическая проверка базы с ошибками пустых обработчиков с группировкой
    # Допустим  я включаю отладку лога с именем "oscript.app.vanessa-runner"
    Допустим Я очищаю параметры команды "oscript" в контексте 
    
    Когда Я очищаю параметры команды "oscript" в контексте
    И Я добавляю параметр "<КаталогПроекта>/src/main.os syntax-check" для команды "oscript"
    И Я добавляю параметр "--junitpath junit.xml" для команды "oscript"
    И Я добавляю параметр "--groupbymetadata" для команды "oscript"
    И Я добавляю параметр "--ibconnection /Fbuild/ib" для команды "oscript"
    И Я добавляю параметр "--mode -ThinClient -WebClient -Server -ExternalConnection -ThickClientOrdinaryApplication -EmptyHandlers" для команды "oscript"
    Когда Я выполняю команду "oscript"
    И Код возврата равен 0
    И файл "junit.xml" существует
    И Файл "junit.xml" содержит
    """
    <testsuite name="CheckConfig.base">
    """
    И Файл "junit.xml" содержит 'status="passed"'

Сценарий: Синтаксическая проверка временной файловой базы с указанием имени тестового набора для JUnit
    # Допустим  я включаю отладку лога с именем "oscript.app.vanessa-runner"
    Допустим Я очищаю параметры команды "oscript" в контексте 
    
    Когда Я добавляю параметр "<КаталогПроекта>/src/main.os syntax-check" для команды "oscript"
    И Я добавляю параметр "--junitpath junit.xml" для команды "oscript"
    И Я добавляю параметр "--ibconnection /Fbuild/ib" для команды "oscript"
    И Я добавляю параметр "--testsuitename custom" для команды "oscript"
    И Я добавляю параметр "--mode -ThinClient -WebClient -Server -ExternalConnection -ThickClientOrdinaryApplication" для команды "oscript"
    Когда Я выполняю команду "oscript"
    # И Я сообщаю вывод команды "oscript"
    И Код возврата равен 0
    И Файл "junit.xml" содержит
    """
    <testsuite name="CheckConfig.custom">
    """
    И Файл "junit.xml" содержит 'status="passed"'
    И Код возврата команды "oscript" равен 0
    # Тогда в лог-файле запуска продукта есть строка 'testsuite name="Синтаксическая проверка конфигурации"'

Сценарий: Синтаксическая проверка временной файловой базы с несуществующего каталога для JUnit
    # Допустим  я включаю отладку лога с именем "oscript.app.vanessa-runner"
    Допустим Я очищаю параметры команды "oscript" в контексте 
    
    Когда Я добавляю параметр "<КаталогПроекта>/src/main.os syntax-check" для команды "oscript"
    И Я добавляю параметр "--junitpath out/junit.xml" для команды "oscript"
    И Я добавляю параметр "--ibconnection /Fbuild/ib" для команды "oscript"
    И Я добавляю параметр "--testsuitename custom" для команды "oscript"
    И Я добавляю параметр "--mode -ThinClient -WebClient -Server -ExternalConnection -ThickClientOrdinaryApplication" для команды "oscript"
    Когда Я выполняю команду "oscript"
    # И Я сообщаю вывод команды "oscript"
    И Код возврата равен 0
    И Файл "out/junit.xml" содержит
    """
    <testsuite name="CheckConfig.custom">
    """
    И Файл "out/junit.xml" содержит 'status="passed"'
    И Код возврата команды "oscript" равен 0
    # Тогда в лог-файле запуска продукта есть строка 'testsuite name="Синтаксическая проверка конфигурации"'

Сценарий: Синтаксическая проверка базы с ошибками с результатами в формате Allure2 во вложенном каталоге
    # Допустим  я включаю отладку лога с именем "oscript.app.vanessa-runner"
    # Допустим я включаю полную отладку логов пакетов OneScript
    Допустим Я очищаю параметры команды "oscript" в контексте 
    
    И Я копирую каталог "cfbad" из каталога "tests/fixtures" проекта в рабочий каталог
    И Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os init-dev --src ./cfbad --nocacheuse --ibconnection /F./build/ib"
    
    Когда Я очищаю параметры команды "oscript" в контексте

    Когда Я добавляю параметр "<КаталогПроекта>/src/main.os syntax-check" для команды "oscript"
    И Я добавляю параметр "--allure-results2 out-my/allure-my" для команды "oscript"
    И Я добавляю параметр "--ibconnection /Fbuild/ib" для команды "oscript"
    И Я добавляю параметр "--mode -ThinClient -WebClient -Server -ExternalConnection -ThickClientOrdinaryApplication" для команды "oscript"
    Когда Я выполняю команду "oscript"
    # И Я показываю вывод команды
    И Код возврата равен 1
    И Вывод команды "oscript" содержит
    | МодульУправляемогоПриложения(2,13)}: Переменная не определена (Итина) |
    | Неопознанный оператор |
    | {Справочник.Справочник1.МодульОбъекта(2,10)}: Неопознанный оператор |
    И каталог "out-my/allure-my" существует
    И файл "out-my/allure-my/*-result.json" существует
