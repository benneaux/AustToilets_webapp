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

popup.text <- paste(toiletdata$Name, ", ", toiletdata$suburb, ": ", toiletdata$IconAltText) 

# Define server logic required to draw a histogram

shinyServer(function(input, output, session) {

### Create Leaflet map object=========
  
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(
#         urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
#         attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
       ) %>%
    setView(lat = -24.920527, lng = 134.211614, zoom = 4)
  })

### Toilet in bounds reactive====================
  
  toiletsInBounds <- reactive({
    
    if (is.null(
      input$map_bounds
      ))
      return(toiletdata[FALSE,])
    
    bounds <- input$map_bounds
    
    latRng <- range(
      bounds$north, 
      bounds$south
      )
    
    lngRng <- range(
      bounds$east,
      bounds$west
      )
    
    subset(
      toiletdata,
      Latitude > latRng[1] 
      & Latitude < latRng[2] 
      & Longitude > lngRng[1] 
      & Longitude < lngRng[2]
    )
  })

### Add data to Leaflet Map=============
  
  observe({
    
    leafletProxy("map", data = toiletdata) %>%
      
      clearShapes() %>%
      
      addCircleMarkers(
        ~Longitude, 
        ~Latitude, 
        popup = popup.text, 
        radius = 8, 
        clusterOption = TRUE) %>%
      
      fitBounds(
        lng1 = max(toiletdata$Longitude), 
        lat1 = max(toiletdata$Latitude),
        lng2 = min(toiletdata$Longitude), 
        lat2 = min(toiletdata$Latitude)
        )
  })

### Number of toilets in bounds - count=========  
    
  output$count <- renderText(
    
    nrow(toiletsInBounds())
  
  )

### Range of map bounds==========    
  output$bounds <- reactive({
    
    list(
      input$map_bounds$north,
      input$map_bounds$east
      )
 
  })

  # When map is clicked, show a popup with city info

  output$table <- renderDataTable({
    df <- toiletsInBounds() %>%
      filter(
        is.null(input$states) | state.abbr %in% input$states
      ) %>%
      mutate(Action = paste('<a class="go-map" href="" data-lat="', Latitude, '" data-long="', Longitude, '" data-suburb="', suburb, '"><i class="fa fa-crosshairs"></i></a>', sep=""))
    action <- DT::dataTableAjax(session, df)
    
    datatable(df, options = list(ajax = list(url = action)), escape = FALSE)
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

### Filtering on Data tab=====

observe({
  suburbs <- if (is.null(input$states)) character(0) else {
    filter(toiletdata, state %in% input$states) %>%
      `$`("Suburb") %>%
      unique() %>%
      sort()
  }
  stillSelected <- isolate(input$suburbs[input$suburbs %in% suburbs])
  updateSelectInput(session, "suburbs", choices = suburbs,
                    selected = stillSelected)
})

