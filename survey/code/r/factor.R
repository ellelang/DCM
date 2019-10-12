rm(list = ls())
setwd("C:/Users/langzx/Desktop/github/DCM/survey/data")
library(psych)
library(GPArotation)
data <- read.csv ("data_number.csv", head = TRUE)
helper <- read.csv ("data_helper.csv", head = TRUE)

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

# visualize the eigenvalues 
scree(factor_EFA_cor, factor = FALSE)

## multifactors
EFA_model <- fa(factordata_EFA, nfactors = 6)
EFA_model$loadings
EFA_model$scores
EFA_model
#The TLI is above the 0.90 cutoff for good fit, and the RMSEA is below the 0.05 cutoff for good fit.
#lower BIC is empirically preferred.