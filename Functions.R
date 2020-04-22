###############################################
###         FUNCTIONS DEFINITION            ###
###############################################

#setwd("~/3. Personal/JHU/10. Data Science Capstone/Next_Word_Prediction")

library(stringr)
library(dplyr)
library(qdapDictionaries)

# Takes a text in tokens and return the words cleaned
cleanText <- function(text) 
{
        ## Removing all non-alphanumeric characters
        new_words <- gsub("[^[:alnum:]]", "", text)
        
        ## Removing punctuation characters
        new_words <- str_replace_all(new_words, '[[:punct:]]', '')
        # special case: can?t --> ?
        #new_words <- str_replace_all(new_words, "?", "")
        
        ## Eliminate numbers
        new_words <- gsub("[[:digit:]]+", "", new_words)
        
        ## Removing words with no vowels
        new_words <-  gsub("(\\b[^\\s\\aeiouAEIOU]+\\b)", "", new_words)
        
        ## change all words to lowercase
        new_words <- tolower(new_words)
        
        ## Removing blank spaces
        new_words <- new_words[new_words != ""]
        
        ## Removing words that aren?t in English Dictionary
        new_words <- new_words[new_words %in% GradyAugmented]
        
        
        words <- new_words
        return(words)
}

cleanText_spain <- function(text)
{
        # CLEAN THE DATA
        
        # list of common words in Spanish
        #RAE <- read.delim("~/3. Personal/JHU/10. Data Science Capstone/dataset/espanol/CREA_total.txt",header = TRUE)
        
        ## Removing all non-alphanumeric characters
        new_words <- gsub("[^[:alnum:]]", "", text)
        
        ## Removing punctuation characters
        #new_words <- str_replace_all(new_words, "[[:punct:]]", "")
        # special cases for spanish and twitter
        new_words <- str_replace_all(new_words, "RT", "")
        
        ## Eliminate numbers
        new_words <- gsub("[[:digit:]]+", "", new_words)
        
        ## Removing words with no vowels
        new_words <-  gsub("(\\b[^\\s\\aeiouAEIOU]+\\b)", "", new_words)
        
        ## change all words to lowercase
        new_words <- tolower(new_words)
        
        ## Removing blank spaces
        new_words <- new_words[new_words != ""]
        
        ## Removing https
        new_words <- gsub("http\\w+ *", "", new_words)
        
        ## Removing @
        new_words <- gsub("@\\w+ *", "", new_words)
        
        ## Removing words that arent in Spanish Dictionary
        #new_words <- new_words[new_words %in% RAE$Orden]
        
        clean_words <- new_words
        return(clean_words)
}

# Find the matches of a text in a ngram table. 
# Inputs are a ngram table and a list of words in tokens (from a text)
# Return a list with the 3 most frequent next words
findMatch <- function(ngram, text)
{
        if (length(text) == 1) # Use bi-gram
        {
                # return only next word
                list <- as.character( ngram[ngram$word_1 == text[1], 2]) 
                return(list[1:3]) # return first 3 matches
        }
        if (length(text) == 2) # Use 3-gram
        {
                list <- as.character( ngram[ngram$word_1 == text[1] &
                                      ngram$word_2 == text[2] , 3] )
                return(list[1:3]) 
        }
        if (length(text) == 3) # Use 4-gram
        {
                list <- as.character( ngram[ngram$word_1 == text[1] &
                                      ngram$word_2 == text[2] &
                                      ngram$word_3 == text[3] , 4] )
                return(list[1:3])
        }
        if (length(text) == 4) # Use 5-gram
        {
                list <- as.character( ngram[ngram$word_1 == text[1] &
                                      ngram$word_2 == text[2] &
                                      ngram$word_3 == text[3] &
                                      ngram$word_4 == text[4], 5]  )
                return(list[1:3])
        }
        
        if (length(text) != 1 & length(text) != 2 & length(text) != 3
            & length(text) != 4) return(c("I", "the", "of"))
}

findMatch_spain <- function(ngram, text)
{
        if (length(text) == 1) # Use bi-gram
        {
                # return only next word
                list <- as.character( ngram[ngram$word_1 == text[1], 2]) 
                return(list[1:3]) # return first 3 matches
        }
        if (length(text) == 2) # Use 3-gram
        {
                list <- as.character( ngram[ngram$word_1 == text[1] &
                                                    ngram$word_2 == text[2] , 3] )
                return(list[1:3]) 
        }
        if (length(text) == 3) # Use 4-gram
        {
                list <- as.character( ngram[ngram$word_1 == text[1] &
                                                    ngram$word_2 == text[2] &
                                                    ngram$word_3 == text[3] , 4] )
                return(list[1:3])
        }
        if (length(text) == 4) # Use 5-gram
        {
                list <- as.character( ngram[ngram$word_1 == text[1] &
                                                    ngram$word_2 == text[2] &
                                                    ngram$word_3 == text[3] &
                                                    ngram$word_4 == text[4], 5]  )
                return(list[1:3])
        }
        
        if (length(text) != 1 & length(text) != 2 & length(text) != 3
            & length(text) != 4) return(c("yo", "el", "de"))
}









