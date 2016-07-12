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

options(digits = 16)
# set.seed(100)
# toiletdata <- toiletdata[sample.int(nrow(toiletdata), 1000),]
popup.text <- paste(toiletdata$Name, ", ", toiletdata$suburb, ": ", toiletdata$IconAltText) 

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

#  map <- createLeafletMap(session, "map")
  
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(
#         urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
#         attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
       ) %>%
    setView(lat = -24.920527, lng = 134.211614, zoom = 4)
  })


  
  toiletsInBounds <- reactive({
    if (is.null(input$map_bounds))
      return(toiletdata[FALSE,])
    bounds <- input$map_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    subset(toiletdata,
           lat > latRng[1] & lat < latRng[2] &
             lon > lngRng[1] & lon < lngRng[2])
    
  })

  
  observe({
    leafletProxy("map", data = toiletdata) %>%
      clearShapes() %>%
      addCircleMarkers(~lon, ~lat, popup = popup.text, radius = 8, clusterOption = TRUE) %>%
      fitBounds(lng1 = max(toiletdata$lon), lat1 = max(toiletdata$lat),
                lng2 = min(toiletdata$lon), lat2 = min(toiletdata$lat))
  })
  
  output$count <- renderText(
    nrow(toiletsInBounds())
  )
  
  output$bounds <- reactive({
    list(input$map_bounds$north,
    input$map_bounds$east)
  })

  # When map is clicked, show a popup with city info

  output$table <- renderDataTable({
    datatable(toiletsInBounds())
  })
  
#   output$distPlot <- renderPlot({
#     
#     # generate bins based on input$bins from ui.R
#     x    <- taxdata[, 2] 
#     bins <- seq(min(x), max(x), length.out = input$bins + 1)
#     
#     # draw the histogram with the specified number of bins
#     hist(x, breaks = bins, col = 'darkgray', border = 'white')
#     
#     
#   })
})
