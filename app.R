library(shiny)

source("helpers.R")
counties <- readRDS("data/counties.rds")
library(maps)
library(mapproj)


ui <- fluidPage(
  titlePanel(title = h3("censusVis")),
  sidebarLayout(
    sidebarPanel(helpText("Create demographic maps with information from the 2010 US Census."),
                 selectInput("var",
                             "Choose a variable to display",
                             choices = list(
                               "Percent White",
                               "Percent Black",
                               "Percent Hispanic",
                               "Percent Asian"),
                             selected = "Percent White"),
                 sliderInput("range",
                             "Range of interest",
                             min = 0,
                             max = 100,
                             value = c(0, 100))
                 ),
    mainPanel(plotOutput("map"))
  )
)

server <- function(input, output) {
  
  output$map <- renderPlot({
    data <- switch(input$var,
                   "Percent White" = counties$white,
                   "Percent Black" = counties$black,
                   "Percent Hispanic" = counties$hispanic,
                   "Percent Asian" = counties$asian)
    colours <- switch(input$var,
                      "Percent White" = "darkgreen",
                      "Percent Black" = "black",
                      "Percent Hispanic" = "darkorange",
                      "Percent Asian" = "darkviolet")
    
    percent_map(var = data, 
                color = colours, 
                legend.title = paste("%", substring(input$var, 9)), 
                max = input$range[2], 
                min = input$range[1])
  })
  
}

shinyApp(ui = ui, server = server)