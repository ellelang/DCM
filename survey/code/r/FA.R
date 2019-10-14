rm(list = ls())
setwd("C:/Users/langzx/Desktop/github/DCM/survey/data")
library(psych)
library(GPArotation)
library(dplyr) 
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
length(question_LM)

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
fa.diagram(EFA_eco,cut=.4,digits=2)

EFA_LM<- fa(LM_factordata, nfactors = 11)
fa.diagram(EFA_LM,cut=.4,digits=2)


EFA_VL<- fa(VL_factordata, nfactors = 5)
fa.diagram(EFA_VL,cut=.4,digits=2)


