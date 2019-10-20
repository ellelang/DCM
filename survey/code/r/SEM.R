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
COM =~ habitatconcern + habitatmoderate + habitatmajor + recreationconcern + recreationmoderate + recreationmajor ##recreation
GCON =~ obssediment + obsnutrients + obsodor + obstrash + obslackfish + obsunsafeswim + obscolor + obsunsafedrink  ##General concern
SMET =~ nutrientconcern + nutrientmoderate + nutrientmajor + sedimentconcern + sedimentmoderate + sedimentmajor + obsnutrients ##Specific metrics water quality 
ETHIC =~ scenicconcern + scenicmoderate + scenicmajor ## scenic beauty
NCOM =~ acexplore + achike + acbike + acpicnic + ackayak + pollutionobs ## outdoor activities (more regular outdoor )
ADV =~ achorseride + acgooffroading + acswim + achunt + acfish +pollutionobs  ## outdoor activities (advanture)
ETHIC ~~ COM
#REC =~ COM + ETHIC 
#ENV =~ GCON + SMET
"
#LOCAL =~ pollutionobs + sedimentmoderate + sedimentmajor + sedimentconcern + obsnutrients +  scenicconcern (local sediment problems)

eco_model.fit <- cfa(model = eco_model,
                     data = eco_factordata )

fitmeasures(eco_model.fit , c("cfi","tli","rmsea", "srmr"))
summary(eco_model.fit, standardized =TRUE, fit.measures = TRUE)

#summary(wais.fit3, standardized = TRUE, fit.measures = TRUE)

modificationindices(eco_model.fit, sort = TRUE)

windows(width = 40, height = 30 )
semPaths(object = eco_model.fit,
         layout = "tree",
         rotation = 1,
         whatLabels = "std",
         edge.label.cex = 0.6,
         what = 'std',
         edge.color = 'blue')


eco_fscores <- lavPredict(eco_model.fit)
eco_fscores
idx <- lavInspect(eco_model.fit, "case.idx")
idx

## loop over factors
for (fs in colnames(eco_fscores)) {
  data[idx, fs] <- eco_fscores[ , fs]
}
head(data)

###########value 

## value
question_value

val_model <- "
AgResp =~ sptfarmmanager + sptgovstaff + sptmrbboard + valundueblame  ## responsibility of agent
WATER =~ valwaterimportant + vallandregulate + valwaterproblem + valpaymentimportant + valinfluence + valundueblame # value of water
AgVal =~ valtogether + valstaff + valundueblame +  valwaterimportant ## value of agent
LoSte =~ valsteward + valknowconservation + familiar25 + valwaterimportant + valundueblame +  vallandregulate # stewship
LoResp =~ sptlandowners + sptfarmmanager + sptrenters + valwaterimportant + vallandregulate # households
"
val_model.fit <- cfa(model = val_model,
                     data = VL_factordata )
fitmeasures(val_model.fit , c("cfi","tli","rmsea", "srmr"))
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

val_fscores <- lavPredict(val_model.fit)
val_fscores
idx_val <- lavInspect(val_model.fit, "case.idx")
idx_val
for (fs in colnames(val_fscores)) {
  data[idx_val, fs] <- val_fscores[ , fs]
}
head(data)

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
fitmeasures(lm_model.fit , c("cfi","tli","rmsea", "srmr"))

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

lm_fscores <- lavPredict(lm_model.fit)
lm_fscores
idx_lm <- lavInspect(lm_model.fit, "case.idx")
idx_lm
for (fs in colnames(lm_fscores)) {
  data[idx_lm, fs] <- lm_fscores[ , fs]
}
head(data)

write.csv(x = data, file = "data_fscores.csv", row.names = FALSE)

f_names <- c(colnames(eco_fscores),colnames(lm_fscores), colnames(val_fscores))
f_names
data$respondentid
factors_data <- data %>% select (respondentid,f_names) 
factors_data

setwd("C:/Users/langzx/Desktop/github/DCM/data")
nlogitdata <- read.csv (file = "wta_observables11192018.csv")
nlogitdata$id

wta_data <- nlogitdata %>% left_join(factors_data, by = c("id" = "respondentid"))
head(wta_data)
write.csv(x = wta_data, file = "wta_fscores10202019.csv", row.names = FALSE)
