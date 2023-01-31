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

dryadData %>%
  group_by(factor(wetland)) %>%
  summarize(avgHydro = mean(count.total.adults, na.rm = TRUE), N = n())

### Boxplot
dryadData$wetland <- factor(dryadData$wetland)
class(dryadData$wetland)
ANOplot2 <- ggplot(dryadData, aes(x = wetland, y = count.total.adults, fill = species)) +
  geom_boxplot() +
  scale_fill_grey()
ANOplot2
##ggsave(file = "SpeciesBoxplots.pdf", plot = ANOplot2, device = "pdf")

### Logistic regression
## Data frame
# gamma probilities - continuous variables that are always positive and have a skewed distribution
xVar <- sort(rgamma(n = 200, shape = 5, scale = 5))
yVar <- sample(rep(c(1,0), each = 100), prob = seq_len(200))
logRegData <- data.frame(xVar, yVar)

### Logistic regression Analysis
logRegModel <- glm(yVar ~ xVar,
                   data = logRegData,
                   family = binomial (link = logit))
summary(logRegModel)

logRegPlot <- ggplot(data = logRegData,
                     aes(x = xVar, y = yVar)) +
  geom_point() +
  stat_smooth(method = "glm", method.args = list(family = binomial))
logRegPlot

### Contingency table (chi=squared) Analysis
### Are there differences in counts of males and females between species
countData <- dryadData %>%
  group_by(species) %>%
  summarize(Males = sum(No.males, na.rm = T), Females = sum(No.females, na.rm = T)) %>%
  select(-species) %>%
  as.matrix()
countData

row.names(countData) = c("SS", "WF")

## chi-squared
testResults <- chisq.test(countData)
testResults$residuals #tells you value compared to expected 


#### mosaic plot (base R)
mosaicplot(x=countData,
           col=c("goldenrod", "grey"),
           shade = FALSE)

### bar plot 

countDataLong <- countData %>%
  as_tibble() %>%
  mutate(Species = c(rownames(countData))) %>% ##makes species a column instead of row titles
  pivot_longer(cols = Males:Females, names_to = "Sex", values_to = "Count")

### plot bar graph
ggplot(countDataLong, aes(x=Species, y=Count, fill=Sex)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_fill_manual(values = c("darkslategrey", "midnightblue"))

####################################################################
#### Control Structures

# if and ifelse statements

###### if statement
#### if (condition) {expression 1} else {expression 2}

#### if (condition1) {expression 1} else
#### if (condition2) {expression 2} else {expression 3}
### if any final unspecified else captures the rest of (unspecified) conditions
# else must appear on the same line as the expression
# use it for single values
z <-  signif(runif(1), digits = 2)
#z > 0.1

### use {} or not
if (z > 0.8) {cat(z, "is a large number", "\n")} else
  if (z < 0.2) {cat(z, "is a small number", "\n")} else
  {cat(z, "is a number of typical size", "\n")
    cat("z^2", z^2, "\n")}

#### ifelse to fill vecotrss
### ifelse(condition, yes, no)
#### insect population where females lay 10.2 eggs on average, follows Poisson distribution (discrete probability distribution showing the likely number of time an event will occur). 35% parasitism where no eggs are laid. Let's make a distribution for 1000 individuals
tester <- runif(1000)
eggs <- ifelse(tester > 0.35, rpois(n = 1000, lambda = 10.2), 0)
hist(eggs)

#### vecotr of p-values from a simulation and we want to create a vector to highlight the significant ones for plotting
pVals <- runif(1000)
z <-  ifelse(pVals <= 0.025, "lowerTail", "nonSig")
z
z[pVals >= 0.975] <- "upperTail"
table(z)

###### for loops
#### workhorse function for doing repetitive tasks
### universal in all computer languages
### Controversial in R
#### - often unnecessary (vectoriation in R)
#### - ery slow with certain operation
#### - family of applied functions

#### Anatomy of for loop
### for(variable in sequence){ #starts loop
#body of the for loop
#}
# var is a counter variable that holds the current value of the loop
# sequence is an integer vector that defines start/end of loop

for(i in 1:5){
  cat("stuck in a loop", i, "\n")
  cat(3+2, "\n")
  cat(3 + i, "\n")
}
print(i)

my_dogs <- c("chow", "akita", "malamute", "husky", "samoyed")
for(i in 1:length(my_dogs)){
    cat("i=", i, "my_dogs[i]", my_dogs[i], "\n")
}

#### use double for loops

## loop over rows
m <- matrix(round(runif(20), digits = 2), nrow = 5)

for(i in 1: nrow(m)) {
  m[i,] <- m[i,] = i
}

## loop over columns
m <- matrix(round(runif(20), digits = 2), nrow = 5)

for(j in 1:ncol(m)){
  m[,j] <- m[,j] + j
            }
m

##loop over rows and columns
for(i in 1:nrow(m)){
  for(j in 1:ncol(m)){
    m[i,j] <- m[i,j]  + i + j
  }
}
print(m)


