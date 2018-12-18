rm(list = ls())
library(mlogit)
library(gmnl)
library(tidyverse)
setwd("C:/Users/langzx/Desktop/github/DCM/data")
dataset <- read.csv (file = "wholeCEscio_dataset_envinfo_1119.csv",header = TRUE)
unique(dataset$County_land)
county2018crp <- read.csv (file = "CRP2018cashrental.csv",header = TRUE)

dataset$crp2018 <-county2018crp$CRP.Regular.Rental.Rate[match(dataset$County_land,county2018crp$County)]
unique(dataset$County_land[is.na(dataset$crp2018)])

write.csv (x = dataset, file= "wholeCEscio_dataset_envinfo_11192.csv", row.names = FALSE)

