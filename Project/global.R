library(shiny)
library(leaflet)
library(raster)
library(RColorBrewer)
library(scales)
library(dplyr)
library(ggplot2)

reds = colorNumeric("Reds", domain = NULL)

shape<-2
# function to calculate annual energy production of chosen turbine
# at site of given mean wind speed.
# A Rayleigh distribution of wind speeds is assumed.

AEP<-function(meanv,shape=2,wsVector,powerVector){
        scale<-round(meanv/gamma(1+1/shape),2)
        windprob<-dweibull(wsVector,shape,scale)
        meanP<-sum(windprob*powerVector)
        round(8760*meanP,2)/1000
}

# function to estimate wind speed at required hub height given wind speed atlas values
# at the location for heights of 10m 25 and 45 m.
# a power law relationship of wind speed with height is assumed
# linear regression on log (wind speed/reference windspeed) ~ log (height/reference height)
# is used to find the exponent.

wsAdj<-function(height,hVector,wsVector){
        hlog<-log(hVector/hVector[1])
        wslog<-log(wsVector/wsVector[1])
       fit<-lm(wslog~-1+hlog)
       wsVector[1]*(height/hVector[1])^fit[[1]]
}

# read in wind turbine power curve data
powerCurves<-read.csv("./data/powerCurves.csv",stringsAsFactors=FALSE)

# create vector of turbine names
turbine<-unique(powerCurves$turbine)
tchoices<-list(NULL)
i <- 1
while(i<=length(turbine)) {
        tchoices[[i]] <- turbine[i]
        i <- i + 1
}

#read in wind speed map of Cornwall taken from the UK NOABL wind speed atlas.
# wind speeds are given for 10 m height with 1 km2 resolution
windSpeeds<-read.csv("./data/windspeeds.csv",stringsAsFactors=FALSE)
#names(windSpeeds)<-c("id","lat","lon","ws","ws","ws")

adm <- getData('GADM', country='GBR', level=2)
cornwall=adm[adm$NAME_2=="Cornwall",]
popup <- paste0("<strong>Name: </strong>", 
                cornwall$NAME_2)
