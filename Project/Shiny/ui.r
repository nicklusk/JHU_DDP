library(shiny)
library(leaflet)

shinyUI(navbarPage("Wind turbines in Cornwall", id = "nav",
    
                   tabPanel("Interactive map",
                            div(class = "outer",
                                
                                tags$head(
                                        # Include our custom CSS - verbatiom copy of SuperZip
                                        includeCSS("styles.css")
                                ),
                                
                                leafletOutput("map", width="100%", height="100%"),
                                absolutePanel(
                                        id = "Wind Turbine", class = "panel panel-default", fixed = TRUE,
                                        draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
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
                   tabPanel("Another tab"),
                   tabPanel("Yet another tab")
))
