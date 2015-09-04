library(shiny)
library(leaflet)
library(RColorBrewer)
library(scales)
library(dplyr)
library(ggplot2)

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

# read in wind speed map of Cornwall taken from the UK NOABL wind speed atlas.
# wind speeds are given for 10 m height with 1 km2 resolution
windSpeeds<-read.csv("./data/windspeeds.csv",stringsAsFactors=FALSE)
