rm(list = ls())
library(mlogit)
library(tidyverse)
setwd("C:/Users/langzx/Desktop/github/DCM/data")


dataset <- read.csv(file = "wholeCEscio_dataset_envinfo_1119.csv", header = TRUE)
idinfo <- read.csv(file = "idinfo.csv",header = TRUE)
colnames(dataset)
dim(dataset)
dataset$alti <- ifelse(dataset$Alternatives == "V",1,2)
dataset$task <- dataset$ChoiceSet
dataset$ChoiceSet <- 2



dataset$num_rotation <- as.numeric(dataset$primaryrotation)
#dataset$num_rotation <- replace_na(dataset$num_rotation, -999) not necessary
dataset$convCS <- ifelse(dataset$num_rotation == 1 | dataset$num_rotation == 2, 1, 0)
dataset$corn <- ifelse(dataset$num_rotation == 1 | dataset$num_rotation == 2 
                       | dataset$num_rotation == 4 | dataset$num_rotation == 5
                       | dataset$num_rotation == 9, 1, 0)

dataset <- plyr::rename(dataset, c("cashrental_peracre" = "cashrent" ,"crp2018" = "crp2018", "dem_president_2016" = "demPrez16",
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

dataset_variables <- dplyr::select(dataset, c("id","Y","ChoiceSet","alti", "task",
                                               "Wetland","Payment","Covercrop","NuMgt", 
                                               "income", "areaf", "demPrez16", "dem_2018",
                                               "unemploy", "costlive", "hrwage", "taxcost",
                                               "cashrent","crp2018", "landvalu",
                                               "impstrea", "implakes", "impwetl",
                                               "imptotal", "childcar", "foodcost", "healthc",  "housecos",
                                              "othercos", "convCS", "corn"))

dim(dataset_variables)
head(dataset_variables)
441*8



datasetwide1 <- reshape(dataset_variables[,1:9], idvar = c("id","task"), timevar = "alti", direction = "wide")
dim(datasetwide1)
head(datasetwide1,16)

datasetwide1$Choice <- ifelse(datasetwide1$Y.1 == 1, 1, 2)
datasetwide1$Choice
head(datasetwide1)
datasetwide <- datasetwide1


idinfo$num_rotation <- as.numeric(idinfo$primaryrotation)
idinfo$convCS <- ifelse(idinfo$num_rotation == 1 | idinfo$num_rotation == 2, 1, 0)
idinfo$corn <- ifelse(idinfo$num_rotation == 1 | idinfo$num_rotation == 2 
                      | idinfo$num_rotation == 4 | idinfo$num_rotation == 5
                      | idinfo$num_rotation == 9, 1, 0)


datasetidinfo <- plyr::rename(idinfo, c("cashrental_peracre" = "cashrent" ,"crp2018" = "crp2018", "dem_president_2016" = "demPrez16",
                                        "incomefromfarming" = "incfar" ,"unemploymentrate" = "unemploy",
                                        "Yearly.Cost" = "costlive", "Hourly.Wage" = "hrwage", "av_monthly_Child.Care" = "childcar",
                                        "av_monthly_Food" = "foodcost", "av_montly_Health.Care" = "healthc",
                                        "av_monthly_Housing" = "housecos", "av_monthly_Transport" = "transpor",
                                        "av_monthly_Other" = "othercos", "av_monthly_Taxes" = "taxcost",
                                        "landvalue_peracre" = "landvalu", "Stream_miles" = "impstrea",
                                        "Lake_acres" = "implakes", "Wetland_acres" = "impwetl", "total_impaired" = "imptotal",
                                        "landarea" = "areaf"))

idinfo_variables <- dplyr::select(datasetidinfo, c("ID", 
                                              "income", "areaf", "demPrez16", "dem_2018",
                                              "unemploy", "costlive", "hrwage", "taxcost",
                                              "cashrent","crp2018", "landvalu",
                                              "impstrea", "implakes", "impwetl",
                                              "imptotal", "childcar", "foodcost", "healthc",  "housecos",
                                              "othercos", "convCS", "corn"))


dim(idinfo_variables)
datasetwide <- left_join(datasetwide1, idinfo_variables, by = c("id" = "ID"))


dim(datasetwide)
write.csv(x = datasetwide, file = "obswta_datasetwide.csv", row.names = FALSE)

write.table (x = datasetwide, file = "widedata.dat", sep = "\t",quote=FALSE, row.names = FALSE)
