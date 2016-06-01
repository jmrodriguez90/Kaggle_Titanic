library(reshape)
library(caret)
train <- read.csv("\\train.csv")
test <- read.csv("\\test.csv")
train.nrow<-seq(1, nrow(train))
train<-rbind(train, cbind(test, Survived=rep(NA, nrow(test))))

train.miss <- melt(apply(train[, -2], 2, function(x) sum(is.na(x) | x=="")))
cbind(row.names(train.miss)[train.miss$value>0], train.miss[train.miss$value>0,])


     [,1]       [,2]  
[1,] "Age"      "263" 
[2,] "Fare"     "1"   
[3,] "Cabin"    "1014"
[4,] "Embarked" "2"


table(train$Embarked)

      C   Q   S 
  2 270 123 914 


train$Embarked[which(is.na(train$Embarked) | train$Embarked=="")] <- 'S' #reemplazando valores perdidos por el valor más común "S"


table(train$Fare)



train$Fare[which(is.na(train$Fare))] <- 0 #reemplazando el valor perdido por el más común, cero.


ticket.count <- aggregate(train$Ticket, by=list(train$Ticket), function(x) sum( !is.na(x) )) #Calculando los que pagaron más por su entrada
train$Price<-apply(train, 1, function(x) as.numeric(x["Fare"]) / ticket.count[which(ticket.count[, 1] == x["Ticket"]), 2])
pclass.price<-aggregate(train$Price, by = list(train$Pclass), FUN = function(x) median(x, na.rm = T))
train[which(train$Price==0), "Price"] <- apply(train[which(train$Price==0), ] , 1, function(x) pclass.price[pclass.price[, 1]==x["Pclass"], 2])


train$TicketCount<-apply(train, 1, function(x) ticket.count[which(ticket.count[, 1] == x["Ticket"]), 2])


Crear una nueva variable que posea los títulos de las personas
train$Title<-regmatches(as.character(train$Name),regexpr("\\,[A-z ]{1,20}\\.", as.character(train$Name)))
train$Title<-unlist(lapply(train$Title,FUN=function(x) substr(x, 3, nchar(x)-1)))
table(train$Title)

#Agrupar los titulos en iguales.
train$Title[which(train$Title %in% c("Mme", "Mlle"))] <- "Miss"
train$Title[which(train$Title %in% c("Lady", "Ms", "the Countess", "Dona"))] <- "Mrs"
train$Title[which(train$Title=="Dr" & train$Sex=="female")] <- "Mrs"
train$Title[which(train$Title=="Dr" & train$Sex=="male")] <- "Mr"
train$Title[which(train$Title %in% c("Col", "Don", "Jonkheer", "Major", "Rev", "Sir"))] <- "Mr"
train$Title<-as.factor(train$Title)

#Agregar la edad a los títulos
title.age<-aggregate(train$Age,by = list(train$Title), FUN = function(x) median(x, na.rm = T))
train[is.na(train$Age), "Age"] <- apply(train[is.na(train$Age), ] , 1, function(x) title.age[title.age[, 1]==x["Title"], 2])



test <- train[-train.nrow, ]
train <- train[train.nrow, ]
set.seed(1234)
inTrain<-createDataPartition(train$Survived, p = 0.8)[[1]]


fit.8 <- glm(Survived ~ Pclass+Sex+Age+SibSp+Parch+Embarked+Title+Price+TicketCount, data=train[inTrain,], family=binomial(("logit")))
summary(fit.8)


confusionMatrix(train[-inTrain,"Survived"], as.numeric(as.numeric(predict(fit.8, train[-inTrain,])>0.5)))$overall[1]


fit.8 <- glm(Survived ~ Pclass+Sex+Age+SibSp+Parch+Embarked+Title+Price, data=train, family=binomial(("logit")))
predict.8<-predict(fit.8,  newdata=test, type="response")
test$Survived <- as.numeric(as.numeric(predict.8)>0.5)

write.csv(test[,c("PassengerId", "Survived")],"C:\\Users\\JMR\\Documents\\Máster\\II Sem_SIGE\\Practica1\\Titanic\\Experimentos\\Experimento 01 Missing Values\\experimentodetitulos.csv", row.names=F)
