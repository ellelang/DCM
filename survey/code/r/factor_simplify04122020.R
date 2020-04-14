rm(list = ls())
#setwd("C:/Users/langzx/Desktop/github/DCM/survey/data")
setwd("~/Documents/github/DCM/survey/data")
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
dim(dich_se)
het.mat <- hetcor(dich_se)$cor

png("../plot/corrplot.png")
corrplot(cor(het.mat))
dev.off()
fa.parallel(het.mat)
png("../plot/screeplot.png")
scree(het.mat)
dev.off()
fa4_EFA_dich <- fa(het.mat, nfactor = 4,rotate = "varimax")
fa4_EFA_dich$loadings

fa.diagram(fa4_EFA_dich)

f_4_CFAmodel <- 'aware =~ obssediment + obsnutrients + obsodor + obstrash + obslackfish + obsunsafeswim + obscolor + obsunsafedrink 
past =~ pastcrp + pastfcp + pastmci + pastlongterm + pastgcdt + pastgcsv 
appreciate =~ acfish + acswim + acexplore + ackayak + achunt + achike + acbike + acpicnic + achorseride + acgooffroading
resp =~ sptlandowners + sptfarmmanager + sptrenters + sptgovstaff + sptmrbboard'

bq_cfa <- cfa(model = f_4_CFAmodel,
              data = dich_se)

png("../plot/cfaplot.png")
semPaths(object = bq_cfa,
         whatLabels = "std",
         edge.label.cex = 1)
dev.off()
summary(bq_cfa, standardized = T, fit.measures = T)
csat_scores <- as.data.frame(predict(bq_cfa)) %>% mutate (practice_ind = practice_indicator1)
names(csat_scores )
dim(csat_scores)
fit <- glm(practice_ind~aware+past+appreciate+resp,data=csat_scores, family = binomial())
summary(fit)
pra_predict <- as.vector(predict(fit))

#####
library(tidyverse)
library(likert)
impute_df<- read.csv('factor_impute.csv')
diffscales <- c('opwetlandopen',
                  'opwetlandrestored','opcovercropplant',
                  'opnmopen','opcovercropopen' )
likert_data <- select (impute_df, -diffscales)
colnames (likert_data)
ecosy <- likert_data[,1:15]
value <- likert_data[,c(16:25,27)]
names(value)
practice <- likert_data[,28:47]
library(dplyr)
eco_likert <- ecosy %>% mutate_if(is.integer, as.factor) %>% likert()
val_likert <- value %>% mutate_if(is.integer, as.factor) %>% likert()
prac_likert <- practice %>% mutate_if(is.integer, as.factor) %>% likert()

png("../plot/ecolikertplot.png")
plot(eco_likert)
dev.off()

png("../plot/vallikertplot.png")
plot(val_likert)
dev.off()

png("../plot/praclikertplot.png")
plot(prac_likert)
dev.off()
