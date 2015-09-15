shinyServer(function(input, output) {
        
        # Create the map
        output$map <- renderLeaflet({
                leaflet() %>%
                        addTiles() %>% # use default OpenStreetMap tile
                        setView(lng = -4.7, lat = 50.4, zoom = 10) # centre on Cornwall
        })
        
        # pick out performance data for the chosen wind turbine
        selectedWTData <<- reactive({
                subset(powerCurves,turbine==input$WT)[,c("v","P","cP")]
        })
        
        # add atlas wind speeds to map - a lattice of 1 km2 squares
        observe({
                leafletProxy("map", data = windSpeeds) %>%
                        clearShapes() %>%
                        addPolygons(data=cornwall, weight = 3, fillColor = "red", popup=NULL,fillOpacity = 0.) %>% # draws a nice border to Cornwall
                        addRectangles(~lon, ~lat, ~lon+0.014, ~lat+0.009, layerId =~id, group = NULL,
                                      stroke = FALSE, color = "blue", weight = 1, opacity = 0, fill = TRUE,
                                      fillColor = ~reds(ws25), fillOpacity = 0.3)
                
        })
        
        # Show a popup at the given location when map is clicked
        showWTPopup <- function(id,lat, lon) {
                
                # atlas windspeeds at 10, 25 and 45 m heights at pop-up location.
                wsVector <-as.numeric(windSpeeds[windSpeeds$id==id,c("ws10","ws25","ws45")])
                
                # estimate wind speed at selected hub height, from atlas values at 10,25 and 45 m heights.
                wsp<-wsAdj(input$hubHeight,c(10,25,45),wsVector)
                
                # calculate annual energy production (AEP) od selected wind turbine at selected location, at selected height
                AEP<-AEP(wsp,shape,selectedWTData()$v,selectedWTData()$P)
                
                # write out values of position, wind speed and AEP to pop-up.
                    #content<-""
                content <- as.character(tagList(
                        sprintf("Latitude: %s ", round(lat,2)),tags$br(),
                        sprintf("Longitude: %s", round(lon,2)),tags$br(),
                        sprintf("Wind speed: %3.1f m/s",wsp),tags$br(),
                        sprintf("AEP: %1.1f MWh",round(AEP,0))
               ))
                leafletProxy("map") %>% addPopups(lon, lat,content,layerId = id)
        }
        
       
        # When map is clicked, show a popup with wind speed at site and likely
        # annual energy yield (AEP) of selected turbine if placed there.
        
        observe({
                leafletProxy("map") %>% clearPopups() 
                event <- input$map_shape_click
                if (is.null(event)){
                        return()                        
                }
                showWTPopup(event$id,event$lat, event$lng)
        })
        
        siteId<-reactive({
                leafletProxy("map") %>% clearPopups() 
                event <- input$map_shape_click
                event$id
        })
        
        output$slider <- renderUI({
                
                sliderInput(
                        "hubHeight"  , label = h5("Choose tower height (m)"),
                        min=unique(powerCurves[powerCurves$turbine==input$WT,"hmin"]),
                        max=unique(powerCurves[powerCurves$turbine==input$WT,"hmax"]),
                        value = (unique(powerCurves[powerCurves$turbine==input$WT,"hmin"])+unique(powerCurves[powerCurves$turbine==input$WT,"hmax"]))/2,
                        step=0.1
                )
                
        })
        
        
        
        output$plot1 <- renderPlot({
 
                ggplot(selectedWTData(), aes(x=v, y=P)) +
                        scale_colour_brewer(palette="Set1")+
                        geom_line(color="red") +
                        ggtitle("Power vs wind speed")+
                        ylab("Power output (kW)")+
                        xlab("Wind speed (m/s)")
        })
        
        output$plot2 <- renderPlot({
                ggplot(selectedWTData(), aes(x=v, y=cP)) +
                        scale_colour_brewer()+
                        geom_line(color="blue") +
                        ggtitle("Power coefficient vs wind speed")+
                        ylab("Power coefficient cP")+
                        xlab("Wind speed (m/s)")
        })
        
        output$plot3 <- renderPlot({
            
                meanv<-seq(4,10)
                AEPall<-sapply(meanv,function(x){
                        AEP(x,shape,selectedWTData()$v,selectedWTData()$P)
                })
                AEPall<-data.frame(meanv,AEPall)
                names(AEPall)=c("meanv","AEP")
                
                ggplot(AEPall,aes(x=meanv,y=AEP))+
                        geom_line(color="green")+
                        ggtitle("Annual Energy Production")+
                        ylab("AEP (MWh)")+
                        xlab("Mean wind speed at site (m/s)")
        })
        
        output$weibullDist <- renderPlot({
            if (is.null(siteId()))  {
                wsp=5
            }
            else {
                # atlas windspeeds at 10, 25 and 45 m heights at pop-up location.
                wsVector <-as.numeric(windSpeeds[windSpeeds$id==siteId(),c("ws10","ws25","ws45")])
                # estimate wind speed at selected hub height, from atlas values at 10,25 and 45 m heights.
                wsp<-wsAdj(input$hubHeight,c(10,25,45),wsVector)           
            } 
            
            # find scale factor, given the mean wind speed at the location
            scale<-round(wsp/gamma(1+1/shape),2)
            # calculate vector of wind speed probabilities
            vseq<-seq(0,20,0.1)
            windProb<-dweibull(vseq,shape,scale)
            dw<-data.frame(vseq,windProb)
            names(dw)=c("v","Probability")
            ggplot(dw,(aes(x=v,y=Probability)))+geom_line()
        }) 
      
        output$vHeight <- renderPlot({
            if (is.null(siteId()))  {
                wsVector<-c(5,5*2.5^(1/7),5*4.5^(1/7)) # assume (1/7) power law exponent
            }
            else {
                wsVector <-as.numeric(windSpeeds[windSpeeds$id==siteId(),c("ws10","ws25","ws45")])
            }
            
            hmin=unique(powerCurves[powerCurves$turbine==input$WT,"hmin"])
            hmax=unique(powerCurves[powerCurves$turbine==input$WT,"hmax"])
   
            wsp<-wsAdj(input$hubHeight,c(10,25,45),wsVector)
            hseq<-seq(hmin,hmax,1)
            wspH<-wsAdj(hseq,c(10,25,45),wsVector)
            dh<-data.frame("h"=hseq,"v"=wspH)
            dHub<-data.frame("hHub"=input$hubHeight,"vHub"=wsp)
            ggplot(dh,(aes(x=h,y=v)))+geom_line()+geom_point(data=dHub,aes(x=hHub,y=vHub))
        }) 
        
        output$siteId <- renderPrint({
            
            wsVector <-as.numeric(windSpeeds[windSpeeds$id==siteId(),c("ws10","ws25","ws45")])
            #wsVector
            siteId()
            })
        
        output$ex1 <- renderUI({
            #withMathJax()#(sprintf("$$e^{i \\pi} + 1 = 0$$"))
            print("$$x = \\frac{-b\\pm\\sqrt{b^2 - 4ac}}{2a}$$") 
        })
}
)