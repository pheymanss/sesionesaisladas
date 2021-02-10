
# Sesion 2: transformacion de datos ---------------------------------------

# 1. Sentar bases ---------------------------------------------------------

# _ paquetes  -------------------------------------------------------------

# instalar paquetes
install.packages('dplyr')

# la notacion paquete::funcion permite dos cosas muy utiles

# 1. llamar una funcion siempre y cuando el paquete este instalado
paquete.no.instalado::funcion() # no funciona, obvio
lubridate::today() # funciona aunque lubridate no este cargado
# reminder: se pueden ver que paquetes estan cargados en el panel Packages

# 2. especificar el paquete del que se quiere usar la funcion
plyr::summarise
dplyr::summarise
# en consola se imprime <environment: namespace:dplyr>

# _ operaciones sobre vectores --------------------------------------------

# R esta pensado para hacer operaciones entre vectores

x <- c(2,6,8,9)

# operacion se aplica a todos los elementos
x + 2
x - x
2^(x)

c(0,0,0,0) - c(1,2,3,4)

# secuencias numero1:numero2
1:5
200:2000

# funcion seq para hacer secuencias con mas control
seq(1, 10, by = 2)
seq(0, 10, by = 2)
seq(0, 1, by = .1)

# PELIGRO: R recicla
c(0,1) + c(1,1,1)
c(0,1) + c(1,1,1,1) # incluso lo hace sin advertir

# _ slicing ---------------------------------------------------------------

x[1:3]
x[1,4,5,6]  # no sirve
x[c(1,3,4)]
x[c(2,4,100)] # PELIGRO: si sirve, R 'completa'
x[c(TRUE, FALSE)]

# slicing con negativos
x[-1]
x[-c(2,4)]
x[c(-2, -4)]
x[c(-1,-2,-100)] # aqui no mete cosas si hay indices negativos

# _ operador pipe -----------------------------------------------------------

# el operador pipe es %>% 
# shortcut: ctrl + shift + M
library(magrittr)

mean(c(1,2,3,4))

c(1,2,3,4) %>% mean()
# por que usar pipes? **polemica**
# - no hay que devolverse para agregar operaciones
# - se ve con mayor claridad cuales son los parametros de la funcion
# - la operacion tiene una narrativa clara: pipe ~ 'y ahora haga'

# el redondeo de la suma de la raiz cuadrada de 0,1,2,3 a dos digitos
round(sum(sqrt(c(0,1,2,3))), 2) 

# agarre 0,1,2,3, saquele la raiz cuadrada, despues los suma y 
# redondea a dos digitos
c(0,1,2,3) %>% sqrt() %>% sum() %>% round(2)

# como usar pipe

f(x)   ==   x %>% f()
g(f(x))  ==   x %>% f() %>% g()
h(g(f(x))) ==   x %>% f() %>% g() %>%  h()

# power user: 
# a veces lo que viene en el pipe no es lo primero que queremos meter
# en la funcion. Para esto, un punto . sirve para decir 'eso que viene
# en el pipe'
x <- 1:5
x %>%  c(0, .)
x %>% mean() %>% paste('El promedio de x es ', .)

# _ tratar con letras: stringr ---------------------------------------------

library(stringr)

# definir strings
palabras <- c('hola', 'mundo', 'o whatever')

# contar caracteres
stringr::str_count(palabras)

# encontrar coincidencias

# pueden ser expresiones regulares, muy muy utiles y
# en 1-2 horas se aprende suficiente para defenderse
# https://regexone.com/
stringr::str_detect(string = palabras, pattern = 'a') 

# slicing
palabras[stringr::str_detect(string = palabras, pattern = 'a')]

# o mas facil
stringr::str_subset(string = palabras, pattern = 'a')

# _ tratar con fechas: lubridate ------------------------------------------

library(lubridate)

# R base tiene una sintaxis para leer fechas pero es incomoda
# mejor usar funciones de lubridate: myd, dmy, mdy
cualquier_fecha <- lubridate::ymd("2020-03-15")
# son bastante flexibles
lubridate::ymd("20200315") # singuiones
lubridate::mdy(06092020)   # los numeros directos

hoy <- lubridate::today()
class(hoy)
ayer <- hoy - 1
class(ayer)

# sumar y restar
hace_un_mes <- hoy - months(1)

# problemas:
# los meses no son medidas consistentes
ymd(20200330) - months(1)
ymd(20200331) + months(1) + months(1)
ymd(20200331) + months(2)
today() - days(33)

# anos bisiestos
ymd(20210101) - days(365)

# hay 3 (!) formas de contar semanas
ymd(20210101) %>% lubridate::week()
ymd(20210101) %>% lubridate::isoweek()
ymd(20210101) %>% lubridate::epiweek()
# :)

# en general, hay que tener mucho cuidado con fechas

# 2. Transformacion de datos ----------------------------------------------

# tidy data:
# 1. Cada variable es una columna
# 2. Cada observacion de la poblacion estudiada es una fila
# 3. Cada tipo de informacion forma una tabla

# leer data completa
pkmn <- readr::read_csv('data/data_grande_importante_de_negocios.csv')

# siempre conveniente limpiar los nombres de las columnas
pkmn <- janitor::clean_names(pkmn)

library(dplyr)
# dplyr: funcion(tabla, parametros)
# con pipe: tabla %>% funcion(parametros)

# _ interaccion basica con data.frames ------------------------------------
# para sacar el vector que tiene ese nombre en la tabla: data.frame$variable 
pkmn$type_2

# y se puede hacer slicing en las dos dimensiones de la tabla
# data.frame[filas, columnas]
pkmn[2:4, 1:10]

# y si se deja vacio, R entiende que es todo
pkmn[1:10,] # las primeras 10 filas de todas las columnas
pkmn[,1:10] # las primeras 10 columnas de todas las filas
pkmn[,] # todo el data.frame

# y tambien aguanta todos los indices que vimos en # _ slicing
pkmn[c(TRUE, FALSE),] # fila de por medio porque aca tambien recicla
pkmn[pkmn$generation > 4 & pkmn$generation <= 2, ] # devuelve cero filas 
pkmn[pkmn$generation < 4 & pkmn$generation >= 2, ] # ahora si

# y ademas podemos hacer slicing por nombres de columnas
pkmn[430:435, 'generation']
pkmn[430:435, c('generation', 'name')]

# el mayor cuidado que hay que tener al hacer slicing con data.frames es saber que
# tipo de objeto devuelve

pkmn$name # vector
pkmn[2] # data.frame
pkmn[[2]] # vector otra vez
pkmn[2][1:3] # no sirve
pkmn[[2]][1:3] # vector
pkmn$name[1:3] # mismo vector. consejo: siempre que se pueda, usar nombres y no indices

# ademas podemos crear nuevas variables desde ahi
pkmn$variable_nueva <- c('a', 'b', 'c') # pero tiene que calzar con el tamano de los demas vectores aka las filas de la tabla
pkmn$variable_nueva <- 1:800

# y si no nos gusta, asignarle NULL la mata
pkmn$variable_nueva <- NULL

# _ filter ------------------------------------------------------------------

# sobre caracteres 
pkmn %>% filter(stringr::str_detect(string = name, pattern = 'Mega'))
pkmn %>% filter(!stringr::str_detect(string = name, pattern = 'Mega'))
pkmn <- pkmn %>% filter(stringr::str_detect(string = name, pattern = 'Mega', negate = TRUE))

# sobre numeros
pkmn %>% filter(hp < 30)
pkmn %>% filter(attack - sp_atk < 20)
pkmn %>% filter(abs(attack - sp_atk) < 20)
# la condicion puede ser tan compleja como se quiera siempre y cuando devuelva
# un falso o verdadero

# _ arrange -----------------------------------------------------------------

pkmn %>% arrange(name)
pkmn %>% arrange(desc(name))
pkmn %>% arrange(-hp, -attack)

# _ select ------------------------------------------------------------------

pkmn %>% select(name, type_1, generation)
pkmn %>% select(-number, -type_2, -total, -hp, -attack, -defense, -sp_atk, -sp_def, -speed, -legendary)
pkmn %>% select(name:attack)
pkmn %>% select(2:4)
pkmn %>% select(2:4, attack)

# y se puede usar para cambiar nombres de variables
pkmn %>% select(nombre_del_pokeman  = name,
                que_tan_rapido_corre = speed,
                mi_variable_favorita = sp_def,
                pero_esta_tambien_me_gusta = defense)

# select helpers
# descripciones de aca: https://tidyselect.r-lib.org/reference/select_helpers.html

# starts_with(): las columnas que empiecen con un prefijo.
pkmn %>% select(starts_with('type'))

# ends_with(): las columnas que terminen con un sufijo.
pkmn %>% select(ends_with('k'))

# contains(): las columnas que contengan un string especifico
pkmn %>% select(contains('gen'))

# matches(): las columnas que matcheen con una expresion regular
pkmn %>% select(matches('^gen'))

# num_range(): las columnas que coincidan con un string y un rango numerico
pkmn %>% select(num_range('type_', 1))

# all_of(): las columnas que coincidan con un vector de caracteres. Tienen que estar todas
pkmn %>% select(all_of(c('name', 'type_1', 'columna_que_no_existe')))
pkmn %>% select(all_of(c('name', 'type_1')))

# any_of(): las columnas que coincidan con un vector de caracteres. Pueden no estar todas
pkmn %>% select(any_of(c('name', 'type_1', 'columna_que_no_existe'))) # en general, mala idea

# everything(): todas las variables
pkmn %>% select(everything())

# last_col(): la ultima columna, con un numero para saltar columnas de derecha a izq 
pkmn %>% select(last_col())
pkmn %>% select(last_col(2))
pkmn %>% select(last_col(2:3))
pkmn %>% select(last_col(-2)) # no tiene sentido

# _ mutate ------------------------------------------------------------------

pkmn %>% mutate(best_attack = max(attack, sp_atk)) # ojo con max
pkmn %>% mutate(best_attack = pmax(attack, sp_atk)) # pairwise max

# y se pueden crear varias columnas a la vez
pkmn %>% mutate(best_attack = pmax(attack, sp_atk),
                best_defense = pmax(defense, sp_def))

# incluso con las variables que se acaban de crear ahi mismo (pero el orden importa)
pkmn %>% mutate(offensive_pkmn = best_attack > best_defense,
                best_attack = pmax(attack, sp_atk),
                best_defense = pmax(defense, sp_def))

pkmn %>% mutate(best_attack = pmax(attack, sp_atk),
                best_defense = pmax(defense, sp_def),
                offensive_pkmn = best_attack > best_defense)

# pero no caben en la consola, usemos select
pkmn %>% mutate(best_attack = pmax(attack, sp_atk),
                best_defense = pmax(defense, sp_def),
                offensive_pkmn = best_attack > best_defense) %>% 
  select(name, best_attack, best_defense, offensive_pkmn)

# ojo, todo hay que guardarlo!
ncol(pkmn)
pkmn %>% mutate(best_attack = pmax(attack, sp_atk),
                best_defense = pmax(defense, sp_def)) %>%  ncol()
ncol(pkmn)
pkmn <- pkmn %>% mutate(best_attack = pmax(attack, sp_atk),
                        best_defense = pmax(defense, sp_def))

# podemos usar la funcion ifelse para cambiar solamente algunas filas de la columna. base::ifelse tambien funciona per me 
pkmn <- pkmn %>% mutate(type_2 = ifelse(test = is.na(type_2),
                                        yes = 'None', 
                                        no = type_2))

# _ summarise ---------------------------------------------------------------

# se usa igual que mutate, pero lo hace sobre toda la data
pkmn %>% summarise(hp = mean(hp),
                   attack = mean(attack),
                   defense = mean(defense),
                   sp_atk = mean(sp_atk),
                   sp_def = mean(sp_def),
                   speed = mean(speed))

# alternativamente
pkmn %>% select(hp, attack, defense, sp_atk, sp_def, speed) %>% 
  summarise_all(mean)

# _ group_by ----------------------------------------------------

# ahora si, por que a la gente le gusta tanto usar dplyr?
# porque con todas las anteriores podemos hacer toda la limpieza y preparacion
# de la data, y ahora group_by y summarise hacen el trabajo pesado

# como funciona? group_by le dice al resto que haga lo que siempre hace, pero por grupos. veamos:

# promedio por tipo:
pkmn %>%
  group_by(type_1) %>%
  summarise(hp = mean(hp),
            attack = mean(attack),
            defense = mean(defense),
            sp_atk = mean(sp_atk),
            sp_def = mean(sp_def),
            speed = mean(speed)) %>% 
  mutate_if(is.numeric, round, digits = -1)

# y se puede agrupar por varias variables a la vez
# promedio por los dos tipos 
pkmn %>% 
  group_by(type_1, type_2) %>%
  summarise(hp = mean(hp),
            attack = mean(attack),
            defense = mean(defense),
            sp_atk = mean(sp_atk),
            sp_def = mean(sp_def),
            speed = mean(speed))

# promedio de los legendarios
pkmn %>%
  filter(legendary) %>% 
  group_by(type_1) %>%
  summarise(hp = mean(hp),
            attack = mean(attack),
            defense = mean(defense),
            sp_atk = mean(sp_atk),
            sp_def = mean(sp_def),
            speed = mean(speed))

# promedio para legendarios y no legendarios por aparte
promedios_por_legendarios <- pkmn %>%
  group_by(type_1, legendary) %>%
  summarise(hp = mean(hp),
            attack = mean(attack),
            defense = mean(defense),
            sp_atk = mean(sp_atk),
            sp_def = mean(sp_def),
            speed = mean(speed))

# tambien sirve para mutate, y le agrega a cada fila el valor de su grupo
pkmn %>% group_by(type_1, type_2) %>% 
  mutate(type_average = mean(total)) %>% 
  select(-hp, - attack, -defense, -starts_with('sp'))

# ahora todo junto
# pregunta: cual es la generacion que tiene mejores pokemon(e)s por tipo?
pkmn %>% group_by(type_1) %>% 
  mutate(type_average = mean(total),
         mejor_que_promedio = total > type_average) %>% 
  select(-hp, - attack, -defense, -starts_with('sp'))

pkmn %>% group_by(type_1) %>% 
  mutate(type_average = mean(total),
         mejor_que_promedio = total > type_average) %>% 
  group_by(type_1, generation) %>% 
  summarise(mejor_que_promedio_gen = sum(mejor_que_promedio))

pkmn %>% group_by(type_1) %>% 
  mutate(type_average = mean(total),
         mejor_que_promedio = total > type_average) %>% 
  group_by(type_1, generation) %>% 
  summarise(mejor_que_promedio_gen = sum(mejor_que_promedio)) %>% 
  arrange(-mejor_que_promedio_gen)


# lo bonito de dplyr: te va contando con una narrativa concisa que se va haciendo
pkmn %>% group_by(type_1) %>%                                          # para cada tipo: 
  mutate(type_average = mean(total),                                   # se saca el promedio de stats totales
         mejor_que_promedio = total > type_average) %>%                # y se identifica si cada pokemon es mejor que el promedio de su tipo
  group_by(type_1, generation) %>%                                     # despues, para cada combinacion de tipo y generacion:
  summarise(mejor_que_promedio_gen = sum(mejor_que_promedio)) %>%      # contamos cuantos pokemones son mejores que el promedio de su tipo
  arrange(-mejor_que_promedio_gen)                                     # y ordenamos de mayor a menor esos conteos

# y al ser modular, cambiar un detalle no requiere cambiar nada de los demas:
pkmn %>% group_by(type_1) %>% 
  filter(stringr::str_detect(string = name, pattern = 'Mega', negate = TRUE)) %>% # quitemos los Mega
  mutate(type_average = mean(total),                                   
         mejor_que_promedio = total > type_average) %>%                
  group_by(type_1, generation) %>%                                     
  summarise(mejor_que_promedio_gen = sum(mejor_que_promedio)/n()) %>%  # contamos el **%** que son mejores que el promedio de su tipo
  arrange(-mejor_que_promedio_gen)

pkmn %>% group_by(type_1) %>%
  mutate(type_average = mean(total), 
         mejor_que_promedio = total > type_average) %>% 
  filter(generation == 4, type_1 == 'Ice') %>% 
  select(name, total, mejor_que_promedio)

porcentaje_mejor_que_prom <- pkmn %>% 
  group_by(type_1) %>%                                          
  mutate(type_average = mean(total),                                   
         mejor_que_promedio = total > type_average) %>%                
  group_by(type_1, generation) %>%                                     
  summarise(mejor_que_promedio_gen = sum(mejor_que_promedio)/n()) %>% 
  arrange(-mejor_que_promedio_gen)

# y podemos hacerle un summary al summary
porcentaje_mejor_que_prom %>% 
  group_by(generation) %>% 
  summarise(tipos_mejores_que_prom = sum(mejor_que_promedio_gen)) %>% 
  arrange(-tipos_mejores_que_prom)

# y ahora podemos aplicar cosas de que aprendimos la primera sesion
library(ggplot2)
porcentaje_mejor_que_prom %>% 
  ggplot(aes(x = generation,
             y = mejor_que_promedio_gen, 
             color = type_1)) + geom_point()

porcentaje_mejor_que_prom %>% 
  ggplot(aes(x = generation,
             y = mejor_que_promedio_gen, 
             color = type_1)) + 
  geom_point() + 
  geom_line()


# stats de cada tipo en cada generacion
porcentaje_mejor_que_prom %>% 
  ggplot(aes(x = generation,
             y = mejor_que_promedio_gen, 
             color = type_1)) + 
  geom_point() +
  geom_line() + 
  facet_wrap(~type_1, scales = 'free_y') + 
  theme_minimal() + 
  theme(legend.position = 'None')

# stats de cada tipo en cada generacion
porcentaje_mejor_que_prom %>% 
  ggplot(aes(x = generation,
             y = mejor_que_promedio_gen, 
             color = type_1)) + 
  geom_point() +
  geom_line() + 
  facet_wrap(~type_1, scales = 'free') + # en vez de solo dejar libre el eje y, dejamos el eje x tambien, es solo para que salga el eje en cada grafico 
  theme_minimal() + 
  theme(legend.position = 'None')



