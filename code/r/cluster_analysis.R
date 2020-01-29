library(dplyr)
library(ggplot2)
library(purrr)
library(tibble)
library(tidyr)
library(cluster)
library(factoextra)
rm(list = ls())
setwd("C:/Users/langzx/Desktop/github/DCM/survey/data")

data_ecovl <- read.csv(file = "ecovl_fscores_0127.csv")
colnames(data_ecovl)
data_wta <- read.csv("wta_observables11192018COMB426.csv")
data_wta$id

data_wta <- data_wta %>% left_join(data_ecovl, by = c("id" = "respondentid"))
write.csv(x =data_wta , file = "wta_cluster_01272020.csv", row.names = FALSE)
ncol(data_wta)
colnames(data_wta)


data_factorall <-read.csv(file = "all_fscores_0128.csv")
colnames(data_factorall)
data_wta <- read.csv("wta_observables11192018COMB426.csv")
data_wta$id
data_wta <- data_wta %>% left_join(data_factorall, by = c("id" = "respondentid"))
write.csv(x =data_wta , file = "wta_cluster_01282020.csv", row.names = FALSE)
ncol(data_wta)



data_eco <- read.csv(file = "ecovl_fscores_0127.csv")
colnames(data_eco)
df <- data_eco[,c(2,3)] 
head(df)

df_impute <- sapply(df,function(x) {
  if(is.numeric(x)) ifelse(is.na(x),median(x,na.rm=T),x) else x})

df_impute
dist.eucl <- dist(df_impute, method = "euclidean")
# Subset the first 3 columns and rows and Round the values
round(as.matrix(dist.eucl)[1:3, 1:2], 1)
dist.cor <- get_dist(df_impute, method = "pearson")
# Display a subset
round(as.matrix(dist.cor)[1:3, 1:2], 1)

fviz_dist(dist.eucl)

set.seed(123)
fviz_nbclust(df_impute, kmeans, method = "wss")

k_eco <- kmeans(df_impute, centers = 2, nstart = 50)
cluster_eco <- k_eco$cluster
as.data.frame(table(cluster_eco ))

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

dat <- data.frame(data_eco$id) %>% mutate(c_eco = cluster_eco)

data_cluster <- read.csv("ecovl_fscores_0127.csv")
data_cluster <- data_cluster%>% mutate(c_ecovl = cluster_eco)
write.csv(x =data_cluster , file = "ecovl_cluster_0127.csv", row.names = FALSE)

data_c  <- data_cluster%>% mutate(c_ecovl = cluster_eco)
data_wta <- data_wta %>% left_join(dat, by = c("id" = "data_eco.id"))
write.csv(x =data_wta , file = "wta_cluster_01222020.csv", row.names = FALSE)

data_c$c_ecovl

###########
data_cluster <- read.csv("ecovl_cluster_0127.csv")
data <- read.csv ("data_number.csv", head = TRUE)
helper <- read.csv ("data_helper.csv", head = TRUE)
groupID <- unique(helper$Grouping)
resid <- data$respondentid
## Questions related to Land management practices
question_LM <- helper %>%
  filter(#Grouping == "wetland_LM opinions" |
           #Grouping == "cc_LM opinions" |
           #Grouping == "nm_LM opinions"
         #Grouping == "Responsibility"|
         #Grouping == "Indicate degree to which you agree"|
         Grouping == "LM practices"
          
  ) %>%
  select(QuestionID) %>% 
  sapply(as.character) %>% 
  as.vector
length(question_LM)
all_data = data[12:126]
#c("practicegd","practicemintill", "practicerb","practicerp")
LM_data <- all_data %>% select(c("practicegd","practicemintill", "practicerb","practicerp"))
LM_data$sum <- rowSums(LM_data)
LM_data$sum
sum_lm <- LM_data$sum
type <- as.factor(data_c$c_ecovl)
data_eco <- data.frame(type,sum_lm)
by_vs_am <- data_eco  %>% group_by(type) %>% 
  summarize(meanlm = mean(sum_lm),
            count = n())

t.test(by_vs_am$meanlm)
t.test(meanlm ~ type, data = by_vs_am )
ggplot(by_vs_am, aes(x=meanlm, color=type)) +
  geom_histogram( position="dodge")+
  theme(legend.position="top")