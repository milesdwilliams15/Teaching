## Clean up the election forecast data ##

library(tidyverse)
url <- "https://raw.githubusercontent.com/fivethirtyeight/checking-our-work-data/master/presidential_elections.csv"
Data <- read_csv(url)
glimpse(Data)

Data <- Data %>%
  filter(forecast_type == "polls-plus",
         candidate %in% c("Biden", "Clinton"),
         is.na(district)) %>%
  select(forecast_date, state, projected_voteshare, 
         actual_voteshare, probwin, probwin_outcome)

write_csv(
  Data,
  here::here("DPR 101", "Data", "538_prez_forecast.csv")
)

small_Data <- filter(
  Data,
  forecast_date %in% as.Date(c("2020-09-01",
                               "2020-10-01",
                               "2020-11-01"))
)

write_csv(
  small_Data,
  here::here("DPR 101", "Data", "538_prez_forecast_small_2020.csv")
)

change_Data <- Data %>%
  mutate(
    election = ifelse(
      forecast_date < as.Date("2020-01-01"),
      "2016",
      "2020"
    )
  ) %>%
  group_by(
    election, state
  ) %>%
  summarize(
    projected_voteshare = projected_voteshare[
      forecast_date == max(forecast_date)
    ],
    actual_voteshare = unique(actual_voteshare)
  ) %>%
  ungroup %>%
  mutate(
    forecast_error = projected_voteshare - actual_voteshare
  )

write_csv(
  change_Data,
  here::here("DPR 101", "Data", "538_prez_forecast_error_20162020.csv")
)
