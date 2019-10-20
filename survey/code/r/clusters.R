
rm(list = ls())
setwd("C:/Users/langzx/Desktop/github/DCM/survey/data")
library(survey)
library(tidyverse)
library(ggplot2)
data <- read.csv ("data_number.csv", head = TRUE)
helper <- read.csv ("data_helper.csv", head = TRUE)
ncol(data)
DEMdata <- data[c(1:11,128:136)] 
DEMdata <- DEMdata %>% 
  mutate_all(na_if,"") %>% 
  mutate_if (is.character, as.factor)
summary(DEMdata)

n_levels <- DEMdata %>%
  summarise_if (is.factor, nlevels) %>% 
  gather (variable, num_levels)
n_levels

DEMdata %>%
  # pull income
  pull(income) %>%
  # get the values of the levels
  levels()

ggplot(DEMdata) +
  geom_bar(aes(x =  fct_rev(fct_infreq(countyresident)))) + 
  # flip the coordinates
  coord_flip()


## income & choice
DEMdata %>%
  # remove NAs
  filter(!is.na(choice1.) & !is.na(income)) %>%
  group_by(choice1.) %>%
  count(income) %>%
  filter (income != "None") %>%
  ggplot(mapping = aes(x = income, y = n, fill = choice1. )) + 
  geom_col(position = "fill") +
  coord_flip()

Choicedata <- data[2:9]
Choicedata[is.na(Choicedata)] <- 0
C_choice = rowSums(Choicedata == "C")/8

DEMdata <- DEMdata %>% 
  mutate (Choice_all = C_choice)

DEMdata %>%
  # remove NAs
  filter(!is.na(income)) %>%
  # get mean_c by income
  group_by(income) %>%
  summarize(mean_c = mean(Choice_all)) %>%
  filter (income != "None") %>%
  ggplot(mapping = aes(x = fct_relevel(income, 
                                       "$1 -$24,999", "$25,000 - $99,999", "$100,000 - $249,999",
                                       "$250,000 - $499,999","$500,000 to $999,999", "$1,000,000 and over"), 
                       y = mean_c )) + 
  geom_col()+
  coord_flip() +
  labs(y = "Mean % of choosing Voluntary Program in CE",
       x = "Income")
  
 
