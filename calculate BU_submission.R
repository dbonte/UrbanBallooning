
library(sf, quietly=T)
library(tidyverse, quietly=T)
library(rgdal, quietly=T)
library(rgeos, quietly=T)
library(sp, quietly=T)
library(data.table, quietly=T)
library(dplyr, quietly=T)


setwd("data pathway")

# Lambert_72 = 31370
# WGS_84     = 4326 

# read in SITES and LU layers
LU <- st_read("./GbgVLBRU.shp", quiet=TRUE)

buffers <- st_read(paste0("./file name.shp"), quiet=TRUE)

st_agr(LU) = "constant"
st_agr(buffers) = "constant"
st_crs(buffers) <- st_crs(LU)

# intersect SITES and LU
LU_intersect <- st_intersection(LU, buffers)

# add in areas in m2
attArea <- LU_intersect %>% mutate(area = st_area(.) %>% as.numeric())

# for each SITE, get area per LU
results <-  attArea %>% as_tibble() %>%
  group_by(BU, ID, distance) %>%
  dplyr::summarise(area= sum(area))

# make sure SITES with no spatial data are added and set to 0   
results <- buffers %>% st_drop_geometry() %>% 
  left_join(results, by = c("ID" = "ID", "distance"="distance"))

results <- results[order(results$ID), ]
results$area [is.na(results$area)] <- 0
results$ratio <- 100*(results$area / results$buf_area)

head(results)

# export output
fwrite(results, paste0("./output/ballooning_manuscript2.csv"))



