rm(list = ls())
library(mlogit)
library(gmnl)
library(tidyverse)
library(fastDummies)
setwd("C:/Users/langzx/Desktop/github/DCM/data")
dataset <- read.csv (file = "wholeCEscio_dataset_envinfo_1119.csv",header = TRUE)
county <- dataset$County_resident
unique(county)
countyname <- cat(paste(shQuote(unique(county), type="cmd"), collapse=", "))
county_u <- c ("Hennepin", "Watonwan", "Yellow Medicine", "Brown", "Blue Earth", "Cottonwood", "Todd", "Le Sueur", "Douglas", "Swift", "Redwood", "Otter Tail", "Grant", "Faribault", "Stevens", "Murray", "Waseca", "Lyon", "Sibley", "Freeborn", "Lincoln", "Kandiyohi", "Carver", "Lac Qui Parle", "Traverse", "Dakota", "Rice", "Renville", "McLeod", "Nicollet", "Chippewa", "Martin", "Goodhue", "Pope", "Jackson", "Meeker", "Pipestone", "Nobles", "Wabasha", "Steele", "Big Stone", "NA", "Washington", "Anoka", "Sherburne")
county_u

write.table (x = county_u, file = "county.dat", sep = "\t",quote=FALSE, row.names = FALSE)
dim(dataset)

dataset1 <- mlogit.data(dataset, varying = 5:152, shape = "long",
                        choice = "Y", alt.levels = c("V", "C"), id.var = "id")

#simple MNL to serve as a check
mnl.gmnl <- gmnl(Y ~  Payment + Wetland + Covercrop + NuMgt, data = dataset1, model = "mnl")
summary(mnl.gmnl)

wtp.gmnl(mnl.gmnl, wrt = "Payment")

############



#####
h.mnl.gmnl <- gmnl(Y ~  Payment + 
                     Wetland + 
                     Covercrop +  
                     NuMgt |dem_president_2016 + dem_2018 + av_monthly_Taxes,
                   data = dataset1 , model = "mnl")
summary(h.mnl.gmnl)



h.mxl.gmnl <- gmnl(Y ~ Wetland + Covercrop + NuMgt + Payment | 
                      dem_president_2016 + dem_2018  + av_monthly_Taxes |
                      0|
                      cashrental_peracre, 
                      data = dataset1, model = "mixl",
                      panel = TRUE, 
                      ranp = c(Wetland = "n", Covercrop = "n", NuMgt = "n", Payment = "n"),
                      mvar = list(Wetland = "cashrental_peracre",
                                  Covercrop = "cashrental_peracre",
                                  NuMgt = "cashrental_peracre",
                                  Payment = "cashrental_peracre"),
                      R = 100, halton = NA)
summary(h.mxl.gmnl)
