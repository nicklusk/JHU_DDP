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

Cornwall is England's windiest county.  
  
Many wind turbines have been sited here, and many more are planned.  

  
However the average wind speed varies with location and height above ground.


It is useful to project developers to have an idea of how much energy any model of wind turbine would produce annually wherever in the county it is placed, on however high a tower.
  

We have produced a Shiny app that uses wind speed atlas data for the county together with wind turbine specifications to produce a clickable map, where the annual energy production (AEP) of a turbine is caluclated, at whatever location in the county is selected, whatever the heighht of the turbine tower, for a range of turbines commmonly seen in the county.



--- 


Here is the map of Cornwall



<iframe src="example.html" STYLE="width:100%;height:100%"> </iframe>




