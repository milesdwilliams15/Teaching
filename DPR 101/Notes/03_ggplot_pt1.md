`ggplot()` Basics, Part I
================

- [Goals](#goals)
- [How ggplot works](#how-ggplot-works)
- [We first need “tidy” data](#we-first-need-tidy-data)
- [Breaking ggplot Down](#breaking-ggplot-down)
- [Adding layers](#adding-layers)
- [Wrapping up](#wrapping-up)
- [Try it out yourself](#try-it-out-yourself)
- [Where to next?](#where-to-next)

<center>

[\<– Getting Started, Part
II](https://github.com/milesdwilliams15/Teaching/blob/main/DPR%20101/Notes/02_getting_started_cont.md)
\| [Back to Notes
Homepage](https://github.com/milesdwilliams15/Teaching/blob/main/DPR%20101/Notes/README.md)
\| [`ggplot()` Basics, Part II
–\>](https://github.com/milesdwilliams15/Teaching/blob/main/DPR%20101/Notes/04_ggplot_pt2.md)

</center>

## Goals

- Understand the ggplot workflow.
- Know how to distinguish tidy data from untidy data, and why tidy data
  are important for doing data viz with ggplot.
- Understand mapping.
- Understand adding layers.

## How ggplot works

At its core, the ggplot workflow consists of a simple three-step
process:

1.  Feed data to the `ggplot()` function.
2.  Tell `ggplot()` what variables you want show relationships for using
    the `aes()` function.
3.  Tell `ggplot()` about the geometry (shapes, colors, points, etc.)
    that you want it to use to show the relationship(s) you’re
    interested in using a `geom_*()` function.

As you move from one step to the next, you’ll use the `+` symbol to
connect your instructions.

In practice, this might look something like the code shown below. It
starts by feeding a data object called `Data` to the `ggplot()`
function. After the `+` operator, it then uses the `aes()` function to
give ggplot instructions about which variables to show. In this case,
`aes(x = var1, y = var2)` specifies that I want values of `var1` to be
shown along the x-axis of the figure and values of `var2` to be shown
along the y-axis. Finally, after another call to the `+` operator the
`geom_point()` function is used. This function tells ggplot that I want
to show the relationship between `var1` and `var2` using points (e.g, I
want a scatter plot). The output is shown below the code.

``` r
ggplot(Data) +
  aes(x = var1, y = var2) +
  geom_point()
```

<img src="03_ggplot_pt1_files/figure-gfm/unnamed-chunk-2-1.png" width="70%" />

The output is quite spartan, but you can see right off the bat that
ggplot does quite a lot for you. As we’ll learn as we progress through
this course, ggplot can do so much more. There’s a reason why it’s the
state-of-the-art for data visualization. Right now, we’re crawling.
Soon, we’ll be sprinting.

## We first need “tidy” data

Using ggplot itself is quite simple, but before we can use it, we need
some data. If we’re lucky, our data will already be fully processed and
ready to go. If we’re not lucky (and usually we’re not), some basic data
management skills will be necessary. Thankfully, the `{tidyverse}`
family of packages provide some helpful tools for **wrangling** data.
Data wrangling just refers to the process of cleaning and reshaping data
to make it ready for visualization or analysis.

For most data viz or analysis purposes (no matter what tools or software
you use), the goal is usually to have **tidy data**. “Tidy” in this
context does not just mean “clean.” Tidy data refers to a specific set
of characteristics about a dataset—its shape and its contents.

Tidy data have three key characteristics:

1.  Each **row** is an **observation**.
2.  Each **column** is a **variable**.
3.  Each **cell** is a **single value**.

Tidy data are always **rectangular** in shape. Specifically, they are
**long-format** data as opposed to **wide-format**.

Here’s an example of data in wide-format. Can you tell why it’s wide?
(Hint: look at how many observations we have per country in a single
row.)

<table>
<caption>
Wide Data
</caption>
<thead>
<tr>
<th style="text-align:left;">
country
</th>
<th style="text-align:right;">
1952
</th>
<th style="text-align:right;">
1957
</th>
<th style="text-align:right;">
1962
</th>
<th style="text-align:right;">
1967
</th>
<th style="text-align:right;">
1972
</th>
<th style="text-align:right;">
1977
</th>
<th style="text-align:right;">
1982
</th>
<th style="text-align:right;">
1987
</th>
<th style="text-align:right;">
1992
</th>
<th style="text-align:right;">
1997
</th>
<th style="text-align:right;">
2002
</th>
<th style="text-align:right;">
2007
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
Afghanistan
</td>
<td style="text-align:right;">
29
</td>
<td style="text-align:right;">
30
</td>
<td style="text-align:right;">
32
</td>
<td style="text-align:right;">
34
</td>
<td style="text-align:right;">
36
</td>
<td style="text-align:right;">
38
</td>
<td style="text-align:right;">
40
</td>
<td style="text-align:right;">
41
</td>
<td style="text-align:right;">
42
</td>
<td style="text-align:right;">
42
</td>
<td style="text-align:right;">
42
</td>
<td style="text-align:right;">
44
</td>
</tr>
<tr>
<td style="text-align:left;">
Albania
</td>
<td style="text-align:right;">
55
</td>
<td style="text-align:right;">
59
</td>
<td style="text-align:right;">
65
</td>
<td style="text-align:right;">
66
</td>
<td style="text-align:right;">
68
</td>
<td style="text-align:right;">
69
</td>
<td style="text-align:right;">
70
</td>
<td style="text-align:right;">
72
</td>
<td style="text-align:right;">
72
</td>
<td style="text-align:right;">
73
</td>
<td style="text-align:right;">
76
</td>
<td style="text-align:right;">
76
</td>
</tr>
<tr>
<td style="text-align:left;">
Algeria
</td>
<td style="text-align:right;">
43
</td>
<td style="text-align:right;">
46
</td>
<td style="text-align:right;">
48
</td>
<td style="text-align:right;">
51
</td>
<td style="text-align:right;">
55
</td>
<td style="text-align:right;">
58
</td>
<td style="text-align:right;">
61
</td>
<td style="text-align:right;">
66
</td>
<td style="text-align:right;">
68
</td>
<td style="text-align:right;">
69
</td>
<td style="text-align:right;">
71
</td>
<td style="text-align:right;">
72
</td>
</tr>
<tr>
<td style="text-align:left;">
Angola
</td>
<td style="text-align:right;">
30
</td>
<td style="text-align:right;">
32
</td>
<td style="text-align:right;">
34
</td>
<td style="text-align:right;">
36
</td>
<td style="text-align:right;">
38
</td>
<td style="text-align:right;">
39
</td>
<td style="text-align:right;">
40
</td>
<td style="text-align:right;">
40
</td>
<td style="text-align:right;">
41
</td>
<td style="text-align:right;">
41
</td>
<td style="text-align:right;">
41
</td>
<td style="text-align:right;">
43
</td>
</tr>
<tr>
<td style="text-align:left;">
Argentina
</td>
<td style="text-align:right;">
62
</td>
<td style="text-align:right;">
64
</td>
<td style="text-align:right;">
65
</td>
<td style="text-align:right;">
66
</td>
<td style="text-align:right;">
67
</td>
<td style="text-align:right;">
68
</td>
<td style="text-align:right;">
70
</td>
<td style="text-align:right;">
71
</td>
<td style="text-align:right;">
72
</td>
<td style="text-align:right;">
73
</td>
<td style="text-align:right;">
74
</td>
<td style="text-align:right;">
75
</td>
</tr>
</tbody>
</table>

This format is really inefficient for making a data viz with ggplot.
Alternatively, long-format, or tidy data is much better. Here’s that
same data, but tidy:

<table>
<caption>
Long Data
</caption>
<thead>
<tr>
<th style="text-align:left;">
country
</th>
<th style="text-align:right;">
year
</th>
<th style="text-align:right;">
lifeExp
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
Afghanistan
</td>
<td style="text-align:right;">
1952
</td>
<td style="text-align:right;">
29
</td>
</tr>
<tr>
<td style="text-align:left;">
Afghanistan
</td>
<td style="text-align:right;">
1957
</td>
<td style="text-align:right;">
30
</td>
</tr>
<tr>
<td style="text-align:left;">
Afghanistan
</td>
<td style="text-align:right;">
1962
</td>
<td style="text-align:right;">
32
</td>
</tr>
<tr>
<td style="text-align:left;">
Afghanistan
</td>
<td style="text-align:right;">
1967
</td>
<td style="text-align:right;">
34
</td>
</tr>
<tr>
<td style="text-align:left;">
Afghanistan
</td>
<td style="text-align:right;">
1972
</td>
<td style="text-align:right;">
36
</td>
</tr>
</tbody>
</table>

Do you see the difference? Now, each row is a single observation (a
country in a single year). For each observation, we have three
variables, each with its own column, and each cell in each column has
just one value.

## Breaking ggplot Down

Once we have some tidy data, we then can start thinking about data
visualization. As already summarized, there are three basic steps we
need to follow. Let’s take a closer look at each of these steps to get a
better sense for the logic behind the ggplot workflow.

When we use ggplot, we first feed the core `ggplot()` function some
data. This is how we tell ggplot what our data is.

However, just giving ggplot our data isn’t enough. Look at what happens
when we run `ggplot()` on its own with just the `gapminder` data:

``` r
ggplot(gapminder)
```

<img src="03_ggplot_pt1_files/figure-gfm/unnamed-chunk-5-1.png" width="70%" />

Ggplot gave us a lot of nothing! Instead, we just have a blank canvas.
Think of the ggplot workflow as a process of **adding layers** of
complexity upon a very simple foundation. This is the secret sauce that
makes ggplot so flexible. Rather than build a super complex plot all at
once, you can take it one step at a time, letting you critique and
revise your work as you fashion a beautiful data visualization. You’re
more like a painter or sculptor than a scientist.

Once we have our blank canvas, the next step is to select the data we
want to show. We do this with the `aes()` function.

``` r
ggplot(gapminder) +
  aes(x = year, y = lifeExp)
```

<img src="03_ggplot_pt1_files/figure-gfm/unnamed-chunk-6-1.png" width="70%" />

The `aes()` function accepts a lot of different commands. In the above,
I told it `x = year` to say I want the year column in the data to appear
along the x-axis, and I told it `y = lifeExp` to tell it I want life
expectancy to appear along the y-axis. I could also tell it to give some
things different colors based on categories of the data (e.g.,
`color = continent`).

You can use `aes()` after you use the core `ggplot()` function using
`+`, or you can add it directly inside of `ggplot()` like so:

    ggplot(gapminder, mapping = aes(x = year, y = lifeExp))

Using it this way makes it more explicit that `aes()` is part of the
mapping process with ggplot. You can use this way if your prefer, or my
way. All roads lead to Rome.

Our next step is to add some geometry to our canvas. To do this, we use
“geoms” (short for geometry). There are a number of geom functions, like
`geom_point()`, `geom_col()`, `geom_boxplot()`, and so on. Some geoms
will make more sense than others depending on your data, and it’s up to
you to make good judgments about which to use. Each provides a specific
set of default instructions for how to connect aesthetics to different
shapes, colors, and sizes in the data viz.

In the case of looking at life expectancy over time, `geom_point()`
would be a sensible option.

``` r
ggplot(gapminder) + 
  aes(x = year, y = lifeExp) +
  geom_point()
```

<img src="03_ggplot_pt1_files/figure-gfm/unnamed-chunk-7-1.png" width="70%" />

What do you think this would look like if you tried `geom_smooth()`,
`geom_line()`, or `geom_boxplot()`?

## Adding layers

A nice thing about working with ggplot is that we can add to it *ad
infinitum*, layer upon layer. You aren’t restricted to only one geom.
Let’s try a combo using `geom_point()` and `geom_smooth()`:

``` r
ggplot(gapminder) +
  aes(x = year, y = lifeExp) +
  geom_point() +
  geom_smooth()
```

<img src="03_ggplot_pt1_files/figure-gfm/unnamed-chunk-8-1.png" width="70%" />

`geom_smooth()` adds a smoothed regression line to our plot. If you
don’t have a background in statistics, just think of the smooth line as
a summary of the mean of the variable on the y-axis depending on the
value of the variable on the x-axis. In the above figure, we can see
that average life expectancy has been increasing over time. By default,
it provides 95% confidence intervals (CIs) around the mean. Think of
these as a summary of how precisely the mean of the y-variable is
estimated. Wider 95% CIs mean there’s more “noise” than “signal” in the
data. Narrower 95% CIs mean there’s more “signal” than “noise.”

An interesting trick about working with geom layers is that we can
specify aesthetics directly inside them. In fact, ggplot is super
flexible about where you give it information about your data, too. Each
of the below ways of writing the code will give you an identical figure
to the one produced above. Try them out to see for yourself.

    ggplot(gapminder, aes(x = year, y = lifeExp)) +
      geom_point() +
      geom_smooth()

    ggplot(gapminder) +
      geom_point(aes(x = year, y = lifeExp)) +
      geom_smooth(aes(x = year, y = lifeExp))

    ggplot() +
      geom_point(
        data = gapminder,
        aes(x = year, y = lifeExp)
      ) +
      geom_smooth(
        data = gapminder,
        aes(x = year, y = lifeExp)
      )

At this point, any of the above approaches makes no difference for your
output. However, as we start to consider conditioning our geometry on
different groups in the data, we’ll need to be a little more specific
about where we specify variables using `aes()`. That’s a lesson for
another day.

## Wrapping up

Ggplot follows a simple logic. Using this logic, you can produce a near
infinite variety of visualizations. We haven’t even covered the myriad
ways you can customize the theme and overall look of your data
viz. Before we get there, however, we first need to talk a little bit
more about mapping aesthetics, which we’ll save for next time.

## Try it out yourself

Explore the `gss_lon` data from the `{socviz}` package. Use ggplot to
check out the relationships of different variables and try to find the
best geom for showing the relationship. [Here’s a
link](http://r-statistics.co/Top50-Ggplot2-Visualizations-MasterList-R-Code.html)
that provides 50 different examples of data visualizations along with
ggplot code for making them.

To access the data just write:

    library(socviz)

The data frame is called `gss_lon`. To see details about the data, just
write the following in the R console.

    ?gss_lon

## Where to next?

<center>

[\<– Getting Started, Part
II](https://github.com/milesdwilliams15/Teaching/blob/main/DPR%20101/Notes/02_getting_started_cont.md)
\| [Back to Notes
Homepage](https://github.com/milesdwilliams15/Teaching/blob/main/DPR%20101/Notes/README.md)
\| [`ggplot()` Basics, Part II
–\>](https://github.com/milesdwilliams15/Teaching/blob/main/DPR%20101/Notes/04_ggplot_pt2.md)

</center>
