

shinyServer(function(input, output) {

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
    
    selectedWS <<- reactive({
        names(windSpeeds)<-c("id","lat","lon","ws","ws","ws")
        windSpeeds[,c(1:3,3+as.integer(input$wsShow))]
    })
    
    # add wind speeds to map - a lattice of 1 km2 squares, made invisible  
    observe({
        
            reds = colorNumeric("Reds", domain = NULL)
            
            fill<-if(input$wsShow == 1) {
                    0.1
            } else {
                    0.6
            }

            leafletProxy("map", data = selectedWS()) %>%
                    clearShapes() %>%
                    addRectangles(~lon, ~lat, ~lon+0.014, ~lat+0.009, layerId =~id, group = NULL,
                                  stroke = FALSE, color = "blue", weight = 1, opacity = 0, fill = TRUE,
                                  fillColor = ~reds(ws), fillOpacity = fill)
         
    })

    # Show a popup at the given location when map is clicked
    showWTPopup <- function(id,lat, lon) {
            selectedid <- selectedWS()[selectedWS()$id == id,]
            AEP<-AEP(selectedid$ws,shape,selectedData()$v,selectedData()$P)
            content <- as.character(tagList(
                    sprintf("Latitude: %s ", round(lat,2)),tags$br(),
                    sprintf("Longitude: %s", round(lon,2)),tags$br(),
                    sprintf("Wind speed: %3.1f m/s",selectedid$ws),tags$br(),
                    sprintf("AEP: %1.1f MWh",round(AEP,0))
            ))
            leafletProxy("map") %>% addPopups(lon, lat,content,layerId = id)
    }
    
    
    
    # When map is clicked, show a popup with wind speed at site and likely
    # annual energy yield (AEP) of selected turbine if placed there.
    
    observe({
            
            leafletProxy("map") %>% clearPopups()
            event <- input$map_shape_click
            if (is.null(event))
                    return()
            
            isolate({
                    showWTPopup(event$id,event$lat, event$lng)
            })
            
            
    })
    
    
    output$plot1 <- renderPlot({
            ggplot(selectedData(), aes(x=v, y=P)) +
                    scale_colour_brewer(palette="Set1")+
                    geom_line(color="red") +
                    #geom_point(color="red",size=2) +
                    ggtitle("Power vs wind speed")+
                    ylab("Power output (kW)")+
                    xlab("Wind speed (m/s)")
    })

    output$plot2 <- renderPlot({
            ggplot(selectedData(), aes(x=v, y=cP)) +
                    scale_colour_brewer()+
                    geom_line(color="blue") +
                    #geom_point(color="blue",size=2) +
                    ggtitle("Power coefficient vs wind speed")+
                    ylab("Power coefficient cP")+
                    xlab("Wind speed (m/s)")
            })

    output$plot3 <- renderPlot({
            meanv<-seq(4,10)
            AEP<-sapply(meanv,function(x){
                    AEP(x,shape,selectedData()$v,selectedData()$P)
            })
            AEP<-data.frame(meanv,AEP)
            names(AEP)=c("meanv","AEP")
            ggplot(AEP,aes(x=meanv,y=AEP))+
                    geom_line(color="green")+
                    ggtitle("Annual Energy Production")+
                    ylab("AEP (MWh)")+
                    xlab("Mean wind speed at site (m/s)")
    })
#    output$oid1 <- renderPrint({windSpeeds[1,c(1:3,2+min(2,as.integer(input$wsShow)))]})
    output$value <- renderPrint({ names(input$wsShow) })
  }
)
