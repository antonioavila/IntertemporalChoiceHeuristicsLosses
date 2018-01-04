# Get rid of missing values
Data_final <- read_delim(
  "data/data_final.csv",";", escape_double = FALSE, trim_ws = TRUE)
Data_final <- na.omit(Data_final)
write.csv(Data_final, file ="data/data_final.csv")

# Get the dataset little

data <- read.csv("data/choices.csv",stringsAsFactors = FALSE)
data <- subset(data, Subject < 100)
write.csv(data, file = "data/choicesNew.csv")

# Generate random sample

set.seed(1)
X1 <- sample (c(5,7,4,10,2,8),500, replace= T)
X2 <- sample (c(11,13,14,16,19,20),500, replace= T)
T1 <- sample (c(1,2),500, replace= T)
T2 <- sample (c(3,5,7),500, replace= T)
LaterOptionChosen <- sample(c(0,1),500, replace=T)
Condition <- sample(c(1,2,3,4),500, replace=T)
Subject <- sample (c(1:50), 500, replace = T)

data2 <-data.frame(cbind(Subject, Condition,X1,X2,T1,T2,LaterOptionChosen))
write.csv(data2, file = "data/choicesGenerated.csv")
