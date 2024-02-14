# Make election forecast data #


# packages ----------------------------------------------------------------

library(tidyverse)
library(here)


# data --------------------------------------------------------------------

## the data
read_csv(
  "https://raw.githubusercontent.com/markjrieke/2024-potus/main/data/abramovitz.csv"
) -> Data

## bring in gdp data for the US
read_csv(
  here::here(
    "DPR 201", "Data", "GDP.csv"
  )
) -> gdp


# updates -----------------------------------------------------------------

## clean up the main dataset
Data |>
  select(
    year,
    inc_party,
    inc_running,
    dem,
    rep,
    inc_approval = fte_net_inc_approval,
    third_party = third_party_present
  ) |>
  mutate(
    inc_vote = ifelse(inc_party == "dem", dem, rep),
    inc_approval = inc_approval/100
  ) -> Data

## clean up the economic dataset
gdp |>
  mutate(
    Q = rep(paste0("Q", 1:4), len = n()),
    year = year(DATE),
    gdp = GDP,
    gdp_lag = lag(gdp, order_by = DATE),
    gdp_growth = gdp - gdp_lag,
    gdp_pct_growth = gdp_growth / gdp_lag
  ) |>
  filter(
    Q == "Q2"
  ) |>
  select(
    year, gdp, gdp_growth, gdp_pct_growth
  ) -> gdp

# merge -------------------------------------------------------------------

Data |>
  left_join(
    gdp, 
    by = c("year")
  ) -> final_data

# save --------------------------------------------------------------------

write_csv(
  final_data,
  file = here("DPR 201", "Data", "prez_data.csv")
)
