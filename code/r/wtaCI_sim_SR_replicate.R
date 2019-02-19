rm(list = ls())

library(tidyverse)
library(mvtnorm)


#setwd("C:/Users/langzx/Desktop/github/DCM/data")
setwd("//udrive.uw.edu/udrive/MRB surveys/Results")
dataset <- read.csv (file = "wta_observables11192018.csv",header = TRUE)
dim(dataset)
n <- dim(dataset)[1]
dataset$asc <- rep(1,n )
dataset$lake1000 <- dataset$implakes/1000
colnames(dataset)
# see NLOGIT output exp_results_441obs_12182018.txt
betas <- read.table("beta.dat", sep = ",", header = TRUE)
varcov <- read.table("varcov.dat", sep = "\t", header = FALSE)
dim(varcov)
varcov_m <- as.matrix(varcov, nrow = 19, ncol = 19)
varcov_m 
betas$Names
betas$Betas

newbetas<- betas
#newbetas$Betas <- as.vector(rmvnorm(1,mean = betas$Betas, sigma = varcov_m)) # takes a draw



## cc
cc_rp <- betas$Betas[betas$Names=="cc"]
lake_rp <- betas$Betas[betas$Names=="cclake"]

## nm
nm_rp <- betas$Betas[betas$Names=="nm"]





dat0 <- select (dataset, Wetland, Payment, Covercrop, NuMgt, asc, 
                dem_2018,taxcost, 
                income_1, income_2, income_3, income_4, income_5, income_6,
                areaf_1, areaf_2, areaf_3, areaf_4, crp2018, lake1000)

## individual sample 
#dat1 <- sample_n(dat0, 1) # so we can get same results, let's pick an arbitrary row, 45
dat1 <- dat0[40,]
dat_m <- as.matrix(x = dat1, nrow = 1, ncol = 19)  
dat_m

############INDIVIDUAL WTA estimate EXAMPLE
R <- 50000 # simulation draws
draws <- matrix (NA,nrow = R, ncol = dim(betas)[1] + 2)
colnames(draws)<-c('wetland','pay','cc','nm','asc','dems18','costtax',
                   'inc1','inc2','inc3','inc4','inc5','inc6',
                   'farm1','farm2','farm3','farm4','crp','cclake' ,'mWTA_wld','tWTA_wld')
for (r1 in 1 : R){
  drawbetas<- betas
  drawbetas$Betas <- as.vector(rmvnorm(1,mean = betas$Betas, sigma = varcov_m)) # draw from sampling distribution
  drawbetas$Betas[betas$Names=="pay"] <- drawbetas$Betas[betas$Names=="pay"] * rexp(rate = 1, n = 1) # draw from assumed random heterogeneity dsn
  drawbetas$Betas[betas$Names=="wetland"] <- drawbetas$Betas[betas$Names=="wetland"] * rexp(rate = 1, n = 1)
  drawbetas$Betas[betas$Names=="cc"] <- drawbetas$Betas[betas$Names=="cc"] * rexp(rate = 1, n = 1)
  drawbetas$Betas[betas$Names=="nm"] <- drawbetas$Betas[betas$Names=="nm"] * rexp(rate = 1, n = 1)
  mWTA_wetland <- -(drawbetas$Betas[betas$Names=="wetland"] / drawbetas$Betas[betas$Names=="pay"]) #marginal wta for wetland
  tWTA_wetland <- -(drawbetas$Betas[betas$Names=="wetland"]  + as.vector(dat_m %*% c(0,0,0,0,drawbetas$Betas[5:18],0))) / drawbetas$Betas[betas$Names=="pay"]
  draws[r1, ] <- c(drawbetas$Betas,mWTA_wetland,tWTA_wetland)
}

draws
colMeans(draws)
hist(draws[,21])
plot(density(draws[,21]))
summary(draws)

# for comparison: no exponential heterogeneity

############INDIVIDUAL WTA estimate just MLE KR
R <- 50000 # simulation draws
draws <- matrix (NA,nrow = R, ncol = dim(betas)[1] + 2)
colnames(draws)<-c('wetland','pay','cc','nm','asc','dems18','costtax',
                   'inc1','inc2','inc3','inc4','inc5','inc6',
                   'farm1','farm2','farm3','farm4','crp','cclake' ,'mWTA_wld','tWTA_wld')
for (r1 in 1 : R){
  drawbetas<- betas
  drawbetas$Betas <- as.vector(rmvnorm(1,mean = betas$Betas, sigma = varcov_m)) # draw from sampling distribution
  #drawbetas$Betas[betas$Names=="pay"] <- drawbetas$Betas[betas$Names=="pay"] * rexp(rate = 1, n = 1) # draw from assumed random heterogeneity dsn
  #drawbetas$Betas[betas$Names=="wetland"] <- drawbetas$Betas[betas$Names=="wetland"] * rexp(rate = 1, n = 1)
  #drawbetas$Betas[betas$Names=="cc"] <- drawbetas$Betas[betas$Names=="cc"] * rexp(rate = 1, n = 1)
  #drawbetas$Betas[betas$Names=="nm"] <- drawbetas$Betas[betas$Names=="nm"] * rexp(rate = 1, n = 1)
  mWTA_wetland <- -(drawbetas$Betas[betas$Names=="wetland"] / drawbetas$Betas[betas$Names=="pay"]) #marginal wta for wetland
  tWTA_wetland <- -(drawbetas$Betas[betas$Names=="wetland"]  + dat_m %*% c(0,0,0,0,drawbetas$Betas[5:18],0) ) / drawbetas$Betas[betas$Names=="pay"]
  draws[r1, ] <- c(drawbetas$Betas,mWTA_wetland,tWTA_wetland)
}

draws
colMeans(draws)
hist(draws[,21])
plot(density(draws[,21]))
summary(draws)

# for comparison: JUST exponential heterogeneity



R <- 5# simulation draws
set.seed(12345)

rexp1 <- rexp(rate = 1, n = R) 
rexp2 <- rexp(rate = 1, n = R)

draws <- matrix (NA,nrow = R, ncol = dim(betas)[1] + 2)
colnames(draws)<-c('wetland','pay','cc','nm','asc','dems18','costtax',
                   'inc1','inc2','inc3','inc4','inc5','inc6',
                   'farm1','farm2','farm3','farm4','crp','cclake' ,'mWTA_wld','tWTA_wld')
mWTA <- c()
beta <- as.vector(betas$Betas)
for (r1 in 1 : R){
  drawbetas <- betas
  #drawbetas$Betas <- as.vector(rmvnorm(1,mean = betas$Betas, sigma = varcov_m)) # draw from sampling distribution
  drawbetas$Betas[drawbetas$Names =="pay"] <- betas$Betas[betas$Names == "pay"] * rexp2[r1] # draw from assumed random heterogeneity dsn
  
  #print(paste("pay parameter =", drawbetas$Betas[betas$Names=="pay"]))
  
  print(paste("mWTA1  =", - beta[1] * rexp1[r1] / (beta[2] * rexp2[r1])))
  
 
  
  drawbetas$Betas[drawbetas$Names=="wetland"] <- betas$Betas[betas$Names=="wetland"] * rexp1[r1]
  #drawbetas$Betas[betas$Names=="cc"] <- betas$Betas[betas$Names=="cc"] * rexp(rate = 1, n = 1)
  #drawbetas$Betas[betas$Names=="nm"] <- betas$Betas[betas$Names=="nm"] * rexp(rate = 1, n = 1)
  mWTA_wetland <- -(drawbetas$Betas[drawbetas$Names=="wetland"] / drawbetas$Betas[drawbetas$Names=="pay"]) #marginal wta for wetland
  mWTA[r1] <- - beta[1] * rexp1[r1] / (beta[2] * rexp2[r1])
  tWTA_wetland <- -(drawbetas$Betas[drawbetas$Names=="wetland"]  + dat_m %*% c(0,0,0,0,betas$Betas[5:18],0) ) / drawbetas$Betas[drawbetas$Names=="pay"]
  print(paste("mWTA =", -(drawbetas$Betas[drawbetas$Names=="wetland"] / drawbetas$Betas[drawbetas$Names=="pay"])))
  draws[r1, ] <- c(drawbetas$Betas,mWTA_wetland,tWTA_wetland)
}


colMeans(draws)
hist(draws[,21])
plot(density(draws[,21]))
summary(draws)

# to double-check: compare with previous draws from exponentials

# coeff 
## Payment 
pay_rp <- betas$Betas[betas$Names=="pay"] # note we don't need a single random draw in L 22

## wetland 
wld_rp <- betas$Betas[betas$Names=="wetland"]


## fixed parameters
new_beta2 <- c(0,0,0,0,betas$Betas[5:18],0)

#n_draws <- 5
#wta_wld <- -(wld_rp * rexp(rate = 1, n = n_draws) + as.vector(dat_m %*% new_beta2)) / pay_rp * rexp(rate = 1, n = n_draws)
ratio <- rexp1 / rexp2
mwta_wld <- - (betas$Betas[betas$Names=="wetland"] * rexp1) / (betas$Betas[betas$Names=="pay"] * rexp2)
wta_wld <- -(wld_rp * rexp1 + as.vector(dat_m %*% new_beta2)) / (pay_rp * rexp2)
mean(wta_wld, na.rm = TRUE)
plot(density(wta_wld))
summary(mwta_wld)
summary(wta_wld)
################################################################## end SR edits





################## FOR WHOLE SAMPLE

R <- 1000
n <- dim(dataset)[1]
t <- 8
s <- 441
index <- seq(1, n, by=16) 
length(index)
n_draws <- 10000

wta_vec <- vector (length = 10)
wta_vec
##########wld wta



WLD_WTA_ALL <- matrix(NA, nrow = s, ncol = 3)
colnames(WLD_WTA_ALL) <- c("MEAN", "CI_L","CI_U")

for (i in 1:s){
  wta_vec <- vector (length = R)
  draws <- matrix (NA,nrow = R, ncol = 19)
  colnames(draws)<-c('wetland','pay','cc','nm','asc','dems18','costtax',
                     'inc1','inc2','inc3','inc4','inc5','inc6',
                     'farm1','farm2','farm3','farm4','crp','cclake')
  for (r1 in 1 : R){
    drawbetas<- betas
    drawbetas$Betas <- as.vector(rmvnorm(1,mean = betas$Betas, sigma = varcov_m))
    draws[r1, ] <- drawbetas$Betas
  }
  
  for (r in 1 : R){
    newbetas <- draws[r,]
    pay_rp <- newbetas["pay"]
    wld_rp <- newbetas["wetland"]
    ## individual-specific parameters
    new_beta2<- c(0,0,0,0,newbetas[5:18],0)
    index_i <- index [i]
    dat_s <- dat0[i,]
    dat_s_m <- as.matrix(x = dat_s, nrow = 1, ncol = 19)  
    wta_s <- -(wld_rp * rexp(rate = 1, n = n_draws) + as.vector(dat_s_m %*% new_beta2)) / pay_rp * rexp(rate = 1, n = n_draws)
    wta_vec[r] <- mean(wta_s,na.rm = TRUE)
  }
  WLD_WTA_ALL[i,1] <- mean(wta_vec,na.rm = TRUE)
  WLD_WTA_ALL[i,2] <- quantile(wta_vec, 0.025,na.rm = TRUE)
  WLD_WTA_ALL[i,3] <- quantile(wta_vec, 0.975,na.rm = TRUE)
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
  wta_vec <- vector(length = R)
  draws <- matrix (NA,nrow = R, ncol = 19)
  colnames(draws)<-c('wetland','pay','cc','nm','asc','dems18','costtax',
                     'inc1','inc2','inc3','inc4','inc5','inc6',
                     'farm1','farm2','farm3','farm4','crp','cclake')
  for (r1 in 1 : R){
    drawbetas<- betas
    drawbetas$Betas <- as.vector(rmvnorm(1,mean = betas$Betas, sigma = varcov_m))
    draws[r1, ] <- drawbetas$Betas
  }
  
  for (r in 1 : R){
    newbetas <- draws[r,]
    pay_rp <- newbetas["pay"]
    cc_rp <- newbetas["cc"]
    lake_rp <- newbetas["cclake"]
    ## individual-specific parameters
    new_beta2<- c(0,0,0,0,newbetas[5:18],0)
    index_i <- index[i]
    dat_s <- dat0[i,]
    dat_s_m <- as.matrix(x = dat_s, nrow = 1, ncol = 19)  
    wta_s <- -(cc_rp * rexp(rate = 1, n = n_draws) + as.vector(dat_s_m %*% new_beta2)) / pay_rp * rexp(rate = 1, n = n_draws)
    wta_vec[r] <- mean(wta_s,na.rm = TRUE)
  }
  CC_WTA_ALL[i,1] <- mean(wta_vec,na.rm = TRUE)
  CC_WTA_ALL[i,2] <- quantile(wta_vec, 0.025,na.rm = TRUE)
  CC_WTA_ALL[i,3] <- quantile(wta_vec, 0.975,na.rm = TRUE)
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
  wta_vec <- vector(length = R)
  draws <- matrix (NA,nrow = R, ncol = 19)
  colnames(draws)<-c('wetland','pay','cc','nm','asc','dems18','costtax',
                     'inc1','inc2','inc3','inc4','inc5','inc6',
                     'farm1','farm2','farm3','farm4','crp','cclake')
  
  for (r1 in 1 : R){
    drawbetas<- betas
    drawbetas$Betas <- as.vector(rmvnorm(1,mean = betas$Betas, sigma = varcov_m))
    draws[r1, ] <- drawbetas$Betas
  }
  
  for (r in 1 : R){
    newbetas <- draws[r,]
    pay_rp <- newbetas["pay"]
    nm_rp <- newbetas["nm"]
    ## individual-specific parameters
    new_beta2<- c(0,0,0,0,newbetas[5:18],0)
    
    newbetas<- betas
    newbetas$Betas <- as.vector(rmvnorm(1,mean = betas$Betas, sigma = varcov_m))
    pay_rp <- newbetas$Betas[newbetas$Names=="pay"]
    nm_rp <- newbetas$Betas[newbetas$Names=="nm"]
    ## fixed parameters
    new_beta2<- c(0,0,0,0,newbetas$Betas[5:18],0)
    index_i <- index[i]
    dat_s <- dat0[i,]
    dat_s_m <- as.matrix(x = dat_s, nrow = 1, ncol = 19)  
    wta_s <- -(nm_rp * rexp(rate = 1, n = n_draws) + as.vector(dat_s_m %*% new_beta2)) / pay_rp * rexp(rate = 1, n = n_draws)
    wta_vec[r] <- mean(wta_s,na.rm = TRUE)
  }
  NM_WTA_ALL[i,1] <- mean(wta_vec,na.rm = TRUE)
  NM_WTA_ALL[i,2] <- quantile(wta_vec, 0.025,na.rm = TRUE)
  NM_WTA_ALL[i,3] <- quantile(wta_vec, 0.975,na.rm = TRUE)
}
NM_WTA_ALL
plot(density(NM_WTA_ALL[,1]))

#sample average value 
NM_mean <- mean(NM_WTA_ALL[,1])
NM_CIL <- mean(NM_WTA_ALL[,2])
NM_CIU <- mean(NM_WTA_ALL[,3])
NM_mean
NM_CIL
NM_CIU
setwd("C:/Users/langzx/Desktop/github/DCM/output")
write.csv (x = WLD_WTA_ALL, file = "WLD_wta_0116.csv", row.names = FALSE)
write.csv (x = CC_WTA_ALL, file = "CC_wta_0116.csv", row.names = FALSE)
write.csv (x = NM_WTA_ALL, file = "NM_wta_0116.csv", row.names = FALSE)
