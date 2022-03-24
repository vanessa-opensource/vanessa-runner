# language: ru

Функционал: Операции с хранилищем расширения
    Как разработчик
    Я хочу выполнять различные операции с хранилищем расширений
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

    # Сценарий: Загрузка одного расширения из файла с обновлением БД
    Допустим Я копирую файл "Extension1.cfe" из каталога "tests/fixtures" проекта в рабочий каталог
    И Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os loadext --file Extension1.cfe --extension РасширениеНовое1 --updatedb --ibconnection /F./build/ib --language ru"
    И Я показываю вывод команды
    И Я очищаю параметры команды "oscript" в контексте
    # Когда Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os unloadext ./РасширениеНовое1.cfe РасширениеНовое1 --ibconnection /F./build/ib --language ru"
    # И Я показываю вывод команды
    # И Файл "./РасширениеНовое1.cfe" существует
    # Тогда Код возврата равен 0

Сценарий: Создание хранилища расширения
    Когда Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os createrepo ./build/repocfe admin 123 --extension РасширениеНовое1 --ibconnection /F./build/ib --language ru"
    Тогда Я сообщаю вывод команды "oscript"
    И каталог "build/repocfe" существует
    И Код возврата команды "oscript" равен 0

# Сценарий: Создание пользователя в хранилище расширения
#     Когда Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os createrepo ./build/repocfe admin 123 --ibconnection /F./build/ib --language ru"
#     И Код возврата команды "oscript" равен 0
#     Когда Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os createrepouser ./build/repocfe admin 123 --storage-user uuu --storage-pwd 321 --storage-role Administration --ibconnection /F./build/ib --language ru"
#     Тогда Я сообщаю вывод команды "oscript"
#     И Код возврата команды "oscript" равен 0

# Сценарий: Подключение базы к хранилищу расширения
#     Когда Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os createrepo ./build/repocfe admin 123 --ibconnection /F./build/ib --language ru"
#     И Код возврата команды "oscript" равен 0
#     Когда Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os createrepouser ./build/repocfe admin 123 --storage-user uuu --storage-pwd 321 --storage-role Administration --ibconnection /F./build/ib --language ru"
#     Когда Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os bindrepo ./build/repocfe uuu 321 --ibconnection /F./build/ib --language ru"
#     Тогда Я сообщаю вывод команды "oscript"
#     И Код возврата команды "oscript" равен 0

# Сценарий: Выгрузка расширения из хранилища расширения
#     Когда Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os createrepo ./build/repocfe admin 123 --ibconnection /F./build/ib --language ru"
#     И Код возврата команды "oscript" равен 0
#     Когда Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os unloadcfrepo --storage-name ./build/repocfe --storage-user admin --storage-pwd 123 -o ./build/1cv8.cf --ibconnection /F./build/ib --language ru"
#     Тогда Я сообщаю вывод команды "oscript"
#     И Код возврата команды "oscript" равен 0
#     И Файл "./build/1cv8.cf" существует
