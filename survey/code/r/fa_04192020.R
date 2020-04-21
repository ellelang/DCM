rm(list = ls())
setwd("C:/Users/langzx/Desktop/github/DCM/survey/data")
library(psych)
library(FactoMineR)
library(dplyr) 
library(corrplot)
library(polycor)
library(tidyverse)
library(lavaan)
da_dich <- read.csv('factorDICH_impute.csv')
names(da_dich)

N <- nrow(da_dich)
indices <- seq(1, N)
indices_EFA <- sample(indices, floor((.5*N)))
indices_CFA <- indices[!(indices %in% indices_EFA )]

# Use those indices to split the dataset into halves for your EFA and CFA
da_EFA <- da_dich[indices_EFA, ]
da_CFA <- da_dich[indices_CFA, ]

het.mat.efa <- hetcor(da_EFA)$cor
#corrplot(cor(het.mat))
fa.parallel(het.mat.efa)

DICH_fa4_EFA <- fa(het.mat.efa, nfactor = 4,rotate = "varimax")
DICH_fa4_EFA

DICH_fa4_EFA$loadings
DICH_fa4_EFA$score.cor
DICH_fa4_EFA$scores
poorloading_DICH <- c('otherswetland', 'otherscovercrop','othersnm',
                      'nowcrp','noweqip','nowfcsv','nowcsp',
                      'practicegd','practicemintill','practicerb','practicerp')

dich_se <- select(da_CFA , -poorloading_DICH) %>% mutate_if(is.factor,as.numeric)
f_4_CFAmodel <- 'aware =~ obssediment + obsnutrients + obsodor + obstrash + obslackfish + obsunsafeswim + obscolor + obsunsafedrink 
past =~ pastcrp + pastfcp + pastmci + pastlongterm + pastgcdt + pastgcsv 
appreciate =~ acfish + acswim + acexplore + ackayak + achunt + achike + acbike + acpicnic + achorseride + acgooffroading
resp =~ sptlandowners + sptfarmmanager + sptrenters + sptgovstaff + sptmrbboard'

bq_cfa <- cfa(model = f_4_CFAmodel,
              data = da_CFA)
summary(bq_cfa, standardized = T, fit.measures = T)

##### likert scale
library(tidyverse)
library(likert)

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
df_se <- select(impute_df, -poorloadings)


N <- nrow(df_se)
indices <- seq(1, N)
indices_EFA <- sample(indices, floor((.5*N)))
indices_CFA <- indices[!(indices %in% indices_EFA )]

# Use those indices to split the dataset into halves for your EFA and CFA
da_EFA <- df_se[indices_EFA, ]
da_CFA <- df_se[indices_CFA, ]

fa3_EFA <- fa(da_EFA , nfactor = 3,rotate = "varimax")
fa3_EFA



fa3_CFAmodel <- 'concern =~ scenicconcern + scenicmoderate + nutrientconcern + nutrientmoderate + nutrientmajor + habitatconcern + habitatmoderate + habitatmajor + sedimentconcern + sedimentmoderate + sedimentmajor + recreationconcern +recreationmoderate +
recreationmajor + valwaterproblem + valwaterimportant  + valtogether
value =~ valknowconservation +  valsteward + opnmfamiliar + opwetlandfamiliar+ familiar25 + opcovercropfamiliar 
landcontrol =~ valundueblame + opwetlandcostr + opwetlandcontrol + opwetlandcostm + opwetlandsoil + opwetlandhabitat + valstaff +
opcovercroprp + opcovercroptimep +opcovercroptimeh + opcovercroprs + opcovercropis + opcovercropln + opnmrs + opnmrl + opnmis + opnmrf + opnmcost+
vallandregulate+valpaymentimportant + valinfluence + opwetlandequipment  '



fa_cfa <- cfa(model = fa3_CFAmodel,data = da_CFA)
summary(fa_cfa, standardized = T, fit.measures = T)

rrslabels<-c(1:8,9:14, 15:24, 25:29, "Awareness",
             "Past","Appreciation","Responsibility")

png("../plot/cfaplot.png")
semPaths(object = bq_cfa,
         what="par",whatLabels="hide", nodeLabels=rrslabels, sizeLat=12,
         sizeMan=4.5,edge.label.cex=0.75, edge.color="black", asize=2)
dev.off()
