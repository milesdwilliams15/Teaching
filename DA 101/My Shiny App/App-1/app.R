#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

data_exists <- exists("faithful.csv")
if(data_exists) {
  faithful <- read.csv("faithful.csv")
} else {
  write.csv(faithful,"faithful.csv")
  faithful <- read.csv("faithful.csv")
}

library(shiny)
library(ggplot2)
# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),
    
    tags$h6("Miles D. Williams (williamsmd@denison.edu | @MDWilliamsPhD)"),
    
    # Some instructions
    "This is an example Shiny Application using the 'faithful' dataset in R. Instructions for how to update features of the visualization are included below.",
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
      sidebarPanel(
        sliderInput("bins",
                    "Number of bins:",
                    min = 1,
                    max = 50,
                    value = 25,
                    width = "400px"),
        "Adjust the slider to change the number of bins used to draw the histogram."
        ),

        # Show a plot of the generated distribution
        mainPanel = mainPanel(
           plotOutput(
             "distPlot",
             height = "400px",
             width = "400px"
           ),
        )
    ),
    sidebarLayout(
      sidebarPanel(
        textInput(
          "fit", 
          "Smoother:", 
          value = "lm",
          width = "400px"),
        "Write one of 'lm', 'gam', or 'loess' in the textbox to change the type of smoother used to show the relationship between wait time and erruption frequency."
      ),
      
      # Show a plot of the generated distribution
      mainPanel = mainPanel(
        plotOutput(
          "scatPlot",
          height = "400px",
          width = "400px"
        )
      )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful$waiting
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        # hist(x, breaks = bins, col = 'darkgray', border = 'white')
        ggplot() +
          aes(x = x) +
          geom_histogram(
            fill = "darkgray",
            color = "white",
            bins = input$bins
          ) +
          labs(
            title = "Distribution of Wait Times"
          )
    })
    
    output$scatPlot <- renderPlot({
        # with(
        #   faithful,
        #   plot(
        #     x = waiting,
        #     y = eruptions,
        #     main = "Eruptions by Wait Time"
        #   )
        # )
        ggplot(faithful) +
          aes(x = waiting, y = eruptions) +
          geom_point(
            color = "darkgray"
          ) +
          geom_smooth(
            method = input$fit
          ) +
          labs(
            title = "Eruptions by Wait Time"
          )
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
