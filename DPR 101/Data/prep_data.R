#### Clean up the election forecast data ----

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


## Create data for graph challenge 0

x <- c(
  runif(250, 0, 1),
  runif(50, 1.2, 1.4)
)
y <- rep(0, len = length(x))
y[between(x, 0, 0.2)] <- 
  runif(sum(between(x, 0, 0.2)), 0, 1)
y[between(x, 0.2, 0.8)] <-
  runif(sum(between(x, 0.2, 0.8)), 0.4, 0.6)
y[between(x, 0.8, 1)] <-
  runif(sum(between(x, 0.8, 1)), 0, 1)
y[between(x, 1.2, 1.4)] <-
  runif(sum(between(x, 1.2, 1.4)), 0, 1)
plot(x, y)
write_csv(
  tibble(var1 = x, var2 = y),
  here::here("DPR 101", "Data", "gc0.csv")
)


# ohio issue 1 data -------------------------------------------------------

library(tidyverse)
dt <- read_csv(
  here::here("DPR 101", "Data", "2023_aug_ohio_turnout.csv")
)
names(dt) |>
  str_replace_all(
    " ", "_"
  ) |>
  tolower() -> names(dt)

dt |>
  filter(
    county_name != "Total"
  ) |>
  mutate(
    official_voter_turnout = 
      100 * ballots_counted / registered_voters
  ) -> dt
write_csv(
  dt,
  file = here::here(
    "DPR 101", "Data", 
    "2023_aug_ohio_turnout_CLEANED.csv"
  )
)

## example use:
ggplot(dt) +
  aes(registered_voters,
      ballots_counted) +
  geom_point() +
  geom_smooth(
    method = "lm",
    se = F
  )

dt <- read_csv(
  here::here("DPR 101", "Data", "ohio_issue1_outcomes.csv")
)
names(dt) |>
  str_replace_all(
    " ", "_"
  ) |>
  tolower() -> names(dt)

dt |>
  filter(
    county_name != "Total"
  ) |>
  mutate(
    official_voter_turnout = 
      100 * ballots_counted / registered_voters
  ) -> dt
write_csv(
  dt,
  file = here::here(
    "DPR 101", "Data", 
    "ohio_issue1_outcomes_CLEANED.csv"
  )
)



# clean up some MIE data --------------------------------------------------

url <- "https://raw.githubusercontent.com/milesdwilliams15/Teaching/main/DPR%20190/Data/events/mie-1.0.csv"
mie_data <- read_csv(url)
mie_data |>
  filter(styear >= 2000) |>
  group_by(ccode1) |>
  summarize(
    n_events = n(),
    fatalmin = sum(fatalmin1),
    fatalmax = sum(fatalmax1),
    .groups = "drop"
  ) |> 
  mutate(
    country = countrycode::countrycode(
      ccode1, "cown", "country.name"
    )
  ) -> mie_small

write_csv(
  mie_small,
  here::here("DPR 101", "Data", "MIE_2000-2014.csv")
)
