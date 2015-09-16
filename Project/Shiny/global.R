library(shiny)
library(leaflet)
library(sp)
library(RColorBrewer)
library(dplyr)
library(ggplot2)
library(htmltools)
library(htmlwidgets)

reds = colorNumeric("Reds", domain = NULL)


# function to calculate annual energy production of chosen turbine
# at site of given mean wind speed.
# A Rayleigh distribution of wind speeds is assumed (=Weibull distribuion with shape factor=2).

shape<-2
AEP<-function(meanv,shape=2,wsVector,powerVector){
        
    # find scale factor, given the mean wind speed at the location
    scale<-round(meanv/gamma(1+1/shape),2)
    
    # calculate vector of wind speed probabilities
    windprob<-dweibull(wsVector,shape,scale)
    
    # average output power = sum power at each windspeed bin x probability of each wind speed bin
    meanP<-sum(windprob*powerVector) # average output power = sum power at each windspeed bin x probability of each wind speed bin
    round(8760*meanP,2)/1000
}

# function to estimate wind speed at required hub height given wind speed atlas values
# at the location for heights of 10m, 25 and 45 m.
# a power law relationship of wind speed with height is assumed, as is common practice.
# linear regression on log (wind speed/reference windspeed) ~ log (height/reference height)
# is used to find the exponent.

wsAdj<-function(height,hVector,wsVector){

# height - height at which speed is to be calculated
# hVector - known heights
# ws Vector - known wind speeds
        
       hlog<-log(hVector/hVector[1])
       wslog<-log(wsVector/wsVector[1])
       fit<-lm(wslog~-1+hlog)
       wsVector[1]*(height/hVector[1])^fit[[1]] # returns the estimated wind speed at h=height
}

# read in wind turbine power curve data
powerCurves<-read.csv("../data/powerCurves.csv",stringsAsFactors=FALSE)

# create vector of turbine names
turbine<-unique(powerCurves$turbine)
tchoices<-list(NULL)
i <- 1
while(i<=length(turbine)) {
    tchoices[[i]] <- turbine[i]
    i <- i + 1
}

# read in wind speed map of Cornwall taken from the UK NOABL wind speed atlas.
# wind speeds are given for 10 m, 25m and 45 m heights with 1 km2 resolution
windSpeeds<-read.csv("../data/windspeeds.csv",stringsAsFactors=FALSE)



# get Cornwall boundary data
adm <- getData('GADM', country='GBR', level=2)
cornwall=adm[adm$NAME_2=="Cornwall",]
rm(adm)
