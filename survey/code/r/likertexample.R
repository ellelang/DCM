library(stringr)
library(likert)

library(reshape2)
library(ggplot2)

# Functions
CreateRowsColumns <- function(noofrows, noofcolumns) {
  createcolumnnames <- paste("Q", 1:noofcolumns, sep ="")
  df <- sapply(1:noofcolumns, function(i) assign(createcolumnnames[i], matrix(sample(1:5, noofrows, replace = TRUE))))
  df <- sapply(1:noofcolumns, function(i) df[,i] <- as.factor(df[,i]))
  colnames(df) <- createcolumnnames
  return(df)}

LikertResponse <- CreateRowsColumns(82, 65)
LikertResponse[LikertResponse == 1] <- "Strongly agree"
LikertResponse[LikertResponse == 2] <- "Agree"
LikertResponse[LikertResponse == 3] <- "Neutral"
LikertResponse[LikertResponse == 4] <- "Disagree"
LikertResponse[LikertResponse == 5] <- "Strongly disagree"
# Prepare data
LikertResponseSummary <- do.call(rbind, lapply(data.frame(LikertResponse), table))
LikertResponseSummaryPercent <- prop.table(LikertResponseSummary,1)

LikertResponseSummary

# Melt data
LikertResponseSummary <- melt(LikertResponseSummary)
LikertResponseSummaryPercent <- melt(LikertResponseSummaryPercent)

LikertResponseSummary$Var1num <- 
  as.numeric(str_extract(LikertResponseSummary$Var1, "[0-9]+"))
LikertResponseSummary$Var2 <- 
  factor(LikertResponseSummary$Var2, 
         levels =  c("Strongly disagree", "Disagree", "Neutral", "Agree", "Strongly agree"))