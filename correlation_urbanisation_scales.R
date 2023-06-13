

install.packages("Hmisc")
install.packages("PerformanceAnalytics")
library("Hmisc")
library("PerformanceAnalytics")

data<-read.csv("pathway/correlation_urbanisation_scales.csv", head=TRUE, sep=",", dec=".",fileEncoding="UTF-8-BOM")

data2 = subset(data, select = -c(ID) )

rcorr(as.matrix(data2), type="pearson")

chart.Correlation(data2, histogram=TRUE, pch=19, method = "pearson")


