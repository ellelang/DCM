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

dataset <- fastDummies::dummy_cols(dataset, select_columns = c("incomefromfarming","landarea"))

# to be incorporated and imported into Nlogit

export_test_nlogit <- select(dataset, c("id","Y","ChoiceSet","alti", "task",
                                        "Wetland","Payment","Covercrop","NuMgt", 
                                        "incomefromfarming", "landarea", "dem_president_2016", "dem_2018",
                                        "unemploymentrate", "Yearly.Cost", "Hourly.Wage", "av_monthly_Taxes",
                                          "cashrental_peracre", "landvalue_peracre",
                                        "Stream_miles", "Lake_acres", "Wetland_acres",
                                        "total_impaired", "water_impaired"))
export_test_nlogit <- export_test_nlogit %>% left_join(datasetcategories, by = "id")


#write.csv(export_test_nlogit,file = "export_test_nlogit.csv", row.names = FALSE)

library(bestglm)

databestglm <- filter(export_test_nlogit, export_test_nlogit$alti == 1)

databestglm$CClakeInter <- databestglm$Covercrop * databestglm$Lake_acres


databestglm <- rename(databestglm , y = Y)
databestglm <- select(databestglm,-ChoiceSet,-id,-alti,-task)
databestglm <- drop_na(databestglm)

glm_data <- as.data.frame(databestglm)

bestglm(glm_data, IC = "BIC")
#BIC agrees with backward stepwise approach
full_model<-glm(y ~ ., data = glm_data, family = binomial)
intercept_model <- glm(y ~ 1, data = glm_data)
step(out, direction = "both", k=log(nrow(glm_data)))
stepAIC(full_model, direction = "backward")
stepAIC(intercept_model, direction = "forward",scope = list(upper = full_model,lower = intercept_model))
stepAIC(intercept_model, direction = "both",scope = list(upper = full_model,lower = intercept_model))


sel_glm1 <- glm(y ~ dem_2018 + Payment + Wetland + landarea, data = glm_data)
summary(sel_glm1)
