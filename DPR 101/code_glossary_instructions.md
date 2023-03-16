Code Glossary Prompt
================

-   <a href="#instructions" id="toc-instructions">Instructions</a>
-   <a href="#getting-started" id="toc-getting-started">Getting Started</a>
-   <a href="#making-a-plot" id="toc-making-a-plot">Making a Plot</a>
-   <a href="#show-the-right-numbers" id="toc-show-the-right-numbers">Show
    the Right Numbers</a>
-   <a href="#draw-maps" id="toc-draw-maps">Draw Maps</a>
-   <a href="#tables-labels-and-notes"
    id="toc-tables-labels-and-notes">Tables, Labels, and Notes</a>
    -   <a href="#preparing-data" id="toc-preparing-data">Preparing Data</a>
    -   <a href="#labels-and-notes" id="toc-labels-and-notes">Labels and
        Notes</a>
-   <a href="#refining-plots" id="toc-refining-plots">Refining Plots</a>
-   <a href="#dealing-with-survey-data"
    id="toc-dealing-with-survey-data">Dealing with Survey Data</a>

## Instructions

You will use the code glossary template for this assignment. The
completed code glossary will be worth 10% of your final grade and will
be due before the final week of class.

In each of the sections below, I’ve given you some prompts for
definitions/examples/explanations of concepts and functions you should
fill in.

For many examples, you’ll need to use some data. You are free to use any
data you like. There are many free and read-to-access datasets in R.
Check them out here:
<https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/00Index.html>

You can also feel free to use any data that we’ve used in the class.

Under each section header, there are some prompts alerting you to what
you need to add. You are allowed to work with study groups to complete
the code glossary, but **all work should be your own.** Definitions and
explanations should be in your own words. If I see that students have
used identical text, or have copied text from online, this will count as
an **academic integrity violation that I will have to report.** The
result will be an automatic failing grade. ***So don’t cheat!***

## Getting Started

This section is all about how to start a project in RStudio and use .Rmd
or RMarkdown files. Each subsection addresses the what, where, how, and
why of working in RStudio and .Rmd files. For each question:

-   **What**: Describe what the “thing” is. E.g., what is an R project?
-   **Where**: Where do you find the “thing?” E.g., where do you click
    to start a new project?
-   **How**: Walk through the steps to do the “thing.” E.g., how do you
    create an R project?
-   **Why**: Why would you want to do this? E.g., why would you want to
    create an R project?

Here’s the code. You can copy and paste stuff over to your template
file.

\### How to start a new project

What:

Where:

How:

Why:

\### How to use a .Rmd file

What:

Where:

How:

Why:

\### Save your work

What:

Where:

How:

Why:

\### How to install and attach packages

What:

Where:

How:

Why:

\### How to read in data

What:

Where:

How:

Why:

## Making a Plot

All plots should be produced using `{ggplot2}`. For each, you’ll add the
following:

-   **Definition**: Define the kind of plot.
-   **Code example**: Write some code that provides a sensible example
    of how to create the kind of plot.
-   **Explanation**: In your own words, explain what the plot is
    supposed to show and when it would be appropriate to use.

You can copy and paste the below over to your template to get started:

\### A Histogram

Definition:

Code example:

\`\`\`{r}

\`\`\`

Explanation:

\### A Box Plot

Definition:

Code example:

\`\`\`{r}

\`\`\`

Explanation:

\### A Scatter Plot

Definition:

Code example:

\`\`\`{r}

\`\`\`

Explanation:

\### A Line Plot

Definition:

Code example:

\`\`\`{r}

\`\`\`

Explanation:

\### A Column/Bar Plot

Definition:

Code example:

\`\`\`{r}

\`\`\`

Explanation:

## Show the Right Numbers

It’s very easy to accidentally show the wrong numbers in your graphs, or
to apply the wrong geom layer for your data. Knowing how to group your
data, use small multiples, and do the right thing with frequency plots
is essential.

\### Grouping

Definition:

Code example:

\`\`\`{r}

\`\`\`

Explanation:

\### Faceting

Definition:

Code example:

\`\`\`{r}

\`\`\`

Explanation:

\### Frequency Plots

Definition:

Code example:

\`\`\`{r}

\`\`\`

Explanation:

\### Histogram with Fill Mapping

Definition:

Code example:

\`\`\`{r}

\`\`\`

Explanation:

\### Density Plot with Fill Mapping

Definition:

Code example:

\`\`\`{r}

\`\`\`

Explanation:

## Draw Maps

When we draw maps, not only do we need to make sure we use the correct
geom in ggplot, but we also need to join the data we want to show with
the coordinates necessary to draw geographic boundaries. That usually
means that we need to *crosswalk* at least a couple of different
datasets with each other and then use a `*_join()` function.

In the below, you’ll first provide an example of how to join two
datasets together. Then you’ll show how to draw a map that shows the
spatial distribution of some variable.

\### Join datasets together

Functions: left_join(), right_join(), full_join(), inner_join()

Definition:

Example:

\`\`\`{r}

\`\`\`

Explanation:

\### Make a Map

Definition:

Example:

\`\`\`{r}

\`\`\`

Explanation:

## Tables, Labels, and Notes

### Preparing Data

Sometimes we need to get our data into a different format to plot it.
That’s where our tools from `{dplyr}` come in handy. In each subsection
below you’ll provide:

-   **Definition**: Define the function.
-   **Code example**: Write some code that provides a sensible example
    of how to use it.
-   **Explanation**: In your own words, explain what the function does
    and when you would want to use it.

You can copy and paste the below over to your template to get started:

\### select()

Definition:

Example:

\`\`\`{r}

\`\`\`

Explanation:

\### filter()

Definition:

Example:

\`\`\`{r}

\`\`\`

Explanation:

\### mutate()

Definition:

Example:

\`\`\`{r}

\`\`\`

Explanation:

\### summarize()

Definition:

Example:

\`\`\`{r}

\`\`\`

Explanation:

\### group_by() + mutate()

Definition:

Example:

\`\`\`{r}

\`\`\`

Explanation:

\### group_by() + summarize()

Definition:

Example:

\`\`\`{r}

\`\`\`

Explanation:

### Labels and Notes

Adding labels and notes to your data viz can go a long way in helping
your audience to identify patterns in data. We can add labels using a
variety of functions. Provide an example of each below:

\### {geomtextpath}

Definition: The {geomtextpath} package provides helpful tools for
plotting text along lines.

Example with geom_textline() and geom_labelline():

\`\`\`{r}

\`\`\`

Explanation:

Example with geom_textsmooth() and geom_labelsmooth():

\`\`\`{r}

\`\`\`

Explanation:

Example with geom_textvline() and geom_labelvline():

\`\`\`{r}

\`\`\`

Explanation:

\### geom_text()

Definition:

Example:

\`\`\`{r}

\`\`\`

Explanation:

\### geom_label()

Definition:

Example:

\`\`\`{r}

\`\`\`

Explanation:

\### annotate()

Definition:

Example:

\`\`\`{r}

\`\`\`

Explanation:

## Refining Plots

\### Modifying the Theme

Definition:

Example:

\`\`\`{r}

\`\`\`

Explanation:

\### Modify Plot Labels

Definition:

Example:

\`\`\`{r}

\`\`\`

Explanation:

## Dealing with Survey Data

Survey data requires some special tools to deal with. In particular, we
usually need a **code book** and we need to be prepared to spend some
time *recoding* variables for analysis.

\### Code Book

What:

Where:

How:

Why:

\### Recodes

Definition: We have several functions in R to help us recode variables
to make them ready for analysis. Recoding just means that we are
converting existing values of variables into different values. Often,
these new values are just more understandable and intuitive versions of
the previous values.

When we recode, we often will use the mutate() function in conjunction
with the following functions:

Example with ifelse():

\`\`\`{r}

\`\`\`

Explanation:

Example with socsci::frcode():

\`\`\`{r}

\`\`\`

Explanation:

\### Summarizing Survey Responses

The {socsci} package provides helpful functions for summarizing survey
data. These functions work seamlessly within the {dplyr} workflow.

Example with mean_ci():

\`\`\`{r}

\`\`\`

Explanation:

Example with mean_ci() + group_by():

\`\`\`{r}

\`\`\`

Explanation:

Example with ct():

\`\`\`{r}

\`\`\`

Explanation:

Example with ct() + group_by():

\`\`\`{r}

\`\`\`

Explanation:
