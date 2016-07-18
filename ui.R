#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(DT)

shinyUI(
  navbarPage(
    "Toilets",
    id = "nav",
    tabPanel("Australian Toilet Data",
      div(
        class = "outer",
                                  
      tags$head(
        # Include our custom CSS
        includeCSS("styles.css"),
        includeScript("gomap.js")
      ),
      
      leafletOutput("map",
                    width = "100%",
                    height = "100%"
                 ),
      
      absolutePanel(id = "controls",
                    class = "panel panel-default",
                    fixed = TRUE,
                    draggable = TRUE,
                    top = 70,
                    left = "auto",
                    right = 20,
                    bottom = "auto",
                    width = 400,
                    height = "auto",
                    
                    h2("Data Explorer"),
                    
                    h3("No. within map bounds:"),
                    
                    h4(textOutput("count"))
                    )
      )
    ),
    
    tabPanel("Data",
      
      fluidRow(
        column(3,
          selectInput("states",
                      "States",
                      c("All states"="",
                        as.character(
                          statecodes$state.abbr
                          )
                        ),
                      multiple = TRUE
                      )
          ),
      column(3,
             conditionalPanel(
               "input.states",
               selectInput(
                 "suburbs",
                 "Suburbs",
                 c("All suburbs"=""), 
                 multiple=TRUE
                 )
               )
             )
      ),
      
      hr(),
      
      dataTableOutput("table")
      ),
    
    conditionalPanel(
     "false",
     icon("crosshair")
     )
    )
  )