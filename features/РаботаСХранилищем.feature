# language: ru

Функционал: Работа с хранилищем
    Как разработчик
    Я хочу создавать хранилище, выгружать версию хранилища, создавать пользователей хранилища
    Чтобы выполнять коллективную разработку проекта 1С

Контекст: Подготовка репозитория и рабочего каталога проекта 1С

    Допустим Я создаю временный каталог и сохраняю его в контекст
    И Я устанавливаю временный каталог как рабочий каталог
    И Я инициализирую репозиторий git в рабочем каталоге
    Допустим Я создаю каталог "build/out" в рабочем каталоге
    И Я копирую каталог "cf" из каталога "tests/fixtures" проекта в рабочий каталог

    И Я установил рабочий каталог как текущий каталог
    И Я сохраняю каталог проекта в контекст
    И Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os init-dev --src ./cf --nocacheuse --language ru"
    И Я очищаю параметры команды "oscript" в контексте


Сценарий: Создание хранилища 1С без указания строки соединения
    Когда Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os createrepo ./build/repo admin 123 --language ru"
    # Когда Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os createrepo ./build/repo admin 123 --language ru --debuglogfile debug.log"
    Тогда Я сообщаю вывод команды "oscript"
    # И я показываю текст файла "debug.log"
    # И Файл "debug.log" содержит "ОТЛАДКА - Подключил вывод отладочного лога в отдельный файл 11/debug.log"
    И каталог "build/repo" существует
    Тогда Вывод команды "oscript" содержит "При создании хранилища не определена БД, создаем на основе временной БД"
    И Код возврата команды "oscript" равен 0

Сценарий: Создание хранилища 1С
    Когда Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os createrepo ./build/repo admin 123 --ibconnection /F./build/ib --language ru"
    Тогда Я сообщаю вывод команды "oscript"
    И каталог "build/repo" существует
    И Код возврата команды "oscript" равен 0

Сценарий: Создание пользователя 1С
    Когда Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os createrepo ./build/repo admin 123 --ibconnection /F./build/ib --language ru"
    И Код возврата команды "oscript" равен 0
    Когда Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os createrepouser ./build/repo admin 123 --storage-user uuu --storage-pwd 321 --storage-role Administration --ibconnection /F./build/ib --language ru"
    Тогда Я сообщаю вывод команды "oscript"
    И Код возврата команды "oscript" равен 0

Сценарий: Подключение базы к хранилищу 1С
    Когда Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os createrepo ./build/repo admin 123 --ibconnection /F./build/ib --language ru"
    И Код возврата команды "oscript" равен 0
    Когда Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os createrepouser ./build/repo admin 123 --storage-user uuu --storage-pwd 321 --storage-role Administration --ibconnection /F./build/ib --language ru"
    Когда Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os bindrepo ./build/repo uuu 321 --ibconnection /F./build/ib --language ru"
    Тогда Я сообщаю вывод команды "oscript"
    И Код возврата команды "oscript" равен 0

Сценарий: Выгрузка конфигурации из хранилища 1С
    Когда Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os createrepo ./build/repo admin 123 --ibconnection /F./build/ib --language ru"
    И Код возврата команды "oscript" равен 0
    Когда Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os unloadcfrepo --storage-name ./build/repo --storage-user admin --storage-pwd 123 -o ./build/1cv8.cf --ibconnection /F./build/ib --language ru"
    Тогда Я сообщаю вывод команды "oscript"
    И Код возврата команды "oscript" равен 0
    И Файл "./build/1cv8.cf" существует
