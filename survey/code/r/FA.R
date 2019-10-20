rm(list = ls())
setwd("C:/Users/langzx/Desktop/github/DCM/survey/data")
library(psych)
library(GPArotation)
library(dplyr) 
library(sem)
#library(lavaan)
#library(semPlot)
data <- read.csv ("data_number.csv", head = TRUE)
helper <- read.csv ("data_helper.csv", head = TRUE)
groupID <- unique(helper$Grouping)

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
           Grouping == "nm_LM opinions"|
           #Grouping == "Responsibility"|
           #Grouping == "Indicate degree to which you agree"|
           Grouping == "LM practices"
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

##Get the subset of data
###factor data : exclude the choice experiments and demorgraphics info
factor_data = data[12:126]
### three subsets based on question groups
eco_factordata <- factor_data %>% select (question_eco)
LM_factordata <- factor_data %>% select(question_LM)
VL_factordata <- factor_data %>% select(question_value)

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

######Examine the loadings

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
# Calculating factor scores by applying the CFA parameters to the EFA dataset
CFA_scores <- fscores(CFA_EFA_eco, data = eco_factordata)

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

summary(CFA__LM)



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