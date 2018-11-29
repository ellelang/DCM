rm(list = ls())
setwd("C:/Users/langzx/Desktop/github/DCM/data")
library(mlogit)
library(gmnl)
library(tidyverse)
library(fastDummies)

dataset <- read.csv (file = "wholeCEscio_dataset_envinfo_1119.csv",header = TRUE)
dim(dataset)
datasetcategories <- read.csv (file = "categoricaldata.csv",header = TRUE)
colnames(datasetcategories)
dataset$alti <- ifelse(dataset$Alternatives == "V",1,2)

dataset$task <- dataset$ChoiceSet
dataset$ChoiceSet <- 2

names(dataset)

# note: should make dummies for farm size categories, farm income and others

export_test_nlogit0 <- select(dataset, c("id","Y","ChoiceSet","alti", "task",
                                        "Wetland","Payment","Covercrop","NuMgt", 
                                        "incomefromfarming", "landarea", "dem_president_2016", "dem_2018",
                                        "unemploymentrate", "Yearly.Cost", "Hourly.Wage", "av_monthly_Taxes",
                                          "cashrental_peracre", "landvalue_peracre",
                                        "Stream_miles", "Lake_acres", "Wetland_acres",
                                        "total_impaired", "water_impaired"))

export_test_nlogit <- export_test_nlogit0 %>% left_join(datasetcategories, by = "id")

dim(export_test_nlogit)

write.csv(export_test_nlogit,file = "export_test_nlogit.csv", row.names = FALSE)
