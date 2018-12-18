rm(list = ls())
library(mlogit)
library(gmnl)
library(tidyverse)
library(fastDummies)
setwd("C:/Users/langzx/Desktop/github/DCM/data")
dataset <- read.csv (file = "wta_observables11192018.csv",header = TRUE)
dim(dataset)
n <- dim(dataset)[1]
colnames(dataset)
betas <- read.table("beta.dat", sep = "\t", header = TRUE)
varcov <- read.table("varcov.dat", sep = "\t", header = FALSE)
betas

b_wetland <- -1.7157
rd <- rexp(10000000,rate = 1/-1.7157)
mean(rd)
########Construct X matrix
var_names <- betas$Names
var_names

k <- length(var_names)
wetland <- - 1*dataset0$Wetland
pay <- dataset$Payment
cc <- dataset$Covercrop
nm <-dataset$NuMgt
asc <- rep(1,n)
dems18 <- dataset$dem_2018
costtax <- dataset$taxcost
##dummyvariables
inc1 <- dataset$income_1
inc2 <- dataset$income_2
inc3 <- dataset$income_3
inc4 <- dataset$income_4
inc5 <- dataset$income_5
inc6 <- dataset$income_6
inc7 <- dataset$income_7
farm1 <- dataset$areaf_1
farm2 <- dataset$areaf_2
farm3 <- dataset$areaf_3
farm4 <- dataset$areaf_4
##interactions
lakescale <- dataset$implakes/1000
payinc <- pay * inc7
cclake <- cc * lakescale
#########
cat(paste(var_names, collapse=", "))
Xmatrix <- as.matrix(cbind (wetland, pay, cc, nm, asc, dems18, 
                  costtax, inc1, inc2, inc3, inc4, inc5, 
                  inc6, farm1, farm2, farm3, farm4, payinc, cclake),
                  ncol = k, nrow = n)
Xmatrix

X_subset <- Xmatrix[1:100,]

##############################KR estimates





dataset <- select(dataset0, -c("id","ChoiceSet","alti","task","income_NA","areaf_NA"))