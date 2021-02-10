
# tidy --------------------------------------------------------------------

# R esta hecho para trabajar con tablas tidy, es decir:
# 1. donde cada fila es una observacion individual
# 2. donde cada columna es una caracteristica de la observacion
# 3. donde cada tabla contiene solamente un tipo de informacion

# pero la mayoria de data es generada por personas que no estan familiarizadas
# con el paradigma de tidy data, y esto es especialmente exacerbado por la
# libertad de escritura de datos en excel

pkmn <- readr::read_csv('data/data_importante_de_negocios.csv') %>%
  janitor::clean_names() %>%  
  filter(stringr::str_detect(string = name, pattern = 'Mega', negate = TRUE))


# unir tablas -------------------------------------------------------------

# frecuentemente se maneja mas de una sola fuente de datos, por lo que 
# cruzar tablas se convierte en una tarea vital para empezar a trabajar con
# data mas grande y mas compleja

# cuando decimos cruzar, nos referimos a unir tablas que tienen una o mas
# columnas en comun y es parte vital del asesoramiento de calidad que se debe
# hacer sobre un set de datos antes de comenzar un analisis

# unir/cruzar ~ hacer un =VLOOKUP() para todas las columnas que no estan en 
# las dos tablas 

# unir/cruzar siempre agrega todas las columnas, lo que cambia por tipo de
# join es cuales son las filas que devuelve

red <- data.frame(trainer = rep('Red', 7), 
                  name = c('Pikachu',
                           'Lapras',
                           'Snorlax',
                           'Venusaur',
                           'Charizard',
                           'Blastoise', 
                           'MissingNo'))

## JOIN

# las operaciones de join son operaciones entre dos tablas, y dependiendo 
# del tipo de join obtendremos distintas uniones:
library(dplyr)

# left_join:
# es la mas intuitiva: a todas las filas de la tabla izquierda,  se le 
# agregan todas las columnas de la tabla de la derecha
left_join(red, pkmn, by = 'name')

# right join:
# funciona igual pero en la otra direccion: a todas las filas de la tabla
# derecha, se le agregan las columnas de la tabla izquierda
right_join(red, pkmn, by = 'name')

# inner_join:
# se deja solo las filas que esten en ambas tablas
inner_join(red, pkmn, by = 'name')

# full_join:
# se deja todas las filas de ambas
full_join(red, pkmn, by = 'name')

# anti_join:
# se deja solo las filas que estan en la tabla izquierda y no en la derecha
anti_join(red, pkmn, by = 'name') 

# el objetivo no es aprenderse cual es cual sino saber que hay varios tipos 
# que se ajustan a distintas necesidades

# PELIGRO: filas duplicadas duplican el join

varias_A <- data.frame(columna_a = c('A', 'A', 'B', 'C'),
                       numeros = 3:6)

varias_B <- data.frame(columna_a = c('B', 'B'),
                       letras = c('e', 'e'))

left_join(varias_A, varias_B)

left_join(varias_A, unique(varias_B))

# escribir tablas ---------------------------------------------------------

red_stats <- left_join(red, pkmn, by = 'name') %>% filter(name != 'MissingNo')

red_stats %>%  readr::write_csv(path = 'data/trainers/red.csv')
red_stats %>%  openxlsx::write.xlsx(file = 'data/trainers/red.xlsx')


