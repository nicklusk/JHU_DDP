d<-read.csv("annual_all_2013.csv")
str(d)
sub<-subset(d,Parameter.Name %in% c("PM2.5 - Local Conditions","Ozone")
            & Pollutant.Standard %in% c("Ozone 8-hour 2008", "PM25 Annual 2006"),
            c(Latitude,Longitude,Parameter.Name,Arithmetic.Mean))
subOzone<-subset(d,Parameter.Name %in% c("Ozone")
            & Pollutant.Standard %in% c("Ozone 8-hour 2008", "PM25 Annual 2006"),
            c(Latitude,Longitude,Parameter.Name,Arithmetic.Mean))
head(sub)
pollavg<-aggregate(sub[,"Arithmetic.Mean"],
          sub[,c("Latitude","Longitude","Parameter.Name")]
          ,mean,na.rm=TRUE)
names(pollavg)[4]<-"level"
pollavg<-transform(pollavg,Parameter.Name=factor(Parameter.Name))
