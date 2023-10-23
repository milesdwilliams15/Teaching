Metadata for the conflict time-series dataset
================

## Data overview

The data used to create the dataset for Main Assignemnt 2 was accessed
and compiled using the `{peacesciencer}` R package. The script necessary
to recreate the dataset is included below:

    ## open packages:
    library(tidyverse)
    library(peacesciencer)

    ## create a dyad-year dataset 
    Data <- create_dyadyears(directed = T) |>
      ## add conflict dataset
      left_join(cow_war_inter) |>
      ## add democracy data
      add_democracy() |>
      ## add capabilities
      add_nmc()
      
    ## rescale the democracy measures
    Data |>
      mutate(
        across(v2x_polyarchy1:xm_qudsest2, scale)
      ) -> Data
      
    ## create measures of weakest democracy
    Data |>
      mutate(
        min_polyarchy = ifelse(
          v2x_polyarchy1 < v2x_polyarchy2,
          v2x_polyarchy1, v2x_polyarchy2
        ),
        min_polity2 = ifelse(
          polity21 < polity22,
          polity21, polity22
        ),
        min_qudsest = ifelse(
          xm_qudsest1 < xm_qudsest2,
          xm_qudsest1, xm_qudsest2
        )
      ) -> Data
      
    ## make function to combine country names into a list
    clist <- function(x) {
      x <- countrycode::countrycode(x, "cown", "country.name")
      paste0(unique(x), collapse = ", ")
    }

    ## aggregate the data to individual wars
    Data |> filter(cowinterongoing == 1) |>
      group_by(warnum) |>
      summarize(
        start_year = min(year),
        duration = max(year) - min(year) + 1,
        side1 = clist(ccode1[sidea1==1]),
        side2 = clist(ccode1[sidea1==2]),
        side1_initiator = max(
          initiator1[sidea1==1], na.rm = T
        ),
        side2_initiator = max(
          initiator1[sidea1==2], na.rm = T
        ),
        side1_winner = min(
          outcome1[sidea1==1]==1, na.rm = T
        ),
        side2_winner = min(
          outcome1[sidea1==2]==1, na.rm = T
        ),
        side1_deaths = sum(
          batdeath1[sidea1==1 & batdeath1 > 0], na.rm = T
        ),
        side2_deaths = sum(
          batdeath1[sidea1==2 & batdeath1 > 0], na.rm = T
        ),
        side1_military_expenditures = sum(
          milex1[sidea1==1], na.rm = T
        ),
        side2_military_expenditures = sum(
          milex1[sidea1==2], na.rm = T
        ),
        side1_military_personnel = sum(
          milper1[sidea1==1], na.rm = T
        ),
        side2_military_personnel = sum(
          milper1[sidea1==2], na.rm = T
        ),
        side1_polyarchy = mean(
          v2x_polyarchy1[sidea1==1], na.rm = T
        ),
        side2_polyarchy = mean(
          v2x_polyarchy1[sidea1==2], na.rm = T
        ),
        side1_polity2 = mean(
          polity21[sidea1==1], na.rm = T
        ),
        side2_polity2 = mean(
          polity21[sidea1==2], na.rm = T
        ),
        side1_qudsest = mean(
          xm_qudsest1[sidea1==1], na.rm = T
        ),
        side2_qudsest = mean(
          xm_qudsest1[sidea1==2], na.rm = T
        ),
        min_polyarchy = min(v2x_polyarchy1, na.rm = T),
        min_polity2 = min(polity21, na.rm = T),
        min_qudsest = min(xm_qudsest1, na.rm = T)
      ) -> sm_data

    ## deal with pesky infinite values
    apply(sm_data, c(1, 2), function(x) ifelse(is.infinite(x), NA, x)) |>
      as_tibble() -> sm_data

The output of the above is an object called `sm_data` which is a
conflict dataset of international wars fought between 1816 to 2007. The
unit of observation is a given war.

## Variable names and definitions

1.  “warnum”: numerical identifier for wars.  
2.  “start_year”: year a war started  
3.  “duration”: number of years a war lasted.  
4.  “side1”: countries on side ‘1’ of a conflict.  
5.  “side2”: countries on side ‘2’ of a conflict.  
6.  “side1_initiator”: equals 1 if side 1 started the war.  
7.  “side2_initiator”: equals 1 if side 2 started the war.  
8.  “side1_winner”: equals 1 if side 1 won the war.  
9.  “side2_winner”: equals 1 if side 2 won the war.  
10. “side1_deaths”: total battle related deaths for side 1.  
11. “side2_deaths”: total battle related deaths for side 2.  
12. “side1_military_expenditures”: total military expenditures for side
    1 in thousands (denominated in British pounds for 1816-1913 and in
    US dollars thereafter).
13. “side2_military_expenditures”: total military expenditures for side
    2 in thousands (denominated in British pounds for 1816-1913 and in
    US dollars thereafter).
14. “side1_military_personnel”: estimate of combined military size in
    personnel in thousands for side 1.  
15. “side2_military_personnel”: estimate of combined military size in
    personnel in thousands for side 2.  
16. “side1_polyarchy”: average V-Dem democracy score for side 1.  
17. “side2_polyarchy”: average V-Dem democracy score for side 2.  
18. “side1_polity2”: average Polity 2 score for side 1.  
19. “side2_polity2”: average Polity 2 score for side 2.  
20. “side1_qudsest”: average UDS score for side 1.
21. “side2_qudsest”: average UDS score for side 2.
22. “min_polyarchy”: the democracy score for the weakest democracy among
    the countries fighting a war (regardless of side) based on V-Dem.  
23. “min_polity2”: the democracy score for the weakest democracy among
    the countries fighting a war (regardless of side) based on Polity
    2.  
24. “min_qudsest”: the democracy score for the weakest democracy among
    the countries fighting a war (regardless of side) based on UDS.
