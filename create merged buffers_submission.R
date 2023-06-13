
library(sf)
library(rgeos)
library(data.table)
library(rgdal)
library(raster)
library(ggplot2)

setwd("E:/datasets_scripts")

# Lambert_72 = 31370
# WGS_84     = 4326 

data <- read.csv("./dispersal_spatial_analysis.csv", head=TRUE, sep = ",", dec=".")

points <- data[,c("ID", "LONGITUDE", "LATITUDE")]

# convert to sf
points.sf <- st_as_sf(points, coords = c("LONGITUDE", "LATITUDE"), crs = 4326, agr = "constant")

# set CRS to Lambert_72 (Belgian CRS)
points.sf.lambert <- st_transform(points.sf, 31370)
plot(points.sf.lambert, axes=T)

# create multiple buffers expressed in meters
radii <- c(50,100,250,500,1000,2000,4000)

for (j in 1:length(radii)) {
  buffer <- st_buffer(points.sf.lambert, radii[j], nQuadSegs = 200)
  buffer$distance <- radii[j]
  if (j==1) {
    buffers <- buffer
  } else {
    buffers <- rbind(buffers, buffer)  
  }
  print(paste("buffers created for", radii[j], "m" ,sep=" "))
}

# get buffer area
buffers$buf_area <- st_area(buffers)

# export as shapefile
st_write(buffers, paste0("./spots/student_exported_app/ballooning_manuscript2.shp"), delete_layer=TRUE)

