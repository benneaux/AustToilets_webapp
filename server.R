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

### Create Leaflet map object=========

  colour <- colorFactor(
    rainbow(3),
    toiletdata$IsOpen
    )
  
  map = leaflet() %>%
    addProviderTiles(
      "CartoDB.Positron",
       options = providerTileOptions(
         noWrap = TRUE,
         minZoom = 7,
         unloadInvisibleTiles = TRUE
         )
      ) %>%

    
      addLegend(
        "bottomleft",
        pal=colour, 
        values=levels(toiletdata$IsOpen),
        labels=levels(toiletdata$IsOpen),
        opacity=1
      )
   
    output$map <- renderLeaflet(map)

### Toilet in bounds reactive====================
  
  toiletsInBounds <- reactive({
    
    if (is.null(input$map_bounds))
      
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
  
  observe({
    click <- input$map_marker_click
    
    if (is.null(click)) 
      
      return()
    
      selection <- paste(click)
      
      output$click_text <- renderText({selection})
  })

### Add data to Leaflet Map=============
  
  observe({
    
    leafletProxy(
      "map",
      data = toiletdata
    ) %>%

      clearShapes() %>%
      
      addPolygons(
        data = hne,
        layerId = "LHD"
      ) %>%
      
      addCircleMarkers(
        
        ~Longitude,
        ~Latitude,
        radius = 6,
        weight = 2,
        opacity = 1,
        fillOpacity = 0.8,
        layerId = ~suburb,

        clusterOptions = markerClusterOptions(
        
          zoomToBoundsOnClick = TRUE,
          removeOutsideVisibleBounds = TRUE,
          disableClusteringAtZoom = 12
        
        ),

        color=~colour(IsOpen)

      ) %>%
      
      setMaxBounds(
      
        lat1 = map.buffer[4],
        lat2 = map.buffer[2],
        lng1 = map.buffer[3],
        lng2 = map.buffer[1]
      
      ) %>%

      fitBounds(
      
        lat1 = map.bounds[4],
        lat2 = map.bounds[2],
        lng1 = map.bounds[3],
        lng2 = map.bounds[1]
    
      )
      
  })

  # Show a popup at the given location
  
  showToiletPopup <- function(lat, lng) {
    
    selectedToilet <- toiletdata[
      toiletdata$Latitude == lat &
      toiletdata$Longitude == lng
      , ]
    
      content <- as.character(
      
        tagList(
          tags$h4(selectedToilet$Name),
          tags$strong(
            HTML(
              sprintf(
                "%s, %s %s",
                selectedToilet$suburb,
                selectedToilet$state.abbr,
                selectedToilet$Postcode
                )
              )
            ),
          tags$br(),
          tags$br(),
          sprintf(
            "Access: %s", 
            selectedToilet$IconAltText
            )
          )
        )
    
    leafletProxy("map") %>%
      
      setView(
        lng, 
        lat, 
        zoom = input$map_zoom
      ) %>%
      
      addPopups(
        lng,
        lat,
        content
      )
    }
  
  # When map is clicked, show a popup with city info
  clickObs <- observe({
    
    leafletProxy("map") %>% clearPopups()
    
    event <- input$map_marker_click
    
    if (is.null(event))
      
      return()
    
    isolate({
      showToiletPopup(
        lat = event$lat,
        lng = event$lng
        ) 
    })
  })
  
  session$onSessionEnded(clickObs$suspend)
  
  ### Number of toilets in bounds - count=========  
    
  output$count <- renderText(
    
    nrow(toiletsInBounds())
  
  )
  
### Filtering on Data tab=====

observe({
  suburbs <- if (is.null(input$states)) {
    
    character(0)
  
  } else {
    
    filter(
      toiletdata, 
      state.abbr %in% input$states
      ) %>%
      `$`('suburb') %>%
      unique() %>%
      sort()
  }
   stillSelected <- isolate(
     input$suburbs[
       input$suburbs %in% suburbs
       ]
     )
   updateSelectInput(
     session,
     "suburbs",
     choices = as.character(suburbs),
     selected = stillSelected
     )
   })
  
  observe({
    if (is.null(input$goto))
      
      return()
    
    isolate({
      
      map <- leafletProxy("map")
      map %>% clearPopups()
      
      dist <- 0.05
      sub <- input$goto$sub
      lat <- input$goto$lat
      lng <- input$goto$lng
      
      showToiletPopup(lat, lng)
      
      map %>% fitBounds(
        lng1 = lng + dist,
        lng2 = lng - dist,
        lat1 = lat + dist,
        lat2 = lat - dist
        )
    })
  })
    
output$table <- DT::renderDataTable({
  
  df <- toiletdata %>%
    filter(
      is.null(input$states) | state.abbr %in% input$states,
      is.null(input$suburbs) | suburb %in% input$suburbs
    ) %>%
    mutate(
      Find = paste(
        '<a class="go-map" href="" data-lat="',
        Latitude,
        '" data-long="',
        Longitude,
        '" data-sub="',
        suburb,
        '"><i class="fa fa-crosshairs"></i></a>',
        sep=""
        )
      ) %>%
    
    select(
      Find,
      everything()
      )

  
  action <- DT::dataTableAjax(session,df)
  
  DT::datatable(
    df,
    options = list(
      ajax = list(
        url = action
      )
    ),
    escape = FALSE
  )
})
})
