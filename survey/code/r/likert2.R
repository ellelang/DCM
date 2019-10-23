rm(list = ls())
setwd("C:/Users/langzx/Desktop/github/DCM/survey/data")
library(survey)
library(tidyverse)
library(ggplot2)
library(likert)
library(RColorBrewer)
data <- read.csv ("data_number.csv", head = TRUE, na.strings=c("","NA"))
helper <- read.csv ("data_helper.csv", head = TRUE)
data_label <- read.csv ("data_label.csv", head = TRUE, na.strings=c("","NA"))
ncol(data)
helper$QuestionID

data <- data_label %>% 
       mutate_if (is.character, as.factor)
summary(data)
## Questions related to moderate
moderate <- data %>% 
  select(contains("moderate")) %>% 
  drop_na()  
summary(moderate)


numlevels <- 5
pal<-brewer.pal(numlevels,"RdBu")
pal
pal <- c("#CA0020", "#F4A582", "#DFDFDF", "#92C5DE", "#0571B0")

  
options(digits=2)
str(moderate)
result_moderate <- likert(moderate)
summary(result_moderate)
plot(result_moderate,
     centered=FALSE, wrap=30,
      colors = pal, include.center=FALSE ) +
  ggtitle("cars") + 
  theme(plot.title = element_text(size = 40, face = "bold"))

ggplot(moderate) +
  geom_bar(aes(x =  fct_rev(fct_infreq(income)))) + 
  # flip the coordinates
  coord_flip() 
