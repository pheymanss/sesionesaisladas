# SESSION ONE

# What are we going to learn today?
#   - RStudio Interface
#   - Object definition
#   - Function calls
#   - Basic folder setup
#   - Create vectors
#   - How to keep things clean
#   - Read plain text files
#   - Read excel files
#   - ggplot2, from scratch to advanced

# What are we (not* going to learn?)
#   - Classic programming things: for, if, else, while, etc. (see https://learnxinyminutes.com/docs/r for a quick recap)
#   - Statistics!

# 0. Getting started ------------------------------------------------------

# How to install R --------------------------------------------------------

# Installing R measn two separate tasks:
# 1. Installing R, the programming language
# 2. Installing RStudio, the integrated development environment (IDE) for R programming

# _ RStudio Interface -----------------------------------------------------

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

# 1. Script panel: here you will have the scripts, whic is the specialized code
# that you will create and you want to keep after you have finish excecuting it.
# When you open RStudio for the first time, it will not show you this panel 
# since we do not have any code yet.

# 2. Environment panel: here you can see all the objects, variables and fuctions, 
# as we create them. It has other tabs that we will not discuss right now.

# 3, Console panel. The best way to think about this is like one of those printer
# calculators. What you run here will be excecuted and the objects will be saved, 
# but once you excecuted the command you cannot go back and edit the code you run, 
# it has already been printed and the next excecution will have its own line. That
# is what scripts are for.

# 4. Many Things Panel: 
#   - Files: Standard file browser. you can change your working directory here, but 
#     we will see a better way to work 
#   - Plots: here you will have all the plots you create in a session and you can 
#     navigate between them, but I usually prefer to re-run the plot I want instead 
#     of going back and forth with the arrows.
#   - Packages: Here you can see all installed R packages. R packages are what makes 
#     R such a powerful tool, and each package has a checkbox to tell you if they are 
#     currently loaded or remaing 'dormant.'
#   - Help: Your best firend! It is a bit hard to read when you are just starting with
#     R, but it is incredibly useful and you can catch most of your beginner mistakes
#     easily if you learn how to read the documentation
#   - Viewer: A general purpose HTML visualizer, you probably will not use it soon.

# _ Define objects ---------------------------------------------------------

# object names must mean *SOMETHING*
# several standard formats for object names:
#  -camelCaseFormat
#  -snake_case_format  
#  -SCREAMING_SNAKE_FORMAT

# number
10 
number <- 10 # alt + - = <-
number <- 15
number <- 5 + 5 
number <- number + 5
new_number <- number * 500

# letters 
a  # not by themselves
'a' 
"a"
letter <- 'a'
letter_double_comma <- "a"

letter == letter_double_comma

# booleans (true and false)
# muts be caps
FALSE
False
false
TRUE
True 
true

# NA when ther is no valid data
NA 

# vectors
number_vector <- c(1,2,3)
character_vector <- c('a', 'b', 'c')
vector_that_should_not_work <- c('a', 1) # ojo no da error

vector_with_vector <- c(1, 2,3, c(4,5))

# careful! NAs are dangerous
good_nubers <- c(1,2,3)
bad_numbers + NA # R gives no warning!

#_ Functions ---------------------------------------------------------------

sum(1,2)
# can be assigned 
sum_1_2 <- sum(1,2)

max(2,3)
mean(2,3)

help(mean)
?mean
mean(c(2,3))

# best way to find the function you are looking for? google it
# eg:
#   change vector class R
#   delete column from table R
#   read column as date R

# There are hundreds of thousands of R packages, a few of my favourites:
install.packages('data.table')
library(data.table) # blazing-fast data transformation
library(purrr)      # list handling and transformation
library(ggplot2)    # grammar of graphics for plotting
library(stringr)    # character string manipulation
library(janitor)    # data cleaning

# _Organize your project folder --------------------------------------------

# Guidelines, not rules, but:
# - a single folder with the name of the project, containing
#   - folder with the raw data
#   - folder with R scripts
#   - folder with intermediate/processed data
#   - folder with results: plots, tables, etc.
# each folder with clear, straight-forward names and subfolders if needed.

# Tips for making presentable code:
# 1. Comment, comment, comment. Code comments should not be only used to say
#    what you are doing, but also *why* you are doing it. And don't only 
#    comment the more complicated parts of the code, give the code a *narrative*.
# 2. ctrl + shift + R creates code headers. Use them to create sections for 
#    easier navigation.
# 3. Select text + ctrl + I automatically indents code. Unlike Python, R 
#    indentations are not part of the sintax, but that does not mean messy 
#    code is acceptable. This also helps you find mismatching brackets or
#    parentheses.


# 1. Tidy data ------------------------------------------------------------

# Data analysis is born from, well, handling data, right? The way in which 
# the data is expressed could be as diverse as the data itself, so having a 
# consistent language for working with data is very, very important.

# Tidy data is a data handling paradigm in which the meaning of the data is
#  conveyed by its structure. We work with rectangular data, eg tables, where:
#  1. Each variable is a column
#  2. Each row is an observation of the phenomena at hand.
#  3. Each type of information forms a table.

#  For further details, the seminal Tidy Data paper by Hadley Wickham
# https://vita.had.co.nz/papers/tidy-data.pdf


# 2. Tables ---------------------------------------------------------------

# Why is tidy data important in R? Because that is how you build a table!

# _ Write tables directly -----
# you can enter all datapoints manually
table <- data.frame(column1 = c('A', 'B', 'C', 'D'),
                    column2 = c(1, 2, 3, 4))

# but it is easier to just load already existent data

# _ Load files ----

# Plai text *aplause* ----
# a. Import Dataset button on the Environment tab, it even lets you
# copy-paste the code

# b. use a function
plain_text_file <- 'data/important_business_data.csv'
# b.1 using the default package: readr
library(readr)
pkmn <- readr::read_csv(plain_text_file)

# b.2 the package I prefer: data.table
library(data.table) # Why do I prefer it? Most of the data I read 
# is not mine, it will have several issues unknown to me and data.table 
# describes them with more detail so it is easier to fix. 
pkmn <- data.table::fread(plain_text_file)

# Excel *boo* ----
excel_file_name <- 'data/important_business_data_but_in_excel.xlsx'
# a. Import Dataset button also works

# b. use a function
# b.1 default package:
library(readxl)
pkmn_xlsx <- readxl::read_excel(excel_file_name)

# b.2 the package I prefer: openxlsx
library(openxlsx) # Why prefer it? It is more tolerant of excel 
# kinks and has more options.
pkmn_xlsx <- openxlsx::read.xlsx(excel_file_name)

View(pkmn)

# glance the data
summary(pkmn)

# there are a few issues with our column names:
# 1. there is a '#' symbol which R already uses for comments
# 2. There are spaces on several column names, like 'Sp. Atk'
#    R allows both these things by using backticks (``) as escape
#    characters, but it is quite cumbersome to wirte that every 
#    time.

library(janitor)
pkmn <- janitor::clean_names(pkmn)
# - `#` now  is 'number'
# - `Sp. Atk` is 'sp_atk'
# - all column names are now on snake_case

# so now let's look at the data
library(skimr)
skimr::skim(pkmn)
# we can also look at linear correlations
library(corrplot)
corrplot::corrplot(cor(pkmn))

# why the error? it cna only recieve numeric variables
corrplot::corrplot(cor(purrr::keep(pkmn, is.numeric))) #advanced trick: purrr::keep() and purr::discard()

# 3. Plot with ggplot2: A Grammar of Graphics --------------------------

library(ggplot2)

# paper explaining everyhting behind the grammar of graphics paradigm:
# https://byrneslab.net/classes/biol607/readings/wickham_layered-grammar.pdf

# beautiful book on when and how use each type of plot
# https://serialmentor.com/dataviz/

# For a grammar of graphics, we always need:
# - data
# - mapping, ie an easthetic: which role will fulfill each function
# - geometry: what shape are we using

# the first function to call will be ggplot(). This builds the space 
# in wich we will start layering all the elements of the plot.

ggplot(data = pkmn) # it gives us a blank space

# then we can add a mapping, in which we will say which variables will
# take each role. Here for example, the x axis values will be the number,
# and the y axis will be the hp.
ggplot(data = pkmn, mapping = aes(x = number, y = hp))

# Now we see a coordinate system, but nothing else. That is because we are
# still missing a geometry for our plot, which determines the type of plot 
# we will be making 

# we can start with a scatter plot, using geom_point
ggplot(data = pkmn, aes(x = number, y = hp)) + geom_point()

# let's switch the variables to get more meaningful insights
ggplot(data = pkmn, aes(x = defense, y = attack)) + geom_point()

# a geom_point can recieve aesthetics in itself, and each geom_* 
# has several parameters
ggplot(data = pkmn, aes(x = defense,
                        y = attack)) +
  geom_point(aes(color = type_1))

# shape 
ggplot(data = pkmn, aes(x = defense,
                        y = attack)) +
  geom_point(aes(color = type_1,
                 shape = type_2))
# problem: many type_2 have NA ï¸values (to be continued)

# size
ggplot(data = pkmn, aes(x = defense,
                        y = attack)) +
  geom_point(aes(color = type_1,
                 shape = type_2,
                 size = hp))

# problems so far:
# this plot is horrible, confusing and most of the data is not displayed

# Let's change the colors: the RcolorBrewer package has a wide variety of palettes
library(RColorBrewer)
RColorBrewer::display.brewer.all()

# and ggplot has a function to apply those palettes directly to a plot, which will 
# be another 'layer' in our grammar
ggplot(data = pkmn, aes(x = defense,
                        y = attack)) +
  geom_point(aes(color = type_1,
                 shape = type_2,
                 size = hp)) +
  scale_color_brewer(palette = 'Spectral')
# and now we also have a warning , we dont have enough colors!

# General take: if there are not enough colors, you should not be using colors in the first place!


# _ facet(t)ing ----

# Instead of trying to fix it with colors, we will make an individual plot for each type.
# This would be a very slow process, dividing the data into 18 different files, reading 
# each file and creating and saving each plot. 
ggplot(data = pkmn, aes(x = defense,
                        y = attack)) +
  geom_point(aes(color = type_1,
                 size = hp)) + 
  scale_color_brewer(palette = 'Paired') + 
  facet_wrap(~ type_1)

# let's get rid of the insufficient pallete
grafico_final_decente <- ggplot(data = pkmn, aes(x = defense,
                                                 y = attack, label = name)) +
  geom_point(aes(color = type_1,
                 size = hp)) + 
  facet_wrap(~ type_1)


# last trick: the package plotly renders an interactive version of a ggplot using ggplotly()
# more info: https://plot.ly/r/
library(plotly)
plotly::ggplotly(grafico_final_decente)


# other geom_* ----

# geom_violin
ggplot(pkmn) +
  geom_violin(aes(x=type_1, y = hp, fill=type_1))

# Which types are more offensively/defensively inclined?
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


_ # For reference -----------------------------------------------------------

# Help choosing the correct plot for different types of data: https://serialmentor.com/dataviz/
# Examples with R code for each geom_*: https://www.r-graph-gallery.com/ggplot2-package.html
# Common mistakes made while visualizing data: https://www.data-to-viz.com/caveats.html
# My favourite R book ever, R for Data Science by Garret Grolemund and Handley Whickam: https://r4ds.had.co.nz/


