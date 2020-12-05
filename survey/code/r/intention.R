rm(list = ls())
library(dplyr)
library(ResourceSelection)
setwd("C:/Users/langzx/Desktop/github/DCM/survey/data")
intdata = read.csv ("intention.csv")
dim(intdata)
wld = ifelse(intdata$ï..wld_open == 1, 1, 0 )
head(wld)
cc = ifelse(intdata$cc_open == 1, 1, 0 )
nm = ifelse(intdata$nm_open == 1, 1, 0 )
scores = read.csv ("scoresall_0501.csv")
names(scores)
scores['wld'] = factor(wld); scores['cc']= factor(cc); scores['nm'] = factor(nm)
names(scores)
scores$wld
dim(scores)
wldlogit <- glm(wld ~ concern + att_wld_unfav + comp + norm_control+
                 aware + past + appreciate + social,.^2, data = scores, family = "binomial")

dependent = scores
datawld = select(scores,-c('cc','nm','id') )

d = glm( wld ~ .^2, data=datawld, family = "binomial")
summary(d)
summary(wldlogit)
formula(wldlogit)
anova(d,wldlogit, test ="Chisq")

nullmod <- glm(wld~1, family="binomial",data = scores)

G2 = wldlogit$null.deviance-wldlogit$deviance; G2
1-pchisq(G2,df=1)



wldlogit$deviance
library(lrtest)
1-logLik(wldlogit)/logLik(nullmod)
anova(wldlogit, nullmod, test ="Chisq")
hoslem.test(scores$wld, fitted(wldlogit),g=5)



int_wld = predict(wldlogit, scores, type="response")
int_wld


cclogit <- glm(cc ~ concern + comp + norm_control+
                  aware + past + appreciate + social, data = scores, family = "binomial")
summary(cclogit)
nullmod <- glm(cc~1, family="binomial",data = scores)
1-logLik(cclogit)/logLik(nullmod)
anova(cclogit, test = "Chisq")

int_cc = predict(cclogit, scores, type="response")
int_cc

nmlogit <- glm(nm ~ concern + att_nm_unfav + comp +  norm_control +
                 aware + past + appreciate + social, data = scores, family = "binomial")
summary(nmlogit) 

nullmod <- glm(nm~1, family="binomial",data = scores)
1-logLik(nmlogit)/logLik(nullmod)



int_nm = predict(nmlogit, scores, type="response")
int_nm




clusterdata <- read.csv(file='merged_cluster.csv')
dim(clusterdata)
cluster <- factor(clusterdata$Cluster)
scores['cluster'] = cluster

int_pred = as.data.frame(cbind(int_wld,int_cc,int_nm))
int_pred['cluster'] = cluster

c0 <- scores[scores$cluster == 0,]
c1 <- scores[scores$cluster == 1,]
c2 <- scores[scores$cluster == 2,]

library(data.table)
c0$wld
c0.wld = table(c0$wld);c1.wld = table(c1$wld); c2.wld = table(c2$wld)
wld01 = rbind(c0.wld,c1.wld)
wld02 = rbind(c0.wld,c2.wld)
wld12 = rbind(c1.wld,c2.wld)
prop.table(wld01, 1)
prop.table(wld02, 1)
prop.table(wld12, 1)

chisq.test(wld01)
chisq.test(wld02)
chisq.test(wld12)

c0$cc
c0.cc = table(c0$cc);c1.cc = table(c1$cc); c2.cc = table(c2$cc)
cc01 = rbind(c0.cc,c1.cc)
cc02 = rbind(c0.cc,c2.cc)
cc12 = rbind(c1.cc,c2.cc)
prop.table(cc01, 1)
prop.table(cc02, 1)
prop.table(cc12, 1)


chisq.test(cc01)
chisq.test(cc02)
chisq.test(cc12)

c0$nm
c0.nm = table(c0$nm);c1.nm = table(c1$nm); c2.nm = table(c2$nm)
nm01 = rbind(c0.nm,c1.nm)
nm02 = rbind(c0.nm,c2.nm)
nm12 = rbind(c1.nm,c2.nm)
chisq.test(nm01)
chisq.test(nm02)
chisq.test(nm12)


prop.table(nm01, 1)
prop.table(nm02, 1)
prop.table(nm12, 1)

int_pred$cluster
pairwise.t.test(int_pred$int_wld, cluster, p.adj = "bonf")
pairwise.t.test(int_pred$int_cc, cluster, p.adj = "bonf")
pairwise.t.test(int_pred$int_nm, cluster, p.adj = "bonf")

write.csv(x = int_pred, file = "int_pred.csv", row.names = FALSE)

library(dplyr)
group_by(s, cluster) %>% mutate(percent = value/sum(value))
