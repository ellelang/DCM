setwd("C:/Users/langzx/Desktop/github/DCM/data")
da000<- read.csv (file = "wta_observables11192018.csv",header = TRUE)
income2 <- select(da000, id, income_2)

da0<- read.csv (file = "wta_observables11192018COMB426.csv",header = TRUE)
library(psych)
library(FactoMineR)
library(dplyr) 
library(tidyverse)
library(fastDummies)
library(corrplot)
library(polycor)
library(lavaan)
library(semPlot)

names(da0)
dim(da0)
dataset <- read.csv (file = "wta_observables11192018.csv",header = TRUE)
cluster_data <- read.csv("fscore_04112020_cluster.csv")
names(cluster_data)
dat <-left_join(dataset, cluster_data)
dim(dat)
names(dat)
write.csv(x= dat, file = "wta_observables04152020.csv", row.names = FALSE)


dat88 <- select(dataset, id,income_2,income_3)
dat888888<- left_join(dat,dat88)


dim(dat888888)
names(dat)
write.csv(x= dat, file = "wta_observables04152020.csv", row.names = FALSE)


names(dat)
