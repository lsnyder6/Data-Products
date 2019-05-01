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


#https://www.ntsb.gov/_layouts/ntsb.aviation/index.aspx Provides airline fatalities, 1948 through 2019


