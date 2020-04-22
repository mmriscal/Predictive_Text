##################################################
####            MAIN.R                       #####
##################################################

## This code load the ngram tables, take a text, clean it and find the next word for it

main <- function(text = "this is an example")
{
        
#setwd("~/3. Personal/JHU/10. Data Science Capstone/Next_Word_Prediction")
source("Functions.R")

# Load the ngrams
g5 <- readRDS("ngrams/reduced_g5.rds")
g4 <- readRDS("ngrams/reduced_g4.rds")
g3 <- readRDS("ngrams/reduced_g3.rds")
g2 <- readRDS("ngrams/reduced_g2.rds") # This one is not reduced

# Input text and clean it
words <- text

# Separate the text in tokens
words <- unlist(strsplit(words, split = "\\s"))

# Clean: lower case, no numbers, no non-alphanumeric characters, etc.
words <- cleanText(words)

# FIND NEXT WORD

# Depending on the length of the text, I use a different ngram
l <- length(words)

next.word <- character()

# 5-gram
if (l >= 4) 
{
        more <- findMatch(g5, tail(words,4))
        more <- more[complete.cases(more)] 
        if(length(more))
        {
                next.word <- c(next.word, more)
        }
        
}

# 4-gram
if (l >= 3 & length(next.word) < 3) # If there are less than 3 results and text >
{
        more <- findMatch(g4, tail(words,3))
        more <- more[complete.cases(more)]
        if(length(more))
        {
                next.word <- c(next.word, more)
        }
}


# 3-gram if the text has 2 words or more. 
if (l >= 2 & length(next.word) < 3)
{
        more <- findMatch(g3, tail(words,2)) # Pass last 2 words and return 3 next words
        more <- more[complete.cases(more)] # take only non-NA
        if(length(more)) # if there are at least one, 
        {
                next.word <- c(next.word, more)
        }
}



# bi-gram in case there are not at least 3 suggestions
if (length(next.word) < 3)
{
        more <- findMatch(g2, tail(words,1)) 
        more <- more[complete.cases(more)] # take only non-NA
        if(length(more)) # if there are at least one, 
        {
                next.word <- c(next.word, more)
        }
}

next.word <- unique(next.word)

if (length(next.word) == 0) next.word<- sample(c("that", "of", "a", "in", "for", "but", 
                                                 "although", "and", "furthermore"), 3)

if (length(next.word)<3) next.word <- c(next.word, sample(c("that", "of", "a", "in", "for", "but", 
                                                            "although", "and", "furthermore"), 3))


return(next.word[1:3])

}









