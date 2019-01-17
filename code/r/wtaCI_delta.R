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
betas
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
R = 1000
se_vector <- length (R)
n_draws <- 1000

for (r in 1:R){
  theta_k <- rexp(rate = 1, n = n_draws)
  theta_c <- rexp(rate = 1, n = n_draws)
  theta_M <- cbind(theta_k,theta_c)
  theta_cov <- cov(theta_M) 
  b_k <- mean((wld_rp * theta_k  + as.vector(dat_m %*% beta2)))
  b_c <- mean((pay_rp * theta_c))
  term1 <- -b_k/b_c
  term2 <- b_k/b_c 
  Matrix_r <- as.matrix(c(term1, term2),nrow = 2,ncol = 1)
  se_m <- sqrt((t(Matrix_r)%*% theta_cov %*% Matrix_r))
  se_vector [r] <- se_m
}
#
se_vector
#z_k <- rnorm(n_draws)
#z_c <- rnorm(n_draws)

theta_cov
# 
cv_matrix <- matrix(data = rep(0,36),nrow = 6, ncol = 6)
cv_matrix
cv_matrix[1:4,1:4]<- theta_cov
cv_matrix[5:6,5:6]<- diag(2)
cv_matrix

b_k <- mean((wld_rp * theta_k  + as.vector(dat_m %*% beta2)))
b_c <- mean((pay_rp * theta_c))
b_c

term1 <- -b_k/b_c
term2 <- b_k/b_c 
term2
term3 <- -1/(sqrt(3) + mean(z_k)) * (1/b_c)
term4 <- 1/(sqrt(3) + mean(z_c))* (1/b_c) * (b_k/b_c)
Matrix_r <- as.matrix(c(term1, term2,term3,term4),nrow = 2,ncol = 1)
dim(Matrix_r)
Matrix_r
theta_M <- cbind(theta_k,theta_c,z_k,z_c)
theta_cov <- cov(theta_M)

t(Matrix_r)%*% theta_cov
t(Matrix_r)%*% theta_cov %*% Matrix_r

se_m <- sqrt((t(Matrix_r)%*% theta_cov %*% Matrix_r))
se_m


wta_wld1 <- -(wld_rp * rexp(rate = 1, n = n_draws) + as.vector(dat_m %*% beta2)) / pay_rp * rexp(rate = 1, n = n_draws)
mean(wta_wld, na.rm = TRUE)
plot(density(wtp_wld))
wta_wld


exp1 <- rexp(n=1000,rate = 1)

exp2 <- rexp (n = 1000, rate = 1)

M <- cbind(exp1,exp2)
M
cov(M)
