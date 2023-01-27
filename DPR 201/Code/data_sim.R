#########################################
# Data simulation for DPR 101 Exercises #
#########################################


# 1. Selecting on the DV --------------------------------------------------

## Setup
rm(list = ls())
library(tidyverse)
library(fabricatr)
library(here)

## What I'm doing

# The goal of this exercise is to get students to 
# think about when they do and don't have enough variation
# in data to make claims about correlation. I've simulated some
# datasets to help. Some have the relevant variation. Others
# don't. It'll be up to the students to identify which.


## Dataset 1: Terrorism and Foreign Occupation
set.seed(1)

fabricate(
  N = 100,
  country_id = 1:100,
  foreign_occupied = draw_binary(0.2, N = N),
  terrorist_attacks = draw_count(c(0, 5, 25, 100), N = N)
) -> terror_data

path <- here(
  "DPR 201", "Data", "terror_data.csv"
)
write_csv(terror_data, path)


## Dataset 2: Ideology and Immigrant Attitudes
set.seed(2)
fabricate(
  N = 1000,
  group_id = rep(1:10, 100),
  ideology = draw_normal_icc(mean = 0, N = N, clusters = group_id, ICC = 0.7),
  ideological_label = draw_ordered(
    x = ideology,
    break_labels = c(
      "Very Conservative", "Conservative",
      "Liberal", "Very Liberal"
    )
  ),
  income = exp(rlnorm(n = N, meanlog = 2.4 - (ideology * 0.1), sdlog = 0.12)),
  Q1_immigration = draw_likert(x = ideology, min = -5, max = 5, bins = 7),
  Q2_defence = draw_likert(x = ideology + 0.5, min = -5, max = 5, bins = 7),
  treatment = draw_binary(0.5, N = N),
  proposition_vote = draw_binary(latent = ideology + 1.2 * treatment, link = "probit")
) -> voters

voters %>%
  filter(
    proposition_vote == 1
  ) -> voters

path <- here(
  "DPR 201", "Data", "immigration_proposition.csv"
)
write_csv(voters, path)


## Dataset 3: Women in Office
set.seed(3)
fabricate(
  party_id = add_level(
    N = 2, party_names = c("Republican", "Democrat"), party_ideology = c(0.5, -0.5),
    in_power = c(1, 0), party_incumbents = c(241, 194)
  ),
  rep_id = add_level(
    N = party_incumbents, member_ideology = rnorm(N, party_ideology, sd = 0.5),
    terms_served = draw_count(N = N, mean = 4),
    female = draw_binary(N = N, prob = 0.198)
  )
) -> house_members

path <- here(
  "DPR 201", "Data", "gender_in_congress.csv"
)
write_csv(house_members, path)


## Dataset 4: GDP Growth
set.seed(4)
fabricate(
  N = 20,
  country = "Germany",
  year = 1990:2009,
  gdp = 20 + 0.3 * 1:N + rnorm(N, sd=0.3),
  immigration = draw_count(mean = 10 + 0.1 * 1:N, N = N)
) -> gdp_panel

path <- here(
  "DPR 101", "Data", "gdp_and_immigration.csv"
)
write_csv(gdp_panel, path)
