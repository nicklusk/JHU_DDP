library(shiny)
library(leaflet)

shinyUI(navbarPage("Wind turbines in Cornwall", id = "nav",

    tabPanel("Interactive map",
        div(class = "outer",

            tags$head(
                # Include our custom CSS
                includeCSS("styles.css")
                #includeScript("gomap.js")
            ),

            leafletOutput("map", width="100%", height="100%"),

            absolutePanel(
                id = "site", class = "panel panel-default", fixed = TRUE,
                draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                width = 330, height = "auto",

                selectInput(
                    "select", label = h4("Choose turbine"),
                    choices = tchoices, #list(turbine[1], turbine[2], turbine[3]),
                    selected = turbine[1]
                ),
                plotOutput('plot1',height =200),
                plotOutput('plot2',height =200)
            ),

            absolutePanel(
                id = "wind turbine", class = "panel panel-default", fixed = TRUE,
                draggable = TRUE, top = 550, left = "auto", right = 20, bottom = "auto",
                width = 330, height = "auto",

#                 selectInput(
#                     "select", label = h3("Choose turbine"),
#                     choices = tchoices, #list(turbine[1], turbine[2], turbine[3]),
#                     selected = turbine[1]
                # ),
                numericInput(
                    'id1', 'Mean wind speed at site', 5, min = 0, max = 10, step = 1
                ),
                h4('AEP'),
                verbatimTextOutput("oid2")
            )
#             selectInput(
#                 "select", label = h3("Choose turbine"),
#                 choices = tchoices, #list(turbine[1], turbine[2], turbine[3]),
#                 selected = turbine[1]
#             ),
#             numericInput(
#                 'id1', 'Mean wind speed at site', 5, min = 0, max = 10, step = 1
#             ),
            #checkboxGroupInput("id2", "Checkbox",
            #              c("Value 1" = "1",
            #                "Value 2" = "2",
            #                "Value 3" = "3")),
            #dateInput("date", "Date:"),
            #h4('Scale parameter'),
            #verbatimTextOutput("oid1"),
            #h4('AEP'),
            #verbatimTextOutput("oid2")
            #plotOutput('plot1'),
            #plotOutput('plot2')
        )
    )
))
