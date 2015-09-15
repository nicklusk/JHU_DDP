library(shiny)
library(leaflet)

shinyUI(fluidPage(h3("Wind turbines in Cornwall"), id = "nav",
       tabsetPanel(
                   tabPanel("Interactive Map",
                            div(class = "outer",
                                
                                tags$head(
                                        # Include our custom CSS - verbatiom copy of SuperZip
                                        includeCSS("styles.css")
                                ),
                                br(),
                                leafletOutput("map", width="100%", height="90%"),
                                absolutePanel(
                                        id = "Wind Turbine", class = "panel panel-default", fixed = TRUE,
                                        draggable = TRUE, top = 100, left = "auto", right = 20, bottom = "auto",
                                        width = 330, height = "auto",
                                        
                                        selectInput(
                                                "WT", label = h5("Choose turbine"),
                                                choices = tchoices, 
                                                selected = turbine[1]
                                        ),
                                        
                                        uiOutput("slider"),
                                        
                                        plotOutput('plot1',height =150),
                                        plotOutput('plot2',height =150),
                                        plotOutput('plot3',height =150)
                                )
                            )
                   ),
                   tabPanel("User Guide",
                            fluidPage(
                                h1("Wind Energy in Cornwall",
                                   style = "font-family: 'Source Sans Pro';color: blue; 
                                   text-align: center;padding: 20px"),
                                br(),
                                fluidRow(
                                    column(width=6,
                                           h3("What is the App for?"),
                                           p("Cornwall is England's windiest county and so many wind turbine
                                             projects are sited here, with more planned. The environmental 
                                             and financial returns for any project depend on the annual energy production,
                                             which in turn depends on the wind speed at the chosen site, at the height
                                             of the tower used for the turbine.",
                                             style = "font-family: 'Source Sans Pro';"),
                                           br(),
                                           p("This Shiny app is intended to help developers assess the likely
                                             annual returns for any wind turbine, placed anywhere in Cornwall. It uses
                                             a publicly available wind speed atlas for the UK (NOABL) that estimates wind 
                                             speeds with 1 km2 resolution, at 3 heights above ground: 10m, 25m, and 45m.
                                             ",
                                             style = "font-family: 'Source Sans Pro';")
                                           ),
                                    column(width=6,
                                           h3("Tabs"),
                                           h4("Interactive map"),
                                           p("In the panel on the right select a wind turbine. Performance details of that turbine will be
                                             displayed in the charts below. Use the slider to choose
                                             the tower height. Click on the map. A pop-up appears that displays the location coordinates,
                                             the estimated mean annual wind speed at the site, and the likely annual energy production (AEP)
                                             of the selected turbine at that site and height. That's it!",
                                             style = "font-family: 'Source Sans Pro';"),
                                           h4("Turbines"),
                                           h4("Calculations")
                                            )

                                    )
                            )
                   ),                     
                   tabPanel("Wind turbines")
         )
))
