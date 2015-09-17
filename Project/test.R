library(shiny)

server <- function(input, output, session) {
    output$formula <- renderUI({
        print("$$x = \\frac{-b\\pm\\sqrt{b^2 - 4ac}}{2a}$$")
    })   
}

ui <- fluidPage(
    titlePanel("Quadratic Equation Roots"),
    sidebarLayout(
        sidebarPanel("LaTeX: (enclose in $$) x = \\frac{-b\\pm\\sqrt{b^2 - 4ac}}{2a}"),    
        mainPanel(withMathJax(uiOutput("formula")))
    )
)

shinyApp(ui = ui, server = server)