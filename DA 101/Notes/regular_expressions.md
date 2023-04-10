Regular Expressions
================

## Examples

You’ll need to install the `{babynames}` package.

``` r
library(tidyverse)
```

    ## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.2 ──
    ## ✔ ggplot2 3.4.0     ✔ purrr   0.3.4
    ## ✔ tibble  3.1.8     ✔ dplyr   1.0.9
    ## ✔ tidyr   1.2.0     ✔ stringr 1.4.0
    ## ✔ readr   2.1.2     ✔ forcats 0.5.1

    ## Warning: package 'ggplot2' was built under R version 4.2.2

    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

``` r
library(babynames)
```

    ## Warning: package 'babynames' was built under R version 4.2.3

``` r
head(babynames)
```

    ## # A tibble: 6 × 5
    ##    year sex   name          n   prop
    ##   <dbl> <chr> <chr>     <int>  <dbl>
    ## 1  1880 F     Mary       7065 0.0724
    ## 2  1880 F     Anna       2604 0.0267
    ## 3  1880 F     Emma       2003 0.0205
    ## 4  1880 F     Elizabeth  1939 0.0199
    ## 5  1880 F     Minnie     1746 0.0179
    ## 6  1880 F     Margaret   1578 0.0162

`babynames` is a dataset from the Social Security Administration in the
US, and it documents all the names given to people registering for new
social security numbers (so mostly babies) in a given year, from 1880 to
2015. To make it a little easier to work with (\>1M rows), let’s use a
summary version of this data:

``` r
NameList <- babynames %>%
    group_by(name, sex) %>%
    summarize(total=sum(n)) %>%
  arrange(desc(total))
```

    ## `summarise()` has grouped output by 'name'. You can override using the
    ## `.groups` argument.

In the past, we’ve used `filter(column=="string")` to find the values
that we want to keep, but this gets more complicated if we want things
that match only part of the string. For example, all names that have an
“A” in them, or all names with “m” as the second letter.

Recall, if we use grepl alone, it will look at the strings that we give
it, in this case, a column containing character strings, and assign each
index \[1\] TRUE or FALSE logical values:

    grepl("Margaret", babynames$name)

So to return the values that we want, we can use it together with
filter().

Say the name contains “shine”, as in “sunshine”, or “moonshine” or
“Shinelle”.

``` r
NameList %>%
    filter(grepl("shine", name, ignore.case = TRUE))
```

    ## # A tibble: 16 × 3
    ## # Groups:   name [14]
    ##    name     sex   total
    ##    <chr>    <chr> <int>
    ##  1 Sunshine F      5173
    ##  2 Shineka  F       150
    ##  3 Shine    F       135
    ##  4 Shine    M        86
    ##  5 Sunshine M        37
    ##  6 Shinequa F        27
    ##  7 Shinead  F        19
    ##  8 Shinea   F        17
    ##  9 Shinell  F        17
    ## 10 Shinelle F        12
    ## 11 Rashine  M        11
    ## 12 Shinese  F         9
    ## 13 Shinece  F         7
    ## 14 Shinetta F         6
    ## 15 Shinee   F         5
    ## 16 Shinesha F         5

Why do you think ignore.case=TRUE might be an important argument here?

Say the name contains 3 or more vowels in a row.

``` r
NameList %>%
    filter(grepl("[aeiou]{3,}", name, ignore.case = TRUE))
```

    ## # A tibble: 2,044 × 3
    ## # Groups:   name [1,966]
    ##    name     sex    total
    ##    <chr>    <chr>  <int>
    ##  1 Louis    M     394969
    ##  2 Louise   F     332672
    ##  3 Isaiah   M     207627
    ##  4 Beau     M      34932
    ##  5 Louie    M      27966
    ##  6 Louisa   F      18828
    ##  7 Precious F      18757
    ##  8 Queen    F      14579
    ##  9 Leeann   F      14011
    ## 10 Ezequiel M      13477
    ## # … with 2,034 more rows
    ## # ℹ Use `print(n = ...)` to see more rows

Some names have multiple different spellings: Sara vs Sarah

``` r
NameList %>%
    filter(grepl("^[s][a][r][a]", name, ignore.case = TRUE))
```

    ## # A tibble: 88 × 3
    ## # Groups:   name [82]
    ##    name     sex     total
    ##    <chr>    <chr>   <int>
    ##  1 Sarah    F     1073895
    ##  2 Sara     F      422998
    ##  3 Sarai    F       17166
    ##  4 Sarahi   F        6159
    ##  5 Sarah    M        3320
    ##  6 Saray    F        2007
    ##  7 Sara     M        1237
    ##  8 Saralyn  F        1235
    ##  9 Sarabeth F        1220
    ## 10 Saraya   F        1189
    ## # … with 78 more rows
    ## # ℹ Use `print(n = ...)` to see more rows

Or

``` r
NameList %>%
    filter(grepl('^sara', name, ignore.case = TRUE))
```

    ## # A tibble: 88 × 3
    ## # Groups:   name [82]
    ##    name     sex     total
    ##    <chr>    <chr>   <int>
    ##  1 Sarah    F     1073895
    ##  2 Sara     F      422998
    ##  3 Sarai    F       17166
    ##  4 Sarahi   F        6159
    ##  5 Sarah    M        3320
    ##  6 Saray    F        2007
    ##  7 Sara     M        1237
    ##  8 Saralyn  F        1235
    ##  9 Sarabeth F        1220
    ## 10 Saraya   F        1189
    ## # … with 78 more rows
    ## # ℹ Use `print(n = ...)` to see more rows

Or

``` r
NameList %>%
    filter(grepl('^sara.$', name, ignore.case = TRUE))
```

    ## # A tibble: 11 × 3
    ## # Groups:   name [8]
    ##    name  sex     total
    ##    <chr> <chr>   <int>
    ##  1 Sarah F     1073895
    ##  2 Sarai F       17166
    ##  3 Sarah M        3320
    ##  4 Saray F        2007
    ##  5 Saran F         572
    ##  6 Sarae F         373
    ##  7 Saran M          25
    ##  8 Saral M           7
    ##  9 Saraa F           6
    ## 10 Sarai M           6
    ## 11 Saras M           5

Or

``` r
NameList %>%
    filter(grepl('^sar[ah]$', name, ignore.case = TRUE))
```

    ## # A tibble: 3 × 3
    ## # Groups:   name [2]
    ##   name  sex    total
    ##   <chr> <chr>  <int>
    ## 1 Sara  F     422998
    ## 2 Sara  M       1237
    ## 3 Sarh  F         52

Or

``` r
NameList %>%
    filter(grepl('^sar[ah]{1,2}$', name, ignore.case = TRUE))
```

    ## # A tibble: 7 × 3
    ## # Groups:   name [5]
    ##   name  sex     total
    ##   <chr> <chr>   <int>
    ## 1 Sarah F     1073895
    ## 2 Sara  F      422998
    ## 3 Sarah M        3320
    ## 4 Sara  M        1237
    ## 5 Sarha F         438
    ## 6 Sarh  F          52
    ## 7 Saraa F           6

Or

``` r
NameList %>%
    filter(grepl('^sar(ah|a)$', name, ignore.case = TRUE))
```

    ## # A tibble: 4 × 3
    ## # Groups:   name [2]
    ##   name  sex     total
    ##   <chr> <chr>   <int>
    ## 1 Sarah F     1073895
    ## 2 Sara  F      422998
    ## 3 Sarah M        3320
    ## 4 Sara  M        1237

**Challenge: you try…!**

-   The name contains 3 or more consonants in a row.
-   The name contains “mn”.
-   The first, third, and fifth letters are consonants.

``` r
NameList %>%
    filter(grepl("[^aeiou]{3,}", name, ignore.case = TRUE))
```

    ## # A tibble: 17,881 × 3
    ## # Groups:   name [16,219]
    ##    name        sex     total
    ##    <chr>       <chr>   <int>
    ##  1 Christopher M     2022164
    ##  2 Matthew     M     1590440
    ##  3 Anthony     M     1432718
    ##  4 Andrew      M     1283910
    ##  5 Dorothy     F     1107096
    ##  6 Timothy     M     1068556
    ##  7 Nancy       F     1002010
    ##  8 Betty       F      999474
    ##  9 Jeffrey     M      973741
    ## 10 Sandra      F      873512
    ## # … with 17,871 more rows
    ## # ℹ Use `print(n = ...)` to see more rows

``` r
NameList %>%
    filter(grepl("mn", name, ignore.case = TRUE))
```

    ## # A tibble: 53 × 3
    ## # Groups:   name [45]
    ##    name    sex    total
    ##    <chr>   <chr>  <int>
    ##  1 Autumn  F     120271
    ##  2 Sumner  M       2338
    ##  3 Amna    F       1328
    ##  4 Domnick M        422
    ##  5 Tatumn  F        306
    ##  6 Yumna   F        291
    ##  7 Autumn  M        277
    ##  8 Romney  M        257
    ##  9 Autymn  F        245
    ## 10 Omni    F        218
    ## # … with 43 more rows
    ## # ℹ Use `print(n = ...)` to see more rows

``` r
NameList %>%
    filter(grepl("^[aeiou].[^aeiou].[^aeiou]", name, ignore.case = TRUE))
```

    ## # A tibble: 5,893 × 3
    ## # Groups:   name [5,404]
    ##    name    sex     total
    ##    <chr>   <chr>   <int>
    ##  1 Edward  M     1288725
    ##  2 Angela  F      663696
    ##  3 Aaron   M      575297
    ##  4 Albert  M      487565
    ##  5 Ethan   M      413193
    ##  6 Eugene  M      378539
    ##  7 Amber   F      369899
    ##  8 Alyssa  F      304582
    ##  9 Ernest  M      300826
    ## 10 Allison F      295039
    ## # … with 5,883 more rows
    ## # ℹ Use `print(n = ...)` to see more rows

How often do boys versus girls names end in vowels?

``` r
NameList %>%
    filter(grepl("[aeiou]$", name, ignore.case = TRUE)) %>%
    group_by(sex) %>%
    summarise(total=sum(total))
```

    ## # A tibble: 2 × 2
    ##   sex       total
    ##   <chr>     <int>
    ## 1 F     100908073
    ## 2 M      22251941

## Uing stringr

The `{stringr}` package can be a great help, if you need to manipulate,
filter, or clean messy data.

For example, take this text…

``` r
Text <- "I am  terrible  at  getting my spacing correct       on my sentences   .      I really   need some    help."
```

Try this:

``` r
text <- str_replace_all(Text, "\\s+", " ")
text
```

    ## [1] "I am terrible at getting my spacing correct on my sentences . I really need some help."

So much better! Something like this could be a handy way to get rid of,
or control extra spaces that appear within text or in columns of data,
that can cause inconsistencies in how the data is read.

Or imagine that you had some data that included special characters:

``` r
GDP <- c("$18.036 Trillion", "$16.832 Trillion", "$11.158 trillion")
```

But if we want to do math/conversions on this, we can’t have all the
other info in there with the numbers. How would we get rid of it?

Either of will leave us with just the numbers:

``` r
str_extract_all(GDP, "\\d+")
```

    ## [[1]]
    ## [1] "18"  "036"
    ## 
    ## [[2]]
    ## [1] "16"  "832"
    ## 
    ## [[3]]
    ## [1] "11"  "158"

``` r
str_extract_all(GDP, "[:digit:]+")
```

    ## [[1]]
    ## [1] "18"  "036"
    ## 
    ## [[2]]
    ## [1] "16"  "832"
    ## 
    ## [[3]]
    ## [1] "11"  "158"

But the results aren’t so good.

Instead, clean up the vector to remove the $ and Trillion

``` r
gdp <- str_replace(GDP, "\\s(T|t)rillion", "")
gdp <- str_replace(gdp, "\\$", "")
gdp
```

    ## [1] "18.036" "16.832" "11.158"

or

``` r
str_replace_all(GDP, "\\$|%|\\s|(T|t)rillion|,", "")
```

    ## [1] "18.036" "16.832" "11.158"
