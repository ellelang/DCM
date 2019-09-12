rm(list = ls())
library(tidyverse)
setwd("C:/Users/langzx/Desktop/github/DCM")
mrbcounties <- read.csv ("data/MRBcountiesGEO.csv")
wta_sim <- read.csv ("data/wtas_county428.csv")
wta_counties <- wta_sim$County
MRB_counties <- mrbcounties$NAME

wta_counties[-which(wta_counties %in% MRB_counties)]
MRB_countries[-which(MRB_counties %in% wta_counties )]

