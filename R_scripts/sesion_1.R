# PRIMERA SESIÓN AISLADA - DATA ANALYSIS EN R

# Que vamos a aprender?

# 0. Para los que nunca han programado:

# Lo que si de fijo hay que saber para entender lo que vamos a hacer hoy:
# - las partes de la interfaz de RStudio
# - guardar valores 
# - llamar funciones
# - crear vectores
# - ordenar su carpeta de trabajo

# Lo que hace falta para que trabajen solos pero no nos da tiempo de ensenar:
# https://learnxinyminutes.com/docs/r
# - Tipos de variables
# - Cosas clasicas de programacion: for, if, else, while, whatevers esos
# - slicing (como agarrar porciones de un vector)

# - estadistica!


# 0. Para los que nunca han programado: -----------------------------------


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
# trabajo. Cuando se abre Rstudio puede que este panel no sea visible, porque
# no hay ni scripts ni objetos abiertos. 

# 2. Panel de ambiente: aca vemos todos los objetos, variables y funciones que
# vamos creando. Tiene otras pestanas que no vamos a discutir aca.

# 3. Panel de consola: la mejor forma de explicarlo que se me ha ocurrido es
# verla como una calculadora de esas que imprimen en papel los resultados. Ahi
# lo que corran se va a ejecutar y les va a imprimir el resultado pero no pueden
# cambiar lo que ya imprimio. Para eso están los scripts

# 4. Panel de muchas cosas:
#   - Files: se ve la carpeta en la que estan trabajando, con todos los archivos
#  que tenga
#  - Plots: aca se visualizaran los graficos que vamos ejecutando, se guardan
#  todos y podemos volver a los  viejos, pero yo siempre prefiero volver a correrlos
#  que estar navegando con la flecha de ese panel.
#  - Packages: aca se ven todos lo paquetes que se hayan instalado adicionalmente,
#  y tienen un check que indica si estan cargados en esta sesion o si estan instalados 
#  pero invisibles para la sesion de trabajo. R ya trae bastantes paquetes instalados,
#  y la mayoria estan "dormidos" cuando se abre RStudio.
#  - Help: su mejor amigx! cuando uno esta apenas empezando a usar R es un poco
#  dificil de leer, pero es increíblemente útil y una buena parte de los errores 
#  corriendo codigo se pueden resolver leyendo la documentacion.


# _ Guardar valores ---------------------------------------------------------

# **nombres de las variables tienen que significar *ALGO*
# varios estandares para formato: no importa cual usen pero sean consistentes**
# -camelCaseFormat
# -snake_case_format  
# -SCREAMING_SNAKE_FORMAT

# numeros
10 
numero <- 10 # alt + - = <-
numero <- 15
numero <- 5 + 5 
numero <- numero + 5
numero_nuevo <- numero*500

# letras
a  # asi sueltas no
'a' 
"a"
letra <- 'a'
letra_comilla_doble <- "a"

letra == letra_comilla_doble

# booleanos (falso y verdadero)
# van en mayúscula
FALSE
False
false
TRUE
True 
true

# NA para cuando no hay data valida
NA 

# vectores
vector_numeros <- c(1,2,3)
vector_letras <- c('a', 'b', 'c')
vector_que_deberia_no_servir <- c('a', 1) # ojo no da error

vector_con_vector <- c(1, 2,3, c(4,5))


# ojo los NA son peligrosos
numeros_buenos <- c(1,2,3)
numeros_buenos + NA # R no da advertencia!


#_ Funciones ---------------------------------------------------------------

sum(1,2)
# se pueden guardar de una vez
suma_1_2 <- sum(1,2)

max(2,3)
mean(2,3)

help(mean)
?mean
mean(c(2,3))

# hay paquetes con un monton de funciones extra. Mis favoritos:
install.packages('data.table')
library(data.table)
library(purrr)
library(ggplot2)
library(janitor)
library(stringr)

#_ Ordenar carpeta de trabajo ----------------------------------------------

# consejos, no reglas, pero:
# - una unica carpeta con el nombre del proyecto, conteniendo:
#   - carpeta con data cruda
#   - carpeta con los scripts de R
#   - carpeta con resultados: gráficos, tablas, etc.
# cada carpeta ordenada, con nombres claros y subcarpetas si fuera necesario

# Tips para hacer su código presentable: 
# 1. comentar comentar y comentar: no solo comentar que estan haciendo en cada
#   comando sino *por que* lo estan haciendo. Los comentarios no son solo para 
#   exlicar las partes enredadas, sino para darle una *narrativa* al codigo
# 2. ctrl + shift + R crea encabezados para seccionar el script, como en este 
#    que estan leyendo.
# 3. seleccionar texto y ctrl + i = indenta el codigo automaticamente. esto
#   funciona ademas para saber si los parentesis calzan o si falta algo

# 1. Tidy data ------------------------------------------------------------

# El analisis de datos nace de, pues, manejar datos, no? Las formas en que se 
# expresan los datos pueden ser tan variados como la misma data, y tener un lenguaje
# de tabajar la data es casi tan importante como tener la data en si.

# Tidy data es un estandar de manejo de data, en donde el significado de la
# data está expresado en su estructura. Se trabaja con data rectangular, es 
# decir, tablas, donde:

# 1. Cada variable es una columna
# 2. Cada observación de la población estudiada es una fila
# 3. Cada tipo de información forma una tabla

# Con eso basta por ahora, pero si quieren más detalle, un paper de Wickham
# lo expone a profundidad: 
# https://vita.had.co.nz/papers/tidy-data.pdf


# 2. Tablas ------------------------------------------------------------------

# Por  que sirve tanto tidy data en R? porque así es como se construyen las 
# tablas en R!

# _Escribir tablas diractamente ----
# se pueden crear "a mano" poniendo cada vector como una columna
tabla <- data.frame(columna1 = c('A', 'B', 'C', 'D'),
                    columna2 = c(1, 2, 3, 4))

# o bien se pueden cargar

# _Cargar datos -----

# Texto plano *aplausos* ----
# a. Botón de Import dataset y copiar y pegar el codigo que diga ahi

# b. leer desde un comando
nombre_archivo_texto_plano <- 'data/data_importante_de_negocios.csv'
# b.1 el paquete default: readr
library(readr)
pkmn <- readr::read_csv(nombre_archivo_texto_plano)

# b.2 el paquete que prefiero: data.table
library(data.table) # por que lo prefiero? porque muchas veces las 
# tablas que cargo no son mias y data.table describe mejor las 
# razones de por que algo no se esta leyendo bien
pkmn <- data.table::fread(nombre_archivo_texto_plano)

# Excel *abucheos* ----
nombre_archivo_excel <- 'data/data_importante_de_negocios_pero_en_excel.xlsx'
# a. Botón de Import Dataset

# b. leer desde un comando
# b.1 el paquete default:
library(readxl)
pkmn_xlsx <- readxl::read_excel(nombre_archivo_excel)

# b.2 el paquete que prefiero: openxlsx
library(openxlsx) # por que lo prefiero? porque es mas tolerante
# con cosas feas de excel, y porque escribir archivos de excel es 
# mas facil, confiable y con mas opciones
pkmn_xlsx <- openxlsx::read.xlsx(nombre_archivo_excel)

View(pkmn)

# tantear data
summary(pkmn)

# hay un par de problemas con los nombres de las columnas:
# 1. una columnas es '#', y ese símbolo ya se usa en R para los comentarios
# 2. hay nombres con espacios como 'Sp. Atk'
# R permite referirse a nombres asi con backtics: `` (la tecla a la par del 1 en el teclado en ingles)
# pero eso es incomodo y hay un paquete que resuelve esas cosas:

library(janitor)
pkmn <- janitor::clean_names(pkmn)
# - `#` ahora es 'number'
# - `Sp. Atk` es 'sp_atk'
# - todos los nombres de columnas estan ahora en snake_case

library(skimr)
skimr::skim(pkmn)

# veamos las correlaciones entre variables
library(corrplot)
corrplot::corrplot(cor(pkmn))

# se cae, hay que dejarnos solo las variables numericas
corrplot::corrplot(cor(purrr::keep(pkmn, is.numeric)))

# 3. Graficar con  ggplot2: Grammar of Graphics --------------------------

library(ggplot2)

# paper que explica todo detrás de la gramatica de graficos:
# https://byrneslab.net/classes/biol607/readings/wickham_layered-grammar.pdf

# libro muy bonito sobre cuándo usar cada grafico: 
# https://serialmentor.com/dataviz/

# siempre necesitamos:
# - data: aka una tabla
# - mapping AKA una estetica: que rol va a tomar cada columna de la tabla
# - geometria: que figura vamos a hacer

# la primera funcion que hay que llamar es ggplot. ggplot construye el
# sistema de coordenadas en las que vamos a poner las capas del grafico

ggplot(data = pkmn)

# y si le damos el mapping, crea los ejes
ggplot(data = pkmn, mapping = aes(x = number, y = hp))

# y sobre estos ejes, se pueden agregar las capas. geom_point serían los puntos
ggplot(data = pkmn, aes(x = number, y = hp)) + geom_point()

# hacer puntos sobre un indice como `#` no tiene sentido 
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

# size
ggplot(data = pkmn, aes(x = defense,
                        y = attack)) +
  geom_point(aes(color = type_1,
                 shape = type_2,
                 size = hp))

# problemas hasta ahora:
# - este grafico es horrible y confuso y no se ve una buena parte de la data

# cambiemos los colores: el paquete RColorBrewer tiene una amplia variedad de paletas de colores
library(RColorBrewer)
RColorBrewer::display.brewer.all()

# y ggplot2 tiene una funcion para aplicarlos a un grafico directamente, agragando 
# la paleta como otra 'capa' en la gramatica: con ggplot2::scale_color_brewer()

ggplot(data = pkmn, aes(x = defense,
                        y = attack)) +
  geom_point(aes(color = type_1,
                 shape = type_2,
                 size = hp)) +
  scale_color_brewer(palette = 'Spectral')
# y ademas da un warning, que no le alcanzan los colores

# En general: si no alcanzan los colores, no usen colores!

# facet(t)ing ----

# en vez de distinguir cada tipo por un color, vamos a hacer un gráfico para cada tipo
ggplot(data = pkmn, aes(x = defense,
                        y = attack)) +
  geom_point(aes(color = type_1,
                 size = hp)) + 
  scale_color_brewer(palette = 'Paired') + 
  facet_wrap(~ type_1)

# todavía tenemos el problema de los colores 
grafico_final_decente <- ggplot(data = pkmn, aes(x = defense,
                        y = attack, label = name)) +
  geom_point(aes(color = type_1,
                 size = hp)) + 
  facet_wrap(~ type_1)

# ultimo truco: plotly grafica en html y se le puede aplicar a un ggplot directamente con su funcion ggplotly()
# mas info: https://plot.ly/r/
library(plotly)
plotly::ggplotly(grafico_final_decente)
# otros geom_* ----

# geom_violin
ggplot(pkmn) +
  geom_violin(aes(x=type_1, y = hp, fill=type_1))

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
