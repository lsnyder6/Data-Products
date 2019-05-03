library(shiny)
library(leaflet)

# Define UI for application that creates a Leaflet map and summarizes fatality totals 
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Airplane Fatalities, 1974-2019"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput("Year",
                  "Choose a year:",
                  min = 1974,
                  max = 2019,
                  value = 2000,
                  sep="") # End slider input
    ), # End sidebar panel
    
    
    # Show a plot of the generated distribution
    mainPanel(
      leafletOutput("map",height = 1000),
      h3("Locations of Airline Fatalities for Chosen Year")
      
    ) # End main page
  ) # End sidebar layout
) # End Fluid Page

) # End Shiny UI
