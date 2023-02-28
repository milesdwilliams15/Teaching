Modifying data with `{dplyr}`
================

-   [Learning Objectives](#learning-objectives)
-   [Using `{dplyr}` for data
    manipulation/wrangling](#using-dplyr-for-data-manipulationwrangling)
    -   [filter()](#filter)
    -   [arrange()](#arrange)
    -   [select()](#select)
    -   [mutate()](#mutate)
    -   [summarize() and group_by()](#summarize-and-group_by)
-   [From summarizing to plotting](#from-summarizing-to-plotting)

## Learning Objectives

-   Apply the main `{dplyr}` functions to manipulate a dataset
-   Layer complexity by chaining together multiple `{dplyr}` functions
    to solve a problem.

## Using `{dplyr}` for data manipulation/wrangling

The `{dplyr}` package is a powerful tool for letting us transform a
dataframe into what we need for analysis and data visualization. This
package is part of the `{tidyverse}` and is automatically opened when
you use `library(tidyverse)`.

There are 6 key `{dplyr}` functions that you need to know about:

-   `filter()`: Choose observations based on their values (==, !=, \>,
    \<, \>=, \<=)
-   `arrange()`: Reorder the rows (sort based on a variable)
-   `select()`: Choose variables (columns) based on their names
-   `mutate()`: Use existing variables to create new variables
-   `summarize()`: Collapse many variables into a single summary
-   `group_by()`: Specify the scope of the function that you want to
    perform (for example, calculate the average votes cast for a
    candidate by education level). ORDERING MATTERS!

We’ll start by opening the tidyverse as always:

``` r
library(tidyverse)
```

While the functions available with `{dplyr}` are functions, sometimes we
call them “verbs”, and they all take input in a similar structure.

`filter(data, colname == "value" & colname >= 1000)`

We can chain together multiple dplyr “layers”, like with ggplot, but we
use the `%>%` pipe instead of `+`.

1.  First, we start with the data frame
2.  Then, we add arguments that describe what to do with the data frame,
    using the column (variable) names. Note that we don’t need to put
    the column names in quotes, because we’ve already specified the data
    frame that they are contained in, R will be able to find them as a
    “known” object.
3.  The output is a new data frame

Do you recall using `filter()` for your last data challenge? What do we
need to add if we want to save the output so we can do things with it
later? Any time we filter data, if we want to save it we need to make
sure we assign the output a name so that it is a known object in R’s
memory.

    filtered_data <- data %>%
        filter(column_name == "some text")

To filter, we need to remember and know how to use the comparison
operators:

-   Greater than `>`
-   Less than `<`
-   Greater than or equal to `>=`
-   Less than or equal to `<=`
-   Equal to `==`
-   Not equal to `!=`
-   In `%in%`
-   Is NA? `is.na()`

Aside: Recall some common mathematical operators (should follow order of
operations).

-   addition `+`
-   subtraction `-`
-   multiplication `*`
-   division `/`
-   square `^2`

We also need to know the logical operators

-   and `&`
-   or `|`
-   not `!`

Let’s try using filter with some data from the `{peacesciencer}`
package.

You may need to install the package first:

    install.packages("peacesciencer")

Then you can open it:

``` r
library(peacesciencer)
```

This package has a lot of useful data for studying conflict, which is a
core subject of study in the political science field called
international relations or IR.

We can call the data we want and customize it using a variety of
functions (and we can do this all using the `%>%` operator from
`{dplyr}`!).

``` r
create_stateyears() %>%
  add_cow_majors() %>%
  add_cow_wars(type = "intra") %>%
  add_democracy() %>%
  add_sdp_gdp() -> Data
```

In the above, we made a dataset where the unit of observation is a
country-year and for each observation we have information about:

1.  Whether the country is classified as a “major power.”
2.  Whether the country experienced a intra-state war or civil war.
3.  Information about the quality of democracy.
4.  Information about economic wellbeing.

We can use the `dim()` function to check out the size of the data.

``` r
dim(Data)
```

    ## [1] 17121    21

With this data, we’ll walk through the different `{dplyr}` “verbs” for
manipulating data.

### filter()

Let’s just practice filter first, which we’ve already seen in action.
Let’s say we only want data for major powers.

``` r
Data %>%
  filter(cowmaj == 1)
```

    ## # A tibble: 2,365 × 21
    ##    ccode statenme       year cowmaj warnum warname wartype cowin…¹ cowin…² intnl
    ##    <dbl> <chr>         <dbl>  <dbl>  <dbl> <chr>   <chr>     <dbl>   <dbl> <dbl>
    ##  1     2 United State…  1898      1     NA <NA>    <NA>          0       0    NA
    ##  2     2 United State…  1899      1     NA <NA>    <NA>          0       0    NA
    ##  3     2 United State…  1900      1     NA <NA>    <NA>          0       0    NA
    ##  4     2 United State…  1901      1     NA <NA>    <NA>          0       0    NA
    ##  5     2 United State…  1902      1     NA <NA>    <NA>          0       0    NA
    ##  6     2 United State…  1903      1     NA <NA>    <NA>          0       0    NA
    ##  7     2 United State…  1904      1     NA <NA>    <NA>          0       0    NA
    ##  8     2 United State…  1905      1     NA <NA>    <NA>          0       0    NA
    ##  9     2 United State…  1906      1     NA <NA>    <NA>          0       0    NA
    ## 10     2 United State…  1907      1     NA <NA>    <NA>          0       0    NA
    ## # … with 2,355 more rows, 11 more variables: outcome <dbl>, sideadeaths <dbl>,
    ## #   sidebdeaths <dbl>, intrawarnums <chr>, v2x_polyarchy <dbl>, polity2 <dbl>,
    ## #   xm_qudsest <dbl>, wbgdp2011est <dbl>, wbpopest <dbl>, sdpest <dbl>,
    ## #   wbgdppc2011est <dbl>, and abbreviated variable names ¹​cowintraonset,
    ## #   ²​cowintraongoing
    ## # ℹ Use `print(n = ...)` to see more rows, and `colnames()` to see all variable names

OK but what if we want to filter on two variables, major powers that are
experiencing civil wars?

``` r
Data %>%
  filter(cowmaj == 1 & cowintraongoing == 1)
```

    ## # A tibble: 61 × 21
    ##    ccode statenme       year cowmaj warnum warname wartype cowin…¹ cowin…² intnl
    ##    <dbl> <chr>         <dbl>  <dbl>  <dbl> <chr>   <chr>     <dbl>   <dbl> <dbl>
    ##  1   220 France         1830      1    513 First … centra…       1       1     0
    ##  2   220 France         1848      1    552 Second… centra…       1       1     0
    ##  3   220 France         1871      1    596 Paris … centra…       1       1     0
    ##  4   300 Austria-Hung…  1848      1    554 Hungar… local …       1       1     1
    ##  5   300 Austria-Hung…  1849      1    554 Hungar… local …       0       1     1
    ##  6   365 Russia         1818      1    500 First … local …       1       1     0
    ##  7   365 Russia         1819      1    500 First … local …       0       1     0
    ##  8   365 Russia         1820      1    500 First … local …       0       1     0
    ##  9   365 Russia         1821      1    500 First … local …       0       1     0
    ## 10   365 Russia         1822      1    500 First … local …       0       1     0
    ## # … with 51 more rows, 11 more variables: outcome <dbl>, sideadeaths <dbl>,
    ## #   sidebdeaths <dbl>, intrawarnums <chr>, v2x_polyarchy <dbl>, polity2 <dbl>,
    ## #   xm_qudsest <dbl>, wbgdp2011est <dbl>, wbpopest <dbl>, sdpest <dbl>,
    ## #   wbgdppc2011est <dbl>, and abbreviated variable names ¹​cowintraonset,
    ## #   ²​cowintraongoing
    ## # ℹ Use `print(n = ...)` to see more rows, and `colnames()` to see all variable names

OK but what if we want to filter on two variables but make it either or?

``` r
Data %>%
  filter(cowmaj == 1 | cowintraongoing == 1)
```

    ## # A tibble: 3,235 × 21
    ##    ccode statenme       year cowmaj warnum warname wartype cowin…¹ cowin…² intnl
    ##    <dbl> <chr>         <dbl>  <dbl>  <dbl> <chr>   <chr>     <dbl>   <dbl> <dbl>
    ##  1     2 United State…  1861      0    572 U.S. C… local …       1       1     0
    ##  2     2 United State…  1862      0    572 U.S. C… local …       0       1     0
    ##  3     2 United State…  1863      0    572 U.S. C… local …       0       1     0
    ##  4     2 United State…  1864      0    572 U.S. C… local …       0       1     0
    ##  5     2 United State…  1865      0    572 U.S. C… local …       0       1     0
    ##  6     2 United State…  1898      1     NA <NA>    <NA>          0       0    NA
    ##  7     2 United State…  1899      1     NA <NA>    <NA>          0       0    NA
    ##  8     2 United State…  1900      1     NA <NA>    <NA>          0       0    NA
    ##  9     2 United State…  1901      1     NA <NA>    <NA>          0       0    NA
    ## 10     2 United State…  1902      1     NA <NA>    <NA>          0       0    NA
    ## # … with 3,225 more rows, 11 more variables: outcome <dbl>, sideadeaths <dbl>,
    ## #   sidebdeaths <dbl>, intrawarnums <chr>, v2x_polyarchy <dbl>, polity2 <dbl>,
    ## #   xm_qudsest <dbl>, wbgdp2011est <dbl>, wbpopest <dbl>, sdpest <dbl>,
    ## #   wbgdppc2011est <dbl>, and abbreviated variable names ¹​cowintraonset,
    ## #   ²​cowintraongoing
    ## # ℹ Use `print(n = ...)` to see more rows, and `colnames()` to see all variable names

What does this give us? Rows are either major powers or countries
experiencing civil war.

Note: `filter()` only includes rows where the condition is `TRUE`. So if
we want to keep in NA (missing) values, then we need to ask for them
explicitly, for example:

What would we do if we wanted only rows where values in a column were
blank (indicated by NA on the computer). Would this work?

    Data %>%
      filter(warnum == NA)

Nope! Since NA is a special value that indicates missing data, it cannot
be equal to anything, or not equal to anything. This means we can only
include or exclude NA using functions designed to do that. For example,
is.na() or na.rm=TRUE. The example below would work/

``` r
Data %>%
  filter(is.na(warnum))
```

    ## # A tibble: 16,190 × 21
    ##    ccode statenme       year cowmaj warnum warname wartype cowin…¹ cowin…² intnl
    ##    <dbl> <chr>         <dbl>  <dbl>  <dbl> <chr>   <chr>     <dbl>   <dbl> <dbl>
    ##  1     2 United State…  1816      0     NA <NA>    <NA>          0       0    NA
    ##  2     2 United State…  1817      0     NA <NA>    <NA>          0       0    NA
    ##  3     2 United State…  1818      0     NA <NA>    <NA>          0       0    NA
    ##  4     2 United State…  1819      0     NA <NA>    <NA>          0       0    NA
    ##  5     2 United State…  1820      0     NA <NA>    <NA>          0       0    NA
    ##  6     2 United State…  1821      0     NA <NA>    <NA>          0       0    NA
    ##  7     2 United State…  1822      0     NA <NA>    <NA>          0       0    NA
    ##  8     2 United State…  1823      0     NA <NA>    <NA>          0       0    NA
    ##  9     2 United State…  1824      0     NA <NA>    <NA>          0       0    NA
    ## 10     2 United State…  1825      0     NA <NA>    <NA>          0       0    NA
    ## # … with 16,180 more rows, 11 more variables: outcome <dbl>, sideadeaths <dbl>,
    ## #   sidebdeaths <dbl>, intrawarnums <chr>, v2x_polyarchy <dbl>, polity2 <dbl>,
    ## #   xm_qudsest <dbl>, wbgdp2011est <dbl>, wbpopest <dbl>, sdpest <dbl>,
    ## #   wbgdppc2011est <dbl>, and abbreviated variable names ¹​cowintraonset,
    ## #   ²​cowintraongoing
    ## # ℹ Use `print(n = ...)` to see more rows, and `colnames()` to see all variable names

### arrange()

We haven’t seen this yet, but it works similarly to `filter()`, except
instead of selecting rows, it changes their order - Kind of like using
“sort” in Excel, except you know that you won’t accidentally sort just
the one row and scramble all your data.

Let’s sort the dataset by year:

``` r
Data %>%
  arrange(year)
```

    ## # A tibble: 17,121 × 21
    ##    ccode statenme       year cowmaj warnum warname wartype cowin…¹ cowin…² intnl
    ##    <dbl> <chr>         <dbl>  <dbl>  <dbl> <chr>   <chr>     <dbl>   <dbl> <dbl>
    ##  1     2 United State…  1816      0     NA <NA>    <NA>          0       0    NA
    ##  2   200 United Kingd…  1816      1     NA <NA>    <NA>          0       0    NA
    ##  3   210 Netherlands    1816      0     NA <NA>    <NA>          0       0    NA
    ##  4   220 France         1816      1     NA <NA>    <NA>          0       0    NA
    ##  5   225 Switzerland    1816      0     NA <NA>    <NA>          0       0    NA
    ##  6   230 Spain          1816      0     NA <NA>    <NA>          0       0    NA
    ##  7   235 Portugal       1816      0     NA <NA>    <NA>          0       0    NA
    ##  8   245 Bavaria        1816      0     NA <NA>    <NA>          0       0    NA
    ##  9   255 Germany        1816      1     NA <NA>    <NA>          0       0    NA
    ## 10   267 Baden          1816      0     NA <NA>    <NA>          0       0    NA
    ## # … with 17,111 more rows, 11 more variables: outcome <dbl>, sideadeaths <dbl>,
    ## #   sidebdeaths <dbl>, intrawarnums <chr>, v2x_polyarchy <dbl>, polity2 <dbl>,
    ## #   xm_qudsest <dbl>, wbgdp2011est <dbl>, wbpopest <dbl>, sdpest <dbl>,
    ## #   wbgdppc2011est <dbl>, and abbreviated variable names ¹​cowintraonset,
    ## #   ²​cowintraongoing
    ## # ℹ Use `print(n = ...)` to see more rows, and `colnames()` to see all variable names

OK, cool, but what if we want to see most recent years first? We can
specify the order, and change the default:

``` r
Data %>%
  arrange(desc(year))
```

    ## # A tibble: 17,121 × 21
    ##    ccode statenme       year cowmaj warnum warname wartype cowin…¹ cowin…² intnl
    ##    <dbl> <chr>         <dbl>  <dbl>  <dbl> <chr>   <chr>     <dbl>   <dbl> <dbl>
    ##  1     2 United State…  2022      1     NA <NA>    <NA>         NA      NA    NA
    ##  2    20 Canada         2022      1     NA <NA>    <NA>         NA      NA    NA
    ##  3    31 Bahamas        2022      1     NA <NA>    <NA>         NA      NA    NA
    ##  4    40 Cuba           2022      1     NA <NA>    <NA>         NA      NA    NA
    ##  5    41 Haiti          2022      1     NA <NA>    <NA>         NA      NA    NA
    ##  6    42 Dominican Re…  2022      1     NA <NA>    <NA>         NA      NA    NA
    ##  7    51 Jamaica        2022      1     NA <NA>    <NA>         NA      NA    NA
    ##  8    52 Trinidad and…  2022      1     NA <NA>    <NA>         NA      NA    NA
    ##  9    53 Barbados       2022      1     NA <NA>    <NA>         NA      NA    NA
    ## 10    54 Dominica       2022      1     NA <NA>    <NA>         NA      NA    NA
    ## # … with 17,111 more rows, 11 more variables: outcome <dbl>, sideadeaths <dbl>,
    ## #   sidebdeaths <dbl>, intrawarnums <chr>, v2x_polyarchy <dbl>, polity2 <dbl>,
    ## #   xm_qudsest <dbl>, wbgdp2011est <dbl>, wbpopest <dbl>, sdpest <dbl>,
    ## #   wbgdppc2011est <dbl>, and abbreviated variable names ¹​cowintraonset,
    ## #   ²​cowintraongoing
    ## # ℹ Use `print(n = ...)` to see more rows, and `colnames()` to see all variable names

But what if we really want to use the warname category? Do you think we
can sort on a factor or character? Let’s try! We can try anything in R…

``` r
Data %>%
  arrange(warname)
```

    ## # A tibble: 17,121 × 21
    ##    ccode statenme       year cowmaj warnum warname wartype cowin…¹ cowin…² intnl
    ##    <dbl> <chr>         <dbl>  <dbl>  <dbl> <chr>   <chr>     <dbl>   <dbl> <dbl>
    ##  1   372 Georgia        1993      0    882 Abkhaz… local …       1       1     0
    ##  2   372 Georgia        1994      0    882 Abkhaz… local …       0       1     0
    ##  3   490 Democratic R…  1998      0    905 Africa… centra…       0       1     1
    ##  4   490 Democratic R…  1999      0    905 Africa… centra…       0       1     1
    ##  5   490 Democratic R…  2000      0    905 Africa… centra…       0       1     1
    ##  6   490 Democratic R…  2001      0    905 Africa… centra…       0       1     1
    ##  7   490 Democratic R…  2002      0    905 Africa… centra…       0       1     1
    ##  8   355 Bulgaria       1923      0    693 Agrari… centra…       1       1     0
    ##  9   615 Algeria        1992      0    875 Algeri… centra…       1       1     0
    ## 10   615 Algeria        1993      0    875 Algeri… centra…       0       1     0
    ## # … with 17,111 more rows, 11 more variables: outcome <dbl>, sideadeaths <dbl>,
    ## #   sidebdeaths <dbl>, intrawarnums <chr>, v2x_polyarchy <dbl>, polity2 <dbl>,
    ## #   xm_qudsest <dbl>, wbgdp2011est <dbl>, wbpopest <dbl>, sdpest <dbl>,
    ## #   wbgdppc2011est <dbl>, and abbreviated variable names ¹​cowintraonset,
    ## #   ²​cowintraongoing
    ## # ℹ Use `print(n = ...)` to see more rows, and `colnames()` to see all variable names

Awesome. Where do you think the NAs went? How would we check? Hint: NAs
are always sorted to the end, whether you use ascending or descending
order.

### select()

Here’s another one. `select()` is another way to “slice” our dataframe.
Usually, we don’t need ALL the variables for a given data analysis, so
it is more efficient to just look at the ones that we need.

How many columns does the data have? Use `ncol()`

``` r
ncol(Data)
```

    ## [1] 21

Let’s just get the ones we want.

``` r
Data %>%
  select(statenme, year, cowintraongoing, sideadeaths, sidebdeaths)
```

    ## # A tibble: 17,121 × 5
    ##    statenme                  year cowintraongoing sideadeaths sidebdeaths
    ##    <chr>                    <dbl>           <dbl>       <dbl>       <dbl>
    ##  1 United States of America  1816               0          NA          NA
    ##  2 United States of America  1817               0          NA          NA
    ##  3 United States of America  1818               0          NA          NA
    ##  4 United States of America  1819               0          NA          NA
    ##  5 United States of America  1820               0          NA          NA
    ##  6 United States of America  1821               0          NA          NA
    ##  7 United States of America  1822               0          NA          NA
    ##  8 United States of America  1823               0          NA          NA
    ##  9 United States of America  1824               0          NA          NA
    ## 10 United States of America  1825               0          NA          NA
    ## # … with 17,111 more rows
    ## # ℹ Use `print(n = ...)` to see more rows

What if we wanted most of the columns, but just not surplus domestic
product? Do we have to name all the other columsn? Thankfully, no!

``` r
Data %>%
  select(-sdpest)
```

    ## # A tibble: 17,121 × 20
    ##    ccode statenme       year cowmaj warnum warname wartype cowin…¹ cowin…² intnl
    ##    <dbl> <chr>         <dbl>  <dbl>  <dbl> <chr>   <chr>     <dbl>   <dbl> <dbl>
    ##  1     2 United State…  1816      0     NA <NA>    <NA>          0       0    NA
    ##  2     2 United State…  1817      0     NA <NA>    <NA>          0       0    NA
    ##  3     2 United State…  1818      0     NA <NA>    <NA>          0       0    NA
    ##  4     2 United State…  1819      0     NA <NA>    <NA>          0       0    NA
    ##  5     2 United State…  1820      0     NA <NA>    <NA>          0       0    NA
    ##  6     2 United State…  1821      0     NA <NA>    <NA>          0       0    NA
    ##  7     2 United State…  1822      0     NA <NA>    <NA>          0       0    NA
    ##  8     2 United State…  1823      0     NA <NA>    <NA>          0       0    NA
    ##  9     2 United State…  1824      0     NA <NA>    <NA>          0       0    NA
    ## 10     2 United State…  1825      0     NA <NA>    <NA>          0       0    NA
    ## # … with 17,111 more rows, 10 more variables: outcome <dbl>, sideadeaths <dbl>,
    ## #   sidebdeaths <dbl>, intrawarnums <chr>, v2x_polyarchy <dbl>, polity2 <dbl>,
    ## #   xm_qudsest <dbl>, wbgdp2011est <dbl>, wbpopest <dbl>, wbgdppc2011est <dbl>,
    ## #   and abbreviated variable names ¹​cowintraonset, ²​cowintraongoing
    ## # ℹ Use `print(n = ...)` to see more rows, and `colnames()` to see all variable names

We can even use some “helper functions” inside of select() to get even
more specific. A few examples are:

-   `starts_with("")`
-   `end_with("")`
-   `contains("ijk")`

For example, we have a couple columns that contain “war”. We can only
select those by writing:

``` r
Data %>%
  select(contains("war"))
```

    ## # A tibble: 17,121 × 4
    ##    warnum warname wartype intrawarnums
    ##     <dbl> <chr>   <chr>   <chr>       
    ##  1     NA <NA>    <NA>    <NA>        
    ##  2     NA <NA>    <NA>    <NA>        
    ##  3     NA <NA>    <NA>    <NA>        
    ##  4     NA <NA>    <NA>    <NA>        
    ##  5     NA <NA>    <NA>    <NA>        
    ##  6     NA <NA>    <NA>    <NA>        
    ##  7     NA <NA>    <NA>    <NA>        
    ##  8     NA <NA>    <NA>    <NA>        
    ##  9     NA <NA>    <NA>    <NA>        
    ## 10     NA <NA>    <NA>    <NA>        
    ## # … with 17,111 more rows
    ## # ℹ Use `print(n = ...)` to see more rows

### mutate()

Sometimes we need to create new variables. This might be a function of
an existing column. We tried this, too, recently.

This is our fourth `{dplyr}` command - let’s start chaining some of
these together to see how they work! Here’s one that we did before, to
select just 5 columns:

    Data %>%
      select(statenme, year, cowintraongoing, sideadeaths, sidebdeaths)

To chain on another command, we use the pipe `%>%`, just like in ggplot
where we added layers to our graphic using `+`. Let’s make our own
calculation of total war deaths.

``` r
Data %>%
  select(statenme, year, cowintraongoing, 
         sideadeaths, sidebdeaths) %>%
  mutate(
    total_deaths = sideadeaths + sidebdeaths
  )
```

    ## # A tibble: 17,121 × 6
    ##    statenme                  year cowintraongoing sideadeaths sidebdea…¹ total…²
    ##    <chr>                    <dbl>           <dbl>       <dbl>      <dbl>   <dbl>
    ##  1 United States of America  1816               0          NA         NA      NA
    ##  2 United States of America  1817               0          NA         NA      NA
    ##  3 United States of America  1818               0          NA         NA      NA
    ##  4 United States of America  1819               0          NA         NA      NA
    ##  5 United States of America  1820               0          NA         NA      NA
    ##  6 United States of America  1821               0          NA         NA      NA
    ##  7 United States of America  1822               0          NA         NA      NA
    ##  8 United States of America  1823               0          NA         NA      NA
    ##  9 United States of America  1824               0          NA         NA      NA
    ## 10 United States of America  1825               0          NA         NA      NA
    ## # … with 17,111 more rows, and abbreviated variable names ¹​sidebdeaths,
    ## #   ²​total_deaths
    ## # ℹ Use `print(n = ...)` to see more rows

Here’s one showing how you can build on new columns you make in
`mutate()` within the same call to the function:

``` r
Data %>%
  select(statenme, year, cowintraongoing, 
         sideadeaths, sidebdeaths, wbpopest) %>%
  mutate(
    total_deaths = sideadeaths + sidebdeaths,
    deaths_pc = total_deaths / exp(wbpopest)
  )
```

    ## # A tibble: 17,121 × 8
    ##    statenme                 year cowin…¹ sidea…² sideb…³ wbpop…⁴ total…⁵ death…⁶
    ##    <chr>                   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
    ##  1 United States of Ameri…  1816       0      NA      NA    15.9      NA      NA
    ##  2 United States of Ameri…  1817       0      NA      NA    16.0      NA      NA
    ##  3 United States of Ameri…  1818       0      NA      NA    16.0      NA      NA
    ##  4 United States of Ameri…  1819       0      NA      NA    16.0      NA      NA
    ##  5 United States of Ameri…  1820       0      NA      NA    16.1      NA      NA
    ##  6 United States of Ameri…  1821       0      NA      NA    16.1      NA      NA
    ##  7 United States of Ameri…  1822       0      NA      NA    16.1      NA      NA
    ##  8 United States of Ameri…  1823       0      NA      NA    16.1      NA      NA
    ##  9 United States of Ameri…  1824       0      NA      NA    16.2      NA      NA
    ## 10 United States of Ameri…  1825       0      NA      NA    16.2      NA      NA
    ## # … with 17,111 more rows, and abbreviated variable names ¹​cowintraongoing,
    ## #   ²​sideadeaths, ³​sidebdeaths, ⁴​wbpopest, ⁵​total_deaths, ⁶​deaths_pc
    ## # ℹ Use `print(n = ...)` to see more rows

See above, we can even do this all at once, by referring to columns that
we have just created!

Or we can do it all in one equation, if we don’t need to save out a
column for height in meters.

``` r
Data %>%
  select(statenme, year, cowintraongoing, 
         sideadeaths, sidebdeaths, wbpopest) %>%
  mutate(
    deaths_pc = (sideadeaths + sidebdeaths) / exp(wbpopest)
  )
```

    ## # A tibble: 17,121 × 7
    ##    statenme                  year cowintraongo…¹ sidea…² sideb…³ wbpop…⁴ death…⁵
    ##    <chr>                    <dbl>          <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
    ##  1 United States of America  1816              0      NA      NA    15.9      NA
    ##  2 United States of America  1817              0      NA      NA    16.0      NA
    ##  3 United States of America  1818              0      NA      NA    16.0      NA
    ##  4 United States of America  1819              0      NA      NA    16.0      NA
    ##  5 United States of America  1820              0      NA      NA    16.1      NA
    ##  6 United States of America  1821              0      NA      NA    16.1      NA
    ##  7 United States of America  1822              0      NA      NA    16.1      NA
    ##  8 United States of America  1823              0      NA      NA    16.1      NA
    ##  9 United States of America  1824              0      NA      NA    16.2      NA
    ## 10 United States of America  1825              0      NA      NA    16.2      NA
    ## # … with 17,111 more rows, and abbreviated variable names ¹​cowintraongoing,
    ## #   ²​sideadeaths, ³​sidebdeaths, ⁴​wbpopest, ⁵​deaths_pc
    ## # ℹ Use `print(n = ...)` to see more rows

Note that as things are getting more complex, we just did one step at a
time, and then went back to edit what we just did, making sure each step
along the way worked before making it more complicated. This is a good
recipe for success, and to cut down on frustration!

You could use any mathematical operators, here, including `sum(x)`,
`y - mean(y)`, `log()`, `log2()`, `log10()`, `lead()`

### summarize() and group_by()

These can be used to collapse a dataframe to a single row, or a set of
rows (if we use group_by()). For example, here’s the mean number of
civil wars in the data:

``` r
Data %>%
  summarize(
    mean_wars = mean(cowintraongoing, na.rm=T)
  )
```

    ## # A tibble: 1 × 1
    ##   mean_wars
    ##       <dbl>
    ## 1    0.0656

And here’s that grouped by year:

``` r
Data %>%
  group_by(year) %>%
  summarize(
    mean_wars = mean(cowintraongoing, na.rm=T)
  )
```

    ## # A tibble: 207 × 2
    ##     year mean_wars
    ##    <dbl>     <dbl>
    ##  1  1816    0     
    ##  2  1817    0     
    ##  3  1818    0.0435
    ##  4  1819    0.0435
    ##  5  1820    0.0870
    ##  6  1821    0.217 
    ##  7  1822    0.125 
    ##  8  1823    0.0833
    ##  9  1824    0.0417
    ## 10  1825    0.04  
    ## # … with 197 more rows
    ## # ℹ Use `print(n = ...)` to see more rows

We could also filter this down so it’s not just the total mean per year.
Say we only want to look at major powers. And say we want to look at
yearly deaths per capita:

``` r
Data %>%
  filter(cowmaj==1) %>%
  mutate(
    deaths_pc = (sideadeaths + sidebdeaths) / exp(wbpopest)
  ) %>%
  group_by(year) %>%
  summarize(
    mean_deaths = mean(deaths_pc, na.rm=T)
  )
```

    ## # A tibble: 207 × 2
    ##     year mean_deaths
    ##    <dbl>       <dbl>
    ##  1  1816  NaN       
    ##  2  1817  NaN       
    ##  3  1818    0.000237
    ##  4  1819    0.000234
    ##  5  1820    0.000229
    ##  6  1821    0.000228
    ##  7  1822    0.000227
    ##  8  1823  NaN       
    ##  9  1824  NaN       
    ## 10  1825  NaN       
    ## # … with 197 more rows
    ## # ℹ Use `print(n = ...)` to see more rows

Finally, we also have data on democracy. What if we only look at those
that scored a 0.5 or higher on the polyarchy index?

``` r
Data %>%
  filter(cowmaj==1 & v2x_polyarchy > 0.5) %>%
  mutate(
    deaths_pc = (sideadeaths + sidebdeaths) / exp(wbpopest)
  ) %>%
  group_by(year) %>%
  summarize(
    mean_deaths = mean(deaths_pc, na.rm=T)
  )
```

    ## # A tibble: 144 × 2
    ##     year mean_deaths
    ##    <dbl>       <dbl>
    ##  1  1876         NaN
    ##  2  1877         NaN
    ##  3  1878         NaN
    ##  4  1879         NaN
    ##  5  1880         NaN
    ##  6  1881         NaN
    ##  7  1882         NaN
    ##  8  1883         NaN
    ##  9  1884         NaN
    ## 10  1885         NaN
    ## # … with 134 more rows
    ## # ℹ Use `print(n = ...)` to see more rows

Adding a column for count to go along with your summary can also be
helpful, because it can help you see how many things were averaged (or
whatever). You don’t want to draw conclusions from a very small number
of samples!

Note: We can also calculate median (midpoint of the data), which tells
us a little different information from mean (average)

``` r
Data %>%
  filter(cowmaj==1, v2x_polyarchy > 0.5) %>%
  mutate(
    pop = exp(wbpopest),
    gdp = exp(wbgdp2011est),
    gdp_pc = gdp / pop
  ) %>%
  group_by(year) %>%
  summarize(
    gdp_pc = mean(gdp_pc),
    N = n()
  )
```

    ## # A tibble: 144 × 3
    ##     year gdp_pc     N
    ##    <dbl>  <dbl> <int>
    ##  1  1876  3498.     1
    ##  2  1877  3523.     1
    ##  3  1878  3526.     1
    ##  4  1879  3519.     1
    ##  5  1880  3619.     1
    ##  6  1881  3722.     1
    ##  7  1882  3805.     1
    ##  8  1883  3801.     1
    ##  9  1884  3778.     1
    ## 10  1885  3767.     1
    ## # … with 134 more rows
    ## # ℹ Use `print(n = ...)` to see more rows

There a lot of different functions you can use:

-   `mean()`: average
-   `median()`: midpoint
-   `sd()`: standard deviation
-   `IQR()`: interquartile range
-   `mad()`: median absolute deviation
-   `min()`: minimum
-   `max()`: maximum
-   `quantile(x, 0.25)`: value in the data that is \> 25% of the values
    and \< 75% of the values
-   `n()`: count
-   `sum(!is.na(x))`: count all non-missing values (don’t count NAs)
-   `n_distinct()`: count all distinct (unique) values

## From summarizing to plotting

Sometimes it will make sense to do a combination of `summarize()` and
`group_by()` with your data before using `ggplot()` to plot
relationships.

``` r
Data %>%
  group_by(year) %>%
  summarize(
    conflict_rate = mean(cowintraonset)
  ) %>%
  ggplot() +
  aes(x = year, y = conflict_rate) +
  geom_col() +
  labs(
    x = NULL,
    y = "Rate of Initiation",
    title = "Conflict initiation over time, 1816-2007",
    caption = "Data: {peacesciencer}"
  )
```

<img src="09_modifying_data_lables_and_notes_pt1_files/figure-gfm/unnamed-chunk-24-1.png" width="75%" />
