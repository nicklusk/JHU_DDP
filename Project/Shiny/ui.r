library(shiny)
library(leaflet)

shinyUI(navbarPage("Wind Energy in Cornwall", id = "nav",
                      tabPanel("Interactive Map",
                               div(class = "outer",
                                   
                                   tags$head(
                                       # Include custom CSS - verbatim copy from SuperZip
                                       includeCSS("styles.css"),
                                       includeScript("MathJax.js")
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
                                       withMathJax(uiOutput("ex1")),
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
                                                which in turn depends on the wind speed at the chosen site, and the height
                                                of the tower used for the turbine.",
                                                style = "font-family: 'Source Sans Pro';"),
                                              br(),
                                              p("This Shiny app is intended to help developers assess the likely
                                                annual returns for any wind turbine, placed anywhere in Cornwall. It uses
                                                a publicly available wind speed atlas for the UK (NOABL) that estimates wind 
                                                speeds with 1 km2 resolution, at 3 heights above ground: 10m, 25m, and 45m.
                                                A linearised (by log transform) fit is carried out at the selected location to 
                                                estimate the mean annual wind speed there at the selected height",
                                                style = "font-family: 'Source Sans Pro';"),
                                              br(),
                                              p("This wind speed information is combined with power output data for the selected turbine
                                                to calculate the annual energy production of that turbine under those conditions. To
                                                do this, a Weibull distribution of wind speeds is assumed, since this is found to represent
                                                actual wind speed distributions very well. It requires two parameters, a scale parameter
                                                which is set by the mean of the independent variable, which in this case is the wind speed,
                                                and by the other parameter, the shape parameter, which is set in this App to the value 2, 
                                                as is common practice in the UK wind industry.",
                                                style = "font-family: 'Source Sans Pro';")
                                
                                       ),
                                       column(width=6,
                                              h3("Tabs"),
                                              h4("Interactive map"),
                                              p("A map of Cornwall is shown, overlayed by an indicative wind speed layer,
                                                so that the user can see where the windiest locations are in the county.",
                                                style = "font-family: 'Source Sans Pro';"),
                                              br(),
                                              p("In the panel on the right select a wind turbine. Performance details of that turbine will be
                                                displayed in the charts below. Use the slider to choose
                                                the tower height. Click on the map. A pop-up appears that displays the location coordinates,
                                                the estimated mean annual wind speed at the site, and the likely annual energy production (AEP)
                                                of the selected turbine at that site and height. That's it!",
                                                style = "font-family: 'Source Sans Pro';"),
                                              br(),
                                              p("Note that the available range for tower height varies with the turbine
                                                chosen, according to what is actually possible for that turbine.",
                                                style = "font-family: 'Source Sans Pro';"),
                                              br(),
                                              p("Once a pop-up has appeared, leave it in place and try varying the tower height to see how
                                                the annual energy production is affected.",
                                                style = "font-family: 'Source Sans Pro';"),
                                              br(),
                                              h4("Calculations"),
                                              p("This tab shows how the calculations are carried for determining the wind speed
                                                at the selected tower height and location, and also the annual energy production
                                                of the selected turbine, given the location and mean wind speed at hub height",
                                                style = "font-family: 'Source Sans Pro';")
                                       )
                                       
                                       )
                                              )
                                              ),                    
                      tabPanel("Calculations",
                               
                               fluidPage(
                                        fluidRow(
                                            column(width=6,
                                                   plotOutput('weibullDist',width="100%",height =250),
                                                   plotOutput('vHeight',width="100%",height =250)
                                                   #verbatimTextOutput("siteId")
                                                   )
#                                             column(width=5,
#                                                    withMathJax(uiOutput("ex1"))
#                                                    )
                                        )
                                    ) 
                              )
))
