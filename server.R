#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(leaflet)
library(shiny)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  map <- createLeafletMap(session, "map")
  
   
  output$distPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    x    <- taxdata[, 2] 
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
  })
  
})
