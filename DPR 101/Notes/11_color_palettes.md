Introducing `{coolorrr}` for Updating Colors
================

- [Goals](#goals)
- [Cooler colors with `{coolorrr}`](#cooler-colors-with-coolorrr)
  - [Setting your palettes](#setting-your-palettes)
  - [Using your palettes](#using-your-palettes)
- [Seeing it in action](#seeing-it-in-action)
- [Make Your Own Palette](#make-your-own-palette)
- [Where to next?](#where-to-next)

<center>

[\<– Layer Complexity and Adding Labels and
Text](https://github.com/milesdwilliams15/Teaching/blob/main/DPR%20101/Notes/10_modifying_data_labels_and_notes_pt2.md)
\| [Back to Notes
Homepage](https://github.com/milesdwilliams15/Teaching/blob/main/DPR%20101/Notes/README.md)
\| [Refining Your Plots
–\>](https://github.com/milesdwilliams15/Teaching/blob/main/DPR%20101/Notes/12_refining_plots.md)

</center>

## Goals

- Use tools in `{coolorrr}` to update color palettes.
- Understand the different kinds of palettes you can choose from.
- Select your own palettes.

## Cooler colors with `{coolorrr}`

Up to now when we’ve mapped color or fill aesthetics to variables in our
data, we’ve relied on ggplot defaults (mostly). These can be updated
using a variety of built-in ggplot functions. I generally dislike most
of these functions—mainly because there are so many.

So I decided to create an R package that would simplify the process. I
call it `{coolorrr}`. In these notes, we’ll walk through how to use it.

First, you need to install it. Instead of using `install.packages()`,
you need to use the `install_github()` function from the `{devtools}`
package. The reason is that the package I made is hosted in a repository
on my person GitHub rather than the CRAN (which is where many other R
packages are hosted). To install it, simply write and run the following
in your console:

    devtools::install_github("milesdwilliams15/coolorrr")

If you don’t have `{devtools}`, you’ll need to install it first by
writing and running `install.packages("devtools")` in your R console.

This package was inspired by a free and easy to use palette-generating
site called [coolors.co](https://coolors.co/). If you go to the site, it
lets you easily pick out all kinds of different palettes, and it gives
you the hex-codes associated with individual colors. R knows how to read
hex-codes, which means we can use them for setting or updating colors
for our data visualizations.

This is where `{coolorrr}` comes in. The package is designed so that you
can take the palettes you make at coolors.co and use them with ggplot.
Here’s how it works.

### Setting your palettes

First, open the `{tidyverse}` along with `{coolorrr}`:

``` r
library(tidyverse)
library(coolorrr)
```

`{coolorrr}` works by setting a series of different palettes *globally*
in R’s environment and then calling them in the ggplot workflow. That
means that before you can use your palettes, you need to “set” them. You
do that with the `set_palette()` function. To get started, you can
actually just run the function in a line of code without any inputs.
It’s pre-programmed with default palettes (my own choices which are
probably of questionable taste).

``` r
set_palette()
```

To use a palette of your own choosing from coolors.co, you’d run
`set_palette()` and using one of four different palette options, tell it
which palette you’d like to set. The below code updates the
“qualitative” palette using a random palette I picked from coolor.co:

``` r
set_palette(
  qualitative = "https://coolors.co/palette/264653-2a9d8f-e9c46a-f4a261-e76f51-ec8c74-f0a390"
)
```

Notice that this works similarly to the way I’ve shown you to use
`read_csv()` to read in a .csv file hosted on my GitHub. I provide a url
(in “quotation marks”) and then the function does the rest.

`set_palette()` supports four different color palettes. These are:

- `qualitative`: useful for showing *unordered categorical* data (e.g.,
  world regions, different categories of democracy measures, or
  different demographic categories such as race).
- `diverging`: useful for *continuous*/*numerical* data that has a
  *reference point* (e.g., showing a vote margin where 0 = no difference
  with positive values to one side and negative to the other).
- `sequential`: useful for *continuous*/*numerical* data where you only
  care about highlighting differences between lower and higher values
  (e.g., population density).
- `binary`: this is a special qualitative palette for those cases where
  you just want to compare two categories (e.g., Republicans and
  Democrats).

Any palettes you don’t specify when running `set_palette()` will
automatically be set using defaults. You can update any of the four
palettes at any time, but just be aware that if you only set *one*
palette when you run the function, *all the others* will revert to the
defaults if you don’t keep your own choices in the code, too.

One last thing I’ll highlight about this function is that you can use
your own color selections directly rather than having to go to
coolors.co. You can do this like so:

``` r
set_palette(
  binary = c("red", "blue"),
  from_coolors = F
)
```

Using this approach, I can set a palette using a vector of color names.
All I need to do is tell `set_palette()` that I’m not giving it colors
from coolor.co. To do that, I need to set the option `from_coolors = F`.

### Using your palettes

Once you’ve set your palettes, you’ll use the `ggpal()` function to
update ggplot’s defaults. The function has a few different options you
can set. The main one’s are:

- `type`: equals one of `"qualitative"`, `"diverging"`, `"sequential"`,
  or `"binary"`. This is how you tell `ggpal()` what palette to use.
- `aes`: equals one of `"color"` or `"fill"`. This is how you tell
  `ggpal()` whether it needs to update the palette for the color
  aesthetic or the fill aesthetic.

By default, the options are `type = "qualitative"` and `aes = "color"`.

In addition to these options, you can update a few other things, too:

- `midpoint`: If you use `type = "diverging"`, this option lets you pick
  what the midpoint (point of reference) should be for the diverging
  palette. By default, this is 0.
- `...`: The `ggpal()` function is set up in such a way that it can give
  other options to stuff “under the hood” to update things like the
  labels of color or fill values in the legend.

The `ggpal()` function is designed to fit right in with the overall
ggplot workflow. To use it, you’ll just create your plot like usual and
then just use `+ ggpal()` as an additional line of code. The next
section shows you what this looks like.

## Seeing it in action

Let’s walk through how `{coolorrr}` works using some `{peacesciencer}`
data:

``` r
library(peacesciencer)
create_stateyears(subset_years = 1945:2007) |>
  add_cow_majors() |>
  add_cow_wars(type = "intra") |>
  add_democracy() |>
  add_sdp_gdp() -> Data
```

Before we get going, we need to add a new column to the data for country
regions. We can do this with `{countrycode}`:

``` r
library(countrycode)
Data |>
  mutate(
    region = countrycode(statenme, "country.name", "region")
  ) -> Data
```

Let’s check trends in civil wars over time by different world regions:

``` r
Data |>
  group_by(
    year, region
  ) |>
  summarize(
    mean = mean(cowintraongoing)
  ) |>
  ggplot() +
  aes(x = year,
      y = mean,
      color = region,
      label = region) +
  geom_point(
    alpha = 0.2
  ) +
  geom_smooth(
    se = F
  ) +
  labs(
    x = NULL,
    y = "Conflict Rate",
    title = "Intrastate conflict rate, 1945-2007",
    color = NULL
  )
```

<img src="11_color_palettes_files/figure-gfm/unnamed-chunk-7-1.png" width="75%" />

The default palette is so-so. Let’s update it.

First, let’s set a new qualitative palette. The one I used below is
Thanksgiving Day themed:

``` r
set_palette(
  qualitative = "https://coolors.co/palette/264653-2a9d8f-e9c46a-f4a261-e76f51-ec8c74-f0a390"
)
```

Then let’s summarize and plot the data:

``` r
Data |>
  group_by(
    year, region
  ) |>
  summarize(
    mean = mean(cowintraongoing)
  ) |>
  ggplot() +
  aes(x = year,
      y = mean,
      color = region,
      label = region) +
  geom_point(
    alpha = 0.2
  ) +
  geom_smooth(
    se = F
  ) +
  labs(
    x = NULL,
    y = "Conflict Rate",
    title = "Intrastate conflict rate, 1945-2007",
    color = NULL
  ) +
  ## update the palette here:
  ggpal() 
```

<img src="11_color_palettes_files/figure-gfm/unnamed-chunk-9-1.png" width="75%" />

As you can see, the workflow is really simple. After you’ve got your
palettes set (which you only need to do once in a given R session), you
can then use `ggpal()` in the normal ggplot workflow.

Here’s an example using a binary palette and the fill aesthetic:

``` r
Data |>
  filter(
    region %in% c("Sub-Saharan Africa", "Middle East & North Africa")
  ) |>
  group_by(region) |>
  summarize(
    conflict_rate = mean(cowintraongoing)
  ) |>
  ggplot() +
  aes(x = conflict_rate, y = region) +
  geom_col(
    aes(fill = region)
  ) +
  ggpal(
    type = "binary",
    aes = "fill"
  ) +
  theme(
    legend.position = "none"
  )
```

<img src="11_color_palettes_files/figure-gfm/unnamed-chunk-10-1.png" width="75%" />

Here’s another example using the default diverging palette to draw a
world map that shows how countries’ democracy scores rate compared to
the global average.

First, we’ll pick a year to look at and then cross-walk and join the
data we want to show with the data we need to draw a world map (we’ll
use our handy `map_data()` function).

``` r
sm_data <- Data |>
  filter(
    year == 2000
  ) |>
  mutate(
    polity2 = scale(polity2)
  ) 
  
world_map <- map_data("world")
world_map_data <- left_join(
  world_map |> 
    mutate(
      region = countrycode(region, "country.name", "country.name")
    ), 
  sm_data |>
    mutate(
      region = countrycode(statenme, "country.name", "country.name")
    )
)
```

Then, we’ll add `ggpal()` to our code to make the map. We’ll use the
default diverging palette. In this example, notice how I use some
additional commands in `ggpal()` to change what’s shown in the legend:

``` r
ggplot(world_map_data) +
  aes(
    x = long,
    y = lat,
    group = group
  ) +
  geom_polygon(
    color = "black",
    size = 0.1,
    fill = "gray"
  ) +
  geom_polygon(
    aes(fill = polity2),
    color = "black",
    size = 0.1
  ) +
  ggpal(
    type = "diverging",
    aes = "fill",
    breaks = c(-1, 0, 1),
    labels = c("below\naverage", "average", "above\naverage")
  ) +
  coord_fixed() +
  theme_void() +
  labs(
    fill = "Quality of\nDemocracy\n"
  )
```

<img src="11_color_palettes_files/figure-gfm/unnamed-chunk-12-1.png" width="75%" />

## Make Your Own Palette

Now it’s your turn to make your own palette. As you do, make sure you
think clearly about your goals and choose a palette accordingly.

Pick out four:

1.  **Qualitative**: Used for categorical data (like regions).
2.  **Sequential**: Used for ordered categories or numerical variables.
3.  **Diverging**: Used for ordered categories or numerical variables
    where there is a mid-point.
4.  **Binary**: Used in cases where you have only two categories to
    compare.

Go to [coolors.co](https://coolors.co) and pick out four palettes that
you like:

- A 7+ color qualitative palette
- A sequential palette — select two colors for the upper and lower
  bounds of the color scheme
- A diverging palette — select three colors, each for the upper, middle,
  and lower bounds respectively
- A binary palette — select two colors

Once you’ve done that you can set them like so. Here are my own picks:

``` r
set_palette(
  qualitative = "https://coolors.co/palette/4d86a5-cf0bf1-12e2f1-3e517a-98da1f-fc9f5b-d60b2d-c3c4e9-9cc76d-2dffdf",
  sequential = "https://coolors.co/palette/e7ecef-274c77",
  diverging = "https://coolors.co/011638-f5f5f5-c20114",
  binary = "https://coolors.co/022864-f40119"
)
```

Then, try out some examples from above or make some new figures and test
out your choices.

## Where to next?

<center>

[\<– Layer Complexity and Adding Labels and
Text](https://github.com/milesdwilliams15/Teaching/blob/main/DPR%20101/Notes/10_modifying_data_labels_and_notes_pt2.md)
\| [Back to Notes
Homepage](https://github.com/milesdwilliams15/Teaching/blob/main/DPR%20101/Notes/README.md)
\| [Refining Your Plots
–\>](https://github.com/milesdwilliams15/Teaching/blob/main/DPR%20101/Notes/12_refining_plots.md)

</center>
