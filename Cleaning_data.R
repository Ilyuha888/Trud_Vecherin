library(tidyverse)

# Три функции, которые переводят из тех вариантов, которые давали респам, в числа
# Функция переводит сначала char в иерархический фактор, а потом numeric
# В результатена месте слова остаётся её место в порядке 

anket <- read_csv2('anket.csv')


words_to_num1 <- function(x){y <- as.numeric(factor(x,
  levels = c('Практически никогда', 'Редко', 'Скорее редко', 'Иногда', 'Скорее часто', 'Часто', 'Практически всегда'), 
  ordered = TRUE))
}

words_to_num2 <- function(x){y <- as.numeric(factor(x,
                                                    levels = c('Абсолютно не согласен', 'Частично согласен', 'Скорее согласен, чем не согласен', 'Полностью согласен'), 
                                                    ordered = TRUE))
}

words_to_num3 <- function(x){y <- as.numeric(factor(x,
                                                    levels = c('Не согласен', 'Скорее не согласен', 'Где-то посередине', 'Скорее согласен', 'Согласен'), 
                                                    ordered = TRUE))
}

#Применяем 3 функции (потому что разный ликерт), каждую к своей шкале
anket %>% mutate(across(a1:a56, words_to_num1)) -> anket
anket %>% mutate(across(b1:b27, words_to_num2)) -> anket
anket %>% mutate(across(c1:c19, words_to_num3)) -> anket

rename_all(anket, funs(str_replace_all(., " ", "_"))) -> anket

anket %>% 
  rename(ID = 'ID_ответа',
         d1 = 'Укажите_Ваш_пол:_(Одиночный_выбор)',
         d2 = 'Укажите_Ваш_возраст:_(Свободный_ответ)',                                                        
         d3 = 'Укажите_город_Вашего_проживания:_(Выпадающий_список)',                                      
         d4 = 'Укажите_Ваш_высший_уровень_образования:_(Выпадающий_список)',                               
         d5 = 'Укажите_стаж_Вашего_труда_в_общем:_(Выпадающий_список)',                                    
         d6 = 'Укажите_Ваш_стаж_на_текущем_месте_работы:_(Выпадающий_список)',                             
         d7 = 'Выберете_из_списка_сферу_деятельности_компании,_где_Вы_работаете:_(Выпадающий_список)',     
         d8 = 'Укажите_размер_компании,_где_работаете:_(Выпадающий_список)',                               
         d9 = 'Укажите_Вашу_должность:_(Свободный_ответ)',                                                 
         d10 = 'Укажите_какая_часть_Вашей_зарплаты_является_фиксированной:_(в_процентах)_(Свободный_ответ)',
         d11 = 'Укажите_уровень_Вашей_заработной_платы_в_месяц:_(Выпадающий_список)',                       
         d12 = 'Планируете_ли_вы_в_ближайшее_время_менять_работу?_(Одиночный_выбор)') ->anket

anket %>% 
  mutate(across(d1, as.factor)) %>% 
  mutate(across(c(d3:d8), as.factor)) %>% 
  mutate(across(c(d11:d12), as.factor)) -> anket

#Сделаем ревёрс факторов, которые должны быть отрицательными (наш опросник)

anket %>% 
  mutate(across(c(a4, a5, a9, a10, a17, a18, a21, a22, a26, a27, a33, a34, a36, a48, a54, c8, c10, c11), as.factor)) %>% 
  mutate(across(c(a4, a5, a9, a10, a17, a18, a21, a22, a26, a27, a33, a34, a36, a48, a54, c8, c10, c11), fct_rev)) %>% 
  mutate(across(c(a4, a5, a9, a10, a17, a18, a21, a22, a26, a27, a33, a34, a36, a48, a54, c8, c10, c11), as.numeric)) -> anket

#Посчитаем суммы факторов

anket %>% 
  mutate(
    a_sum_1 = rowSums(across(c(a1:a13))),
    a_sum_2 = rowSums(across(c(a14:a27))),
    a_sum_3 = rowSums(across(c(a28:a42))),
    a_sum_4 = rowSums(across(c(a43:a56))),
    b_sum_1 = rowSums(across(c(b1:b6))),
    b_sum_2 = rowSums(across(c(b7:b11))),
    b_sum_3 = rowSums(across(c(b12:b14))),
    b_sum_4 = rowSums(across(c(b15:b19))),
    b_sum_5 = rowSums(across(c(b20:b23))),
    b_sum_6 = rowSums(across(c(b24:b27))),
    c_sum_1 = rowSums(across(c(c1:c4))),
    c_sum_2 = rowSums(across(c(c5:c8))),
    c_sum_3 = rowSums(across(c(c9:c11))),
    c_sum_4 = rowSums(across(c(c12:c14))),
    c_sum_5 = rowSums(across(c(c15:c19)))
  )-> anket

#Сохраняем почищенный файл
write_csv(anket, 'anket_clean.csv')
