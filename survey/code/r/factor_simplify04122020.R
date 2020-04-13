rm(list = ls())
setwd("C:/Users/langzx/Desktop/github/DCM/survey/data")
library(psych)
library(FactoMineR)
library(dplyr) 
library(tidyverse)
library(fastDummies)
library(corrplot)
library(polycor)
library(lavaan)
library(semPlot)
impute_df_dich <- read.csv('factorDICH_impute.csv')
dim(impute_df_dich)
het.mat <- hetcor(impute_df_dich)$cor
corrplot(cor(het.mat))
fa.parallel(het.mat)
scree(het.mat)
DICH_fa4_EFA <- fa(het.mat, nfactor = 4,rotate = "varimax")
DICH_fa4_EFA$loadings
DICH_fa4_EFA$score.cor
fa.diagram(DICH_fa4_EFA)
poorloading_DICH <- c('otherswetland', 'otherscovercrop','othersnm',
                      'nowcrp','noweqip','nowfcsv','nowcsp',
                      'practicegd','practicemintill','practicerb','practicerp')

dich_se <- select(impute_df_dich , -poorloading_DICH) %>% mutate_if(is.factor,as.numeric)

het.mat <- hetcor(dich_se)$cor
corrplot(cor(het.mat))
fa.parallel(het.mat)
scree(het.mat)
fa4_EFA_dich <- fa(het.mat, nfactor = 4,rotate = "varimax")
fa4_EFA_dich$loadings

f_4_CFAmodel <- 'aware =~ obssediment + obsnutrients + obsodor + obstrash + obslackfish + obsunsafeswim + obscolor + obsunsafedrink 
past =~ pastcrp + pastfcp + pastmci + pastlongterm + pastgcdt + pastgcsv 
appreciate =~ acfish + acswim + acexplore + ackayak + achunt + achike + acbike + acpicnic + achorseride + acgooffroading
resp =~ sptlandowners + sptfarmmanager + sptrenters + sptgovstaff + sptmrbboard'

bq_cfa <- cfa(model = f_4_CFAmodel,
              data = dich_se)

semPaths(object = bq_cfa,
         whatLabels = "std",
         edge.label.cex = 1)

summary(bq_cfa, standardized = T, fit.measures = T)
csat_scores <- as.data.frame(predict(bq_cfa)) %>% mutate (practice_ind = practice_indicator1)
names(csat_scores )
dim(csat_scores)
fit <- glm(practice_ind~aware+past+appreciate+resp,data=csat_scores, family = binomial())
summary(fit)
pra_predict <- as.vector(predict(fit))