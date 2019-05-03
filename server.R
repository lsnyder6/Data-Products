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
  try1<-try1[!is.na(try1$Latitude) & !is.na(try1$Longitude) & !is.na(try1$Total.Fatal.Injuries) & !is.na(try1$Location),]
  
  newDat<-reactive({
    x<-try1[try1$YearHap==as.integer(input$Year),]
  })
  
  output$map <- renderLeaflet({
    my_map<-leaflet(data=newDat()) %>% 
      addTiles() %>%
      addMarkers(~Longitude, ~Latitude, icon=myIcon, popup = ~as.character(Total.Fatal.Injuries), label=~as.character(Location))
    my_map
  })
  observe({
    leaflet(data=newDat())%>%
      addTiles()%>%
      addMarkers(~Longitude, ~Latitude, popup = ~as.character(Total.Fatal.Injuries), label=~as.character(Location))
  })
  
})