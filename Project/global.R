palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
          "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))

library(dplyr)
library(ggplot2)

powerCurves<-read.csv("./data/powerCurves.csv",stringsAsFactors=FALSE)

turbine<-unique(powerCurves$turbine)

tchoices<-list(NULL)
i <- 1
while(i<=length(turbine)) {
        tchoices[[i]] <- turbine[i]
        i <- i + 1
}


windSpeeds<-read.csv("./data/windspeeds.csv",stringsAsFactors=FALSE)
