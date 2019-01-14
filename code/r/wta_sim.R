rm(list = ls())
library(mlogit)
library(gmnl)
library(tidyverse)
library(fastDummies)
setwd("C:/Users/langzx/Desktop/github/DCM/data")
dataset <- read.csv (file = "wta_observables11192018.csv",header = TRUE)
dim(dataset)
n <- dim(dataset)[1]
dataset$asc <- rep(1,n )

colnames(dataset)
betas <- read.table("beta.dat", sep = ",", header = TRUE)
varcov <- read.table("varcov.dat", sep = "\t", header = FALSE)
L <- t(chol(varcov))
L
sd <- read.table("sd.dat", sep = ",", header = TRUE)
betas$Names
sd



dat0 <- select (dataset, Wetland, Payment, Covercrop, NuMgt, asc, 
                dem_2018,taxcost, 
                income_1, income_2, income_3, income_4, income_5, income_6,
                areaf_1, areaf_2, areaf_3, areaf_4, crp2018, implakes )

dat1 <- sample_n(dat0, 1000)
dat1
dat_m <- as.matrix(x = dat1, nrow = 1000, ncol = 19)  
dat_m
dat_m %*% betas$Betas

new_beta <- t(L)%*% betas$Betas + betas$Betas
new_beta_price <- new_beta[2,]

normals <- rnorm(10, 0, 1)
new_beta2 <- c(0,0,0,0,new_beta[5:19])
#new_beta2_wld <- c(0,0,0,0,new_beta[5:19])
#new_beta2_wld
wta_wetland <- -((exp (new_beta[1,] + sd$sd[1] * normals)) + dat_m %*% new_beta2)/ new_beta_price
wta_wetland
mean(na.omit(wta_wetland))
plot(density(na.omit(wta_wetland)))

wta_nm <- -((exp (new_beta[4,] + sd$sd[4] * normals)) + dat_m %*% new_beta2)/ new_beta_price
mean(na.omit(wta_nm))

plot(density(na.omit(wta_nm)))
#wta_nm <- mean(- dat_m %*% new_beta2_nm/ new_beta_price,na.rm=TRUE)
wta_nm

new_beta2_cc <- c(0,0,new_beta_cc,0,new_beta[5:19])
wta_cc <- -((exp (new_beta[3,] + sd$sd[3] * normals)) + dat_m %*% new_beta2_wld)/ new_beta_price

plot(density(na.omit(wta_cc)))

wta_cc <- mean(- dat_m %*% new_beta2_cc/ new_beta_price,na.rm=TRUE)
wta_cc
######################

beta_price <- exp(-6.41375 + 2.96762 * normals)




new_beta_price <- exp(new_beta[2,] + sd$sd[2] * normals)
new_beta_price
new_beta_wld <- exp (new_beta[1,] + sd$sd[1] * normals)
new_beta_cc <- exp (new_beta[3,]  + sd$sd[3] * normals)
new_beta_nm <- exp (new_beta[4,] + sd$sd[4] * normals)
new_beta_nm

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