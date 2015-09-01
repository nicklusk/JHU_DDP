library(shiny)
library(leaflet)
library(RColorBrewer)
library(scales)

shinyServer(
  function(input, output,session) {

      # Create the map
      output$map <- renderLeaflet({
          leaflet() %>%
              addTiles(
                  urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
                  attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
              ) %>%
              setView(lng = -4.7, lat = 50.4, zoom = 10)
      })

    selectedData <- reactive({
                subset(powerCurves,turbine==input$select)[,2:4]
                })

    shape<-2
    scale<-reactive({
            round(input$id1/gamma(1+1/shape),2)
    })

    AEP<-reactive({
            windprob<-dweibull(selectedData()$v,shape,scale())
            meanP<-sum(windprob*selectedData()$P)
            round(8760*meanP,2)
    })


    output$plot1 <- renderPlot({
            ggplot(selectedData(), aes(x=v, y=P)) +
                    geom_line(color="red") +
                    geom_point(color="red",size=4) +
                    ggtitle("Power vs wind speed")
    })

    output$plot2 <- renderPlot({
            ggplot(selectedData(), aes(x=v, y=cP)) +
                    geom_line(color="blue") +
                    geom_point(color="blue",size=4) +
                    ggtitle("Power coefficient vs wind speed")
    })

    output$oid1 <- scale#renderPrint({scale})
    output$oid2 <- AEP#renderPrint({input$id2})
   # output$odate <- renderPrint({input$date})
   # output$oid3 <- renderPrint({input$select})

    # This observer is responsible for maintaining the circles and legend,
    # according to the variables the user has chosen to map to color and size.
    observe({


        leafletProxy("map", data = windSpeeds) %>%
            clearShapes() %>%
            addRectangles(~lon, ~lat, ~lon+0.014, ~lat+0.009, layerId =NULL, group = NULL,
                          stroke = FALSE, color = "blue", weight = 5, opacity = 0, fill = TRUE,
                          fillColor = ~ws, fillOpacity = 0.5)

            #addLegend("bottomleft", pal=pal, values=colorData, title=colorBy,layerId="colorLegend")
    })

    # Show a popup at the given location when map is clicked
    showWTPopup <- function(site,lat, lon) {
        content <- as.character(tagList(
            sprintf("Latitude: %s", round(lat,2)), tags$br(),
            sprintf("Longitude: %s", round(lon,2)), tags$br(),
            sprintf("Wind speed: %s",tchoices[3])
        ))
        leafletProxy("map") %>% addPopups(lon, lat,content,layerId = site)
    }

    # When map is clicked, show a popup with site info
    observe({
        leafletProxy("map") %>% clearPopups()
        #event <- input$map_shape_click
        event <- input$map_click
        if (is.null(event))
        return()

        isolate({
            showWTPopup(event$id,event$lat, event$lng)
        })
    })

  }
)
