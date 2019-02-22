rm(list = ls())
library(uwIntroStats)
library(tidyverse)
library(mvtnorm)
setwd("C:/Users/langzx/Desktop/github/DCM/data")
dataset <- read.csv (file = "wta_observables11192018.csv",header = TRUE)
dim(dataset)
n <- dim(dataset)[1]
dataset$asc <- rep(1,n )
dataset$lake1000 <- dataset$implakes/1000
colnames(dataset)
betas <- read.table("beta0208.dat", sep = ",", header = TRUE)
varcov <- read.table("varcov0208.dat", sep = "\t", header = FALSE)
dim(varcov)
varcov_m <- as.matrix(varcov, nrow = 18, ncol = 18)
varcov_m 
betas$Names
betas$Betas

newbetas<- betas
#newbetas$Betas <- as.vector(rmvnorm(1,mean = betas$Betas, sigma = varcov_m))
descrip(dataset)
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
length(newbetas$Names)

## fixed parameters
#new_beta2<- c(0,0,0,0,newbetas$Betas[5:17],0)



dat0 <- select (dataset, Wetland, Payment, Covercrop, NuMgt, asc, 
                dfl08to18,taxcost, 
                income_1, income_2, income_3, income_4, income_5, income_6,
                areaf_1, areaf_2, areaf_3, areaf_4, lake1000)

dat11<-select (dataset, Wetland, Payment, Covercrop, NuMgt, asc, 
               dfl08to18,taxcost, 
               income_1, income_2, income_3, income_4, income_5, income_6,
               areaf_1, areaf_2, areaf_3, areaf_4, lake1000,County_resident)


groupdata <- dat11 %>%
  group_by(County_resident) %>%
  summarize_at(vars(-County_resident),funs(mean(., na.rm=TRUE)))


groupdataselect <- select (groupdata, Wetland, Payment, Covercrop, NuMgt, asc, 
                           dfl08to18,taxcost, 
                           income_1, income_2, income_3, income_4, income_5, income_6,
                           areaf_1, areaf_2, areaf_3, areaf_4, lake1000)

groupdataselect_s_m <- as.matrix(x = groupdataselect, nrow = 1, ncol = 18) 
groupbeta <- betas$Betas
groupbeta[1:4] <- c(0,0,0,0)
countylevel <- groupdataselect_s_m %*% as.vector(groupbeta)

write.csv(x = groupdataselect, file = "groupcountydata221.csv", row.names = FALSE)
mean_wld <- 407.49

mean_cc <- 7.04

mean_nm <- 118.08


county_wld <- mean_wld + countylevel
county_cc <- mean_cc + countylevel
county_nm <- mean_nm + countylevel
County <- as.vector (groupdata$County_resident)
countyleveldata <- cbind (county_wld, county_cc, county_nm)
countyleveldata
colnames(countyleveldata) <- c('wetland','cc','nm')
countyleveldata<- as.data.frame(countyleveldata)
countyleveldata
countyleveldata$county <- groupdata$County_resident
countyleveldata
write.csv(x = countyleveldata, file= "219countylevelwta.csv", row.names = FALSE)

## individual sample 
dat1 <- sample_n(dat0, 1)
dat1
dat_m <- as.matrix(x = dat1, nrow = 1, ncol = 18)  
dat_m

############INDIVIDUAL WTA estimate EXAMPLE
draws <- matrix (NA,nrow = 10, ncol = 18)
colnames(draws)<-c('wetland','pay','cc','nm','asc','dfl','costtax',
                   'inc1','inc2','inc3','inc4','inc5','inc6',
                   'farm1','farm2','farm3','farm4','cclake')
for (r1 in 1 : 10){
  drawbetas<- betas
  drawbetas$Betas <- as.vector(rmvnorm(1,mean = betas$Betas, sigma = varcov_m))
  draws[r1, ] <- drawbetas$Betas
}



draws

draws[1,"pay"]
newbetas <- draws[1,]
newbetas["pay"]
newbetas[5:17]
n_draws <- 10000
wta_wld <- -(wld_rp * rexp(rate = 1, n = n_draws) + as.vector(dat_m %*% new_beta2)) / pay_rp * rexp(rate = 1, n = n_draws)
mean(wta_wld, na.rm = TRUE)
plot(density(wtp_wld))
wta_wld

################## FOR WHOLE SAMPLE
#set.seed(123456)
R <- 1000
n <- dim(dataset)[1]
t <- 8
s<- 441
index <- seq(1, n, by=16) 
length(index)
n_draws <- 1000

wta_vec <- vector (length = 10)
wta_vec
##########wld wta



WLD_WTA_ALL <- matrix(NA, nrow = s, ncol = 3)
colnames(WLD_WTA_ALL) <- c("MEAN", "CI_L","CI_U")

for (i in 1:s){
  wta_vec <- vector (length = R)
  draws <- matrix (NA,nrow = R, ncol = 18)
  colnames(draws)<-c('wetland','pay','cc','nm','asc','dfl','costtax',
                     'inc1','inc2','inc3','inc4','inc5','inc6',
                     'farm1','farm2','farm3','farm4','cclake')
  set.seed(4008)
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
    new_beta2<- c(0,0,0,0,newbetas[5:17],0)
    index_i <- index [i]
    dat_s <- dat0[i,]
    dat_s_m <- as.matrix(x = dat_s, nrow = 1, ncol = 18)  
    wta_s <- -(wld_rp * rexp(rate = 1, n = n_draws) + as.vector(dat_s_m %*% new_beta2)) / pay_rp 
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
  draws <- matrix (NA,nrow = R, ncol = 18)
  colnames(draws)<-c('wetland','pay','cc','nm','asc','dfl','costtax',
                     'inc1','inc2','inc3','inc4','inc5','inc6',
                     'farm1','farm2','farm3','farm4','cclake')
  set.seed(5008)
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
    new_beta2<- c(0,0,0,0,newbetas[5:17],0)
    index_i <- index[i]
    dat_s <- dat0[i,]
    dat_s_m <- as.matrix(x = dat_s, nrow = 1, ncol = 18)  
    wta_s <- -((cc_rp + lake_rp )* rexp(rate = 1, n = n_draws) + as.vector(dat_s_m %*% new_beta2)) / pay_rp
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
  draws <- matrix (NA,nrow = R, ncol = 18)
  colnames(draws)<-c('wetland','pay','cc','nm','asc','dfl','costtax',
                     'inc1','inc2','inc3','inc4','inc5','inc6',
                     'farm1','farm2','farm3','farm4','cclake')
  
  set.seed(6008)
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
    new_beta2<- c(0,0,0,0,newbetas[5:17],0)
    index_i <- index[i]
    dat_s <- dat0[i,]
    dat_s_m <- as.matrix(x = dat_s, nrow = 1, ncol = 18)  
    wta_s <- -(nm_rp * rexp(rate = 1, n = n_draws) + as.vector(dat_s_m %*% new_beta2)) / pay_rp
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
write.csv (x = WLD_WTA_ALL, file = "WLD_wta_0214.csv", row.names = FALSE)
write.csv (x = CC_WTA_ALL, file = "CC_wta_0214.csv", row.names = FALSE)
write.csv (x = NM_WTA_ALL, file = "NM_wta_0214.csv", row.names = FALSE)


WLD_mean
WLD_CIL
WLD_CIU

CC_mean
CC_CIL
CC_CIU

NM_mean
NM_CIL
NM_CIU
