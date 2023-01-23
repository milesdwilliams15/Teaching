# I need these packages:
library(ggplot2)
library(dplyr)
library(here)

# attach the data:
here::here()
file_path <- here::here("GarlicMustardData.csv")
GarlicMustardData <- read.csv(file_path) 

# summarize
summary(GarlicMustardData)

# subsets
myvars <- c("Latitude", "Longitude", "Altitude")
GarlicMustardGeo <- GarlicMustardData[myvars]
summary(GarlicMustardGeo)

GarlicMustardGeo <- GarlicMustardData %>%
  select(Latitude, Longitude, Altitude)
summary(GarlicMustardGeo)

GarlicMustard_subset <- select(GarlicMustardData, 1, 5:8)
summary(GarlicMustard_subset)

GM_filtered <- GarlicMustardData %>%
  filter(TotalDens >= 4 & Altitude >= 100)
