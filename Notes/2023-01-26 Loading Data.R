##### Lecture 8: Loading in Data
##### 26 January 2023
##### LVA

### Create and save a dataset
### write.table(x = varName, file = "outputFileName.csv", header = TRUE, sep = ",")

#### These functions read in a data set
### read.table()
### read.table(file = "path/to/data.csv", header = TRUE, sep = ",")

### read.csv(file = "data.csv", header = T)

#### Use RDS object when working in R
## helpful with large datasets
## saveRDS(my_data, file = "FileName.RDS")
## readRDS("FileName.RDS")
## p <- readRDS("FileName.RDS")

### Long vs. Wide data formats
### wide format = contain values that do not repeat in the ID column
### long format = contains values that DO repeat in the ID column

library(tidyverse)
b1 <- glimpse(billboard) # a wide data set
billboard %>%
  pivot_longer(
    cols = starts_with("wk"), # specify which columns you want to make "longer"
    names_to = "Week", # name of new column which will contain the header names
    values_to = "Rank", # name of new column which will contain the values
    values_drop_na = TRUE # removes any rows where the value = NA
  )
View(b1) ## rmarkdown does NOT like this - remove if knitting

### pivot_wider
### best for making occupancy matrix
glimpse(fish_encounters)
View(fish_encounters)

fish_encounters %>%
  pivot_wider(names_from = station, # which column you want to turn into multiple columns
              values_from = seen) # which column contains the values for the new column cells

fish_encounters %>%
  pivot_wider(names_from = station, # which column you want to turn into multiple columns
              values_from = seen,
              values_fill = 0) # fills NAs with 0s

##### Dryad: makes research data freely resuable, citable, and discoverable

dryadData <- read.table(file = "Data/veysey-babbitt_data_amphibians.csv", header = TRUE, sep = ",")
glimpse(dryadData)
head(dryadData)

table(dryadData$species) ### allows you to see different groups of character column
summary(dryadData$mean.hydro)

str(dryadData$species)
dryadData$species<-factor(dryadData$species, labels=c("Spotted Salamander", "Wood Frog")) #creating 'labels' to use for the plot # It changes to data type into a factor with 2 levels: "Spotted Salamander" and "Wood Frog"
str(dryadData$species)

#class(dryadData$treatment) # Shows data type of the "treatment" column
dryadData$treatment <- factor(dryadData$treatment, 
                              levels=c("Reference",
                                       "100m", "30m"))













