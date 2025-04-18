MA4: Fall 2023 Starter Code
================
2023-11-15

For our final main assignment, we’ll be dealing with DU survey data
collected during the month of October (2023). There is a metric ton of
questions to consider, so have fun! To give you a head start, I went
ahead and wrote the following code. You can copy and paste this into
your first code chunk and build on it to include other topics you want
to explore in the data. Good luck!

``` r
knitr::opts_chunk$set(echo = F,
                      message = F,
                      warning = F,
                      dpi = 500,
                      out.width = "80%")

## packages
library(tidyverse)
library(coolorrr)
library(socsci)
library(googlesheets4)

## custom data viz
set_theme()   # you can get rid of this if you don't like it
set_palette(
  qualitative = c("steelblue", "gray20", "red3", "purple4", "forestgreen"),
  from_coolors = F
)

## survey data
gs4_deauth()
o23 <- range_read(
  "https://docs.google.com/spreadsheets/d/19Et52eKP1Yte9tainpfB7f_9sCB8UAVM36DbR2ySyaI/edit#gid=1526346509"
)

## link to the code book:
# https://drive.google.com/file/d/13HQ7HgKD4JS6CMYGUIUwgUykGqXttSV9/view?usp=sharing

## Some  Gifted Recodes 
o23 |>
  
    # make all column names lowercase
  rename_with(tolower, everything()) |>
    
    # start the recodes
  mutate(
    
    # race
    white = replace_na(q57_1, 0),
    hispanic = replace_na(q57_2, 0),
    black = replace_na(q57_3, 0),
    asian = replace_na(q57_4, 0),
    other = replace_na(q57_5, 0),
    race = case_when(
      white==1 & (black!=1 & hispanic!=1 & asian!=1 & other!=1) ~ "White",
      black==1 ~ "Black",
      asian==1 & (black!=1 & hispanic!=1) ~ "Asian",
      hispanic==1 ~ "Hispanic",
      other==1 & (black!=1 & hispanic!=1 & asian!=1)~ "Other"
    ),
    
    # gender
    gender = frcode(
      q53 == 1 ~ "Men",
      q53 == 2 ~ "Women"
    ),
    femtran = frcode(
      q54_1 == 1 ~ "Men",
      q54_2 == 1 ~ "Women",
      q54_3 == 1 | q54_1 == 1 ~ "Trans/N-B"
    ),
    
    # group participation
    greek = replace_na(q44_6, 0),
    varsity = replace_na(q44_1, 0),
    across(
      starts_with("q44_"),
      ~ replace_na(.x, 0)
    )
  ) |>
  rowwise() |>
  mutate(
    num_groups = 
      sum(c_across(starts_with("q44_")), na.rm  = T)
  ) |>
  ungroup() |>
  mutate(
    
    # partisanship
    pid7 = frcode(
      q3 == 1 ~ "Strong Democrat",
      q3 == 2 ~ "Democrat",
      q3 == 3 ~ "Lean Democrat",
      q3 == 4 ~ "Independent",
      q3 == 5 ~ "Lean Republican",
      q3 == 6 ~ "Republican",
      q3 == 7 ~ "Strong Republican"
    ),
    pid3 = frcode(
      q3 %in% 1:3 ~ "Democrat",
      q3 == 4 ~ "Independent",
      q3 %in% 5:7 ~ "Republican"
    ),
    
    # polarization
    polarized = abs(q11_6 - q11_8)
  ) |>
  
    # importance of foreign policy issues
  mutate(
    across(q8_1:q8_12, ~ replace_na(.x, 0))
  ) |>
  rename(
    cyber_security = q8_1,
    ethnic_conflict = q8_2,
    climate_change = q8_3,
    human_rights = q8_4,
    migration = q8_5,
    terrorism = q8_6,
    trade = q8_7,
    regional_disintegration = q8_8,
    russian_aggression = q8_9,
    rising_china = q8_10,
    domestic_political_instability = q8_11,
    weapons_of_mass_destruction = q8_12,
    other_fp_concerns = q8_13
  ) |>
  
    # biden's foreign policy performance
  mutate(
    biden_fp = frcode(
      q10_1 == 5 ~ "Very poorly",
      q10_1 == 4 ~ "Poorly",
      q10_1 == 3 ~ "Neither",
      q10_1 == 2 ~ "Well",
      q10_1 == 1 ~ "Very well"
    )
  ) -> o23
```
