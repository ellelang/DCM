rm(list = ls())
setwd("C:/Users/langzx/Desktop/github/DCM/data")
library(mlogit)
library(gmnl)
library(plyr)
library(tidyverse)
library(bestglm)

dataset <- read.csv (file = "wholeCEscio_dataset_envinfo_1119.csv",header = TRUE)
dim(dataset)
dataset$Alternatives
colnames(dataset)
databestglm <- filter(dataset, dataset$Alternatives == "V")
dim(databestglm)
databestglm <- rename(databestglm , y = Y )
databestglm <- dplyr::select(databestglm,-ChoiceSet,-id,-Alternatives)
databestglm <- drop_na(databestglm)

glm_data <- as.data.frame(databestglm)

bestglm(glm_data, IC = "BIC")
#BIC agrees with backward stepwise approach?
full_model<-glm(y ~ ., data = glm_data)
summary(full_model)
intercept_model <- glm(y ~ 1, data = glm_data)
#step(out, direction = "both", k=log(nrow(glm_data)))
stepAIC(full_model, direction = "backward")
stepAIC(intercept_model, direction = "forward",scope = list(upper = full_model,lower = intercept_model))
stepAIC(intercept_model, direction = "both",scope = list(upper = full_model,lower = intercept_model))




dataset <- read.csv (file = "wta_observables11192018.csv",header = TRUE)
