rm(list = ls())
setwd("C:/Users/langzx/Desktop/github/DCM/survey/data")
library(psych)
library(FactoMineR)
library(dplyr) 
library(tidyverse)
library(fastDummies)
library(sem)
library(factoextra)
library(lavaan)
library(likert)
library(missMDA)
library(corrplot)
library(polycor)
library(semPlot)
#################
# factor analysis results

fa_dat <- read.csv( "wta_04112020.csv", header= TRUE)
cluster_data <- read.csv("fscore_04112020_cluster.csv")
names(cluster_data)
df_cluster <- select (cluster_data, c(id, Cluster))
dfcluster_dummy <- dummy_cols(df_cluster, select_columns = "Cluster")
head(dfcluster_dummy)
dim(fa_dat)
dat00 <- left_join(fa_dat,dfcluster_dummy)
write.csv(x = dat00, file= "wta_04122020.csv", row.names = FALSE)
dim(dat00)
##############






names(fa_dat)
fscore <- select(fa_dat, c(id,aware,past,appreciate, resp))
df_fscore <- distinct(fscore)
dim(df_fscore)
write.csv(x=df_fscore, file = "fscore_04112020.csv", row.names = FALSE)
scores <- select(df_fscore, -id)
multi.hist(scores)

#############factor analysis EFA& CFA
dat <- read.csv ("data_likertscale.csv", head = TRUE)
dat$id
p_data <- read.csv("../../data/wta_factors04112020.csv", head = TRUE)
head(dat)
dim(dat)
dat_dich <- read.csv ("data_binaryscale.csv", head = TRUE)
dim(dat_dich)

df <- dat[,2:53]
nrow(na.omit(df))
colSums(is.na(df))

df_dich <- dat_dich[,2:42]
nrow(na.omit(df_dich))
colSums(is.na(df_dich))


data_dich <- df_dich %>% mutate_if(is.numeric,as.factor)
nb = estim_ncpMCA(data_dich,ncp.max=2)
tab.disj_dich = imputeMCA(data_dich, ncp=4)$tab.disj
res.mca = MCA(data_dich,tab.disj=tab.disj_dich)
impute_df_dich = imputeMCA(data_dich, ncp=4)$completeObs
write.csv(x = impute_df_dich, file = 'factorDICH_impute.csv', row.names = FALSE)

het.mat <- hetcor(impute_df_dich)$cor
corrplot(cor(het.mat))
fa.parallel(het.mat)
scree(het.mat)
DICH_fa4_EFA <- fa(het.mat, nfactor = 4,rotate = "varimax")
DICH_fa4_EFA$loadings
DICH_fa4_EFA$score.cor
poorloading_DICH <- c('otherswetland', 'otherscovercrop','othersnm',
                      'nowcrp','noweqip','nowfcsv','nowcsp',
                      'practicegd','practicemintill','practicerb','practicerp')


dep_var <- select(impute_df_dich , c('practicegd','practicemintill','practicerb','practicerp')) %>% mutate_if(is.factor,as.numeric)


dep_eng <- dep_var %>% mutate(practicegd = ifelse(practicegd==2, 1,0),
                   practicemintill = ifelse(practicemintill==2, 1,0),
                   practicerb = ifelse( practicerb ==2,1,0),
                   practicerp = ifelse( practicerp ==2,1,0))

practice_indicator <- apply(dep_eng, 1, sum)
practice_indicator1 <- ifelse(practice_indicator>0, 1, 0)
describe(practice_indicator)


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
summary(bq_cfa, standardized = T, fit.measures = T)



csat_scores <- as.data.frame(predict(bq_cfa)) %>% mutate (practice_ind = practice_indicator1)
names(csat_scores )
dim(csat_scores)
fit <- glm(practice_ind~aware+past+appreciate+resp,data=csat_scores, family = binomial())
summary(fit)
pra_predict <- as.vector(predict(fit))
csat_scores <- csat_scores %>% mutate(id =dat$id, prac_pred = pra_predict)
dim(p_data)
dim(csat_scores)
names(p_data)
names(csat_scores)
new_p_data <-left_join(p_data,csat_scores)
names(new_p_data)
dim(new_p_data)
write.csv(x = new_p_data, file = "wta_04112020.csv", row.names = FALSE)

data <- df %>% mutate_if(is.numeric,as.factor)
nb = estim_ncpMCA(data,ncp.max=2)
tab.disj = imputeMCA(data, ncp=4)$tab.disj
res.mca = MCA(data,tab.disj=tab.disj)
impute_df = imputeMCA(data, ncp=4)$completeObs
write.csv(x = impute_df, file = 'factor_impute.csv', row.names = FALSE)


names(impute_df)

describe(impute_df)

df_likert <-  as.data.frame(impute_df) %>%
  mutate_if(is.integer,
            as.factor) %>%
  likert()

df_num <- impute_df%>% mutate_if(is.factor,as.numeric)

corrplot(cor(df_num))

fa.parallel(df_num)

scree(df_num)

fa4_EFA <- fa(df_num, nfactor = 4)
fa4_EFA$loadings
fa4_EFA$e.values
fa4_EFA$score.cor

poorloadings <- c('valundueblame','vallandregulate',
                  'valpaymentimportant','valinfluence','pollutionobs',
                  'opwetlandequipment','opnmis','opwetlandopen',
                  'opwetlandrestored','opcovercropplant',
                  'opnmopen','opcovercropopen',
                  'valknowconservation', 'valwaterimportant', 'valtogether',
                   'familiar25' )

library(car)
df_se <- select(df_num, -poorloadings)
dim(df_num)
names(df_num)
df_se <- df_num[,1:15]
df_num<-scale(df_num)

fa.parallel(df_num)
fa3_EFA <- fa(df_se, nfactor = 2)
fa3_EFA$loadings

fa2_EFA$score.cor


fa2_CFAmodel <- 'awareproblem =~ scenicconcern + scenicmoderate + nutrientconcern + nutrientmoderate + nutrientmajor +
habitatconcern + habitatmoderate + habitatmajor + sedimentconcern + sedimentmoderate + sedimentmajor + recreationconcern +recreationmoderate +
recreationmajor  + valundueblame + vallandregulate + valwaterproblem + valinfluence 
knowledge =~ valknowconservation + valwaterimportant +  valtogether + valstaff + valsteward'
fa_cfa <- cfa(model = fa2_CFAmodel,
              data = df_se, estimator = 'MLR')
summary(fa_cfa, standardized = T, fit.measures = T)
