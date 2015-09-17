---
title: "Cornwall wind energy estimator"
author: "Michael Hunt"
highlighter: highlight.js
output: pdf_document
job: null
knit: slidify::knit2slides
mode: selfcontained
hitheme: tomorrow
subtitle: null
framework: io2012
widgets: [mathjax,quiz,bootstrap,leaflet]
---
## Purpose of the App
Cornwall is England's windiest county.  
  
Many wind turbines have been sited here, and many more are planned.  
  
  
However the average wind speed varies with location and height above ground.
  

It is useful to project developers to have an idea of how much energy any model of wind turbine would produce annually wherever in the county it is placed, on however high a tower.
    

We have produced a Shiny app that uses wind speed atlas data for the county together with wind turbine specifications to produce a clickable map, where the annual energy production (AEP) of a turbine is calculated, at whatever location in the county is selected, whatever the height of the turbine tower, for a range of turbines commmonly seen in the county.



--- 
## Display a map of Cornwall

The leaflet package is used to display a clickable, zoomable map centred on Cornwall. In the app this is overlayn by an illustrative wind speed mesh.
  




<iframe src="cornwall.html" STYLE="width:100%;height:100%"> </iframe>

---

## Calculate the mean annual wind speed

The user clicks on the map within the boundaries of Cornwall and the app detects the location of the click to within a 1 km2 square. 

The turbine tower height is selected with a slider, and the mean annual wind speed at this location and height is then estimated from the windspeeds provided by the atlas,which gives wind speed values for heights of 10m, 25m and 45m. A linearised (by log transform) power law fit is used.

For example, if a location selected were on the windy north coast, that had id25 in the atlas csv file, and if a tower height of h=50 m had been selected, then the windspeed at that height would be found to be:




```
## [1] "6.84 m/s"
```

---

## Calculate the annual energy production of a turbine

As is common practice, a Weibull distribution of wind speeds is assumed, determined by two parameters, the scale parameter (which determines where the peak lies) and the shape parameter (which determines the width of the distribution). A shape parameter of 2 is assumed. This, together with the mean wind speed determines the scale parameter via a gamma function.
  
Given this windspeed and the power output specification of the selected turbine, the annual energy production (AEP) of the turbine can be estimated.
  
For example, if the mean wind speed were 8 m/s , and a 2 MW Gamesa G80  turbine were selected, the AEP would be




```
## [1] "7149 MWh"
```
Any number of wind turbines could be included, and the app could be extended to cover the whole of the UK.



