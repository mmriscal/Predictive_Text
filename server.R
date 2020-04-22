######################################################
###########         SERVER.R                ##########
######################################################


library(shiny)
source("Main.R")
source("Main_spanish.R")

shinyServer(function(input, output, session) {
    
     observe({
        
        text <- reactive({input$text})
        
        if (input$language == 1) # spanish
        {
            predictions <- main_spanish(text())
            a1 <<- predictions[1]
            a2 <<- predictions[2]
            a3 <<- predictions[3]
            
           
        }
        
        if (input$language == 2) # english
        {
            predictions <- main(text())
            a1 <<- predictions[1]
            a2 <<- predictions[2]
            a3 <<- predictions[3]
            
        }
        
     
  ###########################################################
        
        output$prediction1 <- renderUI({
            actionButton("button1", label = a1)
            
        })
        
        
        output$prediction2 <- renderUI({
            actionButton("button2", label = a2)
            
        })
        
        
        output$prediction3 <- renderUI({
            actionButton("button3", label = a3)
            
        })
        
     })
    ########################################################
        
        observeEvent(input$button1, {
            #   if(input$button1 == 1){
            name <- paste(input$text, a1)
            updateTextInput(session, "text", value=name)
            #   }
            
        })
        
        observeEvent(input$button2, {
            
            name <- paste(input$text, a2)
            updateTextInput(session, "text", value=name)
        })
            
        observeEvent(input$button3, {
            
            name <- paste(input$text, a3)
            updateTextInput(session, "text", value=name)
        })
        
        observeEvent(input$language, {
            name <- ""
            updateTextInput(session, "text", value=name)
        })
        
        

})
    