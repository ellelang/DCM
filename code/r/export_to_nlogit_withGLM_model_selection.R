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

dataset <- plyr::rename(dataset, c("cashrental_peracre" = "cashrent" , "dem_president_2016" = "demPrez16",
                                   "incomefromfarming" = "incfar" ,"unemploymentrate" = "unemploy",
                                   "Yearly.Cost" = "costlive", "Hourly.Wage" = "hrwage", "av_monthly_Child.Care" = "childcar",
                                   "av_monthly_Food" = "foodcost", "av_montly_Health.Care" = "healthc",
                                   "av_monthly_Housing" = "housecos", "av_monthly_Transport" = "transpor",
                                   "av_monthly_Other" = "othercos", "av_monthly_Taxes" = "taxcost",
                                   "landvalue_peracre" = "landvalu", "Stream_miles" = "impstrea",
                                   "Lake_acres" = "implakes", "Wetland_acres" = "impwetl", "total_impaired" = "imptotal",
                                   "landarea" = "areaf"))

# note: should make dummies for farm size categories, farm income and others



# to be incorporated and imported into Nlogit

export_test_nlogit <- dplyr::select(dataset, c("id","Y","ChoiceSet","alti", "task",
                                        "Wetland","Payment","Covercrop","NuMgt", 
                                        "incfar", "areaf", "demPrez16", "dem_2018",
                                        "unemploy", "costlive", "hrwage", "taxcost",
                                          "cashrent", "landvalu",
                                        "impstrea", "implakes", "impwetl",
                                        "imptotal", "childcar", "foodcost", "healthc",  "housecos",
                                        "othercos"))

export_test_nlogit <- fastDummies::dummy_cols(export_test_nlogit, select_columns = c("incfar","areaf"))

write.csv(export_test_nlogit,file = "wta_observables11192018.csv", row.names = FALSE)



library(bestglm)

databestglm <- filter(export_test_nlogit, export_test_nlogit$alti == 1)

#databestglm$CClakeInter <- databestglm$Covercrop * databestglm$Lake_acres


databestglm <- rename(databestglm , y = Y)
databestglm <- dplyr::select(databestglm,-ChoiceSet,-id,-alti,-task)
databestglm <- drop_na(databestglm)

glm_data <- as.data.frame(databestglm)

bestglm(glm_data, IC = "BIC")
#BIC agrees with backward stepwise approach?
full_model<-glm(y ~ ., data = glm_data)
intercept_model <- glm(y ~ 1, data = glm_data)
#step(out, direction = "both", k=log(nrow(glm_data)))
stepAIC(full_model, direction = "backward")
stepAIC(intercept_model, direction = "forward",scope = list(upper = full_model,lower = intercept_model))
stepAIC(intercept_model, direction = "both",scope = list(upper = full_model,lower = intercept_model))


sel_glm1 <- glm(y ~ dem_2018 + Payment + Wetland + landarea, data = glm_data)
summary(sel_glm1)
