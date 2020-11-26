rm(list = ls())
library(dplyr)
#install.packages("ggpubr")
#library(ggpubr)

setwd("C:/Users/langzx/Desktop/github/DCM/survey/data")
#setwd("~/Documents/github/DCM/survey/data")
#data <- read.csv(file='merged_cluster.csv')
data <- read.csv(file='merged_cluster_0504.csv')
cluster <- factor(data$Cluster)
c0 <- data[data$Cluster == 0,]
c1 <- data[data$Cluster == 1,]
c2 <- data[data$Cluster == 2,]
colnames(data)

n <- 10
mydata <- data %>% select(last_col(offset=0:(n-1), everything()))
head(mydata)
mydata$Cluster <- factor(mydata$Cluster)
mydata$Cluster 
res.ftest <- var.test(social ~ Cluster, data = mydata)
res.ftest


tables_summary <- mydata %>% group_by(Cluster) %>% 
  summarise_at(.vars = names(.)[2:10],
               .funs = c(Mean="mean", Sd="sd"))

tables_summary
write.csv(tables_summary, 'cluster_factorsummary.csv', row.names = FALSE)

intend = read.csv("int_pred.csv")
tables_summary_intend <- intend %>% group_by(cluster) %>% 
  summarise_at(.vars = names(.)[1:3],
               .funs = c(Mean="mean", Sd="sd"))

tables_summary_intend
#a paired sample t-test
pairwise.t.test(data$social, cluster, p.adj = "bonf")
pairwise.t.test(data$appreciate, cluster, p.adj = "bonf")
pairwise.t.test(data$past, cluster,p.adj = "bonf")
pairwise.t.test(data$aware, cluster,p.adj = "bonf")
pairwise.t.test(data$norm_control, cluster, p.adj = "bonf")
pairwise.t.test(data$comp, cluster,p.adj = "bonf")
pairwise.t.test(data$att_nm_unfav, cluster,p.adj = "bonf")
pairwise.t.test(data$att_wld_unfav, cluster,p.adj = "bonf")
pairwise.t.test(data$concern, cluster,p.adj = "bonf")
pairwise.t.test(data$mean_wld, cluster, p.adj = "bonf")
pairwise.t.test(data$mean_cc, cluster, p.adj = "bonf")
pairwise.t.test(data$mean_nm, cluster, p.adj = "bonf")

pairwise.t.test(data$costlive, cluster, p.adj = "bonf")
pairwise.t.test(data$taxcost, cluster, p.adj = "bonf")
pairwise.t.test(data$impstrea, cluster, p.adj = "bonf")
pairwise.t.test(data$impwetl, cluster, p.adj = "bonf")


library(data.table)
c0$mean_wld
c0.gender = table(c0$gender);c1.gender = table(c1$gender); c2.gender = table(c2$gender)

c2.gender['3']=0



gender01 = rbind(c0.gender,c1.gender)
gender02 = rbind(c0.gender,c2.gender)
gender12 = rbind(c1.gender,c2.gender)

gender01

chisq.test(gender01)
chisq.test(gender02)

chisq.test(gender12)

c0.age = table(c0$age);c1.age = table(c1$age); c2.age = table(c2$age)
c0.age['1']=0; c2.age['1']=0
age01 = rbind(c0.age,c1.age)
age02 = rbind(c0.age,c2.age)
age12 = rbind(c1.age,c2.age)

age02[,c(1,2,3)]

chisq.test(age01)
chisq.test(age02[,c(1,2,3)])
chisq.test(age12)

c0.education = table(c0$education);c1.education = table(c1$education); c2.education = table(c2$education)

education01 = rbind(c0.education,c1.education)
education02 = rbind(c0.education,c2.education)
education12 = rbind(c1.education,c2.education)

chisq.test(education01)
chisq.test(education02)
chisq.test(education12)


c0.income = table(c0$income);c1.income = table(c1$income); c2.income = table(c2$income)
c0.income['6'] = 0;c0.income['7'] = 0
income01 = rbind(c0.income,c1.income)
income02 = rbind(c0.income,c2.income)
income12 = rbind(c1.income,c2.income)

chisq.test(income01)
chisq.test(income02)
chisq.test(income12)

c0.incomefarming = table(c0$incomefromfarming);c1.incomefarming = table(c1$incomefromfarming); c2.incomefarming= table(c2$incomefromfarming)

fromfarming01 = rbind(c0.incomefarming ,c1.incomefarming )
fromfarming02 = rbind(c0.incomefarming ,c2.incomefarming )
fromfarming12 = rbind(c1.incomefarming ,c2.incomefarming )
chisq.test(fromfarming01)
chisq.test(fromfarming02)
chisq.test(fromfarming12)

c0.area = table(c0$landarea); c1.area = table(c1$landarea);c2.area = table(c2$landarea)
area01 = rbind(c0.area,c1.area)
area02 = rbind(c0.area,c2.area)
area12 = rbind(c1.area,c2.area)
chisq.test(area01)
chisq.test(area02)
chisq.test(area12)

data$majorityland
c0.majorland = table(c0$majorityland); c1.majorland = table(c1$majorityland);c2.majorland = table(c2$majorityland)
majorland01 = rbind(c0.majorland,c1.majorland)
majorland02  = rbind(c0.majorland,c2.majorland)
majorland12 = rbind(c1.majorland,c2.majorland)

chisq.test(majorland01)
chisq.test(majorland02)
chisq.test(majorland12)

c0.rotation = table(c0$primaryrotation);c1.rotation = table(c1$primaryrotation);c2.rotation = table(c2$primaryrotation);
rotation02 = rbind(c0.rotation,c2.rotation)
c0.rotation['6'] = 0;c2.rotation['6'] = 0
rotation01 = rbind(c0.rotation,c1.rotation)
rotation12 = rbind(c1.rotation,c2.rotation)

chisq.test(rotation01)
chisq.test(rotation02)
chisq.test(rotation12)


c0.region = table(c0$Region_y);c1.region = table(c1$Region_y);c2.region = table(c2$Region_y)
region01 = rbind(c0.region,c1.region) 
region02 = rbind(c0.region,c2.region) 
region12 = rbind(c1.region,c2.region) 

chisq.test(region01)
chisq.test(region02)
chisq.test(region12)


chisq.test(rbind(res.fair,res.bias))

pairwise.chisq.test(data$gender, cluster)

attach(airquality)
Month <- factor(Month, labels = month.abb[5:9])
pairwise.t.test(Ozone, Month)
detach()
