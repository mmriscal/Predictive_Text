#################################################
###### GET SPANISH TEXT NGRAMS     #############
#################################################

#setwd("~/3. Personal/JHU/10. Data Science Capstone/Next_Word_Prediction")
source("Functions.R")

library(tm)
library(quanteda)

library(doSNOW)
library(plyr)
#install.packages("twitteR")
library("twitteR")
#install.packages("RCurl")
library("RCurl")


## Get data from twitter

api_key <- "x21hpOoT0scZmTyogZ7udOvjo"

api_secret <- "9Qy5sNicMgKxj21aJepwuBtsmjQH8RNuw4H9vekomvwOM9OY6D"

access_token <- "408452318-CLFeV9AF2WJA6q2ojiveliwhugrSc72KF7lzxtad"

access_token_secret <- "7JqYVnJA5lpgp2R9UF8CUX2BrxXx3znwcc3vlsNPUeBSk"

setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)

#"Using direct authentication"
#Use a local file ('.httr-oauth'), to cache OAuth access credentials between R sessions?
 #  1: Yes
 # 2: No
1

# download tweets

#tweets1 <- searchTwitter("elmundoes", n=3000, lang = "es")
tweets1 <- favorites("elmundoes", n = 200)
tweets2 <- favorites("el_pais", n = 200)
tweets3 <- favorites("abc_es", n = 200)
tweets4 <- favorites("abc_cultura", n = 200)
tweets5 <- favorites("marca", n = 200)
tweets6 <- favorites("elpaissemanal", n = 200)

# transform to dataframes
tweets1 <- twListToDF(tweets1)
tweets2 <- twListToDF(tweets2)
tweets3 <- twListToDF(tweets3)
tweets4 <- twListToDF(tweets4)
tweets5 <- twListToDF(tweets5)
tweets6 <- twListToDF(tweets6)

tweets <- rep(c("Hola mi nombre es", "Yo soy un", "hola como estas"), times = 30)

tweets <- c(tweets,tweets1$text,tweets2$text,tweets3$text,tweets4$text,tweets5$text,tweets6$text)
rm(tweets1, tweets2, tweets3, tweets4, tweets5, tweets6)

# download text in Spanish

# read teatro and books in spanish
#con <- file("~/3. Personal/JHU/10. Data Science Capstone/dataset/espanol/teatro.txt", "r") 
#teatro <- readLines(con)
#close(con)

#con <- file("~/3. Personal/JHU/10. Data Science Capstone/dataset/espanol/teatro2.txt", "r") 
#teatro2 <- readLines(con)
#close(con)


#con <- file("~/3. Personal/JHU/10. Data Science Capstone/dataset/espanol/texto.txt", "r") 
#texto <- readLines(con)
#close(con)

mio <- rep("Yo me llamo pepe y yo soy el hombre más guapo del mundo yo no tengo complejos yo quiero lo mejor para todos yo amo al mundo yo estoy trabajando duro yo estoy viendo la tele yo estoy deseando verte yo tengo un tren yo tengo un juguete yo tengo un nuevo coche yo te amo yo te quiero yo te deseo yo te prefiero yo te espero
El trabajo es una fuente de ingresos el virus esta matando a mucha gente el coronavirus está matando a gente y acabará con la economía mundial el amor a una madre es enorme el amor a otras personas es un motivo para despertarse cada día el telediario no para de poner noticias malas el perro de san roque no tiene rabo el 
De una manera u otra de una manera u otra de una manera u otra vamos a hacerlo de paso se consigue todo lo que quieres cuando hay un propósito en la vida se consigue dinero  amor y amistad 
Creo que el coronavirus creo que el coronavirus va acabar con la economía española y la economía mundial porque creo que tienes razón y creo que te mereces algo más que lo que tienes y creo que un buen principio sería ideal creo que vamos a ser buenos amigos
Esas cosas son fáciles de implementar, si las quejas van llegando supongo que se hará ya está bueno chavales me voy a casa a comer de otros porque no tiene sentido eso que dices
", 30)

tweets <- unlist(strsplit(tweets, split = "\\s"))
texto <- unlist(strsplit(texto, split = "\\s"))
teatro <- unlist(strsplit(teatro, split = "\\s"))
teatro2 <- unlist(strsplit(teatro2, split = "\\s"))
mio <- unlist(strsplit(mio, split = "\\s"))

words <- c(tweets, texto, teatro, teatro2, mio)
rm(texto, teatro, teatro2, mio)


#############################################################################################
# CLEAN THE TEXT
words <- cleanText_spain(words)


##########################################################################################

# MAKE N-GRAMS

############################################## CREATE TABLE 5-GRAMS

# I use parallel processing with 5 cores
cl <- makeCluster(5, type = "SOCK")
registerDoSNOW(cl)

# Time the code execution
start.time <- Sys.time()

spanish_g5 <- data.frame(matrix(ncol = 5 , nrow = 0))
colnames(spanish_g5) <- c("word_1", "word_2", "word_3", "word_4", "word_5")
for (i in 1:length(words)-4)
{
        spanish_g5[i,1] <- words[i]
        spanish_g5[i,2] <- words[i+1]
        spanish_g5[i,3] <- words[i+2]
        spanish_g5[i,4] <- words[i+3]
        spanish_g5[i,5] <- words[i+4]
}
# Total time of execution. 
total.time <- Sys.time() - start.time
total.time

stopCluster(cl)

# Save it for using it later
#saveRDS(spanish_g3, "ngrams/spanish_g3.rds")

list <- ddply(spanish_g5,.(word_1,word_2, word_3, word_4, word_5),nrow)
list <- list[order(list$V1, decreasing = TRUE),]
colnames(list)[6] <- "Freq"
saveRDS(list, "ngrams/spanish_g5b.rds")

############################################## CREATE TABLE 4-GRAMS

# I use parallel processing with 5 cores
cl <- makeCluster(5, type = "SOCK")
registerDoSNOW(cl)

# Time the code execution
start.time <- Sys.time()

spanish_g4 <- data.frame(matrix(ncol = 4 , nrow = 0))
colnames(spanish_g4) <- c("word_1", "word_2", "word_3", "word_4")
for (i in 1:length(words)-3)
{
        spanish_g4[i,1] <- words[i]
        spanish_g4[i,2] <- words[i+1]
        spanish_g4[i,3] <- words[i+2]
        spanish_g4[i,4] <- words[i+3]
}
# Total time of execution. 
total.time <- Sys.time() - start.time
total.time

stopCluster(cl)

# Save it for using it later
#saveRDS(spanish_g3, "ngrams/spanish_g3.rds")

list <- ddply(spanish_g4,.(word_1,word_2, word_3, word_4),nrow)
list <- list[order(list$V1, decreasing = TRUE),]
colnames(list)[5] <- "Freq"
saveRDS(list, "ngrams/spanish_g4b.rds")

############################################## CREATE TABLE 3-GRAMS

# I use parallel processing with 5 cores
cl <- makeCluster(5, type = "SOCK")
registerDoSNOW(cl)

# Time the code execution
start.time <- Sys.time()

spanish_g3 <- data.frame(matrix(ncol = 3 , nrow = 0))
colnames(spanish_g3) <- c("word_1", "word_2", "word_3")
for (i in 1:length(words)-2)
{
        spanish_g3[i,1] <- words[i]
        spanish_g3[i,2] <- words[i+1]
        spanish_g3[i,3] <- words[i+2]
}
# Total time of execution. 
total.time <- Sys.time() - start.time
total.time

stopCluster(cl)

# Save it for using it later
#saveRDS(spanish_g3, "ngrams/spanish_g3.rds")

list <- ddply(spanish_g3,.(word_1,word_2, word_3),nrow)
list <- list[order(list$V1, decreasing = TRUE),]
colnames(list)[4] <- "Freq"
#reduced_g3 <- list[list$Freq > 1,]
saveRDS(list, "ngrams/spanish_g3b.rds")

############################################## CREATE TABLE 2-GRAMS

# I use parallel processing with 5 cores
cl <- makeCluster(5, type = "SOCK")
registerDoSNOW(cl)

# Time the code execution
start.time <- Sys.time()

spanish_g2 <- data.frame(matrix(ncol = 2 , nrow = 0))
colnames(spanish_g2) <- c("word_1", "word_2")
for (i in 1:length(words)-1)
{
        spanish_g2[i,1] <- words[i]
        spanish_g2[i,2] <- words[i+1]
}
# Total time of execution. 
total.time <- Sys.time() - start.time
total.time

stopCluster(cl)

# Save it for using it later
#saveRDS(g2, "ngrams/spanishg2.rds")

# For g2, I will save the complete data set because it will be the last search
list <- ddply(spanish_g2,.(word_1,word_2),nrow)
list <- list[order(list$V1, decreasing = TRUE),]
colnames(list)[3] <- "Freq"
saveRDS(list, "ngrams/spanish_g2b.rds")













































