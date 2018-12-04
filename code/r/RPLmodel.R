
rm(list = ls())
library(mlogit)
library(gmnl)
library(tidyverse)
library(fastDummies)
setwd("C:/Users/langzx/Desktop/github/DCM/data")
dataset <- read.csv (file = "wta_observables12032018.csv",header = TRUE)
dim(dataset)
colnames(dataset)


dataset1 <- mlogit.data(dataset, varying = 6:43, shape = "long",
                        choice = "Y", alt.levels = c("V", "C"), id.var = "id")

#simple MNL to serve as a check

mnl.gmnl <- gmnl(Y ~  Payment + Wetland + Covercrop + NuMgt, data = dataset1, model = "mnl")
summary(mnl.gmnl)
wtp.gmnl(mnl.gmnl, wrt = "Payment")

############ Replicate the RPL results from Nlogit 
# ;Pds = 8
# ;rpl = lake1000 
# ;Pts = 1000 
# ;fcn=  wetland[l],pay[l], covercro(n) 
# ;Halton
# ;Model:
#   U(VolCons) = asc + pay*Payment + wetland*negWetl + covercro*CC + dems18*dem_2018 + incfarm*FARMINC 
# /  U(Current) = 0
#
set.seed(123)
dataset1$scaleimplakes <- dataset1$implakes / 1000
dataset1$negWetland <- -1 * dataset1$Wetland 

nlogit_rpl.gmnl <- gmnl(Y ~ Payment + negWetland + Covercrop| 
                   dem_2018  + incfar|
                   0|
                 scaleimplakes, 
                 data = dataset1,
                 model = 'mixl',
                 R = 20,
                 panel = TRUE,
                 ranp = c(negWetland = "ln", Covercrop = "n", Payment = "ln"),
                 mvar = list(Covercrop = "scaleimplakes"),
                 correlation = TRUE)
summary(nlogit_rpl.gmnl)

################  RPL 
set.seed(1000)
rpl.gmnl <- gmnl(Y ~ Payment + negWetland + Covercrop| 
                dem_2018  +  foodcost +  
                  incfar_1 + incfar_2 + incfar_3 + incfar_4 +
                  areaf_1 + areaf_2 + areaf_3 + areaf_4  |
                  0|
                  scaleimplakes + incfar_5 + costlive, 
                 data = dataset1,
                 model = 'mixl',
                 R = 20,
                 panel = TRUE,
                 ranp = c(negWetland = "ln", Covercrop = "n", Payment = "ln"),
                 mvar = list(Covercrop = "scaleimplakes",
                            Payment = c("incfar_5","costlive")),
                 correlation = TRUE)
summary(rpl.gmnl)
