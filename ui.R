library(shiny)
library(leaflet)

# Define UI for application that creates a Leaflet map and summarizes fatality totals 
shinyUI(fluidPage(

  # Application title
  titlePanel("Airplane Fatalities, 1948-2019"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput("Year",
                  "Choose a year:",
                  min = as.Date("1948","%Y"),
                  max = as.Date("2019","%Y"),
                  value = as.Date("1950","%Y"))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      leafletOutput("map",height = 1000),
      h3("Locations of Airline Fatalities for Chosen Year")
      
    )
    )
  
))
