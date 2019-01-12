
rm(list = ls())
library(uwIntroStats)
library(mlogit)
library(gmnl)
library(tidyverse)
library(imager)
library(xtable)
setwd("C:/Users/langzx/Desktop/github/DCM/data")
dataset <- read.csv (file = "wholeCEscio_dataset_envinfo_1119.csv",header = TRUE)
colnames(dataset)
unique(dataset$County_resident)

sociodata <-  dataset %>% 
  select(gender, age, education, income, landarea) 
  
sociodata1 <- sociodata %>% filter(gender != 3)  

dataset$lake1000 <- dataset$Lake_acres/1000
  
descrip(sociodata)

county <- dataset  %>% 
  select(County_resident,crp2018, dem_2018, av_monthly_Taxes,lake1000,income, landarea) %>% 
  filter (n()>1)

county1 <- county[!duplicated(county), ]
descrip(county)

xtable (des)

pdf("Plots//pie.pdf", width=8, height=8)
par(mfrow=c(1,2))
im1 <- load.image("pieedus.png")
im2 <- load.image("pieinc.PNG")
plot(im1,axes=FALSE)
plot(im2,axes=FALSE)
dev.off()
