################################################################
#############           UI.R - PREDICT NEXT WORD      ##########
################################################################

library(shiny)
library(shinythemes)
library(wordcloud)
library(stringr)
library(dplyr)
library(qdapDictionaries)

shinyUI(navbarPage("Predictive Text",
                   theme = shinytheme("spacelab"),
                   
tabPanel(HTML ("<li><a href=\'https://www.linkedin.com/in/mmriscal'>Check my Linkedin</a></li>"),

                
    fluidRow(
            column(2,
                   selectInput("language", label = h5("Select language"), 
                        choices = list("Spanish*" = 1, "English" = 2), 
                        selected = 2)),
            
            column(5, offset = 2,
                   tags$head(
                       tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
                           ),
                           tags$div(
                       
                       h5("Enter your text"),
                       tags$textarea(id = 'text', placeholder = 'Type here', rows = 3, class='form-control',""),
                                           
                                           
                        HTML('<script type="text/javascript"> document.getElementById("text").focus();</script>'),
                                           
                                           HTML("<div id='buttons'>"),
                                           uiOutput("prediction1",inline = T),
                                           uiOutput("prediction2",inline = T),
                                           uiOutput("prediction3",inline = T)),
                                       HTML("</div>"),align="center"),
                                
                                
                                column(3)
                            )),
        fluidRow(column(9, h2(""), h2(""), h2(""), 
                        h6("* Please, note that the spanish predictor is a beta version and it was 
                      trained with a reduced dataset")), h2("")),
        
        
        fluidRow(
                column(9,
                          h6("This predictive text project is an application which is trained on large 
                          amount of text data to predict next word based on previous words. The text
                          is processing with NLP techniques and the prediction is made using Markov
                          models and backoff algorithms with N-grams"),
                       )
        ),
                   
        ## Footer
        hr(),        

        tags$span(style="color:grey", 
                tags$footer("Manuel Mariscal: ", 
                tags$a(href="mailto:mmriscal@gmail.com", target="_blank"," e-mail"), 
                align = "Center")),

        tags$span(style="color:grey", 
          tags$footer("You can find more of my projects in: ", 
                      tags$a(href="https://rpubs.com/mmriscal", target="_blank"," My Rpubs"), 
                      align = "Center"))
                   
))


