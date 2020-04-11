rm(list = ls())
setwd("C:/Users/langzx/Desktop/github/DCM/survey/data")
library(psych)
library(GPArotation)
library(dplyr) 
library(tidyverse)
library(sem)
library(factoextra)
library(lavaan)
library(likert)
#library(semPlot)
data <- read.csv ("data_number.csv", head = TRUE)
helper <- read.csv ("data_helper.csv", head = TRUE)
groupID <- unique(helper$Grouping)
resid <- data$respondentid
head(data)

names(data)

# Get the question ID (column names)
## Questions related to ecosystem services
question_eco <- helper %>%
  filter(Grouping == "Concern_Ecosystem Services" |
           Grouping == "ModerateImprove_Ecosystem Services" |
           Grouping == "MajorImprove_Ecosystem Services"|
           #Grouping == "Indicate degree to which you agree"|
           Grouping == "Outdoor activities"|
           Grouping == "Environmental issues" |
           Grouping == "Pollution notification"
  ) %>%
  select(QuestionID) %>% 
  sapply(as.character) %>% 
  as.vector
length(question_eco)

## Questions related to Land management practices
question_LM <- helper %>%
  filter(Grouping == "wetland_LM opinions" |
           Grouping == "cc_LM opinions" |
           Grouping == "nm_LM opinions"
           #Grouping == "Responsibility"|
           #Grouping == "Indicate degree to which you agree"|
           #Grouping == "LM practices"
  ) %>%
  select(QuestionID) %>% 
  sapply(as.character) %>% 
  as.vector
length(question_LM)


## Questions related to conservation values
question_value <- helper %>%
  filter(Grouping == "Indicate degree to which you agree"|
           Grouping == "Responsibility"|
           Grouping == "25 by 25 goal"
  ) %>%
  select(QuestionID) %>% 
  sapply(as.character) %>% 
  as.vector
length(question_value)
head(question_value)

##Get the subset of data
###factor data : exclude the choice experiments and demorgraphics info
factor_data = data[12:102]


# factor_data[!is.na(factor_data)]
### three subsets based on question groups
eco_factordata <- factor_data %>% select (question_eco)
LM_factordata <- factor_data %>% select(question_LM)
VL_factordata <- factor_data %>% select(question_value)
#ecoVL_factordata <- factor_data %>% select(question_eco,question_value)
all_factordata <- factor_data %>% select(c(question_eco,question_value,question_LM))



colnames(all_factordata)


fa.parallel(LM_factordata, fa="both", n.iter=100,
            show.legend=FALSE, main="Scree plot with parallel analysis")

fa.varimax_ecoVL <- fa(ecoVL_factordata, nfactors = 2, rotate = "varimax", fm = "pa")
class(fa.varimax_ecoVL[2])

factor.plot(fa.varimax_ecoVL, labels=rownames(fa.varimax_ecoVL$loadings))

scores_ecovl <- fa.varimax_ecoVL$loadings

efa_ecovl_eq <- "
FA1 =~ scenicconcern +  scenicmoderate+ scenicmajor+ 
habitatconcern+ habitatmoderate+habitatmajor+ 
recreationconcern+ recreationmoderate+recreationmajor+ 
sedimentconcern+ sedimentmoderate+ sedimentmajor+ 
nutrientconcern+ nutrientmoderate+ nutrientmajor+
valundueblame+ valwaterimportant+vallandregulate+valwaterproblem+ 
valpaymentimportant+valinfluence+valtogether+ valstaff+
sptlandowners+ sptfarmmanager+ sptrenters+sptgovstaff+ sptmrbboard+
valknowconservation+ valsteward

FA2=~ obssediment+obsnutrients+ obsodor+ obstrash+ 
obslackfish+obsunsafeswim+ obscolor+ obsunsafedrink+pollutionobs+
achike+ acexplore+acbike+ ackayak+ acpicnic+achunt+ acfish+achorseride+acgooffroading+acswim+
sptfarmmanager+sptrenters+sptgovstaff+ sptmrbboard+familiar25
"
ecovl_model.fit <- cfa(model = efa_ecovl_eq, ecoVL_factordata )
ecovl_fscores <- lavPredict(ecovl_model.fit)
idx_ecovl <- lavInspect(ecovl_model.fit, "case.idx")
idx_ecovl
for (fs in colnames(ecovl_fscores)) {
  data[idx_ecovl, fs] <- ecovl_fscores[ , fs]
}
head(data)
fscore_ecovl <- data %>% select (c(respondentid, FA1,FA2))
write.csv(x = fscore_ecovl, file = "ecovl_fscores_0127.csv", row.names = FALSE)


CFA_ecovl <- sem(eq_syn_ecovl, data = ecoVL_factordata)
summary(CFA_ecovl)

CFA_scores_ecovl <- fscores(CFA_ecovl, data = ecoVL_factordata)
df_CFA_scores_ecovl <- data.frame(CFA_scores_ecovl) %>% mutate (id = resid )

write.csv(x = df_CFA_scores_ecovl, file = "fscore_ecovl.csv", row.names = FALSE)

###########all questions
fa.varimax_all <- fa(all_factordata, nfactors = 2, rotate = "varimax", fm = "pa")

factor.plot(fa.varimax_all)

scores_all <- fa.varimax_all$loadings


efa_all_eq <- "
FA1 = ~ scenicconcern + scenicmoderate + scenicmajor + 
habitatconcern+ habitatmoderate + habitatmajor+ 
recreationconcern + recreationmoderate +recreationmajor+ 
sedimentconcern + sedimentmoderate + sedimentmajor+ 
nutrientconcern + nutrientmoderate + nutrientmajor+
valundueblame + valwaterimportant + vallandregulate + valwaterproblem + 
valpaymentimportant + valinfluence + valtogether + valstaff+
sptlandowners+ sptfarmmanager+ sptrenters + sptgovstaff+ sptmrbboard+
valknowconservation+ valsteward +
opwetlandcostr + opwetlandcontrol +opwetlandequipment + opwetlandcostm+opwetlandhabitat+opwetlandsoil+   
opcovercroprp+opcovercroptimep+opcovercroptimeh+opcovercroprs+opcovercropis+opcovercropln+ 
opnmrs+opnmrl+opnmis+opnmrf+opnmcost   

FA2 =~ obssediment+obsnutrients+ obsodor+ obstrash+ 
obslackfish+obsunsafeswim+obscolor+ obsunsafedrink+pollutionobs+
achike+ acexplore+ acbike+ ackayak+ acpicnic+achunt+ acfish+achorseride+acgooffroading+acswim+
sptfarmmanager+ sptrenters+sptgovstaff+sptmrbboard+familiar25+
otherswetland+ otherscovercrop + othersnm+
opwetlandfamiliar+opcovercropfamiliar+ opnmfamiliar+
opwetlandopen+opwetlandrestored+opcovercropopen+opcovercropplant+opnmopen 
"

all_model.fit <- cfa(model = efa_all_eq,data = all_factordata )
#fitmeasures(all_model.fit , c("cfi","tli","rmsea", "srmr"))
#summary(all_model.fit, standardized =TRUE, fit.measures = TRUE)

data <- read.csv ("data_number.csv", head = TRUE)

all_fscores <- lavPredict(all_model.fit)
idx_all <- lavInspect(all_model.fit, "case.idx")
idx_all
for (fs in colnames(all_fscores)) {
  data[idx_all, fs] <- all_fscores[ , fs]
}
head(data)
fscore <- data %>% select (c(respondentid, FA1,FA2))
write.csv(x = fscore, file = "all_fscores_0128.csv", row.names = FALSE)



CFA_all <- sem(eq_syn_all, data = all_factordata)
summary(CFA_all)

CFA_scores_all <- fscores(CFA_all, data = all_factordata)
df_CFA_scores_all <- data.frame(CFA_scores_all) %>% mutate (id = resid )
write.csv(x = df_CFA_scores_all, file = "fscore_allquestions.csv", row.names = FALSE)


     

library(devtools)
install_github("vqv/ggbiplot", force = TRUE)
library(ggbiplot)

df_impute <- sapply(ecoVL_factordata,function(x) {
  if(is.numeric(x)) ifelse(is.na(x),median(x,na.rm=T),x) else x})

ecovl.pca <- prcomp(df_impute, center = TRUE,scale. = TRUE)
ecovl.pca 
ggbiplot(ecovl.pca)





##Correlation and eigenvalues
cor_eigen <- function(data){
  factor_cor <- cor(data, use = "pairwise.complete.obs")
  eigenvals <- eigen (factor_cor)
  #### A general rule is that the eigenvalues greater than one represent meaningful factors
  nfactors <- sum(eigenvals$values >= 1)
  return (nfactors)
}

## number of factors based on eigenvalues > 1
n_least_eco <- cor_eigen(eco_factordata)
n_least_LM <- cor_eigen(LM_factordata)
n_least_VL <- cor_eigen(VL_factordata)
n_least_all <- cor_eigen(factor_data)
n_least_all

EFAfun <- function (data, nleast){
  factorlist <- c(seq(nleast, nleast+5, 1))
  TLIvec <- c()
  RMSEAvec <- c()
  BICvec <- c() 
  for (n in factorlist){
    EFA_fa <- fa(data, nfactors = n)
    TLIvec <- c(TLIvec, EFA_fa$TLI)
    RMSEAvec <- c(RMSEAvec, EFA_fa$RMSEA[1])
    BICvec <-  c( BICvec, EFA_fa$BIC)
  }
  res <- data.frame(N = factorlist, TLI = TLIvec, RMSEA = RMSEAvec,  BIC = BICvec)
  return (res)
}
#EFA_fa <- fa(data, nfactors = factorlist[i])

EFAfun(eco_factordata, n_least_eco) # choose n of factors = 8
EFAfun(LM_factordata, n_least_LM) # choose n of factors = 11
EFAfun(VL_factordata, n_least_VL) # choose n of factors = 5

EFAfun(factor_data, n_least_all) # choose n of factors = 28

######Examine the loadings

EFA_all<- fa(factor_data, nfactors = 2)
EFA_all$loadings
fa.diagram(EFA_all,cut=.3,digits=2)


EFA_eco<- fa(eco_factordata, nfactors = 8)
EFA_eco$loadings
fa.diagram(EFA_eco,cut=.3,digits=2)
EFA_scores <- EFA_eco$scores
names_eco <- c("GCon","REC","NUTR",)
head(data.frame(EFA_scores))
#iclust(eco_factordata)
#omega(eco_factordata, sl=FALSE)

EFA_LM<- fa(LM_factordata, nfactors = 11)
fa.diagram(EFA_LM,cut=.3,digits=2)


EFA_VL<- fa(VL_factordata, nfactors = 5)
fa.diagram(EFA_VL,cut=.3,digits=2)


###############confirmatory factor analysis

###ECO
question_eco

CFA_syn_eco <- structure.sem(EFA_eco)
EFA_syn_eq <- "
F1: habitatconcern, habitatmoderate, habitatmajor,recreationconcern, recreationmoderate, recreationmajor
F2: obssediment, obsnutrients,obsodor, obstrash, obslackfish, obsunsafeswim, obscolor, obsunsafedrink
F3: nutrientconcern, nutrientmoderate,nutrientmajor, sedimentconcern, sedimentmoderate, sedimentmajor
F4: scenicconcern, scenicmoderate,scenicmajor
F5: acexplore, achike, acbike, acpicnic, ackayak
F6: achorseride, acgooffroading, acswim, achunt, acfish
F7: pollutionobs,sedimentmoderate,sedimentmajor, sedimentconcern
F8: acswim, ackayak
"


theory_syn_eq1 <- "
OBS: obssediment, obsnutrients, obsodor, obstrash, obslackfish,obsunsafeswim, obscolor, obsunsafedrink,pollutionobs 
CON1: scenicconcern, scenicmoderate, scenicmajor, habitatconcern, habitatmoderate,habitatmajor, recreationconcern, recreationmoderate,recreationmajor 
CON2: sedimentconcern, sedimentmoderate, sedimentmajor, nutrientconcern, nutrientmoderate, nutrientmajor
ACT1: achike, acexplore, acbike, ackayak, acpicnic
ACT2: achunt, acfish
ACT3: achorseride, acgooffroading,acswim
"
theory_syn <- cfa(text = theory_syn_eq1, 
                  reference.indicators = FALSE)
EFA_syn <- cfa(text = EFA_syn_eq, 
                  reference.indicators = FALSE)

# Run a CFA using the EFA syntax you created earlier
options(fit.indices = c("CFI", "GFI", "RMSEA", "BIC"))
CFA_eco <- sem(theory_syn, data = eco_factordata)
summary(CFA_eco)

CFA_EFA_eco <- sem(EFA_syn, data = eco_factordata)
summary(CFA_EFA_eco)

resid <- data$respondentid
# Calculating factor scores by applying the CFA parameters to the EFA dataset
CFA_scores_eco <- fscores(CFA_EFA_eco, data = eco_factordata)
df_CFA_scores_eco <- data.frame(CFA_scores_eco) %>% mutate (id = resid )

write.csv(x = df_CFA_scores_eco, file = "fscore_eco.csv", row.names = FALSE)
#########################
## LM
question_LM
CFA_syn_LM <- structure.sem(EFA_LM)
EFA_syn_LM_eq <- "
F1: pastcrp, pastfcp, pastmci, pastoneseason, pastgcdt,  practicerb, practicerp
F2: opwetlandfamiliar, opwetlandcontrol, opwetlandequipment, opwetlandequipment, opwetlandcostm, opwetlandcostr
F3: opnmfamiliar, opnmrs, opnmrl, opnmis, opnmcost
F4: otherswetland, otherscovercrop, othersnm,opwetlandfamiliar, opcovercropfamiliar, opnmfamiliar, opcovercropplant
F5: opcovercroprp, opcovercroptimep, opcovercroptimeh
F6: pastgcsv, nowcrp, nowcsp, opwetlandrestored,noweqip, nowfcsv
F7: opcovercropopen, opnmopen, opwetlandopen
F8: pastoneseason, pastlongterm, practicegd, practicemintill
F9: opcovercroprs, opcovercropis
F10: opwetlandhabitat, opwetlandsoil
F11: opcovercropln, opnmrf
"
EFA_syn_LM <- cfa(text = EFA_syn_LM_eq, 
                  reference.indicators = FALSE)

CFA_EFA_LM <- sem(EFA_syn_LM, data = LM_factordata)
summary(CFA_EFA__LM)
#CFA_scores_LM <- fscores(CFA_EFA_LM, data = LM_factordata)


theory_syn_LM_eq1 <- "
ACTS: pastcrp, pastfcp, pastmci, pastoneseason, pastlongterm, pastgcsv, pastgcdt, practicegd, practicemintill, practicerb, practicerp
ACTS2: nowcrp, nowcsp, opwetlandrestored,noweqip, nowfcsv
FAMIL_ML: otherswetland, otherscovercrop, othersnm, opwetlandfamiliar, opcovercropfamiliar, opnmfamiliar, opcovercropplant
OPEN: opcovercropopen, opnmopen, opwetlandopen
ADV_WL: opwetlandhabitat, opwetlandsoil
DIS_WL: opwetlandcostr, opwetlandcontrol,opwetlandequipment, opwetlandcostm
ADV_CC: opcovercroprs, opcovercropis, opcovercropln
DIS_CC: opcovercroprp, opcovercroptimep, opcovercroptimeh
ADV_NM: opnmis,opnmrf
DIS_NM: opnmrs,opnmrl, opnmcost
"
theory_syn_LM <- cfa(text = theory_syn_LM_eq1, 
                  reference.indicators = FALSE)

#options(fit.indices = c("CFI", "GFI", "RMSEA", "BIC"))
CFA_LM <- sem(theory_syn_LM, data = LM_factordata)

summary(CFA_LM)
CFA_scores_LM <- fscores(CFA_EFA_LM, data = LM_factordata)
df_CFA_scores_LM <- data.frame(CFA_scores_LM) %>% mutate (id = resid)
write.csv(x = df_CFA_scores_LM, file = "fscore_lm.csv", row.names = FALSE)

################################VALUE
#########################
## value
question_value
CFA_syn_VL <- structure.sem(EFA_VL)

EFA_syn_VL_eq <- "
F1: sptfarmmanager, sptgovstaff, sptmrbboard
F2: valwaterimportant, vallandregulate, valwaterproblem, valpaymentimportant, valinfluence
F3: valtogether, valstaff, valundueblame
F4: valsteward, valknowconservation, familiar25
F5: sptlandowners, sptfarmmanager, sptrenters, valwaterimportant, vallandregulate
"
EFA_syn_VL <- cfa(text = EFA_syn_VL_eq, 
                  reference.indicators = FALSE)
options(fit.indices = c("CFI", "GFI", "RMSEA", "BIC"))
CFA_EFA_VL <- sem(EFA_syn_VL, data = VL_factordata)
summary(CFA_EFA_VL)
CFA_scores_VL <- fscores(CFA_EFA_VL, data = VL_factordata)
length(data.frame(CFA_scores_VL)[,1])
df_CFA_scores_VL <- data.frame(CFA_scores_VL)%>% mutate (id = resid )

write.csv(x = df_CFA_scores_VL, file = "fscore_vl.csv", row.names = FALSE)



theory_syn_VL_eq1 <- "
COMM: sptfarmmanager, sptgovstaff, sptmrbboard, valtogether, valstaff
STEW: valsteward, valknowconservation, familiar25, sptlandowners
WVAL: valwaterimportant, vallandregulate, valwaterproblem, valpaymentimportant, valinfluence
NEGA:  sptrenters, valundueblame
"

theory_syn_VL <- cfa(text = theory_syn_VL_eq1, 
                     reference.indicators = FALSE)


options(fit.indices = c("CFI", "GFI", "RMSEA", "BIC"))
CFA_VL <- sem(theory_syn_VL, data = VL_factordata)
summary(CFA_VL)
# plot(density(EFA_scores[,1], na.rm = TRUE),
# xlim = c(-3, 3), ylim = c(0, 1), col = "blue")
# lines(density(CFA_scores[,1], na.rm = TRUE),
# xlim = c(-3, 3), ylim = c(0, 1), col = "red")