# Cross-reference governance with civil war
rm(list = ls())
library(tidyverse)
library(peacesciencer)
library(wwmetrics)
library(countrycode)

ucdp_onsets %>%
  transmute(
    country = countrycode(
      gwcode, "gwn", "country.name"
    ),
    year,
    sumonset1
  ) %>%
  distinct() -> onset

data("WGI")
WGI %>%
  transmute(
    country = countrycode(
      Country, "iso3c", "country.name"
    ),
    year,
    wgi = mean_WGI
  ) -> wgi

left_join(
  onset, wgi,
  by = c("country", "year")
) -> Data

write_csv(
  na.omit(Data),
  here::here(
    "DPR 101", "Data", "onset_and_wgi.csv"
  )
)
