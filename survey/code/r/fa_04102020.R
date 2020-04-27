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
library(semTools)
#################
# factor analysis results

fa_dat <- read.csv( "wta_04112020.csv", header= TRUE)
cluster_data <- read.csv("fscore_04112020_cluster.csv")
names(cluster_data)
dim(cluster_data)
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

data_dich <- dat_dich[,2:42]
head(data_dich)
df_info <- dat_dich[,43:65]
names(df_info)
nrow(na.omit(df_dich))
colSums(is.na(df_dich))


#data_dich <- df_dich %>% mutate_if(is.numeric,as.factor)
nb = estim_ncpMCA(data_dich,ncp.max=2)
tab.disj_dich = imputeMCA(data_dich, ncp=4)$tab.disj
res.mca = MCA(data_dich,tab.disj=tab.disj_dich)
impute_df_dich = imputeMCA(data_dich, ncp=4)$completeObs
write.csv(x = impute_df_dich, file = 'factorDICH_impute.csv', row.names = FALSE)

tab.disj_dich_info = imputeMCA(df_info, ncp=4)$tab.disj
#res.mca_info = MCA(data_dich,tab.disj=tab.disj_dich_info)
impute_df_dich_info = imputeMCA(df_info, ncp=4)$completeObs
het.mat_info <- hetcor(impute_df_dich_info)$cor
corrplot(cor(het.mat_info))
fa.parallel(het.mat_info)
scree(het.mat_info)
fa_info <- fa(het.mat_info, nfactor = 1,rotate = "varimax")

fa_info$loadings
fa_info$R2.scores
fa_info_alpha <- alpha.ci(het.mat_info)
summary(fa_info_alpha)
splitHalf(het.mat_info)

info_CFAmodel <- 'info_so =~ infonrcs  + infomedian + infoscdc 
+ infovai + infoprivateconsultants + prefercountymeeting + infomedian + preferfielddemo  + prefertelevision + prefermagazines  + preferradio + preferprinted + preferonfarmconsul' 

poorloading_info <- c('infofsa', 'infoces','infoces','infonpo',
                      'infomedial','infospecialists','infosfdealer','infomdealer',
                      'infoneighborfriends','preferinternet','prefervisual','prefertradeshows')

dich_info_se <- select(impute_df_dich_info , -poorloading_info) %>% mutate_if(is.factor,as.numeric)


info_cfa <- cfa(model = info_CFAmodel,
              data = dich_info_se)

reliability(info_cfa )

summary(info_cfa, standardized = T, fit.measures = T)
info_scores <- as.data.frame(predict(info_cfa))
info_scores['id'] = dat_dich$ï..id

f7 <- read.csv(file = "../../data/factors7_0415.csv")
f7 <- left_join(f7, info_scores)
write.csv(x = f7, file = "../../data/factors7_0415.csv", row.names = FALSE)


info<- fa.poly(impute_df_dich_info, nfactor =1, rotate="varimax")
info$loadings
info$scores
####################3

het.mat <- hetcor(impute_df_dich)$cor
splitHalf(het.mat)
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
reliability(bq_cfa)


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

setwd("C:/Users/langzx/Desktop/github/DCM/survey/data")

impute_df <- read.csv("factor_impute.csv")

names(impute_df)

describe(impute_df)

# df_likert <-  as.data.frame(impute_df) %>%
#   mutate_if(is.integer,
#             as.factor) %>%
#   likert()

df_num <- impute_df%>% mutate_if(is.factor,as.numeric)

corrplot(cor(df_num))

fa.parallel(df_num)

scree(df_num)


fa4_EFA <- fa(df_num, nfactor = 4)
fa4_EFA$loadings
fa4_EFA$e.values
fa4_EFA$score.cor
fa4_EFA$scores

poorloadings <- c('pollutionobs',
                  'opwetlandopen',
                  'opwetlandrestored','opcovercropplant',
                  'opnmopen','opcovercropopen'
                    )

# poorloadings <- c('valundueblame','vallandregulate',
#                   'valpaymentimportant','valinfluence','pollutionobs',
#                   'opwetlandequipment','opnmis','opwetlandopen',
#                   'opwetlandrestored','opcovercropplant',
#                   'opnmopen','opcovercropopen',
#                   'valknowconservation', 'valwaterimportant', 'valtogether')




library(car)
df_se <- select(df_num, -poorloadings)
splitHalf(df_se)
#df_se <- select(df_num, -c(alundueblame, vallandregulate,valinfluence,pollutionobs
                           #opwetlandrestored, opcovercropplant,
                           #opnmopen,opwetlandopen,opcovercropopen))
dim(df_num)
dim(df_se)
names(df_num)
#df_se <- df_num[,1:15]
#df_se<-scale(df_se)
dim(df_num)
fa.parallel(df_se)
fa3_EFA <- fa(df_se, nfactor = 3, rotate = "varimax")
fa3_EFA$loadings

fa3_EFA$score.cor



fa3_CFAmodel <- 'concern =~ scenicconcern + scenicmoderate + nutrientconcern + nutrientmoderate + nutrientmajor + habitatconcern + habitatmoderate + habitatmajor + sedimentconcern + sedimentmoderate + sedimentmajor + recreationconcern +recreationmoderate +
recreationmajor + valwaterproblem + valwaterimportant  + valtogether
value =~ valknowconservation +  valsteward + opnmfamiliar + opwetlandfamiliar+ familiar25 + opcovercropfamiliar 
landcontrol =~ valundueblame + opwetlandcostr + opwetlandcontrol + opwetlandcostm + opwetlandsoil + opwetlandhabitat + valstaff +
opcovercroprp + opcovercroptimep +opcovercroptimeh + opcovercroprs + opcovercropis + opcovercropln + opnmrs + opnmrl + opnmis + opnmrf + opnmcost+
vallandregulate+valpaymentimportant + valinfluence + opwetlandequipment  '



fa_cfa <- cfa(model = fa3_CFAmodel,data = df_se)
summary(fa_cfa, standardized = T, fit.measures = T)
library(semTools)
reliability(fa_cfa)


f_scores <- as.data.frame(predict(fa_cfa))
names(f_scores)
daaa <-  read.csv("data_likertscale.csv", head = TRUE)
daaa$id
f_scores['id'] = daaa$id
write.csv(x= f_scores, file = "factorscores_likertlike.csv", row.names = FALSE)

di_fscores <- read.csv("fscore_04112020.csv") 
dim(di_fscores)
names(di_fscores)
all <- read.csv( "wta_04112020.csv")
all_fa <- left_join(all, f_scores)
dim(all_fa)
write.csv(x= all_fa, file = "wta_factorsall_0415.csv", row.names = FALSE)

fscoresall <- left_join (di_fscores, f_scores)
dim(fscoresall)
names(fscoresall)
write.csv(x= fscoresall, file = "factors7_0415.csv", row.names = FALSE)
##############
f_dich <- read.csv("fscore_04112020_cluster.csv")
f_likert <- read.csv("factorscores_likertlike.csv")
dim(f_likert)
f_all <- left_join(f_dich, f_likert) %>% select(-c(Cluster,id))
fa.parallel(f_all)
f_all <- scale(f_all)
fa3_EFA <- fa(f_all, nfactor = 2)
fa3_EFA$loadings
