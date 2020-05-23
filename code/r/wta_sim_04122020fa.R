rm(list = ls())
library(uwIntroStats)
library(matrixcalc)
library(tidyverse)
library(tmvtnorm)
library(mvtnorm)
setwd("C:/Users/langzx/Desktop/github/DCM/data")
dataset <- read.csv (file = "wta_04122020.csv",header = TRUE)
dim(dataset)
n <- dim(dataset)[1]
dataset$asc <- rep(1,n )
dataset$lake1000 <- dataset$implakes/1000
colnames(dataset)

dim(dataset)
n <- dim(dataset)[1]
dataset$asc <- rep(1,n )
dataset$lake1000 <- dataset$implakes/1000
colnames(dataset)
#betas <- read.table("betas04142020.txt", sep = "\t", header = TRUE)
#varcov <- read.table("varscov0414.txt", sep = "\t", header = FALSE)
#varcov_m <- as.matrix(varcov, nrow = 19, ncol = 19)

betas <- read.table("betas05202020.txt", sep = "\t", header = TRUE)
varcov <- read.table("varscov05202020.txt", sep = "\t", header = FALSE)
#varcov_test <- read.table("varscovtest.txt", sep = "\t", header = FALSE)
dim(varcov)
varcov_m <- as.matrix(varcov, nrow = 20, ncol = 20)
varcov_m_test <- as.matrix(varcov, nrow = 20, ncol = 20)
length(betas$Names)
betas$Names
betas$Betas
length(betas$Names)
betas <- betas%>% mutate_if(is.factor,as.character)
#varcov_m_test
rmvnorm(1,mean = betas$Betas, sigma = varcov_m_test)
betas$Names


newbetas<- betas
# coeff 
## Payment 
pay_rp <- newbetas$Betas[newbetas$Names=="pay"]
lake_pay_rp <- newbetas$Betas[newbetas$Names=="plake"]
## wetland 
wld_rp <- newbetas$Betas[newbetas$Names=="wetland"]

## cc
cc_rp <- newbetas$Betas[newbetas$Names=="cc"]
lake_rp <- newbetas$Betas[newbetas$Names=="clake"]

dat0 <- select (dataset, Wetland, Payment, Covercrop, NuMgt, asc, 
                dfl08to18,taxcost, 
                income_1, INCOMB23, income_4, income_5, income_6,
                areaf_1, areaf_3, areaf_4, aware, past, appreciate, resp,lake1000, lake1000)
dim(dat0)

############INDIVIDUAL WTA estimate EXAMPLE
draws <- matrix (NA,nrow = 10, ncol = 20)
colnames(draws)<-c('wetland','pay','cc','nm','asc','dfl','costtax',
                   'incfarm1','incfarm23','incfarm4','incfarm5','incfarm6',
                   'farmsi1','farmsi3','fscaware','fscpast','fscapp','fscresp','plake','clake')
dim(varcov_m)
for (r1 in 1 : 10){
  drawbetas<- betas
  drawbetas$Betas <- as.vector(rmvnorm(1,mean = betas$Betas, sigma = varcov_m_test))
  draws[r1, ] <- drawbetas$Betas
}

draws

################## FOR WHOLE SAMPLE
#set.seed(123456)
R <- 1000
n <- dim(dataset)[1]
t <- 8
s<- 441
index <- seq(1, n, by=16) 
length(index)
n_draws <- 500

wta_vec <- vector (length = 10)
wta_vec
##########wld wta

WLD_WTA_ALL <- matrix(NA, nrow = s, ncol = 3)
colnames(WLD_WTA_ALL) <- c("MEAN", "CI_L","CI_U")

for (i in 1:s){
  wta_vec <- vector (length = R)
  draws <- matrix (NA,nrow = R, ncol = 20)
  colnames(draws)<-c('wetland','pay','cc','nm','asc','dfl','costtax',
                     'incfarm1','incfarm23','incfarm4','incfarm5','incfarm6',
                     'farmsi1','farmsi3','fscaware','fscpast','fscapp','fscresp','plake','clake')
  set.seed(4008)
  for (r1 in 1 : R){
    drawbetas<- betas
    drawbetas$Betas <- as.vector(rmvnorm(1,mean = betas$Betas, sigma = varcov_m_test))
    draws[r1, ] <- drawbetas$Betas
  }
  
  for (r in 1 : R){
    newbetas <- draws[r,]
    pay_rp <- newbetas["pay"]
    wld_rp <- newbetas["wetland"]
    lake_p <- newbetas["plake"]
    ## individual-specific parameters
    new_beta2<- c(0,0,0,0,newbetas[5:18],0,0)
    index_i <- index [i]
    dat_s <- dat0[i,]
    dat_s_m <- as.matrix(x = dat_s, nrow = 1, ncol = 20)  
    wta_s <- -(wld_rp * rexp(rate = 1, n = n_draws) + as.vector(dat_s_m %*% new_beta2)) / (pay_rp)
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

prev <- read.csv('../output/WLD_wta_0214.csv')
mean(prev$MEAN)

################2
R <- 1000
n_draws <- 1000
CC_WTA_ALL <- matrix(NA, nrow = s, ncol = 3)
colnames(CC_WTA_ALL) <- c("MEAN", "CI_L","CI_U")

for (i in 1:s){
  wta_vec <- vector(length = R)
  draws <- matrix (NA,nrow = R, ncol = 20)
  colnames(draws)<-c('wetland','pay','cc','nm','asc','dfl','costtax',
                     'incfarm1','incfarm23','incfarm4','incfarm5','incfarm6',
                     'farmsi1','farmsi2','farmsi3','fscaware','fscpast','fscapp','fscresp','plake','clake')
  set.seed(5008)
  for (r1 in 1 : R){
    drawbetas<- betas
    drawbetas$Betas <- as.vector(rmvnorm(1,mean = betas$Betas, sigma = varcov_m_test))
    draws[r1, ] <- drawbetas$Betas
  }
  
  for (r in 1 : R){
    newbetas <- draws[r,]
    pay_rp <- newbetas["pay"]
    cc_rp <- newbetas["cc"]
    lake_rp <- newbetas["clake"]
    lake_p <- newbetas["plake"]
    ## individual-specific parameters
    new_beta2<- c(0,0,0,0,newbetas[5:18],0,0)
    index_i <- index[i]
    dat_s <- dat0[i,]
    dat_s_m <- as.matrix(x = dat_s, nrow = 1, ncol = 20)  
    wta_s <- -((cc_rp + lake_rp )* rexp(rate = 1, n = n_draws) + as.vector(dat_s_m %*% new_beta2)) / (pay_rp)
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
prev <- read.csv('../output/CC_wta_0214.csv')
mean(prev$MEAN)
###########nm wta
##########nm wta

NM_WTA_ALL <- matrix(NA, nrow = s, ncol = 3)
colnames(NM_WTA_ALL) <- c("MEAN", "CI_L","CI_U")

for (i in 1:s){
  wta_vec <- vector(length = R)
  draws <- matrix (NA,nrow = R, ncol = 20)
  colnames(draws)<-c('wetland','pay','cc','nm','asc','dfl','costtax',
                     'incfarm1','incfarm23','incfarm4','incfarm5','incfarm6',
                     'farmsi1','farmsi2','farmsi3','fscaware','fscpast','fscapp','fscresp','plake','clake')
  
  set.seed(6008)
  for (r1 in 1 : R){
    drawbetas<- betas
    drawbetas$Betas <- as.vector(rmvnorm(1,mean = betas$Betas, sigma = varcov_m_test))
    draws[r1, ] <- drawbetas$Betas
  }
  
  for (r in 1 : R){
    newbetas <- draws[r,]
    pay_rp <- newbetas["pay"]
    nm_rp <- newbetas["nm"]
    lake_p <- newbetas["plake"]
    ## individual-specific parameters
    new_beta2<- c(0,0,0,0,newbetas[5:18],0,0)
    index_i <- index[i]
    dat_s <- dat0[i,]
    dat_s_m <- as.matrix(x = dat_s, nrow = 1, ncol = 20)  
    wta_s <- -(nm_rp * rexp(rate = 1, n = n_draws) + as.vector(dat_s_m %*% new_beta2)) / (pay_rp)
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
prev <- read.csv('../output/NM_wta_0214.csv')
mean(prev$MEAN)
