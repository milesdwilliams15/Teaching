
# -------------------------------------------------------------------------
# {peacesciencer} helper function source code
# -------------------------------------------------------------------------

# *****
# The {peacesciencer} package is a great resource for
# creating datasets for studying international politics,
# especially international conflict. But it has some 
# quirks that make certain data merges unruly. This
# script file contains source code for helper functions
# that make overcoming these quirks as simple as a call
# to a single function.


# merging int'l conflict data to country-year data ------------------------

# *****
# By default, international conflict variables, like 
# MIDs or all out war can only be added to dyad-year
# data. But sometimes it'd be nice to join these to
# country-year data instead. Here are functions that
# make that possible.

# update on add_cow_wars(type = "inter")
# ?add_cow_wars

force_cow_wars <- function(data) {
  # first check if the data is state-year
  is_state_year <- attributes(data)$ps_data_type == "state_year"
  if(!is_state_year) stop(
    "Data is not of type 'state_year.' Cannot merge."
  )
  
  # make dyad-year data and merge war data
  dy <- create_dyadyears()
  dy <- dy |>
    left_join(
      y = cow_war_inter
    )
  
  # aggregate to country-year
  cy <- dy |>
    select(year, warnum, cowinteronset, cowinterongoing, ends_with("1"), resume) |>
    rename_with(
      ~ str_remove(.x, "1")
    ) |>
    group_by(ccode, year) |>
    summarize(
      nwars = sum(!is.na(unique(warnum))),
      across(cowinteronset:cowinterongoing, max),
      across(c(initiator, batdeath, resume), ~ unique(.x) |>
               sum(na.rm = T)),
      outcome = (sum(outcome==1, na.rm = T) > 0)+0
    ) |>
    distinct()
  
  # merge with data and return
  data <- data |> 
    left_join(cy, by = c("ccode", "year"))
  data
}

# TEST
# cy <- create_stateyears()
# cy <- cy |>
#   force_cow_wars()

# update on add_cow_mids()
# ?add_cow_mids

force_cow_mids <- function(data) {
  # first check if the data is state-year
  is_state_year <- attributes(data)$ps_data_type == "state_year"
  if(!is_state_year) stop(
    "Data is not of type 'state_year.' Cannot merge."
  )
  
  # make dyad-year data and merge war data
  dy <- create_dyadyears()
  dy <- add_cow_mids(dy)
  
  # aggregate to country-year
  cy <- dy |>
    select(
      year, dispnum, cowmidonset, cowmidongoing,
      ends_with("1"),
      fatality:stmon
    ) |>
    rename_with(
      ~ paste0("tot_", .x),
      fatality:hostlev
    ) |>
    rename_with(
      ~ str_remove(.x, "1")
    ) |>
    mutate(
      across(
        c(fatality,fatalpre,tot_fatality),
        ~ ifelse(.x == -9, NA_integer_, .x)
      )
    ) |>
    group_by(ccode, year) |>
    summarize(
      nmids = sum(!is.na(unique(dispnum))),
      across(c(cowmidonset, cowmidongoing), max),
      across(c(fatalpre, orig), ~ unique(.x) |> sum(na.rm = T)),
      across(c(fatality, hiact:hostlev, tot_fatality:maxdur, stmon), ~ unique(.x) |>
               mean(na.rm = T))
    ) |>
    distinct()
  
  # merge with data and return
  data <- data |> 
    left_join(cy, by = c("ccode", "year"))
  data
}

# TEST
# cy <- create_stateyears()
# cy <- cy |>
#   force_cow_mids()


# add state names ---------------------------------------------------------

# *****
# In some datasets, country names are not already included.
# The following function can be used to add state names from
# the country codes in the data.

add_state_names <- function(data) {
  col_names <- colnames(data)
  cow_codes <- any(str_detect(col_names, "ccode"))
  if(cow_codes) {
    is_dyadic <- any(str_detect(col_names, "ccode1"))
    if(is_dyadic) {
      data <- data |>
        mutate(
          statename1 = countrycode::countrycode(
            ccode1, "cown", "country.name"
          ),
          statename2 = countrycode::countrycode(
            ccode2, "cown", "country.name"
          )
        )
    } else {
      data <- data |>
        mutate(
          statename = countrycode::countrycode(
            ccode, "cown", "country.name"
          )
        )
    }
  } else {
    is_dyadic <- any(str_detect(col_names, "gwcode1"))
    if(is_dyadic) {
      data <- data |>
        mutate(
          statename1 = countrycode::countrycode(
            gwcode1, "gwn", "country.name"
          ),
          statename2 = countrycode::countrycode(
            gwcode2, "gwn", "country.name"
          )
        )
    } else {
      data <- data |>
        mutate(
          statename = countrycode::countrycode(
            gwcode, "gwn", "country.name"
          )
        )
    }
  }
  # return the data
  data
}
