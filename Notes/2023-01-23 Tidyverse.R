

### tidyverse: collection of packages that share philosophy, grammar (or how the code is structured), and data structures

## Operators: symbols that tells R to perform different operations (between variables, functions, etc.)

## Arithmetic operators: + - * / ^ ~
## Assignment operator: <- 
## Logical operators ! & |
## Relational operators: ==, !=, >, <, >=, <=
## Miscellaneous operators: %>% (forward pipe operator) %in%

### only need to install packages once
library(tidyverse) # library gunction to load in packages

#dplyr: new(er) packages provide a set of tools for manipulating data sets

#### The core verbs
## filter()
## arrange()
## select()
## group_by() and summarize()
## mutate()

## built in data sets
data(starwars)
class(starwars)

## Tibble: modern take on data frames

# great aspects of dfs and drops frustrating ones (change variables)

glimpse(starwars)

anyNA(starwars) #is.na #complete.cases

starwarsClean <- starwars[complete.cases(starwars[,1:10]),]

### filter(): picks/subsets

filter(starwarsClean, gender == "masculine" & height < 180 & height > 100) # multiple conditions for the same variable

filter(starwarsClean, gender == "masculine" | gender == "feminine")

#### %in% operator (matching);
#similar == but you can compare vectors of different length
#sequence of letters
a <-  LETTERS[1:10]
length(a) #length of vector

b <-  LETTERS[4:10]
length(b)

## output of %in% depends on first vector
a %in% b
b %in% a

# use %in% to subset
eyes <- filter(starwars, eye_color %in% c("blue", "brown"))
view(eyes)
## arrange() reorders rows

arrange(starwarsClean, by = height) #default is ascending order

arrange(starwarsClean, by = desc(height))

arrange(starwarsClean, height, desc(mass)) # second variable used to break ties

sw <- arrange(starwarsClean, by = height)
tail(sw) # missing values are at the end

#### select(): chooses variables (COLUMNS) by their names

select(starwarsClean, 1:10)
select(starwarsClean, name:species)
select(starwarsClean, -(films:starships))
starwarsClean[,1:11]

### Rearrange columns
select(starwarsClean, name, gender, species, everything()) # everything() helper function; useful if you have a couple variables you want to move to the beginning

#contains() helper funciton
select(starwarsClean, contains ("color")) # others include ends_with(), starts_with(), num_range()

# select can also rename columsn
select(starwarsClean, haircolor = hair_color) # returns only renamed column #can use everything() too
rename(starwarsClean, haircolor = hair_color) # returns whole df

### mutate(): creates new variables using functions of existing variables

# let's create a new column that is height divided by mass
mutate(starwarsClean, ratio = height/mass)

starwars_lbs <- mutate(starwarsClean, mass_lbs = mass*2.2, .after = mass) # after/before # have to use . before argument so it recognizes it as an argument
view(starwars_lbs)

starwars_lbs <- select(starwars_lbs, 1:3, mass_lbs, everything()) # brought it to the front

# transmute
transmute(starwarsClean, mass_lbs = mass*2.2) # only returns mutated columns
transmute(starwarsClean, mass, mass_lbs = mass*2.2, height)

### group_by() and summarize()
summarize(starwarsClean, meanHeight = mean(height))

summarize(starwarsClean, meanHeight = mean(height)) #throws NA if NAs are in df -need to use na.rm

summarize(starwarsClean, meanHeight = mean(height), totalNumber = n()) # returns av height and total # of operations

# use group_by for maximum usefulness
starwarsGenders <-  group_by(starwars, gender)
head(starwarsGenders)
summarize(starwarsGenders, meanHeight = mean(height, na.rm = TRUE), totalNumber = n())

# Piping %>%
# use to emphasize a sequence of actions
# allows you to pass on intermediate results onto the next function (uses output of one function as input  of the next function)
# avoid if you need to manipulate more than one object/variable at a time; or if variable is meaningful

#formatting: should have a space before the %>% followed by new line

starwarsClean %>%
  group_by(gender) %>%
  summarize(meanHeight = mean(height), TotalNumber = n()) # na.rm = T skips NAs # much cleaner with piping!

#### more complex coding:
## case_when() is useful for multiple if/ifelse statements
starwarsClean %>%
  mutate(sp = case_when(species == "Human" ~ "Human", TRUE ~ "Non-Human")) # uses condition, puts "Human" if True in sp column, "Non-Human" if it's FALSE


