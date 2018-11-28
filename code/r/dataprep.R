data0 <- read.csv(file = "wholeCEscio_dataset_envinfo_1119.csv", header = TRUE, na.strings=c("","NA"))
# number of respondents
n <- length(unique(data0$id))
# number of choice sets
round <- 8
# number of alternatives 
alter <- 2
dim(data0)[1]
library(tidyverse)
colnames(data0)
head(data0)


id <- data0$id
Y <- data0$Y
cset <- rep(2,n)
task <- data0$ChoiceSet
alti <- rep(c(1,2), times= n * round)
alti



wld <- data0$Wetland
cc <- data0$Covercrop
nm <- data0$NuMgt
pay <- data0$Payment
crent <- data0$cashrental_peracre
votea <- data0$dem_president_2016
voteb <- data0$dem_2018
tax <- data0$av_monthly_Taxes
rlake <- data0$Lake_records
rstream <- data0$Lake_records

gender <- data0$gender
age <- data0$age
edu <- data0$education
area <- data0$landarea
income <- data0$income
incomef <- data0$incomefromfarming
county <- data0$County_resident
county
nlogit_data <- data.frame(cbind(id, Y, cset, task, alti, 
                 wld, cc, nm, pay,
                 crent, demp16, demp18,
                 tax, rlake, rstream,
                 gender, age, edu, area,income, incomef, county))
nlogit_data$county <- data0$County_resident
dim(nlogit_data)
colnames(nlogit_data)
write.csv (x = nlogit_data, file ="dataset_nlogit.csv", row.names = FALSE)
