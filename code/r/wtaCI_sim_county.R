rm(list = ls())
library(uwIntroStats)
library(tidyverse)
library(mvtnorm)
setwd("C:/Users/langzx/Desktop/github/DCM/data")
dataset <- read.csv (file = "county_all0426.csv",header = TRUE)
dim(dataset)
n <- dim(dataset)[1]
dataset$asc <- rep(1,n )
dataset$Wetland <- rep(1,n )
dataset$Payment <- rep(1,n )
dataset$Covercrop<- rep(1,n )
dataset$NuMgt <- rep(1,n )

dataset$lake1000 <- dataset$implakes/1000
colnames(dataset)
betas <- read.csv("beta_county.csv", header = TRUE)
varcov <- read.csv("varcov_county.csv",  header = FALSE)
dim(varcov)
varcov_m <- as.matrix(varcov, nrow = 16, ncol = 16)
varcov_m 
betas$Names
betas$Betas

newbetas<- betas
newbetas$Betas
#newbetas$Betas <- as.vector(rmvnorm(1,mean = betas$Betas, sigma = varcov_m))
descrip(dataset)
# coeff 
## Payment 
pay_rp <- newbetas$Betas[newbetas$Names=="pay"]
pay_rp
## wetland 
wld_rp <- newbetas$Betas[newbetas$Names=="wetlands"]
wld_rp
## cc
cc_rp <- newbetas$Betas[newbetas$Names=="cc"]
cc_rp
lake_rp <- newbetas$Betas[newbetas$Names=="cclake"]
lake_rp
## nm
nm_rp <- newbetas$Betas[newbetas$Names=="nm"]
nm_rp
length(newbetas$Names)

## fixed parameters
new_beta2<- c(0,0,0,0,newbetas$Betas[5:15],0)
dat0 <- select (dataset, Wetland, Payment, Covercrop, NuMgt, asc, 
                dflall,taxcost, 
                income1, income23, income4, income5, income6,
                area2, area3, area4, lake1000)


############INDIVIDUAL WTA estimate EXAMPLE

## individual sample 
dat1 <- sample_n(dat0, 1)
dat1
dat_m <- as.matrix(x = dat1, nrow = 1, ncol = 16)  
dim(dat_m)


draws <- matrix (NA,nrow = 10, ncol = 16)
colnames(draws)<-c('wetland','pay','cc','nm','asc','dfl','costtax',
                   'inc1','inc23','inc4','inc5','inc6',
                   'farm2','farm3','farm4','cclake')
for (r1 in 1 : 10){
  drawbetas<- betas
  drawbetas$Betas <- as.vector(rmvnorm(1,mean = betas$Betas, sigma = varcov_m))
  draws[r1, ] <- drawbetas$Betas
}
draws

as.vector(dat_m %*% new_beta2)
wld_rp
draws[1,"pay"]
newbetas <- draws[1,]
newbetas["pay"]
new_beta2 <- c(0,0,0,0,newbetas[5:15],0)
dat_m %*% new_beta2
n_draws <- 10000
wta_wld <- -(wld_rp + as.vector(dat_m %*% new_beta2) )/ pay_rp 
wta_wld
mean(wta_wld, na.rm = TRUE)
plot(density(wtp_wld))
wta_wld



################## FOR WHOLE SAMPLE
#set.seed(123456)
R <- 10
n <- dim(dataset)[1]
n

WLD_WTA_ALL <- matrix(NA, nrow = n, ncol = 3)
colnames(WLD_WTA_ALL) <- c("MEAN", "CI_L","CI_U")

for (i in 1:n){
  wta_vec <- vector (length = R)
  draws <- matrix (NA,nrow = R, ncol = 16)
  colnames(draws)<-c('wetlands','pay','cc','nm','asc','dfl','costtax',
                     'inc1','inc23','inc4','inc5','inc6',
                     'farm2','farm3','farm4','cclake')
  set.seed(4008)
  for (r1 in 1 : R){
    drawbetas<- betas
    drawbetas$Betas <- as.vector(rmvnorm(1,mean = betas$Betas, sigma = varcov_m))
    draws[r1, ] <- drawbetas$Betas
  }
  
  for (r in 1 : R){
    newbetas <- draws[r,]
    pay_rp <- newbetas["pay"]
    wld_rp <- newbetas["wetlands"]
    ## individual-specific parameters
    new_beta2<- c(0,0,0,0,newbetas[5:15],0)
    dat_s <- dat0[i,]
    dat_s_m <- as.matrix(x = dat_s, nrow = 1, ncol = 16)  
    wta_vec[r] <- -(wld_rp + as.vector(dat_s_m %*% new_beta2)) / pay_rp 
  }
  WLD_WTA_ALL[i,1] <- mean(wta_vec,na.rm = TRUE)
  WLD_WTA_ALL[i,2] <- quantile(wta_vec, 0.025,na.rm = TRUE)
  WLD_WTA_ALL[i,3] <- quantile(wta_vec, 0.975,na.rm = TRUE)
}
WLD_WTA_ALL



#sample average value 
WLD_mean <- mean(WLD_WTA_ALL[,1])
WLD_CIL <- mean(WLD_WTA_ALL[,2])
WLD_CIU <- mean(WLD_WTA_ALL[,3])
WLD_mean
WLD_CIL
WLD_CIU