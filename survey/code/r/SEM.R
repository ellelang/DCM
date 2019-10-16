rm(list = ls())
setwd("C:/Users/langzx/Desktop/github/DCM/survey/data")
library(psych)
library(GPArotation)
library(dplyr) 
library(lavaan)
library(semPlot)

data <- read.csv ("data_number.csv", head = TRUE)
helper <- read.csv ("data_helper.csv", head = TRUE)
groupID <- unique(helper$Grouping)

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

##Get the subset of data
###factor data : exclude the choice experiments and demorgraphics info
factor_data = data[12:126]
### three subsets based on question groups
eco_factordata <- factor_data %>% select (question_eco)
LM_factordata <- factor_data %>% select(question_LM)
VL_factordata <- factor_data %>% select(question_value)



###ECO
question_eco

eco_model <- "
RECRE =~ habitatconcern + habitatmoderate + habitatmajor + recreationconcern + recreationmoderate + recreationmajor ##recreation
AWARE =~ obssediment + obsnutrients + obsodor + obstrash + obslackfish + obsunsafeswim + obscolor + obsunsafedrink  ##awareness
WATER =~ nutrientconcern + nutrientmoderate + nutrientmajor + sedimentconcern + sedimentmoderate + sedimentmajor + obsnutrients ##water quality 
BEAUTY =~ scenicconcern + scenicmoderate + scenicmajor ## scenic beauty
OUTDOOR =~ acexplore + achike + acbike + acpicnic + ackayak + pollutionobs ## outdoor activities (more regular outdoor )
OUTDOOR2 =~ achorseride + acgooffroading + acswim + achunt + acfish +  pollutionobs  ## outdoor activities (advanture)
LOCAL =~ pollutionobs + sedimentmoderate + sedimentmajor + sedimentconcern + obsnutrients +  scenicconcern (local sediment problems)
BEAUTY ~~ RECRE
"

eco_model.fit <- cfa(model = eco_model,
                     data = eco_factordata )

summary(eco_model.fit, standardized =TRUE, fit.measures = TRUE)


modificationindices(eco_model.fit, sort = TRUE)

windows(width = 40, height = 30 )
semPaths(object = eco_model.fit,
         layout = "circle",
         rotation = 1,
         whatLabels = "std",
         edge.label.cex = 0.6,
         what = 'std',
         edge.color = 'blue')

###########value 

## value
question_value

val_model <- "
RESPON =~ sptfarmmanager + sptgovstaff + sptmrbboard + valundueblame  ## responsibility of agent
WATER =~ valwaterimportant + vallandregulate + valwaterproblem + valpaymentimportant + valinfluence + valundueblame # value of water
AGENT =~ valtogether + valstaff + valundueblame +  valwaterimportant ## value of agent
STEW =~ valsteward + valknowconservation + familiar25 + valwaterimportant + valundueblame +  vallandregulate # stewship
OWNER =~ sptlandowners + sptfarmmanager + sptrenters + valwaterimportant + vallandregulate # households
"
val_model.fit <- cfa(model = val_model,
                     data = VL_factordata )

summary(val_model.fit, standardized =TRUE, fit.measures = TRUE)

modificationindices(val_model.fit, sort = TRUE)

windows(width = 40, height = 30 )
semPaths(object = val_model.fit,
         layout = "circle",
         rotation = 1,
         whatLabels = "std",
         edge.label.cex = 0.6,
         what = 'std',
         edge.color = 'black')

#############Land management 
EFA_LM<- fa(LM_factordata, nfactors = 9)
fa.diagram(EFA_LM,cut=.3,digits=2)

lm_model <- "
NM_DIS =~ opnmrs + opnmrl + opnmfamiliar + othersnm + opnmcost +  opnmopen  # negative view about NM
WLD_DIS =~ opwetlandcostm + opwetlandcostr  + opwetlandequipment + opnmcost + opwetlandcontrol  # negative view about WLD
CC_DIS =~ opcovercroprp + opcovercroptimep + opcovercroptimeh + opcovercropfamiliar + opcovercropopen   # negative view about CC
OPEN =~ opcovercropopen + opnmopen + opwetlandopen + opcovercropfamiliar #OPENNESS 
FAMIL =~ otherswetland + opwetlandfamiliar + opwetlandrestored +  opnmfamiliar + othersnm + otherscovercrop + opcovercropfamiliar  # FAMILIAR
WLD_ADV =~  opwetlandhabitat +  opwetlandsoil  + otherswetland +  opwetlandrestored  #Positive view about WLD and NM
CC_ADV =~ opcovercroprs +  opcovercropis + opnmis  + opcovercropfamiliar #Positive view about CC and NM
NM_ADV =~ opnmrf + opcovercropln +  opnmis + opnmfamiliar
opnmfamiliar ~~ othersnm
opnmfamiliar ~~ opcovercropfamiliar
opwetlandfamiliar ~~ opcovercropfamiliar
"

lm_model.fit <- cfa(model = lm_model,
                     data = LM_factordata, check.gradient = FALSE  )

summary(lm_model.fit, standardized =TRUE, fit.measures = TRUE)
modificationindices(lm_model.fit, sort = TRUE)
windows(width = 40, height = 30 )

semPaths(object = lm_model.fit,
         layout = "circle",
         rotation = 1,
         whatLabels = "std",
         edge.label.cex = 0.6,
         what = 'std',
         edge.color = 'purple')
