Airline Fatalities, 1949-2019, as reported by the National Transportation Safety Board (NTSB)
Interactive Leaflet Plot
========================================================
author: Laura Snyder
date: 30 April 2019
autosize: true

What the data is...
========================================================

Data Collected

Data was downloaded as a csv file from https://www.ntsb.gov/_layouts/ntsb.aviation/index.aspx. Only aviation accidents involving 1 or more fatalities since 1948 were included in the dataset.

The NTSB aviation accident database contains information on civil aviation accidents and selected incidents within the United States, its territories and possessions, and in international waters.

The purpose of the graph is to show worldwide aviation fatalities since 1948, by year, with a geographic represenation of where the fatalities occurred, the number of fatalities per accident, and the total number of fatalities for that year.


Here is the full map with all Fatality information
========================================================

```{r, echo=FALSE}
library(dplyr) #Add all needed libraries
library(lubridate)
library(leaflet)
library(shiny)

try1<-read.csv("AirlineData.txt", header=T, sep="|") #Read in the downloaded library 

try1<-select(try1, Event.Date, Location, Country, Latitude, Longitude, Make, Total.Fatal.Injuries) #Cuts out unnecessary columns
try1$Event.Date <- as.Date(try1$Event.Date, format = '%m/%d/%Y') #Convert factor into date format
try1<-mutate(try1, YearHap=try1$Event.Date) #Add a new column for year
try1$YearHap<-as.integer(format(try1$YearHap,"%Y")) #Format year column as a single year integer
try1<-try1[complete.cases(try1),] #Subset for complete cases only

new<-filter(try1, YearHap==2018) #Provides a sample set for year 2018 only
summarize(new,total_fatalities=sum(new$Total.Fatal.Injuries, na.rm=T)) #Summary statistics

myIcon <- makeIcon(
  iconUrl = "Stone.png", iconWidth=15, iconHeight=18
) #Create a custom icon for mapping

my_map<-leaflet(data=new) %>% 
  addTiles() %>%
  addMarkers(~Longitude, ~Latitude, icon=myIcon, popup = ~as.character(Total.Fatal.Injuries), label=~as.character(Location))
my_map #Build map with data points marked with location name and number of deaths

```

Here is the server and ui code...
========================================================
# server.r code
# Define server logic required to build leaflet plot

library(dplyr) #Add all needed libraries
library(lubridate)
library(leaflet)
library(shiny)

shinyServer(function(input, output) {

  myIcon <- makeIcon(
    iconUrl = "Stone.png", iconWidth=15, iconHeight=18, iconAnchorX=12, iconAnchorY=12
  ) 
 
  try1<-read.csv("AirlineData.txt", header=T, sep="|")
  try1<-select(try1, Event.Date, Location, Country, Latitude, Longitude, Make, Total.Fatal.Injuries) #Cuts out unnecessary columns
  try1$Event.Date <- as.Date(try1$Event.Date, format = '%m/%d/%Y')
  try1<-mutate(try1, YearHap=try1$Event.Date)
  try1$YearHap<-as.integer(format(try1$YearHap,"%Y"))
  try1<-try1[complete.cases(try1),]
   
  new<-reactive({
    x<-try1[try1$YearHap==input$Year]
  })
    
  output$map <- renderLeaflet({
    my_map<-leaflet(data=new()) %>% 
      addTiles() %>%
      addMarkers(~Longitude, ~Latitude, icon=myIcon, popup = ~as.character(Total.Fatal.Injuries), label=~as.character(Location))
    my_map
  })
  observe({
    leaflet(data=new())%>%
      addTiles()%>%
      addMarkers(~Longitude, ~Latitude, popup = ~as.character(Total.Fatal.Injuries), label=~as.character(Location))
  })
  
})

## ui.r code

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


Difficulties
========================================================
Data was collected from https://www.ntsb.gov/_layouts/ntsb.aviation/index.aspx.

Leaflet plot rendered perfectly in R, but not in ui.R/server.R Shiny app. The best I could get was the slider. I am unable to diagnose my error.

