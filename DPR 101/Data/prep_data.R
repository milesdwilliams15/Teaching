## Clean up the election forecast data ##

library(tidyverse)
url <- "https://raw.githubusercontent.com/fivethirtyeight/checking-our-work-data/master/presidential_elections.csv"
Data <- read_csv(url)
str(Data)

Data <- Data %>%
  filter(forecast_type == "polls-plus",
         party == "D") %>%
  select(forecast_date, state, projected_voteshare, actual_voteshare, probwin, probwin_outcome)

write_csv(
  Data,
  here::here("DPR 101", "Data", "538_prez_forecast.csv")
)

Data <- filter(
  Data,
  forecast_date %in% as.Date(c("2020-09-01",
                               "2020-10-01",
                               "2020-11-01"))
)

write_csv(
  Data,
  here::here("DPR 101", "Data", "538_prez_forecast_small_2020.csv")
)
