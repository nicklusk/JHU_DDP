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
                  urlTemplate = "http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
              ) %>%
              setView(lng = -4.7, lat = 50.4, zoom = 10)
      })

    selectedData <<- reactive({
                subset(powerCurves,turbine==input$select)[,2:4]
                })

    shape<-2

#     scale1<-reactive({
#             round(input$id1/gamma(1+1/shape),2)
#     })

    AEP1<-reactive({
            AEP(seq(4,10),shape,selectedData()$v,selectedData()$P)
    })


    output$plot1 <- renderPlot({
            ggplot(selectedData(), aes(x=v, y=P)) +
                    geom_line(color="red") +
                    geom_point(color="red",size=2) +
                    ggtitle("Power vs wind speed")
    })

    output$plot2 <- renderPlot({
            ggplot(selectedData(), aes(x=v, y=cP)) +
                    geom_line(color="blue") +
                    geom_point(color="blue",size=2) +
                    ggtitle("Power coefficient vs wind speed")
    })

    output$plot3 <- renderPlot({
        ggplot(selectedData(), aes(x=v, y=cP)) +
            geom_line(color="blue") +
            geom_point(color="blue",size=2) +
            ggtitle("Power coefficient vs wind speed")
    })
    
    #output$oid1 <- scale1
    output$oid2 <-renderPrint({AEP1()[2]})
    output$odate <- renderPrint({input$date})
    output$oid3 <- renderPrint({input$select})


    observe({

        leafletProxy("map", data = windSpeeds) %>%
            clearShapes() %>%
            addRectangles(~lon, ~lat, ~lon+0.014, ~lat+0.009, layerId =~id, group = NULL,
                          stroke = FALSE, color = "blue", weight = 1, opacity = 1, fill = TRUE,
                          fillColor = ~ws, fillOpacity = 0)

            #addLegend("bottomleft", pal=pal, values=colorData, title=colorBy,layerId="colorLegend")
    })

    # Show a popup at the given location when map is clicked
    showWTPopup <- function(id,lat, lon) {
            selectedid <- windSpeeds[windSpeeds$id == id,]
            AEP<-AEP(selectedid$ws,shape,selectedData()$v,selectedData()$P)
            content <- as.character(tagList(
            sprintf("Latitude: %s ", round(lat,2)),tags$br(),
            sprintf("Longitude: %s", round(lon,2)),tags$br(),
            sprintf("Wind speed: %3.1f m/s",selectedid$ws),tags$br(),
            sprintf("AEP: %1.2e kWh",round(AEP,0))
        ))
        leafletProxy("map") %>% addPopups(lon, lat,content,layerId = id)
    }

    AEP<-function(meanv,shape,wsVector,powerVector){
            scale<-round(meanv/gamma(1+1/shape),2)
            windprob<-dweibull(wsVector,shape,scale)
            meanP<-sum(windprob*powerVector)
            round(8760*meanP,2)
    }

    # When map is clicked, show a popup with wind speed at site and likely
    # annual energy yield (AEP) of selected turbine if placed there.

    observe({
        
        leafletProxy("map") %>% clearPopups()
        event <- input$map_shape_click

        #event <- input$map_click
        if (is.null(event))
        return()

        isolate({
            showWTPopup(event$id,event$lat, event$lng)
        })

        
    })

  }
)
