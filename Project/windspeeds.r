# Load the packages
library(rgdal)
# Variables for holding the coordinate system types (see:
# http://www.epsg.org/ for details)
ukgrid = "+init=epsg:27700"
latlong = "+init=epsg:4326"

# load data
windSpeeds<-read.csv("./data/windspeeds.csv")

# Create coordinates variable
coords <- cbind(Easting = as.numeric(as.character(windSpeeds$easting)),Northing = as.numeric(as.character(windSpeeds$northing)))

# Create the SpatialPointsDataFrame
ws_SP <- SpatialPointsDataFrame(coords, data = data.frame(windSpeeds$ws10,
                                                          windSpeeds$ws45,
                                                          windSpeeds$ws45,
                                                          windSpeeds$id,coords.nrs=c(6:8)) ,proj4string = CRS("+init=epsg:27700"))



# quick plot
plot(ws_SP@coords)

# where are the easting and northing coordinates?
head(ws_SP@coords)

# project to latitude and longitude
# Convert from Eastings and Northings to Latitude and Longitude
ws_SP_LL <- spTransform(ws_SP, CRS(latlong))

# Rename the columns
colnames(ws_SP_LL@coords)[colnames(ws_SP_LL@coords) == "Easting"] <- "lng"
colnames(ws_SP_LL@coords)[colnames(ws_SP_LL@coords) == "Northing"] <- "lat"

head(ws_SP_LL@coords)

plot(ws_SP_LL@coords)


library(sp)
library(KernSmooth)
library(RColorBrewer)

library(sp)
library(lattice) # required for trellis.par.set():
trellis.par.set(sp.theme()) # sets color ramp to bpy.colors()

data(meuse)
coordinates(meuse)=~x+y
data(meuse.riv)
meuse.sr = SpatialPolygons(list(Polygons(list(Polygon(meuse.riv)),"meuse.riv")))
rv = list("sp.polygons", meuse.sr, fill = "lightblue")


windSpeeds<-read.csv("./data/windspeeds.csv")
coordinates(windSpeeds)=~easting+northing
spplot(windSpeeds,c("ws10","ws45"))
