library(shiny)
library(leaflet)

shinyUI(navbarPage("Wind turbines in Cornwall", id = "nav",

    tabPanel("Interactive map",
        div(class = "outer",

            tags$head(
                # Include our custom CSS
                 includeCSS("myStyles.css")
            ),


            leafletOutput("map", width="100%", height="100%"),

            absolutePanel(
                id = "Wind Turbine", class = "panel panel-default", fixed = TRUE,
                draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                width = 330, height = "auto",

                selectInput(
                    "select", label = h4("Choose turbine"),
                    choices = tchoices, #list(turbine[1], turbine[2], turbine[3]),
                    selected = turbine[1]
                ),
                plotOutput('plot1',height =150),
                plotOutput('plot2',height =150),
                plotOutput('plot3',height =150),
                verbatimTextOutput("oid1"),
                selectInput("wsShow", label = h5("Show wind speeds at"),
                             choices = list( "10 m" =1, "25 m" = 2, "45 m" = 3), 
                             selected = 1)
            )
        )
    )
))
