# People
Table of people's accounts got from API(skeleton, activityIndicator); search, filter, sort; detail screen

1. написать план - 2ч (2ч 10мин)
2. создать РЕПО, создать gitignore, ветки, залить README.md - 0.5 (0.5)
3. сделать основу MVVM + C - 2
4. сверстать экран ЛЮДИ: 
    1. изучить как делать segment control (как переключать его, чтобы была полоска внизу) или иной элемент интерфейса - 2 (25 мин)
    2. сверстать экран ЛЮДИ с таблицей, полем поиска, вставить иконки: лупу и фильтр, segment control - 2
    3. Создать ячейку ПЕРСОНА - 2
    4. Создать ячейку СКЕЛЕТОН - 2
    5. изучить как сделать пулл-то-рефреш и добавить на экран ЛЮДИ активити индикатор - 2
    6. Создать вью КРИТИЧЕСКАЯ ОШИБКА и добавить ее на экран ЛЮДИ - 1
    7. НАписать код для показа скелетона - 2 
    8. Код для первой загрузки данных(посредством UD), чтобы показать скелетон - 2
    9. создать enum States и наполнить его возможными состояниями  - 2
5. Разобраться в API - 1
6. Создать модель - 2
7. Написать Storage,  используя FM - 2
8. Написать Endpoint file - 1
9. Написать Mapper - 2
10. Написать NetworkService - 2
11. Расширение к Date - 0.5
12. pull-to-refresh перезагружает список людей. Если в процессе обновления произошла ошибка, необходимо ее игнорировать. Если данные загрузились успешно, необходимо обновить список на главном экране. - 2
13. При этом параметры поиска и сортировки, если они были выставлены ранее, должны учитываться и не должны быть сброшены - продумать и запоминать состояние segment control, состояние поиска, состояние сортировки - 2
14. Имплементировать запомненные состояния - 2
15. Изучить как делают фильтрацию - 2
16. Вставить иконку ФИЛЬТРА, подвязать нажатие, открывать bottom sheet 2.0.1 - Фильтр - 2
17. Реализовать фильтрацию по алфавиту (выбрал, скрывается, скелетон, показываем) - 2 
18. Изучить как делают разбиение по блокам (год) в таблице (хедеры?) и сделать для фильтрации по ДР - 2
19. Реализовать появление даты рождения в определенном формате, если выбрали сортировку по ДР - 2
20. Изучить как делают ПОИСК - 2
21. При нажатии на лупу изменять серчТекстФилд (меньше ширина, лупа выделена, Кнопка Отмена - 2
22. Когда пользователь вводит текст в поле поиска, необходимо локально фильтровать список и отображать только работников, соответствующих параметрам поиска. Поиск может осуществляться по имени, фамилии или никнейму, состоящему из двух символов - 2
23. Пока фотография не загрузилась, вместо неё отображается заглушка - гусь - 2 (создал issue - может ответят) - или скелетон?
24. В случае отсутствия результатов поиска необходимо отобразить информацию о том, что ничего не было найдено – состояние 2.0.2Г. - вью с лейблом  - 1
25. Экран ДЕТАЛИ
    1. основу MVVM + C для экрана ДЕТАЛИ - 2 
    2. При тапе на сотрудника нужно открыть экран информации о нём - сверстать экран  (вью(фото+ФИ+никнейм+название департамента) + таблица(2ячейки(ДР и сколько лет)+ (номер телефона+иконкаКнопка) - 2
    3. при нажатии на ячейку с номером показать Action Sheet с подтверждением звонка - 2
    4. При нажатии на кнопку с номером телефона должен начаться звонок, а сам Action Sheet закрывается - 2
