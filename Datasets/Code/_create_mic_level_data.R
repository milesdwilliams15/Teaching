##################################
# Create Conflict Level Datasets #
##################################

# This code is used to create conflict level datasets for
# use in DPR 101 and 201.

## open {tidyverse} and {peacesciencer}
library(tidyverse)
library(peacesciencer)


## bring in MIE data
read_csv(
  here::here(
    "DPR 201", 
    "Data",
    "mie-1.0.csv"
  )
) -> mie_data


## aggreagate to MICs
mie_data |>
  mutate(
    stday = ifelse(stday == -9, 1, stday),
    endday = ifelse(endday == -9, stday, endday),
    stdate = paste0(
      styear, "-",
      str_pad(stmon, width = 2, pad = "0"), "-",
      str_pad(stday, width = 2, pad = "0")
    ) |> as.Date(),
    enddate = paste0(
      endyear, "-",
      str_pad(endmon, width = 2, pad = "0"), "-",
      str_pad(endday, width = 2, pad = "0")
    ) |> as.Date()
  ) |>
  group_by(micnum, ccode1, ccode2) |>
  summarize(
    year = min(styear),
    stdate = min(stdate),
    enddate = max(enddate),
    num_events = max(eventnum),
    days_durration = enddate - stdate + 1,
    across(
      fatalmin1:fatalmax2,
      sum
    ),
    full_on_war = ifelse(
      max(hostlev) == 5, 1, 0
    )
  ) -> mic_data

## merge with base data then
## filter out obs. with no confrontations
create_dyadyears(
  subset_years = 1816:2014,
  directed = F
) |>
  left_join(
    mic_data
  ) |>
  ## merge in additional data for covariates
  add_democracy() |>
  add_sdp_gdp() |>
  add_nmc() |>
  add_strategic_rivalries() |>
  add_cow_majors() |>
  add_cow_trade() |>
  add_capital_distance() |>
  add_atop_alliance() |>
  add_igos() -> Data

rescale <- function(x) {
  rx <- (x - min(x, na.rm = T)) / 
    max(x - min(x, na.rm = T), na.rm = T)
  1 + 9 * rx
}
Data |>
  mutate(
    across(
      c(polity21, polity22,
        v2x_polyarchy1, v2x_polyarchy2,
        xm_qudsest1, xm_qudsest2),
      rescale
    )
  ) -> Data

## condense to the confrontation level
Data |>
  drop_na(micnum) |>
  group_by(micnum) |>
  summarize(
    ## timing
    year = min(year),
    stdate = min(stdate),
    enddate = max(enddate),
    
    ## outcomes
    days_duration = max(days_durration, na.rm = T) |>
      as.numeric(),
    militarized_events = max(num_events, na.rm = T),
    total_involved = length(unique(ccode1)) +
      length(unique(ccode2)),
    across(
      c(fatalmin1, fatalmin2, fatalmax1, fatalmax2),
      sum
    ),
    fatalmin_ratio = fatalmin1 / fatalmin2,
    fatalmax_ratio = fatalmax1 / fatalmax2,
    full_on_war = max(full_on_war, na.rm = T),
    
    ## covariates
    ## - mean democracy
    across(
      c(polity21, v2x_polyarchy1, xm_qudsest1,
        polity22, v2x_polyarchy2, xm_qudsest2),
      ~ mean(.x, na.rm = T),
      .names = "mean_{.col}"
    ),
    ## - dem ratio
    polity2_ratio = mean_polity21 / mean_polity22,
    v2x_polyarchy_ratio = mean_v2x_polyarchy1 / mean_v2x_polyarchy2,
    xm_qudsest_ratio = mean_xm_qudsest1 / mean_xm_qudsest2
    
    # ## - mean, min, and max diff cinc scores
    # mean_mil_power = (mean(cinc1, na.rm = T) +
    #                     mean(cinc2, na.rm = T)) / 2,
    # min_mil_power = min(
    #   min(cinc1, na.rm = T),
    #   min(cinc2, na.rm = T)
    # ),
    # maxdiff_mil_power = max(
    #   max(cinc1, na.rm = T),
    #   max(cinc2, na.rm = T)
    # ) - min_mil_power,
    
    # ## - mean and total population
    # mean_pop = (mean(1000 * tpop1, na.rm = T) + 
    #               mean(1000 * tpop2, na.rm = T)) / 2,
    # total_pop = 1000 * sum(tpop1 + tpop2, na.rm = T),
    # 
    # ## - ravalries rate
    # rivals_rate = mean(ongoingrivalry, na.rm = T),
    # 
    # ## - major powers involved
    # major_powers_involved = sum(cowmaj1 + cowmaj2, na.rm = T),
    # 
    # ## - trade between sides
    # total_trade = 1000000 * sum(flow1 + flow2, na.rm = T),
    # total_trade_pc = total_trade / total_pop,
    # 
    # ## - proximity of sides capitals
    # mean_dist = mean(capdist, na.rm = T),
    # min_dist = min(capdist, na.rm = T),
    # 
    # ## - alliances
    # total_alliances = sum(atop_defense, na.rm = T),
    # mean_alliances = mean(atop_defense, na.rm = T),
    # min_alliances = min(atop_defense, na.rm = T),
    # 
    # ## - joint IGO membership
    # total_igos = sum(dyadigos, na.rm = T),
    # mean_igos = mean(dyadigos, na.rm = T),
    # min_igos = min(dyadigos, na.rm = T)
  ) |>
  ungroup() |>
  rename(
    mic_id = micnum
  ) |>
  arrange(
    year
  ) -> final_Data

## bring in confrontation names
read_csv(
  here::here(
    "DPR 201",
    "Data",
    "micnames-1.0.csv"
  )
) -> micnames

final_Data |>
  left_join(
    micnames,
    by = c("mic_id" = "micnum")
  ) -> final_Data

final_Data %>%
  dplyr::select(-version) %>%
  dplyr::select(
    mic_id,
    micname,
    everything()
  ) -> final_Data

## save as .csv file
# write_csv(
#   final_Data,
#   here::here(
#     "Datasets",
#     "Data",
#     "mic_data.csv"
#   )
# )
write_csv(
  final_Data |> 
    filter(full_on_war == 1) |>
    select(-full_on_war),
  here::here(
    "Datasets",
    "Data",
    "mic_data_only_wars.csv"
  )
)

dt <- final_Data |> filter(full_on_war == 1)

ggplot(dt) -> p

p + 
  aes(year) +
  geom_bar() 
p +
  aes(year, fatalmax1 + fatalmax2) +
  geom_line()
p + 
  aes(year, days_duration) +
  geom_line()
p + 
  aes(year, militarized_events) +
  geom_line()
p +
  aes(year, total_involved) +
  geom_line()

dt |>
  pivot_longer(
    contains("mean")
  ) |>
  dplyr::select(year, name, value) |>
  mutate(
    name = str_remove_all(name, "[0-9]")
  ) |>
  ggplot() +
  aes(x = year, y = value) +
  geom_point() +
  geom_smooth() +
  facet_wrap(~ name,
             scales = "free_y")

ggplot(dt) +
  aes(x = v2x_polyarchy_ratio,
      y = fatalmax_ratio) +
  geom_point() +
  geom_smooth() +
  scale_x_log10() +
  scale_y_log10()
