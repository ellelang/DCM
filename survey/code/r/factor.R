rm(list = ls())
setwd("C:/Users/langzx/Desktop/github/DCM/survey/data")
library(psych)
library(GPArotation)
library(dplyr) 
data <- read.csv ("data_number.csv", head = TRUE)
helper <- read.csv ("data_helper.csv", head = TRUE)

groupID <- unique(helper$Grouping)

question_eco <- helper %>%
  filter(Grouping == "Concern_Ecosystem Services" |
           Grouping == "ModerateImprove_Ecosystem Services" |
           Grouping == "MajorImprove_Ecosystem Services"|
           Grouping == "Indicate degree to which you agree" |
           Grouping == "Pollution notification") %>%
  select(QuestionID) %>% 
  sapply(as.character) %>% 
  as.vector

length(question_eco)

factor_data = data[12:126]

eco_factordata <- factor_data %>% select (question_eco)

eco_factor_cor <- cor(eco_factordata, use = "pairwise.complete.obs")
eigenvals <- eigen (eco_factor_cor)
eigenvals$values
## The general rule is that the eigenvalues greater than one represent meaningful factors
sum(eigenvals$values >= 1)

EFA_eco<- fa(eco_factordata, nfactors = 6)
EFA_eco$loadings
EFA_eco$TLI



##########
question_LM <- helper %>%
  filter(Grouping == "wetland_LM opinions" |
           Grouping == "cc_LM opinions" |
           Grouping == "nm_LM opinions"|
           Grouping == "LM practices" ) %>%
  select(QuestionID) %>% 
  sapply(as.character) %>% 
  as.vector

LM_factordata <- factor_data %>% select(question_eco)
EFA_LM<- fa(LM_factordata, nfactors = 6)
EFA_LM$loadings

EFA_LM$TLI


describe (data)
dim(data)
democol <- tail(1:136, 9)
democol

error.dots(data[12:19])
error.bars(data[12:19])

# Establish two sets of indices to split the dataset
N <- nrow(data)
indices <- seq(1, N)
indices_EFA <- sample(indices, floor((.5*N)))
indices_CFA <- indices[!(indices %in% indices_EFA)]
data_EFA <- data[indices_EFA, ]
data_CFA <- data[indices_CFA, ]

group_var <- vector("numeric", nrow(data))
group_var
group_var[indices_EFA] <- 1
group_var[indices_CFA] <- 2

# Bind that grouping variable onto the gcbs dataset
data_grouped <- cbind(data, group_var)
data_grouped$group_var
# Compare stats across groups
describeBy(data_grouped, group = group_var)
statsBy(data_grouped, group = "group_var")

factor_data = data[12:126]

eco_factordata <- factor_data %>% select (question_eco)
question_eco
dim(factor_data)

lowerCor(factor_data)
corr.test(factor_data, use = "pairwise.complete.obs")$ci
#In reliability values greater than 0.8 are desired, though some fields of study have higher or lower guidelines.
alpha(factor_data)
splitHalf(factor_data)

## Calculate the the correlation matrix
factordata_EFA <- data[indices_EFA, ][12:126]
factordata_CFA <- data[indices_CFA, ][12:126]
factor_EFA_cor <- cor(factordata_EFA, use = "pairwise.complete.obs")
factor_EFA_cor

factordata_EFA
## use the correlation matrix to calculate the eigenvalues
eigenvals <- eigen (factor_EFA_cor)
eigenvals$values
## The general rule is that the eigenvalues greater than one represent meaningful factors
sum(eigenvals$values >= 1)
# visualize the eigenvalues 
windows(width = 15, height = 15)
scree(factor_EFA_cor, factor = FALSE)

## multifactors
EFA_model <- fa(factordata_EFA, nfactors = 31)
EFA_model$loadings
EFA_model$scores
EFA_model
#The TLI is above the 0.90 cutoff for good fit, and the RMSEA is below the 0.05 cutoff for good fit.
#lower BIC is empirically preferred.
# Chi-square test (aka the log likelihood test) : the p value is usually significant due to the sample size although the
# desired results is lack of significance
# GFI (goodness of fit index) > 0.9
# CFI (Comparative fit index) > 0.9
### CFA

# Run a CFA using the EFA syntax you created earlier
#EFA_CFA <- sem(EFA_syn, data = bfi_CFA)

# Locate the BIC in the fit statistics of the summary output
#summary(EFA_CFA)$BIC


# Compare EFA_CFA BIC to the BIC from the CFA based on theory
#summary(theory_CFA)$BIC

# Set the options to include various fit indices so they will print
#options(fit.indices = c("CFI", "GFI", "RMSEA", "BIC"))

# Use the summary function to view fit information and parameter estimates
#summary(theory_CFA)

# View the first five rows of the EFA loadings
#EFA_model$loadings[1:5,]

# View the first five loadings from the CFA estimated from the EFA results
#summary(EFA_CFA)$coeff[1:5,]

# Extracting factor scores from the EFA model
EFA_scores <- EFA_model$scores

# Calculating factor scores by applying the CFA parameters to the EFA dataset
#CFA_scores <- fscores(EFA_CFA, data = bfi_EFA)

# Comparing factor scores from the EFA and CFA results from the bfi_EFA dataset
#plot(density(EFA_scores[,1], na.rm = TRUE), 
     #xlim = c(-3, 3), ylim = c(0, 1), col = "blue")
#lines(density(CFA_scores[,1], na.rm = TRUE), 
      #xlim = c(-3, 3), ylim = c(0, 1), col = "red")

# Comparing the original model and the revised model: conduct a likelihood ratio test
#anova(theory_CFA, theory_CFA_add)
# If it is significant, one model is significantly better than the other
#check out more indices: http://davidakenny.net/cm/fit.htm
# SEM http://davidakenny.net/webinars/listw.htm#SEM

# # Add some plausible item/factor loadings to the syntax
# theory_syn_add <- "
# AGE: A1, A2, A3, A4, A5
# CON: C1, C2, C3, C4, C5
# EXT: E1, E2, E3, E4, E5, N4
# NEU: N1, N2, N3, N4, N5, E3
# OPE: O1, O2, O3, O4, O5
# "
# 
# # Convert your equations to sem-compatible syntax
# theory_syn2 <- cfa(text = theory_syn_add, reference.indicators = FALSE)
# 
# # Run a CFA with the revised syntax
# theory_CFA_add <- sem(model = theory_syn2, data = bfi_CFA)

# # Conduct a likelihood ratio test
# anova(theory_CFA, theory_CFA_add)
# 
# # Compare the comparative fit indices - higher is better!
# summary(theory_CFA)$CFI
# summary(theory_CFA_add)$CFI
# 
# # Compare the RMSEA values - lower is better!
# summary(theory_CFA)$RMSEA
# summary(theory_CFA_add)$RMSEA

# Remove the worst item/factor loadings from the syntax
#theory_syn_del <- "
# AGE: A1, A2, A3, A4, A5
# CON: C1, C2, C3, C4, C5
# EXT: E1, E2, E3, E4, E5
# NEU: N1, N2, N3, N4, N5
# OPE: O1, O2, O3, O5
# "

# # Convert your equations to sem-compatible syntax
# theory_syn3 <- cfa(text = theory_syn_del, reference.indicators = FALSE)
# 
# # Run a CFA with the revised syntax
# theory_CFA_del <- sem(model = theory_syn3, data = bfi_CFA)

# # Compare the comparative fit indices - higher is better!
# summary(theory_CFA)$CFI
# summary(theory_CFA_del)$CFI
# 
# # Compare the RMSEA values - lower is better!
# summary(theory_CFA)$RMSEA
# summary(theory_CFA_del)$RMSEA