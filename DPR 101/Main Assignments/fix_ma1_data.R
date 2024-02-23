
## open the {tidyverse}
library(tidyverse)
## read in the data
url <- "http://tinyurl.com/ma1dataset"
Data <- read_csv(url)
Data |>
  mutate(
    county_name = str_remove_all(
      county_name, " County"
    )
  ) -> Data

## bring in county map data
library(socviz)

county_map |>
  left_join(
    county_data
  ) |>
  select(
    long, lat, order, hole, piece, group, id, name, state 
  ) -> map_data

map_data |>
  filter(state == "OH") |>
  select(id, name) |>
  distinct() -> map_ids

Data |>
  mutate(
    county_name = paste0(county_name, " County")
  ) -> Data

Data |>
  left_join(
    map_ids,
    by = c("county_name" = "name")
  ) -> Data

Data |>
  mutate(
    id = as.character(id)
  ) -> Data

write_csv(
  Data,
  here::here(
    "DPR 101",
    "Data",
    "ma1_data.csv"
  )
)
