
# ==================== Session 2: Data transformation ====================
#  
# 1. Setup the basics ----------------------------------------------------

# _ operations over vectors ----------------------------------------------

# R is built around vector operations
# This means that *EVERY* operation is a vector operation
x <- c(3,4,5,6)

3,4,5,6 # this is not a vector

x + 2
x - x
2^(x)

c(0,0,0,0) - c(1,2,3,4)

# sequences are easily created with the sintax number1:number2
1:5
200:2000

# for more complex sequences you can use seq()
seq(1, 10, by = 2) # the 'by' parameter lets you choose the distance between elements of the sequence
seq(0, 10, by = 2)
seq(0, 1, by = .1)

# WARNING: recycling
c(0,1) + c(1,1,1)
c(0,1) + c(1,1,1,1) # no message or warning whatsoever, R thinks you are 
# doing it on purpose!

# _ slicing ---------------------------------------------------------------

x[1:3]
x[1,4,5,6]  # doesn't work because 1,4,5,6 is not a vector
x[c(1,3,4)]
x[c(TRUE, FALSE)]

# slicing with negatives allows eliminating elements
x[-1]
x[-1] == x[c(FALSE, TRUE, TRUE, TRUE)]

# _ R packages  -------------------------------------------------------------
# Standing on the shoulder of giants

# 1. install packages
install.packages('dplyr')

# 2. load the package into memory: R doesn't load packages without you asking
library(dplyr)  

# 2. pipe operators -----------------------------------------------------------

# the pipe operator is %>% 
# shortcut: ctrl + shift + M
library(magrittr)

mean(c(1,2,3,4))

c(1,2,3,4) %>% mean()

# why use pipes? *controversial*
# - it is easier to add functions at any point of the execution.
# - it is easier to identify the parameters of each function.
# - it gives a clear narrative to the code: pipe = 'and then do.'
# - clearly separates the object and the functions
# - it is easier to see the order of excecution

# Let's compare 

# the rounding of the sum of the square root of 0,1,2,3 up to two digits
round(sum(sqrt(c(0,1,2,3))), 2) 

# vs

# take 0,1,2,3, take the square root, add all values and round to two digits
c(0,1,2,3) %>% sqrt() %>% sum() %>% round(2)

# how to use a pipe
f(x)         ==   x %>% f()
f(x, y)      ==   x %>% f(y)
g(f(x))      ==   x %>% f()  %>% g()
h(g(f(x)))   ==   x %>% f()  %>% g() %>% h()
g(h(f(x, y)),z) ==   x %>% f(y) %>% h() %>% g(z)

# 3. Dealing with text: stringr ---------------------------------------------

library(stringr)

# defining stings
words <- c('ola', 'mundo', 'o whatever')

# you can count characters 
str_count(words) #it counts space characters too!
str_count(words) %>% sum()
# text matching

# this can be done with regular expressions: you
# can get up to speed with them in 1-2 hours here
# https://regexone.com/
str_detect(string = words, pattern = 'a') 

# slicing works identically as it worked with numbers
words[1:2]
words[c(1,3)]
words[c(FALSE, FALSE, TRUE)]

# using TRUE FALSE is especially useful since you can test conditions on each text
# for example, keep the words with a (lowercase) letter 'a' 
str_detect(string = words, pattern = 'a')
words[str_detect(string = words, pattern = 'a')]

# 4. Deal with dates: lubridate ------------------------------------------

library(lubridate)

# Working with dates is never a pleasure, but lubridate makes it more 
# manageable. To read data as dates, you can use the lubridate functions: 
# myd, dmy, mdy, where m stands for month, d for day and y for year
any_date <- ymd("2020-03-15")
# these are very flexible
ymd("20200315") # character with no hyphen
mdy(06092020)   # numbers directly

today <- today()
class(today)
yesterday <- today - 1
class(yesterday)

# sum and substract
a_month_ago <- today - months(1)

# CAREFUL!
# Months are not consistent measures for time: think about why these do not work
ymd(20200330) - months(1)
ymd(20200331) + months(1) + months(1)
ymd(20200331) + months(2)
today() - days(33)

# also leap-years
ymd(20210101) - days(365)
ymd(20210101) - years(1)

# also there are 3 (!) ways to count weeks
ymd(20210101) %>% week()
ymd(20210101) %>% isoweek()
ymd(20210101) %>% epiweek()
# :)

# generally, be very careful with dates

# 5. Data transformation with dplyr ------------------------
# 
# tidy data: 
# (https://cran.r-project.org/web/packages/tidyr/vignettes/tidy-data.html)
# 1. Each variable is a column
# 2. Each observation is a row
# 3. Each type of observational unit forms a table.

# read more data than last time
library(readr)
pkmn <- read_csv('data/bigger_important_business_data.csv')

# always convenient to clean up the column names
library(janitor)
pkmn <- clean_names(pkmn)

# and let's get to business
library(dplyr)
# dplyr sintax: function(table, additional, parameters)
# with pipe: table %>% funcion(additional, parameters)

# _ filter ----------------------------------------------------------------
# remove rows from a table based on column values 
# sintax: filter(table, condition1, condition2, contition3, ...)
# modifier: !

# over character columns 
pkmn %>% filter(str_detect(string = name, pattern = 'Mega'))
pkmn %>% filter(!str_detect(string = name, pattern = 'Mega'))

# over numeric columns
pkmn %>% filter(hp < 30, attack < 100)
pkmn %>% filter(attack - sp_atk < 20)
pkmn %>% filter(abs(attack - sp_atk) < 20)

# both at the same time
pkmn %>% filter(abs(attack - sp_atk) < 20,                    # condition1
                !str_detect(string = name, pattern = 'Mega'), # condition2
                speed > 60)                                   # condition3

# conditions can be as complex as you want them to be,
# as long as the expression returns TRUE/FALSE values

#  _ arrange --------------------------------------------------------------
# order the rows based on the value of columns
# sintax: arrange(table, column1, column2, column3, ....)
# modifier: -

pkmn %>% arrange(name)
pkmn %>% arrange(desc(name))
pkmn %>% arrange(-hp, -attack)

# not advised but it is possible to use more complex expressions than just 
# the column names
pkmn %>% arrange(-sp_atk, speed > 90, str_detect(type_1, 'Water'))

# _ select ------------------------------------------------------------------
# keep or remove columns 
# sintax: select(table, column1, colum2, colum3)
# modifier: -

pkmn %>% select(name, type_1, generation)
pkmn %>% select(-number, -type_2, -total, -hp, -attack, -defense, -sp_atk, -sp_def, -speed, -legendary)

# you can also use sequences!
pkmn %>% select(2:4)
pkmn %>% select(2:4, attack)
pkmn %>% select(name:attack)

# it is also possible to rename 
pkmn %>% select(pokename = name,                 # column1
                how_fast = speed,                # column2
                my_favourite_variable = sp_def,  # column3
                like_this_one_too     = defense) # column4
# see apendix: select() helpers

# _ mutate ------------------------------------------------------------------
# create or modify columns
# sintax: mutate(table, column1 = function(*), column2 = function(*), ...)

pkmn %>% mutate(best_attack = max(attack, sp_atk)) # careful with max!
pkmn %>% mutate(best_attack = pmax(attack, sp_atk)) # pairwise max

# mutate can create and modify several columns at a time 
pkmn %>% mutate(best_attack = pmax(attack, sp_atk),
                best_defense = pmax(defense, sp_def)) %>% select(-number, -hp)

# you can even use columns you have just created
pkmn %>% mutate(offensive_pkmn = best_attack > best_defense,
                best_attack = pmax(attack, sp_atk),
                best_defense = pmax(defense, sp_def))

# (but order is important)
pkmn %>% mutate(best_attack = pmax(attack, sp_atk),
                best_defense = pmax(defense, sp_def),
                offensive_pkmn = best_attack > best_defense)

# we are seeing too many columns, let's use select
pkmn %>% mutate(best_attack = pmax(attack, sp_atk),
                best_defense = pmax(defense, sp_def),
                offensive_pkmn = best_attack > best_defense) %>% 
  select(name, best_attack, best_defense, offensive_pkmn)

# remember, you have to update the object or else you will lose your changes
ncol(pkmn)
pkmn %>% mutate(best_attack = pmax(attack, sp_atk),
                best_defense = pmax(defense, sp_def)) %>%  ncol()
ncol(pkmn)
pkmn <- pkmn %>% mutate(best_attack = pmax(attack, sp_atk),
                        best_defense = pmax(defense, sp_def))

pkmn <- pkmn %>% mutate(type_2 = ifelse(test = is.na(type_2),
                                        yes = 'None', 
                                        no = type_2))

# _ summarise ---------------------------------------------------------------
# create summary tables 
# sintax: summarise(table, column1 = function(*), column2 = function(*), ...)

# as you can see, summarise is used just like mutate()
pkmn %>% summarise(hp = mean(hp),
                   attack = mean(attack),
                   defense = mean(defense),
                   sp_atk = mean(sp_atk),
                   sp_def = mean(sp_def),
                   speed = mean(speed))

# alternatively, summarise_all()
pkmn %>% select(hp, attack, defense, sp_atk, sp_def, speed) %>% 
  summarise_all(mean)

# _ group_by ----------------------------------------------------
# group rows by the value of a column

# why do people love using dplyr?
# becasue with all we have seen so far, we can do all the data 
# cleaning and preparation, and with group_by + summarise we can
# make complex computations for our table with just a few lines
# of code.

# average by type:
pkmn %>%
  group_by(type_1) %>%
  summarise(hp = mean(hp),
            attack = mean(attack),
            defense = mean(defense),
            sp_atk = mean(sp_atk),
            sp_def = mean(sp_def),
            speed = mean(speed)) %>% 
  mutate_if(is.numeric, round, digits = -1)

# it is possible to group by several columns at the same time
# here we can have the averages by both type_1 and type_2 

pkmn %>% 
  group_by(type_1, type_2) %>%
  summarise(hp = mean(hp),
            attack = mean(attack),
            defense = mean(defense),
            sp_atk = mean(sp_atk),
            sp_def = mean(sp_def),
            speed = mean(speed))

# so, instead of filtering each group and compute it on its own
pkmn %>%
  filter(legendary) %>% 
  group_by(type_1) %>%
  summarise(hp = mean(hp),
            attack = mean(attack),
            defense = mean(defense),
            sp_atk = mean(sp_atk),
            sp_def = mean(sp_def),
            speed = mean(speed))

# you can do it by grouping_by
averages_by_legendary <- pkmn %>%
  group_by(type_1, legendary) %>%
  summarise(hp = mean(hp),
            attack = mean(attack),
            defense = mean(defense),
            sp_atk = mean(sp_atk),
            sp_def = mean(sp_def),
            speed = mean(speed))

# and if you use it with mutate instead of summarise, you get a column with
# the same value for all members of the same group
pkmn %>% group_by(type_1, type_2) %>% 
  mutate(type_average = mean(total)) %>% 
  select(-hp, - attack, -defense, -starts_with('sp'))

# bring it all together ---------------------------------------------------

# business question: which generation has the best pokemons by type?

pkmn <- pkmn %>% group_by(type_1) %>% 
  mutate(type_average = mean(total),
         better_than_av = total > type_average)

pkmn %>% select(-hp, -attack, -defense, -starts_with('sp')) 
#see apendix for starts_with()

pkmn %>% 
  group_by(type_1, generation) %>% 
  summarise(better_than_av_gen = sum(better_than_av))

pkmn %>% group_by(type_1, generation) %>% 
  summarise(better_than_av_gen = sum(better_than_av)) %>% 
  arrange(-better_than_av_gen)

# the beauty of dplyr + pipes: it gives a concise narrative to
# what you are doing with the table
pkmn %>% group_by(type_1) %>%                             # for each type: 
  mutate(type_average = mean(total),                      # compute the average total stats
         better_than_av = total > type_average) %>%       # then, identify if each pokemon is above their type average
  group_by(type_1, generation) %>%                        # then, for each combination of type + generation:
  summarise(better_than_av_gen = sum(better_than_av)) %>% # count how many pokemons we have above average
  arrange(-better_than_av_gen)                            # and sort the result from larger to smaller

# and due to its modularity, changing one detail does not require 
# rewriting everything. For instance, it may be deemed unfair to 
# use counts since some groups are over represented, so changing
# counts to percentages darastically changes the meaning and the 
# results of what we are doing, but it only takes changing one line
pkmn %>% group_by(type_1, generation) %>%       
  # divide by n() to get percentages:
  summarise(better_than_av_gen = sum(better_than_av)/n()) %>%  
  arrange(-better_than_av_gen)

# and based on that info, we can look for the elements of the best set
pkmn %>%
  # get only the pokemon from gen 4 type Dark:
  filter(generation == 4, type_1 == 'Dark') %>%   
  select(name, total, better_than_av)

# save the table
better_av_perc <- pkmn %>% group_by(type_1, generation) %>%                                     
  summarise(better_than_av_gen = sum(better_than_av)/n()) %>% 
  arrange(-better_than_av_gen)

# another big benefit of using dplyr is that dplyr functions 
# both recieve and return a table, so you can keep applying 
# dplyr functions to your newly created tables. Let's summarise
# our summary table: 
better_av_perc %>% 
  group_by(generation) %>% 
  summarise(better_than_av = sum(better_than_av_gen)) %>% 
  arrange(-better_than_av)

# back to plotting --------------------------------------------------------

library(ggplot2)

# see the best generations for each type
better_av_perc %>% 
  ggplot(aes(x = generation,
             y = better_than_av_gen, 
             color = type_1)) + geom_point()

# see the evolution of each type
better_av_perc %>% 
  ggplot(aes(x = generation,
             y = better_than_av_gen, 
             color = type_1)) + 
  geom_point() + 
  geom_line()

# split into several plots
better_av_perc %>% 
  ggplot(aes(x = generation,
             y = better_than_av_gen, 
             color = type_1)) + 
  geom_point() +
  geom_line() + 
  facet_wrap(~type_1, scales = 'free_y') + 
  theme_minimal() + 
  theme(legend.position = 'None')



# 6. APPENDIX: ----

# a. package::function() notation ----------------------------------------------

# the notation 'package::function' allows two very (circumstancially) useful 
# things:

# 1. make function calls without the need to load the package
package_that_isnt_installed::function_not_installed() # of course gives an error
lubridate::today() # works even when we have not loaded the lubridate package
# reminder: you can see all installed packages in the 'Packages' panel on the
# bottom right 

# 2. differentiate between functions with the same name from different packages
plyr::summarise
dplyr::summarise
# when you print a function on the console: <environment: namespace:dplyr>

# b. Live without dplyr: basic data.frame interaction with base R -----------

# AS we saw previously, R data.frames (tables) are a bunch of vectors joined
# together. To get one of those vectors, you can use df$column
pkmn$type_2

# slicing works on bit dimensions of a table.
# data.frame[rows, columns]
pkmn[2:4, 1:10]

# and if left empty, R understands that you want all that dimension:
pkmn[1:10,] # first 10 rows, all columns.
pkmn[,1:10] # all rows, first 10 columns.
pkmn[,] # the entire data.frame

# all indices seen on the # _ slicing section work here:
pkmn[c(TRUE, FALSE),] # only odd rows (recycling also works here)
pkmn[pkmn$generation > 4 & pkmn$generation <= 2, ] # zero rows returned because no data can be bigger than 4 and lower or equal to 2
pkmn[pkmn$generation < 4 & pkmn$generation >= 2, ] # now it works

# slicing also works by column name
pkmn[430:435, 'generation']
pkmn[430:435, c('generation', 'name')]

# a tricky part of this is knowing what will give you a vector 
# and what will give you a dtaa.frame (dplyr always returns data.frames)

pkmn$name # vector
pkmn[2] # data.frame
pkmn[1, 'name'] # data.frame
pkmn[[2]] # vector again
pkmn[2][1:3] # doesn't work
pkmn[['name']] # vector
pkmn[[2]][1:3] # vector
pkmn$name[1:3] # same vector. 
# good practice:use names instead of indices whenever possible.

# you can also create new variables from there
pkmn$new_variable <- c('a', 'b', 'c') # it has to match the size of the other columns
pkmn$new_variable <- 1:800

# and to delete a variable, you can assign a NULL to it
pkmn$variable_nueva <- NULL

# _select() helper functions -------------------------------------

# select helpers
# descriptions come from here: https://tidyselect.r-lib.org/reference/select_helpers.html

# starts_with(): columns that start with a prefix.
pkmn %>% select(starts_with('type'))

# ends_with(): columns that ends with a suffix
pkmn %>% select(ends_with('k'))

# contains(): explicit character matching
pkmn %>% select(contains('gen'))

# matches(): regex matching
pkmn %>% select(matches('^gen'))

# num_range(): columns compunded by a prefix and a number
pkmn %>% select(num_range('type_', 1))

# all_of(): matches column names against a vector.
# If there is at least one column missing, it fails
pkmn %>% select(all_of(c('name', 'type_1', 'column_that_does_not_exist')))
pkmn %>% select(all_of(c('name', 'type_1')))

# any_of(): matches column names against a vector.
# Does not fail if some of the columns are missing
pkmn %>% select(any_of(c('name', 'type_1', 'columna_que_no_existe'))) # en general, mala idea

# everything(): all variables
pkmn %>% select(everything())

# last_col(): last column, with an index to jump counting backwards 
pkmn %>% select(last_col())
pkmn %>% select(last_col(2))
pkmn %>% select(last_col(2:3))
pkmn %>% select(last_col(-2)) # does not make sense