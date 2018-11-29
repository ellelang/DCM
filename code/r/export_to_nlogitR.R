rm(list = ls())
setwd("//udrive.uw.edu/udrive/MRB surveys/Results")
library(mlogit)
library(gmnl)
library(tidyverse)
library(fastDummies)

dataset <- read.csv (file = "wholeCEscio_dataset_envinfo_1119.csv",header = TRUE)
dim(dataset)


dataset$alti <- ifelse(dataset$Alternatives == "V",1,2)

dataset$task <- dataset$ChoiceSet
dataset$ChoiceSet <- 2

names(dataset)

# note: should make dummies for farm size categories, farm income and others

export_test_nlogit <- select(dataset, c("id","Y","ChoiceSet","alti", "task",
                                        "Wetland","Payment","Covercrop","NuMgt", 
                                        "incomefromfarming", "landarea", "dem_president_2016", "dem_2018",
                                        "unemploymentrate", "Yearly.Cost", "Hourly.Wage", "av_monthly_Taxes",
                                          "cashrental_peracre", "landvalue_peracre",
                                        "Stream_miles", "Lake_acres", "Wetland_acres",
                                        "total_impaired", "water_impaired"))

write.csv(export_test_nlogit,file = "export_test_nlogit.csv", row.names = FALSE)
