# Predictive_Text
APP to predict next word from previous.

## Introduction
Around the world, people are spending an increasing amount of time on their mobile devices for email, social networking, banking and a whole range of other activities. But typing on mobile devices can be a serious pain.
With this code, I train a model based on N-grams and Markov Chains to predict the next word given one or more previous words. 

## Reading and pre-processing the data
In this case, I took the data from twitter, blogs, news and books (in Spanish). R has a few libraries very interesting to work with NLP (Natural Language Processing). But I did not use any of the functions that you can find in R for cleaning the data because I did not get good results with them. On the contrary, I made my own functions to clean English and Spanish texts. They worked better than R libraries with my corpus although probably they shouldn´t fit so well with a different dataset.

A report on this can be found here: https://rpubs.com/mmriscal/598900

## Organizing the corpus
After thinking a lot about it, it was clear to me that the famous n-gram model was the best way to organize the words. The computation times were very high and I had to control the memory and size of the objects. To reduced the n-gram tables, I finally decided to eliminate the phrases with less than two repetitions. Except for bi-grams and for the spanish dataset (which was already very reduced).

But before eliminating part of the dataset I made some test on the performance and I could check that with the reduced tables the prediction was around 3-5% worse. Anyway, I did not have a choice because with the compleated ngrams the time for the calculation was unacceptable.

## Making the model and predictions
To have some fun, I decided not to follow any of the models that you can find on internet. To predict the next word, it seems like everybody uses markmov chains with back-off models (https://en.wikipedia.org/wiki/Katz%27s_back-off_model). 
So, I started to think and work... but the logic finally took me to the same kind of idea. At the end, my own model was a sort of backoff chain but probably a little worse (less efficient). At least, I am happy of being able to get to the "almost" same point by my own. Anyway, my prediction was quite fast and accurate so I left it as I designed. 

## Shiny app
To be honest, I did not want to waste time thinking about aestetics. Therefore, I surfed on internet and I found a guy who did a really good job on the shiny interface: https://github.com/achalshah20/Next-Word-Prediction-Model-Using-ANLP/blob/master/Shiny/ui.R

I just copied and changed a little his work (to adapt it to my bilingual version)

You can try my final app here: 
 https://mmriscal.shinyapps.io/Next_Word_Prediction/
 
 
