# hegs_krause_shell
model.sh
# Сценарий : Реализует сценарий эволюции математической модели Hegselman-Krause
# bounded confidence level in opinion dynamics. При запуске запрашивает у пользователя количество агентов. 
# Каждому агенту присваивается случайное мнение от 0 до количества агентов. Далее скрипт запрашивает 
# уровень уверенности (Confidence level) и максимальное количество итераций эволюции модели
# если консенсус не удается достигнуть или эволюция модели не остановилась. 
# Для каждого агента вычисляется группа доверия, в нее входят те агенты, мнение которых отличается 
# от мнения данного агента на величины меньшую либо равную confidence level (+ сам рассматриваемый агент). 
# Находится среднее арифметическое. для группы доверия и полученная величина присваивается агенту.
# И так для каждого агента каждую итерацию. В случае, если изменение мнений прекратилось 
# (эволюция модели остановлена) или достигнут консенсус (все мнения агентов равны)
# выводится соответствующее сообщение. 
# Автор : Vershinin Eldar 
# Дата : 2020.06.04
