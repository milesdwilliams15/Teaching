Functional Programming in R
================

-   [Goals](#goals)
-   [Defining a function](#defining-a-function)
-   [Composing functions in
    succession](#composing-functions-in-succession)
-   [Setting defaults](#setting-defaults)
-   [Documenting your work](#documenting-your-work)
-   [Challenge](#challenge)

## Goals

-   We can make functions in R
-   Making functions makes it easier to do repeated tasks or routines.
-   When we make functions, make sure you document what you’re doing and
    why. Your future self and other collaborators will thank you.

## Defining a function

The basic syntax for creating a function in R looks like this:

    fun_name <- function(x) {
      newx <- operation1(x)
      newx <- operation2(newx)
      newx # returned object
    }

-   You’ll assign your function a name
-   Specify inputs and other options for the function using `function()`
-   You’ll write the code that the function will apply given your inputs
-   You’ll specify what object or objects your function will return

Here’s an example of a function that “demeans” a numeric variable. To
demean means or mean center a variable means that we update a variable
so that it has a mean of zero.

``` r
demean <- function(x) {
  cx <- x - mean(x, na.rm=T)
  cx # return the results
}
```

Say we have the following numerical vector:

``` r
my_nums <- 1:10
```

We can demean it by using our `demean()` function:

``` r
demean(my_nums)
```

    ##  [1] -4.5 -3.5 -2.5 -1.5 -0.5  0.5  1.5  2.5  3.5  4.5

Notice that the output is now such that the mean of the variable is zero
and its min. and max. values have been adjusted accordingly.

``` r
dm_nums <- demean(my_nums)
mean(my_nums)
```

    ## [1] 5.5

``` r
mean(dm_nums)
```

    ## [1] 0

## Composing functions in succession

We can compose functions in succession. This is a nice strategy when we
want to create more complicated functions/routines.

For example, let’s create a function that converts a numeric vector into
z-scores:

``` r
zscore <- function(x) {
  zx <- demean(x) / sd(x, na.rm=T)
  zx # return the results
}
```

z-scores are values that have been re-scaled to have mean of zero and
variance of one. To create them, we simple demean a variable and then
divide it by its standard deviation. That’s just what the above function
does. But notice that to demean it uses the `demean()` function that we
already created.

See it in action:

``` r
cbind(
  x = my_nums,
  cx = demean(my_nums),
  zx = zscore(my_nums)
)
```

    ##        x   cx         zx
    ##  [1,]  1 -4.5 -1.4863011
    ##  [2,]  2 -3.5 -1.1560120
    ##  [3,]  3 -2.5 -0.8257228
    ##  [4,]  4 -1.5 -0.4954337
    ##  [5,]  5 -0.5 -0.1651446
    ##  [6,]  6  0.5  0.1651446
    ##  [7,]  7  1.5  0.4954337
    ##  [8,]  8  2.5  0.8257228
    ##  [9,]  9  3.5  1.1560120
    ## [10,] 10  4.5  1.4863011

To check that the `zscore()` function worked, we can write:

``` r
mean(zscore(my_nums)) # should = 0
```

    ## [1] 0

``` r
sd(zscore(my_nums))   # should = 1
```

    ## [1] 1

## Setting defaults

As we start to compose more complex functions, we can begin to think
about setting defaults.

Often when we want to re-scale a variable, we typically either want to
convert it to z-scores or to the unit interval (0-1). The function
`rescale()` created below will do either transformation, depending on
whether `zscore = TRUE`. Check it:

``` r
rescale <- function(x, zscore = TRUE) {
  if(zscore) {
    newx <- zscore(x)
  } else {
    newx <- (x - min(x, na.rm=T)) /
      (max(x, na.rm=T) - min(x, na.rm=T))
  }
  newx # return
}
```

The default option is `zscore = TRUE`, meaning that unless we specify
otherwise, the function will convert a numeric variable to z-scores. But
if we set it to `FALSE`, it’ll scale the variable to the unit interval:

``` r
rescale(my_nums)
```

    ##  [1] -1.4863011 -1.1560120 -0.8257228 -0.4954337 -0.1651446  0.1651446
    ##  [7]  0.4954337  0.8257228  1.1560120  1.4863011

``` r
rescale(my_nums, zscore = F)
```

    ##  [1] 0.0000000 0.1111111 0.2222222 0.3333333 0.4444444 0.5555556 0.6666667
    ##  [8] 0.7777778 0.8888889 1.0000000

## Documenting your work

As you compose new functions, remember that while your programs are
written in R, you want them to be legible to other humans. That’s why
you should always make sure that you document your new functions to tell
your future self or others what the function does and why.

Here are the above examples in a single chunk with documentation:

``` r
## Creates a function that "demeans"
## a variable (ie - sets the mean to zero)
demean <- function(x) {
  # take the input x and subtract the mean
  # since na.rm=T, you don't have to wory about NAs
  cx <- x - mean(x, na.rm=T)
  cx # return the results
}

## Creates a function that converts
## a variable to z-scores with mean
## of zero and variance of one.
zscore <- function(x) {
  # demean x in the numerator and take the
  # SD in the denominator
  zx <- demean(x) / sd(x, na.rm=T)
  zx # return the results
}


## Creates a function that rescales
## a variable either to z-scores or to
## the 0-1 scale.
rescale <- function(x, zscore = TRUE) {
  ## Use simple logic to return either
  ## the z-score or scaled to [0, 1]
  if(zscore) { 
    ## If zscore = TRUE
    newx <- zscore(x)
  } else {
    ## if zscore = FALSE
    newx <- (x - min(x, na.rm=T)) /
      (max(x, na.rm=T) - min(x, na.rm=T))
  }
  newx # return
}
```

There is no formal set of rules for how to document your code, but some
good rules of thumb are:

-   Explain the overall purpose of the function
-   Explain the sequence of steps the function takes “under the hood” —
    i.e., inside the `{ }`s

## Challenge

Check out the following routine. Can you create a function called
`lm_summary()` that will implement the following routine for any linear
model and dataset, returning the output in a data table with a column
for the variable name, the coefficient, and the lower and upper bounds
of the 95% confidence intervals?

``` r
form <- mpg ~ hp + wt + cyl
fit <- lm(form, data = mtcars)
out <- data.frame(names(coef(fit)),
                  coef(fit),
                  lmtest::coefci(fit))
names(out) <- c("term", "coef", "lower", "upper")
out <- tibble::as_tibble(out)
out
```

    ## # A tibble: 4 × 4
    ##   term           coef   lower    upper
    ##   <chr>         <dbl>   <dbl>    <dbl>
    ## 1 (Intercept) 38.8    35.1    42.4    
    ## 2 hp          -0.0180 -0.0424  0.00629
    ## 3 wt          -3.17   -4.68   -1.65   
    ## 4 cyl         -0.942  -2.07    0.187
