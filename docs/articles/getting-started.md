# Getting started with backyardWTC

## Introduction

The `backyardWTC` package provides an interactive way to explore runner
performance at the 2026 Backyard Ultra World Team Championships.

It is designed for backyard ultra spectators, running enthusiasts and
performance analysts interested in comparing results across nations and
competition classes.

This vignette explains how to install the package, launch the Shiny
application, explore its outputs and interpret the results.

## Installation

The development version of `backyardWTC` can be installed from GitHub.

``` r

install.packages("remotes")

remotes::install_github(
  "ETC5523-2026/etc5523-assignment-4-jban0020"
)
```

Once installed, load the package:

``` r

library(backyardWTC)
```

## Launching the Shiny application

The main feature of the package is an interactive Shiny dashboard.

Launch it using:

``` r

backyardWTC::run_wtc_app()
```

The dashboard opens in a browser and allows users to explore performance
among stopped runners.

## Exploring the dashboard

The application provides several controls for comparing runner
performance.

### Choosing a comparison

Use the **Compare performance by** menu to switch between:

- Nation: compare runners representing different countries.
- Competition class: compare runners across the four recorded classes.

### Applying filters

The sidebar allows users to:

- Select one or more nations, or leave the selection blank to include
  all nations.
- Select which competition classes to include.
- Set the minimum number of completed yards.
- Choose mean or median yards as the performance measure.
- Adjust the number of nations shown in the chart.

The chart and summary table update automatically when these settings
change.

### Example exploration

Suppose you want to compare nations with runners who completed at least
50 yards.

1.  Select **Nation** as the comparison.
2.  Set **Minimum completed yards** to 50.
3.  Keep all competition classes selected.
4.  Select **Median yards** as the performance measure.
5.  Examine the resulting chart and summary table.

This allows you to compare performance among runners who reached the
selected threshold.

## Interpreting the outputs

### Performance chart

The bar chart displays either the mean or median completed yards for
each nation or competition class.

The **median** represents the middle yard count within a group, while
the **mean** represents the arithmetic average.

Each bar is labelled with the number of runners contributing to that
group’s summary.

When comparing nations, the chart displays the highest-ranked nations
according to the selected performance measure.

### Summary table

The table provides additional statistics for every group matching the
selected filters.

These include:

- **Runners:** Number of stopped runners in the group.
- **Mean yards:** Average completed yards.
- **Median yards:** Middle completed yard count.
- **Maximum yards:** Highest completed yard count.
- **Total yards:** Combined completed yards across runners.

The table is useful for comparing performance while considering
differences in group sizes.

A high group median does not necessarily indicate that the group had the
greatest total number of completed yards.

## Working with the data directly

The package also includes the `wtc_stopped` dataset.

``` r

head(
  wtc_stopped[
    , c("runner", "nation", "class", "yards")
  ]
)
#>            runner                   nation     class yards
#> 1    Ivo Steyaert                  Belgium Super Six   124
#> 2   Merijn Geerts                  Belgium Super Six   124
#> 3        Jon Noll United States of America Super Six   106
#> 4 Kengo Takahashi                    Japan Super Six   104
#> 5  Julien Pierlot                   France Super Six   100
#> 6  Nicholas Steel United States of America Super Six    94
```

The
[`summarise_stopped_runners()`](../reference/summarise_stopped_runners.md)
function allows users to generate summaries without opening the
dashboard.

For example, summarise performance by competition class:

``` r

summarise_stopped_runners(
  group = "class"
)
#>       group runners mean_yards median_yards max_yards total_yards
#> 1 Super Six      84   64.58333         62.5       124        5425
#> 2 Class AAA     252   40.85317         38.0        89       10295
#> 3  Class AA     278   28.85612         29.0        61        8022
#> 4   Class A     311   18.92283         18.0        42        5885
```

Alternatively, compare nations after restricting the data to runners
completing at least 50 yards:

``` r

head(
  summarise_stopped_runners(
    group = "nation",
    min_yards = 50
  )
)
#>                      group runners mean_yards median_yards max_yards
#> 1 United States of America      11   79.81818         83.0       106
#> 2                Australia      13   72.46154         73.0        86
#> 3                   Mexico       2   70.50000         70.5        72
#> 4           United Kingdom      10   68.70000         69.0        89
#> 5              New Zealand       8   65.12500         67.5        76
#> 6                  Belgium      13   74.69231         67.0       124
#>   total_yards
#> 1         878
#> 2         942
#> 3         141
#> 4         687
#> 5         521
#> 6         971
```

The function returns the same core summary measures used by the Shiny
application.

## Important limitations

The dataset contains 925 stopped-runner records from a snapshot taken
after yard 124 of the 2026 championships.

It does not represent the complete championship roster or official team
standings.

Consequently, the results describe performance among runners recorded as
stopped in this snapshot, rather than the final performance of every
championship participant.

Comparisons involving groups with relatively few runners should also be
interpreted cautiously.

The original data was obtained from the [WTC 2026 Live
Dashboard](https://wtc2026.bigsbackyardultra.com/#race).

## Conclusion

The `backyardWTC` package provides two ways to explore runner
performance: an interactive Shiny application and an R summary function.

Together, these tools allow users to compare nations and competition
classes, investigate different performance measures and explore the
championship data while remaining aware of its limitations.
