library(dplyr)
library(ggplot2)
library(purrr)
library(tibble)
library(tidyr)
library(cluster)
library(factoextra)
rm(list = ls())
setwd("C:/Users/langzx/Desktop/github/DCM/data")

data_ecovl <- read.csv(file = "fscore_ecovl.csv")
colnames(data_ecovl)
data_wta <- read.csv("wta_observables11192018COMB426.csv")
data_wta$id

data_wta <- data_wta %>% left_join(data_ecovl, by = c("id" = "id"))
write.csv(x =data_wta , file = "wta_cluster_01272020.csv", row.names = FALSE)
ncol(data_wta)
colnames(data_wta)




data_eco <- read.csv(file = "fscore_eco.csv")
colnames(data_eco)
df <- data_eco[,seq(1,8,1)] 
head(df)

df_impute <- sapply(df,function(x) {
  if(is.numeric(x)) ifelse(is.na(x),median(x,na.rm=T),x) else x})

df_impute
dist.eucl <- dist(df_impute, method = "euclidean")
# Subset the first 3 columns and rows and Round the values
round(as.matrix(dist.eucl)[1:3, 1:8], 1)
dist.cor <- get_dist(df_impute, method = "pearson")
# Display a subset
round(as.matrix(dist.cor)[1:3, 1:8], 1)

fviz_dist(dist.eucl)

set.seed(123)
fviz_nbclust(df_impute, kmeans, method = "wss")

k_eco <- kmeans(df_impute, centers = 4, nstart = 50)
cluster_eco <- k_eco$cluster

# function to compute total within-cluster sum of square 
wss <- function(k) {
  kmeans(df_impute, k, nstart = 10 )$tot.withinss
}

# Compute and plot wss for k = 1 to k = 5
k.values <- 1:5

# extract wss for 2-15 clusters
wss_values <- map_dbl(k.values, wss)
plot(k.values, wss_values,
     type="b", pch = 19, frame = FALSE, 
     xlab="Number of clusters K",
     ylab="Total within-clusters sum of squares")


data_lm <- read.csv(file = "fscore_lm.csv")
colnames(data_lm)
df_lm <- data_lm[,seq(1,11,1)] 
head(df_lm)

df_impute_lm <- sapply(df_lm,function(x) {
  if(is.numeric(x)) ifelse(is.na(x),median(x,na.rm=T),x) else x})


set.seed(123)
fviz_nbclust(df_impute_lm, kmeans, method = "wss")
k_lm <- kmeans(df_impute, centers = 5, nstart = 25)
k_lm$cluster

data_vl <- read.csv(file = "fscore_vl.csv")
colnames(data_vl)
df_vl <- data_vl[,seq(1,5,1)] 
head(df_vl)

df_impute_vl <- sapply(df_vl,function(x) {
  if(is.numeric(x)) ifelse(is.na(x),median(x,na.rm=T),x) else x})


set.seed(123)
fviz_nbclust(df_impute_vl, kmeans, method = "wss")
k_vl <- kmeans(df_impute_vl, centers = 3, nstart = 25)
k_vl$cluster

fviz_nbclust(df_impute_vl, clara, method = "silhouette")+
  theme_classic()


res.dist_eco <- dist(df_impute, method = "euclidean")
res.hc_eco <- hclust(d = res.dist_eco, method = "ward.D2")
fviz_dend(res.hc_eco, cex = 0.5)

cluster_lm <- k_lm$cluster
cluster_vl <- k_vl$cluster

dat <- data.frame(data_eco$id) %>% mutate(
  c_eco = cluster_eco,
  c_lm = cluster_lm,
  c_vl = cluster_vl
)

data_wta <- read.csv("wta_fscores10202019.csv")
data_wta$id

data_wta <- data_wta %>% left_join(dat, by = c("id" = "data_eco.id"))
write.csv(x =data_wta , file = "wta_cluster_01222020.csv", row.names = FALSE)
