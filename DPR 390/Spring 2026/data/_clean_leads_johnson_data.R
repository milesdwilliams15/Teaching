

# clean up alliance data from FPA article ---------------------------------

## setup ----
library(tidyverse)
library(haven)
library(here)

## data ----

read_dta(
  here("DPR 390", "Spring 2026", "data", "Johnson&LeedsFPA.dta")
) -> dt

## clean and aggregate ----

dt |>
  select(challenger, target, year, ptargdef, pchalally) |>
  filter(ptargdef == 1 | pchalally == 1) -> sm_dt

colnames(sm_dt) <- c("ccode1", "ccode2", "year", "target_defense", "challenger_defense")

## save ----

write_csv(
  sm_dt,
  here("DPR 390", "Spring 2026", "data", "johnson_leeds_alliances.csv")
)
