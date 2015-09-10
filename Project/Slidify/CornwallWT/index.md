---
title       : Cornwall wind energy estimator
subtitle    : 
author      : Michael Hunt
job         : 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

Cornwall is England's windiest county.  
  
Many wind turbines have been sited here, and many more are planned.  

  
However the average wind speed varies with location and height above ground.


It is useful to project developers to have an idea of how much energy any model of wind turbine would produce annually wherever in the county it is placed, on however high a tower.
  

We have produced a Shiny app that uses wind speed atlas data for the county together with wind turbine specifications to produce a clickable map, where the annual energy production (AEP) of a turbine is caluclated, at whatever location in the county is selected, whatever the heighht of the turbine tower, for a range of turbines commmonly seen in the county.



--- 


Here is the map of Cornwall




```r
library(leaflet)
m <- leaflet() %>%
  addTiles() %>%  
  setView(lng = -4.7, lat = 50.4, zoom = 10)
m  
```

<!--html_preserve--><div id="htmlwidget-6105" style="width:504px;height:504px;" class="leaflet"></div>
<script type="application/json" data-for="htmlwidget-6105">{"x":{"calls":[{"method":"addTiles","args":["http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"maxNativeZoom":null,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"continuousWorld":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":null,"unloadInvisibleTiles":null,"updateWhenIdle":null,"detectRetina":false,"reuseTiles":false,"attribution":"&copy; <a href=\"http://openstreetmap.org\">OpenStreetMap</a> contributors, <a href=\"http://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA</a>"}]}],"setView":[[50.4,-4.7],10,[]]},"evals":[]}</script><!--/html_preserve-->




