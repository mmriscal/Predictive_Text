#######################################
####    TEST THE MODEL            #####
#######################################

setwd("~/3. Personal/JHU/10. Data Science Capstone/Next_Word_Prediction")
library(stringr)
library(dplyr)
source("Functions.R")
source("Main2.R")
library(doSNOW)

# test: When you breathe, I want to be the air for you. I'll be there for you, I'd live and I'd
# test: Talking to your mom has the same effect as a hug and helps reduce your

## READING THE DATA
con <- file("~/3. Personal/JHU/10. Data Science Capstone/test/en_US.twitter.txt", "r") 
US_twitter <- readLines(con, 1000)
close(con)

corpus <- unlist(strsplit(US_twitter, split = "\\s"))
corpus <- cleanText(corpus)

count <- 0
number <- 1000

cl <- makeCluster(5, type = "SOCK")
registerDoSNOW(cl)

for (i in 1:number)
{
        # I will take random lenghts of text in random positions
        p <- floor(runif(1, min = 1, max = length(corpus)-5))
        n <- p + floor(runif(1, min = 1, max = 5))
        
        text <- paste(corpus[p:n], collapse = " ")
        pred <- main(text)
        real <- corpus[n+1]
        # if one the the suggested words is ok, count 1
        if (real == pred[1] | real == pred[2] | real == pred[3]) count <- count + 1
}

rate <- (count/number)*100
print(paste(rate,"%"))
stopCluster(cl)


## USANDO REDUCED_GRAMS 
# la tasa de acierto con twitter y 10.000 pruebas es del 30%
# y con News (palabras no usadas en el train) es del 29% 

# 200 pruebas y todos reduced - 27%
# 200 pruebas y solo g3 order - 30%

## USANDO ORDER_GRAMS
# la tasa de acierto con twitter y 10.000 pruebas es del 89.12% !!!!
# con 200 pruebas es de un 27.5%


