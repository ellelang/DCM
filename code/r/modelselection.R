rm(list = ls())
setwd("C:/Users/langzx/Desktop/github/DCM/data")
library(mlogit)
library(gmnl)
library(plyr)
library(tidyverse)
library(bestglm)
library(MASS)

dataset <- read.csv (file = "wholeCEscio_dataset_envinfo_1119.csv",header = TRUE)
dim(dataset)


dataset$alti <- ifelse(dataset$Alternatives == "V",1,2)

dataset$task <- dataset$ChoiceSet
dataset$ChoiceSet <- 2

names(dataset)

dataset <- plyr::rename(dataset, c("cashrental_peracre" = "cashrent" , "dem_president_2016" = "demPrez16",
                                   "incomefromfarming" = "incfar" ,"unemploymentrate" = "unemploy",
                                   "Yearly.Cost" = "costlive", "Hourly.Wage" = "hrwage", "av_monthly_Child.Care" = "childcar",
                                   "av_monthly_Food" = "foodcost", "av_montly_Health.Care" = "healthc",
                                   "av_monthly_Housing" = "housecos", "av_monthly_Transport" = "transpor",
                                   "av_monthly_Other" = "othercos", "av_monthly_Taxes" = "taxcost",
                                   "landvalue_peracre" = "landvalu", "Stream_miles" = "impstrea",
                                   "Lake_acres" = "implakes", "Wetland_acres" = "impwetl", "Stream_records" = "streamr",
                                   "Lake_records" = "laker", "Wetland_records" = "wetldr","total_impaired" = "imptotal",
                                   "landarea" = "areaf"))

export_test_nlogit <- dplyr::select(dataset, c("id","Y","ChoiceSet","alti", "task",
                                               "Wetland","Payment","Covercrop","NuMgt", 
                                               "incfar", "areaf", "demPrez16", "dem_2018",
                                               "unemploy", "costlive", "hrwage", "taxcost",
                                               "cashrent", "landvalu",
                                               "impstrea", "implakes", "impwetl",
                                               "streamr", "laker", "wetldr",
                                               "imptotal", "childcar", "foodcost", "healthc",  "housecos",
                                               "othercos"))

export_test_nlogit <- fastDummies::dummy_cols(export_test_nlogit, select_columns = c("incfar","areaf"))

write.csv(export_test_nlogit,file = "wta_observables12032018.csv", row.names = FALSE)
#########################

dataset <- read.csv (file = "wta_observables12032018.csv",header = TRUE)
dim(dataset)
colnames(dataset)
databestglm <- filter(dataset, dataset$alti == 1)
dim(databestglm)
databestglm <- rename(databestglm , y = Y )
databestglm <- dplyr::select(databestglm,-id,-ChoiceSet,-alti,-task)
databestglm <- drop_na(databestglm)

glm_data <- as.data.frame(databestglm)

#bestglm(glm_data, IC = "BIC")
#BIC agrees with backward stepwise approach?
full_model<-glm(y ~ ., data = glm_data)
summary(full_model)
intercept_model <- glm(y ~ 1, data = glm_data)
#step(out, direction = "both", k=log(nrow(glm_data)))
stepAIC(full_model, direction = "backward")
stepAIC(intercept_model, direction = "forward",scope = list(upper = full_model,lower = intercept_model))
stepAIC(intercept_model, direction = "both",scope = list(upper = full_model,lower = intercept_model))




dataset <- read.csv (file = "wta_observables11192018.csv",header = TRUE)
