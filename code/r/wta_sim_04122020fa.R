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
betas <- read.table("betas04122020.txt", sep = "\t", header = TRUE)
varcov <- read.table("varscov04122020.txt", sep = "\t", header = FALSE)


dim(varcov)
varcov_m <- as.matrix(varcov, nrow = 21, ncol = 21)
varcov_m 
length(betas$Names)
betas$Betas
betas$Names
rmvnorm(1,mean = betas$Betas, sigma = varcov_m)
sigma = varcov_m
sigma <- make.positive.definite(sigma, tol=1e-3)
mean = betas$Betas
rmvnorm(1, mean = mean, sigma = sigma,
        method=c("eigen", "svd", "chol"), pre0.9_9994 = FALSE)

rtmvnorm(1, mean = mean, sigma = sigma)
nn <- make.positive.definite(sigma)         
         
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
                areaf_1, areaf_2, areaf_3, areaf_4, aware, past, appreciate, resp,lake1000, lake1000)
dim(dat0)
isSymmetric(varcov_m )
############INDIVIDUAL WTA estimate EXAMPLE
draws <- matrix (NA,nrow = 10, ncol = 21)
colnames(draws)<-c('wetland','pay','cc','nm','asc','dfl','costtax',
                   'incfarm1','incfarm23','incfarm4','incfarm5','incfarm6',
                   'farmsi1','farmsi2','farmsi3','fscaware','fscpast','fscapp','fscresp','plake','clake')
dim(varcov_m)
for (r1 in 1 : 10){
  drawbetas<- betas
  drawbetas$Betas <- as.vector(rmvnorm(1,mean = betas$Betas, sigma = varcov_m))
  draws[r1, ] <- drawbetas$Betas
}

draws
