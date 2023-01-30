##### Analysis and Control
##### 30 January 2023
##### LVA

dryadData <- read.table(file = "Data/veysey-babbitt_data_amphibians.csv", header = TRUE, sep = ",")

## Set up libraries
library(tidyverse)
library(ggthemes)

### Analyses
### Experimental designs
### independent/explanatory variable (x-axis) vs dependent/response variable (y axis)
### continuous (range of numbers: height, weight, temperature) vs discrete/categorical variables (categories: species, treatment, site)

### basic linear regression anylsis (2 continuous variables)
## Is there a relationship between the mean pool hydroperiod and the number of breeding frogs
## y ~ x
regModel <- lm(count.total.adults ~ mean.hydro, data = dryadData)
print(regModel)
summary(regModel)
hist(regModel$residuals)
summary(regModel)$"r.squared"
summary(regModel)[["r.squared"]]

#View(summmary(regModel))

regPlot <- ggplot(dryadData, aes(x = mean.hydro, y = count.total.adults + 1)) +
  geom_point(size = 2) +
  stat_smooth(method = "lm", se = 0.99)

regPlot + theme_few()

### Basic ANOVA
### Was there a statistically significant difference in the number of adults among wetlands?
#y~x
ANOmodel <- aov(count.total.adults ~ factor(wetland), data = dryadData)
summary(ANOmodel)
