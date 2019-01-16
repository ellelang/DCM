rm(list = ls())
library(tidyverse)
library(mvtnorm)
setwd("C:/Users/langzx/Desktop/github/DCM/data")
dataset <- read.csv (file = "wta_observables11192018.csv",header = TRUE)
dim(dataset)
n <- dim(dataset)[1]
dataset$asc <- rep(1,n )
dataset$lake1000 <- dataset$implakes/1000
colnames(dataset)
betas <- read.table("beta.dat", sep = ",", header = TRUE)
varcov <- read.table("varcov.dat", sep = "\t", header = FALSE)
dim(varcov)
varcov_m <- as.matrix(varcov, nrow = 19, ncol = 19)
varcov_m 
betas$Names
betas$Betas

newbetas<- betas
newbetas$Betas <- as.vector(rmvnorm(1,mean = betas$Betas, sigma = varcov_m))

# coeff 
## Payment 
pay_rp <- newbetas$Betas[newbetas$Names=="pay"]

## wetland 
wld_rp <- newbetas$Betas[newbetas$Names=="wetland"]

## cc
cc_rp <- newbetas$Betas[newbetas$Names=="cc"]
lake_rp <- newbetas$Betas[newbetas$Names=="cclake"]

## nm
nm_rp <- newbetas$Betas[newbetas$Names=="nm"]


## fixed parameters
new_beta2<- c(0,0,0,0,newbetas$Betas[5:18],0)



dat0 <- select (dataset, Wetland, Payment, Covercrop, NuMgt, asc, 
                dem_2018,taxcost, 
                income_1, income_2, income_3, income_4, income_5, income_6,
                areaf_1, areaf_2, areaf_3, areaf_4, crp2018, lake1000)

## individual sample 
dat1 <- sample_n(dat0, 1)
dat1
dat_m <- as.matrix(x = dat1, nrow = 1, ncol = 19)  
dat_m

############INDIVIDUAL WTA estimate EXAMPLE
n_draws <- 10000
wta_wld <- -(wld_rp * rexp(rate = 1, n = n_draws) + as.vector(dat_m %*% new_beta2)) / pay_rp * rexp(rate = 1, n = n_draws)
mean(wta_wld, na.rm = TRUE)
plot(density(wtp_wld))
wta_wld

################## FOR WHOLE SAMPLE
R <- 1000
n <- dim(dataset)[1]
t <- 8
s<- 441
index <- seq(1, n, by=16) 
length(index)
n_draws <- 10000


##########wld wta
WLD_WTA_ALL <- matrix(NA, nrow = s, ncol = 3)
colnames(WLD_WTA_ALL) <- c("MEAN", "CI_L","CI_U")

for (i in 1:s){
  wta_vec <- length(R)
  for (r in 1 : R){
    newbetas<- betas
    newbetas$Betas <- as.vector(rmvnorm(1,mean = betas$Betas, sigma = varcov_m))
    pay_rp <- newbetas$Betas[newbetas$Names=="pay"]
    wld_rp <- newbetas$Betas[newbetas$Names=="wetland"]
    ## fixed parameters
    new_beta2<- c(0,0,0,0,newbetas$Betas[5:18],0)
    index_i <- index(i)
    dat_s <- dat0[i,]
    dat_s_m <- as.matrix(x = dat_s, nrow = 1, ncol = 19)  
    wta_s <- -(wld_rp * rexp(rate = 1, n = n_draws) + as.vector(dat_m %*% new_beta2)) / pay_rp * rexp(rate = 1, n = n_draws)
    wta_vec[r] <- mean(wta_s)
  }
  WLD_WTA_ALL[i,1] <- mean(wta_vec)
  WLD_WTA_ALL[i,2] <- quantile(wta_vec, 0.025)
  WLD_WTA_ALL[i,3] <- quantile(wta_vec, 0.975)
}
WLD_WTA_ALL
plot(density(WLD_WTA_ALL[,1]))
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
  wta_vec <- length(R)
  for (r in 1 : R){
    newbetas<- betas
    newbetas$Betas <- as.vector(rmvnorm(1,mean = betas$Betas, sigma = varcov_m))
    pay_rp <- newbetas$Betas[newbetas$Names=="pay"]
    cc_rp <- newbetas$Betas[newbetas$Names=="cc"]
    lake_rp <- newbetas$Betas[newbetas$Names=="cclake"]
    ## fixed parameters
    new_beta2<- c(0,0,0,0,newbetas$Betas[5:18],0)
    index_i <- index(i)
    dat_s <- dat0[i,]
    dat_s_m <- as.matrix(x = dat_s, nrow = 1, ncol = 19)  
    wta_s <- -(cc_rp * rexp(rate = 1, n = n_draws) + as.vector(dat_m %*% new_beta2)) / pay_rp * rexp(rate = 1, n = n_draws)
    wta_vec[r] <- mean(wta_s)
  }
  CC_WTA_ALL[i,1] <- mean(wta_vec)
  CC_WTA_ALL[i,2] <- quantile(wta_vec, 0.025)
  CC_WTA_ALL[i,3] <- quantile(wta_vec, 0.975)
}

CC_WTA_ALL
plot(density(CC_WTA_ALL[,1]))
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
  wta_vec <- length(R)
  for (r in 1 : R){
    newbetas<- betas
    newbetas$Betas <- as.vector(rmvnorm(1,mean = betas$Betas, sigma = varcov_m))
    pay_rp <- newbetas$Betas[newbetas$Names=="pay"]
    nm_rp <- newbetas$Betas[newbetas$Names=="nm"]
    ## fixed parameters
    new_beta2<- c(0,0,0,0,newbetas$Betas[5:18],0)
    index_i <- index(i)
    dat_s <- dat0[i,]
    dat_s_m <- as.matrix(x = dat_s, nrow = 1, ncol = 19)  
    wta_s <- -(nm_rp * rexp(rate = 1, n = n_draws) + as.vector(dat_m %*% new_beta2)) / pay_rp * rexp(rate = 1, n = n_draws)
    wta_vec[r] <- mean(wta_s)
  }
  NM_WTA_ALL[i,1] <- mean(wta_vec)
  NM_WTA_ALL[i,2] <- quantile(wta_vec, 0.025)
  NM_WTA_ALL[i,3] <- quantile(wta_vec, 0.975)
}
NM_WTA_ALL

#sample average value 
NM_mean <- mean(NM_WTA_ALL[,1])
NM_CIL <- mean(NM_WTA_ALL[,2])
NM_CIU <- mean(NM_WTA_ALL[,3])
NM_mean
NM_CIL
NM_CIU
setwd("C:/Users/langzx/Desktop/github/DCM/output")
write.csv (x = WLD_WTA_ALL, file = "WLD_wta.csv", row.names = FALSE)
write.csv (x = CC_WTA_ALL, file = "CC_wta.csv", row.names = FALSE)
write.csv (x = NM_WTA_ALL, file = "NM_wta.csv", row.names = FALSE)
