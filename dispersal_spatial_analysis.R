#a demofile for reading and analysing data
library(spatial)
library(spatstat)

#read your data as text-file
data <- read.table("dispersal_spatial_analysis.txt", header=T)
names(data) 
attach(data) 

#summary of the data
summary (data)

#define the data for further analysis (vectorising)
X<-data$LONGITUDE
Y<-data$LATITUDE

#Translate to km scale#
X<-X*70436-157599
Y<-Y*110428-5444000

summary(X)


#point pattern data with  borders
samples <- ppp(X, Y, c(86600,110900), c(167000,196000))
plot(samples)



#summary of the data
summary(samples)




#add marks



#create simple rectangular window

W<-owin(c(86600,110900), c(167000,196000))
SamplesPP <- ppp(X, Y, c(86600,110900), c(167000,196000),marks=data$fB,window=W)
plot(SamplesPP)
plot(W,add=T)




#First order statistics
#stats for homogeneous denisty

summary(SamplesPP)
lambda<-summary(SamplesPP)$intensity
lambda



#Inhomogeneous densities
den <- density(SamplesPP, sigma = 10)
plot(den)
plot(samples, add = TRUE, cex = 0.5)


contour(density(SamplesPP,10),axes=FALSE)




#Second order stats


#test deviation from random pattern
E<-envelope(SamplesPP,Fest,nsim=99,rank=1)
plot(E,main="pointwise envelopes")



#correlation-decay by age

par(mfrow=c(1, 3))
DispCorr<- markcorr(SamplesPP)
plot(DispCorr)

