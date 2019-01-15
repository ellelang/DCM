rm(list = ls())
set.seed(12345)
library(mlogit)
library(gmnl)
library(tidyverse)
library(fastDummies)
#setwd("C:/Users/langzx/Desktop/github/DCM/data")
setwd("//udrive.uw.edu/udrive/MRB surveys/Results")
dataset <- read.csv (file = "wta_observables11192018.csv",header = TRUE)
dim(dataset)
n <- dim(dataset)[1]
dataset$asc <- rep(1,n )
dataset$lake1000 <- dataset$implakes/1000
colnames(dataset)
betas <- read.table("beta.dat", sep = ",", header = TRUE)
#varcov <- read.table("varcov.dat", sep = "\t", header = FALSE)
#L <- t(chol(varcov))
#sd <- read.table("sd.dat", sep = ",", header = TRUE)
betas$Names
betas$Betas



dat0 <- select (dataset, Wetland, Payment, Covercrop, NuMgt, asc, 
                dem_2018,taxcost, 
                income_1, income_2, income_3, income_4, income_5, income_6,
                areaf_1, areaf_2, areaf_3, areaf_4, crp2018, lake1000)

# coeff 
## Payment 
pay_rp <- betas$Betas[betas$Names=="pay"]

## wetland 
wld_rp <- betas$Betas[betas$Names=="wetland"]

## cc
cc_rp <- betas$Betas[betas$Names=="cc"]
lake_rp <- betas$Betas[betas$Names=="cclake"]

## wetland 
nm_rp <- betas$Betas[betas$Names=="nm"]


## fixed parameters
beta2<- c(0,0,0,0,betas$Betas[5:18],0)


## individual sample 
dat1 <- sample_n(dat0, 1)
dat1
dat_m <- as.matrix(x = dat1, nrow = 1, ncol = 19)  
dat_m
dat_m %*% betas$Betas

dat_m %*% beta2
dat_m

############INDIVIDUAL WTA estimate EXAMPLE
n_draws <- 10000

# WTA for any program
wta_anything <- -(as.vector(dat_m %*% beta2)) / pay_rp * rexp(rate = 1, n = n_draws)
mean(wta_anything, na.rm = TRUE)
plot(density(wta_anything))
summary(wta_anything)

# marginal WTA for wetland
wta_mwetland <- -(wld_rp * rexp(rate = 1, n = n_draws) ) / pay_rp * rexp(rate = 1, n = n_draws)
mean(wta_mwetland, na.rm = TRUE)
plot(density(wta_mwetland))
summary(wta_mwetland)

# marginal WTA for NM
wta_mnm <- -(nm_rp * rexp(rate = 1, n = n_draws) ) / pay_rp * rexp(rate = 1, n = n_draws)
mean(wta_mnm, na.rm = TRUE)
plot(density(wta_mnm))
summary(wta_mnm)

# marginal WTA for cover crops
lake_rp
lake_rp * dat_m[,19]
wta_cc <- -((cc_rp + lake_rp * dat_m[,19] )* rexp(rate = 1, n = n_draws) ) / pay_rp * rexp(rate = 1, n = n_draws)
mean(wta_cc, na.rm = TRUE)
plot(density(wta_cc))
summary(wta_cc)

# WTAs with 'fixed costs' added

wta_wld <- -(wld_rp * rexp(rate = 1, n = n_draws) + as.vector(dat_m %*% beta2)) / pay_rp * rexp(rate = 1, n = n_draws)
mean(wta_wld, na.rm = TRUE)
plot(density(wta_wld))
summary(wta_wld)


wta_nm <- -(nm_rp * rexp(rate = 1, n = n_draws) + as.vector(dat_m %*% beta2)) / pay_rp * rexp(rate = 1, n = n_draws)
mean(wta_nm, na.rm = TRUE)
plot(density(wta_nm))
summary(wta_nm)

lake_rp
lake_rp * dat_m[,19]
wta_cc <- -((cc_rp + lake_rp * dat_m[,19] )* rexp(rate = 1, n = n_draws) + as.vector(dat_m %*% beta2)) / pay_rp * rexp(rate = 1, n = n_draws)
mean(wta_cc, na.rm = TRUE)
plot(density(wta_cc))
wta_cc


########### FOR WHOLE SAMPLE
n <- dim(dataset)[1]
t <- 8
s <- 441
index <- seq(1, n, by=16) 
length(index)
n_draws <- 10000

#### 'fixed cost of any program' WTA
ANY_WTA_ALL <- matrix(NA, nrow = s, ncol = 3)
colnames(ANY_WTA_ALL) <- c("MEAN", "CI_L","CI_U") # note these aren't confidence intervals but percentiles of taste heterogeneity

for (i in 1:s){
  index_i <- index(i)
  dat_s <- dat0[i,]
  dat_s_m <- as.matrix(x = dat_s, nrow = 1, ncol = 19)  
  wta_s <- -(as.vector(dat_s_m %*% beta2)) / pay_rp * rexp(rate = 1, n = n_draws)
  ANY_WTA_ALL[i,1] <- mean(wta_s)
  ANY_WTA_ALL[i,2] <- quantile(wta_s, 0.05) 
  ANY_WTA_ALL[i,3] <- quantile(wta_s, 0.95)
}
summary(ANY_WTA_ALL)

plot(density (wta_s),xlim = c(-1000,1000))

#sample average value 
WLD_mean <- mean(WLD_WTA_ALL[,1])
WLD_CIL <- mean(WLD_WTA_ALL[,2])
WLD_CIU <- mean(WLD_WTA_ALL[,3])
WLD_mean
WLD_CIL
WLD_CIU


##########wld wta
WLD_WTA_ALL <- matrix(NA, nrow = s, ncol = 3)
colnames(WLD_WTA_ALL) <- c("MEAN", "CI_L","CI_U") # note these aren't confidence intervals but percentiles of taste heterogeneity

for (i in 1:s){
  index_i <- index(i)
  dat_s <- dat0[i,]
  dat_s_m <- as.matrix(x = dat_s, nrow = 1, ncol = 19)  
  wta_s <- -(wld_rp * rexp(rate = 1, n = n_draws) + as.vector(dat_s_m %*% beta2)) / pay_rp * rexp(rate = 1, n = n_draws)
  WLD_WTA_ALL[i,1] <- mean(wta_s)
  WLD_WTA_ALL[i,2] <- quantile(wta_s, 0.25) # note these are 1st and 3rd quantiles
  WLD_WTA_ALL[i,3] <- quantile(wta_s, 0.75)
}
summary(WLD_WTA_ALL)

plot(density (wta_s),xlim = c(-1000,1000))

#sample average value 
WLD_mean <- mean(WLD_WTA_ALL[,1])
WLD_CIL <- mean(WLD_WTA_ALL[,2])
WLD_CIU <- mean(WLD_WTA_ALL[,3])
WLD_mean
WLD_CIL
WLD_CIU
##########cc wta
CC_WTA_ALL <- matrix(NA, nrow = s, ncol = 3)
colnames(CC_WTA_ALL) <- c("MEAN", "CI_L","CI_U")

for (i in 1:s){
  index_i <- index(i)
  dat_s <- dat0[i,]
  dat_s_m <- as.matrix(x = dat_s, nrow = 1, ncol = 19)  
  wta_s <- -((cc_rp + lake_rp * dat_s_m[,19] )* rexp(rate = 1, n = n_draws) + as.vector(dat_s_m %*% beta2)) / pay_rp * rexp(rate = 1, n = n_draws)
  CC_WTA_ALL[i,1] <- mean(wta_s)
  CC_WTA_ALL[i,2] <- quantile(wta_s, 0.25)
  CC_WTA_ALL[i,3] <- quantile(wta_s, 0.75)
}
summary(CC_WTA_ALL)

plot(density (wta_s),xlim = c(-1000,1000))

#sample average value 
CC_mean <- mean(CC_WTA_ALL[,1])
CC_CIL <- mean(CC_WTA_ALL[,2])
CC_CIU <- mean(CC_WTA_ALL[,3])
CC_mean
CC_CIL
CC_CIU

##########nm wta
NM_WTA_ALL <- matrix(NA, nrow = s, ncol = 3)
colnames(NM_WTA_ALL) <- c("MEAN", "CI_L","CI_U")

for (i in 1:s){
  index_i <- index(i)
  dat_s <- dat0[i,]
  dat_s_m <- as.matrix(x = dat_s, nrow = 1, ncol = 19)  
  wta_s <- -(nm_rp * rexp(rate = 1, n = n_draws) + as.vector(dat_s_m %*% beta2)) / pay_rp * rexp(rate = 1, n = n_draws)
  NM_WTA_ALL[i,1] <- mean(wta_s)
  NM_WTA_ALL[i,2] <- quantile(wta_s, 0.25)
  NM_WTA_ALL[i,3] <- quantile(wta_s, 0.75)
}
summary(NM_WTA_ALL)

plot(density (wta_s),xlim = c(-1000,1000))

#sample average value 
NM_mean <- mean(NM_WTA_ALL[,1])
NM_CIL <- mean(NM_WTA_ALL[,2])
NM_CIU <- mean(NM_WTA_ALL[,3])
NM_mean
NM_CIL
NM_CIU




