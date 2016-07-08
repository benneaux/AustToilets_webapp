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


shinyUI(navbarPage("Tax!", 
                   id = "nav",
                   
                   tabPanel("Australian Tax Data",
                            div(class = "outer",
                                
                                tags$head(
                                  # Include our custom CSS
                                  includeCSS("styles.css"),
                                  includeScript("gomap.js")
                                ),
                                mainPanel(
                                leafletMap("map", width = "100%", height = "100%",
                                  options=list(
                                    center = c(37.45, -93.85),
                                    zoom = 4,
                                    maxBounds = list(list(15.961329,-129.92981), list(52.908902,-56.80481))
                                  )
                                )))
                   ),
                   
                   tabPanel("histogram",
                            div(class = "outer",

                                sidebarLayout(
                                  sidebarPanel(
                                    sliderInput(
                                      "bins",
                                      "Number of bins:",
                                      min = 1,
                                      max = 50,
                                      value = 30
                                      )
                                    ),
                                  mainPanel(                                
                                    plotOutput(
                                      "distPlot"
                                    )
                                  )
                                )
                            )
                   )
))
