##################################################
####            MAIN_spanish.R               #####
##################################################

## This code load the ngram tables, take a text, clean it and find the next word for it

main_spanish <- function(text = "hola")
{
        
#setwd("~/3. Personal/JHU/10. Data Science Capstone/Next_Word_Prediction")
source("Functions.R")

# Load the ngrams
spain_g5 <- readRDS("ngrams/spanish_g5b.rds")
spain_g4 <- readRDS("ngrams/spanish_g4b.rds")
spain_g3 <- readRDS("ngrams/spanish_g3b.rds")
spain_g2 <- readRDS("ngrams/spanish_g2b.rds") # This one is not reduced

# Separate the text in tokens
words <- unlist(strsplit(text, split = "\\s"))

# Input text and clean it
#words <- cleanText_spain(words)


# FIND NEXT WORD

# Depending on the length of the text, I use a different ngram
l <- length(words)

next.word <- character()

# 5-gram
if (l >= 4) 
{
        more <- findMatch_spain(spain_g5, tail(words,4))
        more <- more[complete.cases(more)] 
        if(length(more))
        {
                next.word <- c(next.word, more)
        }
        
}

# 4-gram
if (l >= 3 & length(next.word) < 3) # If there are less than 3 results and text >
{
        more <- findMatch_spain(spain_g4, tail(words,3))
        more <- more[complete.cases(more)]
        if(length(more))
        {
                next.word <- c(next.word, more)
        }
}

# 3-gram if the text has 2 words or more. 
if (l >= 2 & length(next.word) < 3)
{
        more <- findMatch_spain(spain_g3, tail(words,2)) # Pass last 2 words and return 3 next words
        more <- more[complete.cases(more)] # take only non-NA
        if(length(more)) # if there are at least one, 
        {
                next.word <- c(next.word, more)
        }
}

# bi-gram in case there are not at least 3 suggestions
if (length(next.word) < 3)
{
        more <- findMatch_spain(spain_g2, tail(words,1)) 
        more <- more[complete.cases(more)] # take only non-NA
        if(length(more)) # if there are at least one, 
        {
                next.word <- c(next.word, more)
        }
}

next.word <- unique(next.word)

if (length(next.word) == 0) next.word<- sample(c("pues", "de", "entonces", "que", 
                                        "para", "tu","en","si", "por", "segun", "sobre"), 3)

if (length(next.word)<3) next.word <- c(next.word, sample(c("pues", "de", "entonces", "que",
                                        "para", "tu","en","si", "por", "segun", "sobre"), 3))


return(next.word[1:3])



}









