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
