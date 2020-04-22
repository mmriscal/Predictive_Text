###############################################
####        CREATE N-GRAM TABLEs         ######
###############################################

library(doSNOW)
library(plyr)

#setwd("~/3. Personal/JHU/10. Data Science Capstone")
source("Functions.R")



## READING THE DATA
#con <- file("~/3. Personal/JHU/10. Data Science Capstone/final/en_US/en_US.blogs.txt", "r") 
#US_blogs <- readLines(con)
#close(con)

#con <- file("~/3. Personal/JHU/10. Data Science Capstone/final/en_US/en_US.twitter.txt", "r") 
#US_twitter <- readLines(con)
close(con)

#con <- file("~/3. Personal/JHU/10. Data Science Capstone/final/en_US/en_US.news.txt", "r") 
#US_news <- readLines(con)
#close(con)

# Separate in tokens
blogs <- unlist(strsplit(US_blogs, split = "\\s"))
twitter <- unlist(strsplit(US_twitter, split = "\\s"))
news <- unlist(strsplit(US_news, split = "\\s"))

## SAMPLING THE DATA
## I will concatenate words from blogs, twitter and news

words <- c(blogs[1:200000], twitter[1:200000], news[1:200000])

## CLEAN THE TEXT
words <- cleanText(words)


############################################## CREATE TABLE 5-GRAMS

# I use parallel processing with 5 cores
cl <- makeCluster(5, type = "SOCK")
registerDoSNOW(cl)

# Time the code execution
start.time <- Sys.time()

g5 <- data.frame(matrix(ncol = 5 , nrow = 0))
colnames(g5) <- c("word_1", "word_2", "word_3", "word_4", "word_5")
for (i in 1:length(words)-4)
{
        g5[i,1] <- words[i]
        g5[i,2] <- words[i+1]
        g5[i,3] <- words[i+2]
        g5[i,4] <- words[i+3]
        g5[i,5] <- words[i+4]
}
# Total time of execution. 
total.time <- Sys.time() - start.time
total.time

# Processing is done, stop cluster.
stopCluster(cl)

# I can only use 7GB of RAM
object.size(g5)

# Save it for using it later
saveRDS(g5, "ngrams/g5.rds")

# REDUCE THE SIZE OF THE DATAFRAME TAKING ONLY THE MOST REPEATED SENTENCES

# Find the repeated sentences in g5
list <- ddply(g5,.(word_1,word_2, word_3, word_4, word_5),nrow)
list <- list[order(list$V1, decreasing = TRUE),]
colnames(list)[6] <- "Freq"

# I will take only those sentences that appear 2 or more times
reduced_g5 <- list[list$Freq > 1,]

# Now the object is much smaller
object.size(reduced_g5)

# Save it for using it later
saveRDS(reduced_g5, "ngrams/reduced_g5.rds")



############################################## CREATE TABLE 4-GRAMS

# I use parallel processing with 5 cores
cl <- makeCluster(5, type = "SOCK")
registerDoSNOW(cl)

# Time the code execution
start.time <- Sys.time()

g4 <- data.frame(matrix(ncol = 4 , nrow = 0))
colnames(g4) <- c("word_1", "word_2", "word_3", "word_4")
for (i in 1:length(words)-3)
{
        g4[i,1] <- words[i]
        g4[i,2] <- words[i+1]
        g4[i,3] <- words[i+2]
        g4[i,4] <- words[i+3]
}
# Total time of execution. 
total.time <- Sys.time() - start.time
total.time

# Processing is done, stop cluster.
stopCluster(cl)

# I can only use 7GB of RAM
object.size(g4)

# Save it for using it later
saveRDS(g4, "ngrams/g4.rds")

# REDUCE THE SIZE OF THE DATAFRAME TAKING ONLY THE MOST REPEATED SENTENCES

# Find the repeated sentences in g4
list <- ddply(g4,.(word_1,word_2, word_3, word_4),nrow)
list <- list[order(list$V1, decreasing = TRUE),]
colnames(list)[5] <- "Freq"

# I will take only those sentences that appear 2 or more times
reduced_g4 <- list[list$Freq > 1,]

# Now the object is much smaller
object.size(reduced_g4)

# Save it for using it later
saveRDS(reduced_g4, "ngrams/reduced_g4.rds")


############################################## CREATE TABLE 3-GRAMS

# I use parallel processing with 5 cores
cl <- makeCluster(5, type = "SOCK")
registerDoSNOW(cl)

# Time the code execution
start.time <- Sys.time()

g3 <- data.frame(matrix(ncol = 3 , nrow = 0))
colnames(g3) <- c("word_1", "word_2", "word_3")
for (i in 1:length(words)-2)
{
        g3[i,1] <- words[i]
        g3[i,2] <- words[i+1]
        g3[i,3] <- words[i+2]
}
# Total time of execution. 
total.time <- Sys.time() - start.time
total.time

stopCluster(cl)

# Save it for using it later
saveRDS(g3, "ngrams/g3.rds")

# Save the reduced data frame with only 2 or more repetitions
list <- ddply(g3,.(word_1,word_2, word_3),nrow)
list <- list[order(list$V1, decreasing = TRUE),]
colnames(list)[4] <- "Freq"
reduced_g3 <- list[list$Freq > 1,]
saveRDS(reduced_g3, "ngrams/reduced_g3.rds")



############################################## CREATE TABLE 2-GRAMS

# I use parallel processing with 5 cores
cl <- makeCluster(5, type = "SOCK")
registerDoSNOW(cl)

# Time the code execution
start.time <- Sys.time()

g2 <- data.frame(matrix(ncol = 2 , nrow = 0))
colnames(g2) <- c("word_1", "word_2")
for (i in 1:length(words)-1)
{
        g2[i,1] <- words[i]
        g2[i,2] <- words[i+1]
}
# Total time of execution. 
total.time <- Sys.time() - start.time
total.time

stopCluster(cl)

# Save it for using it later
saveRDS(g2, "ngrams/g2.rds")

# For g2, I will save the complete data set because it will be the last search
list <- ddply(g2,.(word_1,word_2),nrow)
list <- list[order(list$V1, decreasing = TRUE),]
colnames(list)[3] <- "Freq"
saveRDS(list, "ngrams/order_g2.rds")

