# PRIMERA SESION - DATA ANALYSIS EN R

# Que vamos a aprender?

# 0. Para los que nunca han programado:

# Lo que si de fijo hay que saber para entender lo que vamos a hacer hoy:
# - las partes de la interfaz de RStudio
# - guardar valores 
# - llamar funciones

# Lo que hace falta para que trabajen solos pero no nos da tiempo de ensenar:
# https://learnxinyminutes.com/docs/r
# - Tipos de variables
# - Cosas clasicas de programacion: for, if, else, while, whatevers esos
# - slicing (como agarrar porciones de un vector)
# - estadistica!

# 0. Para los que nunca han programado: -----------------------------------

# _ Instalar R  -------------------------------------------------------------

# Instalar R requiere dos tareas:
# 1. Instalar R, el lenguaje de programacion.
# 2. Instalar RStudio, el programa que vamos a usar para programar.

# Convenientemente, ambos están en ASAP Software, así que basta con:
#  > 1. Navegar a The Hub 
#  > 2. Irse a la seccion de Tools 
#  > 3. Abrir ASAP Software
#  > 4. Bajar hasta la R e instalar tanto 'R for Windows' como 'RStudio'


# _ Interfaz de RStudio -----------------------------------------------------

# |----------------|----------------|
# |                |                |
# |                |                |
# |       1        |       2        |
# |                |                |
# |----------------|----------------| 
# |                |                |
# |                |                |
# |       3        |       4        |
# |                |                |
# |----------------|----------------| 


# 1. Panel de scripts: aca van los scripts, que es el codigo especializado 
# que vamos creando y queremos conservar cuando terminemos la jornada de 
# trabajo. Cuando se abre Rstudio puede que este panel no sea visible, 
# porque no hay ni scripts ni objetos abiertos. 

# 2. Panel de ambiente: aca vemos todos los objetos, variables y funciones
# que vamos creando. Tiene otras pestanas que no vamos a discutir hoy.

# 3. Panel de consola: la mejor forma de explicarlo que se me ha ocurrido es
# verla como una calculadora de esas que imprimen en papel los resultados. 
# Ahi lo que corran se va a ejecutar y les va a imprimir el resultado pero no
# pueden cambiar lo que ya imprimio. Para eso estan los scripts.

# 4. Panel de muchas cosas:
#  - Files: se ve la carpeta en la que estan trabajando, con todos los 
#  archivos que tenga
#  - Plots: aca se visualizaran los graficos que vamos ejecutando, se guardan
#  todos y podemos volver a los  viejos, pero yo siempre prefiero volver a 
#  correrlos que estar navegando con la flecha de ese panel.
#  - Packages: aca se ven todos lo paquetes que se hayan instalado 
#  adicionalmente, y tienen un check que indica si estan cargados en esta 
#  sesion. R no carga todos los paquetes instalados cada vez que se abre, hay
#  que cargar los que se vana  usar en cada sesion.
#  - Help: su mejor amigo! cuando uno esta apenas empezando a usar R es un 
#  poco dificil de leer, pero es increiblemente util y una buena parte de los
#  errores corriendo codigo se pueden resolver leyendo la documentacion.

#_ Funciones ---------------------------------------------------------------

sum(1,2)

# guardar valores
valor1 <- 1
valor2 <- 2
suma_1_2 <- sum(1,2)
suma_1_2_con_variables <- sum(valor1,valor2) 

max(2,3)

help(mean)
?mean
?sum

# hay paquetes con un monton de funciones extra. Mis favoritos:
install.packages('data.table')
library(data.table) # transformacion de tablas
library(purrr)      # iteracion de funciones
library(ggplot2)    # construccion de graficos
library(janitor)    # limpieza automatica de tablas
library(stringr)    # manejo de texto

# 1. Tidy data ------------------------------------------------------------

# El analisis de datos nace de, pues, manejar datos, no? Las formas en que 
# se expresan los datos pueden ser tan variados como la misma data, y 
# tener un lenguaje de tabajar la data es casi tan importante como tener la
# data en si.

# Tidy data es un estandar de manejo de data, en donde el significado de la
# data esta expresado en su estructura. Se trabaja con data rectangular, es 
# decir, tablas, donde:

# 1. Cada variable es una columna
# 2. Cada observacion de la poblacion estudiada es una fila
# 3. Cada tipo de informacion forma una tabla

# Con eso basta por ahora, pero si quieren mas detalle, un paper de Wickham
# lo expone a profundidad: 
# https://vita.had.co.nz/papers/tidy-data.pdf

# 2. Tablas ------------------------------------------------------------------

# Por  que sirve tanto tidy data en R? porque asi es como se construyen las 
# tablas en R!

# _Escribir tablas diractamente ----
# se pueden crear "a mano" poniendo cada vector como una columna
tabla <- data.frame(columna1 = c('A', 'B', 'C', 'D'),
                    columna2 = c(1, 2, 3, 4))

# o bien se pueden cargar

# _Cargar datos -----

# Texto plano *aplausos* ----
# a. Boton de Import dataset y copiar y pegar el codigo que diga ahi
library(readr)
data_importante_de_negocios <- read_csv("data/data_importante_de_negocios.csv")
View(data_importante_de_negocios)

# b. leer desde un comando
nombre_archivo_texto_plano <- 'data/data_importante_de_negocios.csv'
library(readr)
pkmn <- readr::read_csv(nombre_archivo_texto_plano)

# Excel *abucheos* ----
nombre_excel <- 'data/data_importante_de_negocios_pero_en_excel.xlsx'
# a. Boton de Import Dataset

# b. leer desde un comando
library(readxl)
pkmn_xlsx <- read_excel(nombre_excel)

View(pkmn)

# tantear data
summary(pkmn)

# hay un par de problemas con los nombres de las columnas:
# 1. una columnas es '#', y ese simbolo ya se usa en R para los comentarios
# 2. hay nombres con espacios como 'Sp. Atk'
# R permite referirse a nombres asi con backtics: `` (la tecla a la par del 1 en el teclado en ingles)
# pero eso es incomodo y hay un paquete que resuelve esas cosas:

library(janitor)
pkmn <- clean_names(pkmn)
# - `#` ahora es 'number'
# - `Sp. Atk` es 'sp_atk'
# - todos los nombres de columnas estan ahora en snake_case

library(skimr)
skim(pkmn)

# veamos las correlaciones entre variables
library(corrplot)
corrplot(cor(pkmn))

# se cae, hay que dejarnos solo las variables numericas
library(purrr)
pkmn_num <- keep(pkmn, is.numeric)
corrplot(cor(pkmn_num))

# 3. Graficar con  ggplot2: Grammar of Graphics --------------------------

library(ggplot2)

# paper que explica todo detras de la gramatica de graficos:
# https://byrneslab.net/classes/biol607/readings/wickham_layered-grammar.pdf

# libro muy bonito sobre cuando usar cada grafico: 
# https://serialmentor.com/dataviz/

# siempre necesitamos:
# - data: AKA una tabla
# - mapping AKA una estetica: cual rol va a tomar cada columna de la tabla
# - geometria: que figura vamos a hacer

# la primera funcion que hay que llamar es ggplot(). ggplot solamente construuye
# el espacio en el que vamos a poner las capas del grafico

ggplot(data = pkmn)

# entonces, si le damos el mapping, crea los ejes
ggplot(data = pkmn, mapping = aes(x = number, y = hp))

# y sobre estos ejes, se pueden agregar las capas con las formas. geom_point() 
# por ejemplo serian los puntos
ggplot(data = pkmn, aes(x = number, y = hp)) + geom_point()

# hacer puntos sobre un indice como `#` no tiene mucho sentido 
ggplot(data = pkmn, aes(x = defense, y = attack)) + geom_point()

# a geom_point se le pueden cambiar muchas cosas dentro de su estetica:
# color:
ggplot(data = pkmn, aes(x = defense,
                        y = attack)) +
  geom_point(aes(color = type_1))

# shape 
ggplot(data = pkmn, aes(x = defense,
                        y = attack)) +
  geom_point(aes(color = type_1,
                 shape = type_2))
# problema: muchos type 2 tienen NA️ (to be continued)

# problemas hasta ahora:
# - este grafico es horrible y confuso y no se ve una gran parte de la data

# faceting ----

# en vez de distinguir cada tipo por un color, vamos a hacer un grafico para
# cada uno de los tipos
grafico_final_decente <- ggplot(data = pkmn, 
                                aes(x = defense, y = attack, label = name)) +
  geom_point(aes(color = type_1,
                 size = hp)) + 
  facet_wrap(~ type_1) + 
  theme_minimal()

grafico_final_decente

# ultimo truco: plotly grafica en html y se le puede aplicar a un ggplot 
# directamente con su funcion ggplotly()
# mas info: https://plot.ly/r/
library(plotly)
plotly::ggplotly(grafico_final_decente)

# otros geom_* ----

# geom_boxplot
ggplotly(ggplot(pkmn) +
           geom_boxplot(aes(x=type_1, y = hp, fill=type_1)))

# cuales tipos son mas ofensivos/defensivos?
# geom_density

ggplot(pkmn) +
  geom_density(aes(x = attack,
                   color = 'red',
                   fill  = 'red',
                   alpha = 0.8)) +
  geom_density(aes(x = defense,
                   color = 'blue' ,
                   fill  = 'blue',
                   alpha = 0.8)) +
  facet_wrap(~type_1) + 
  theme_minimal() + 
  theme(legend.position = 'None')

# links de referencia para graficar ----
# para saber que grafico sirve para lo que quieran ensenar: https://serialmentor.com/dataviz/
# ejemplos con codigo en R para cada geom_*: https://www.r-graph-gallery.com/ggplot2-package.html
# problemas comunes al disenar visualizaciones: https://www.data-to-viz.com/caveats.html
# siempre recomendado: https://r4ds.had.co.nz/