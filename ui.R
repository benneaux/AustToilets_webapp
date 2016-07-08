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
                                
                                leafletMap(
                                  "map",
                                  width = "100%",
                                  height = "100%"
                                  )
                                
                            )
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
