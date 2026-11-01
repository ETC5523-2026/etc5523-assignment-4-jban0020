# Getting started with backyardWTC

## What the package does

`backyardWTC` is an R package and Shiny dashboard for exploring a
snapshot of stopped runners from the 2026 Backyard Ultra World Team
Championships. It is intended for spectators, running enthusiasts and
performance analysts asking **how completed-yard performance differs
across nations and competition classes**.

The included `wtc_stopped` dataset records 925 stopped runners from 67
nations in four classes, captured after yard 124. One yard means one
completed race lap. The data is **not** the complete starting field,
live race standings or the final team results.

## Install and launch

Install the package from its GitHub Classroom repository:

``` r

install.packages("remotes")
remotes::install_github("ETC5523-2026/etc5523-assignment-4-jban0020")
```

Load it and launch the application:

``` r

library(backyardWTC)
```

``` r

run_wtc_app()
```

The Shiny app reads the dataset **from the installed package**. You do
not need to download or load the original CSV to run it.

## The two dashboard tabs

The app offers **Race progression** and **Performance comparison**. Each
tab has its own nation, competition-class and yard controls. Changing
the filters in one tab does not change the other tab.

### Race progression: when do runners stop?

Use this tab to reconstruct how the *recorded stopped-runner cohort*
progresses through completed-yard thresholds.

1.  Choose any nations, or leave the nation selection blank for all
    nations. Tick the classes to include.
2.  Move the **Current completed yard** slider, use the previous/next
    buttons, or play the slider to move one yard at a time.
3.  Select **Runners reaching each yard** for a cumulative count, or
    **Stopped at each yard** to examine departures.
4.  Click a chart point or bar to update the selected yard and see the
    runner names and recorded stopping reasons. The table initially
    shows eight runners and can be expanded.

The metric **Reached at least yard X** counts runners who completed X or
more yards. For example, a runner recorded with exactly 50 completed
yards is counted as having reached yard 50, but not yard 51. A flat
section of the progression chart means no runner in the selected cohort
stopped at that completed-yard count.

This is not a survival curve for the entire field: runners not recorded
as stopped in this snapshot are outside the dataset.

### Performance comparison: how do groups differ?

Use this tab to compare nations or competition classes, with filters
that are separate from those in Race progression.

1.  Set **Compare performance by** to Nation or Competition class and
    choose which nations and classes are included.
2.  Select **Total yards (lines)** to plot each group’s cumulative
    completed yards through every yard threshold. The yard slider
    highlights one vertical position on these lines; it does not filter
    the lines. **Runners left** in the hover details refers only to the
    selected stopped-runner cohort reaching that threshold and does not
    set line height.
3.  Switch to **Runner distribution** to see individual stopped-runner
    yard counts and box plots for each group. Here the yard slider is a
    **minimum completed-yards filter**.
4.  Choose **Median yards** or **Mean yards** to rank the summary table,
    then show the top five groups, selected groups or all groups. In
    Nation mode you can also choose how many nations appear in the
    chart.

The plotted groups and table can use **different rankings**: line-chart
nations are selected by total accumulated yards, while table rows are
ranked by the selected mean or median. Total yards is strongly affected
by the number of runners in the group; mean and median are better for
discussing typical individual performance. Very small groups can give
unstable comparisons.

## Interpreting a result

For example, choose all nations and all classes, then compare the
classes using the summary table. In this snapshot, the median recorded
completion was **62.5 yards for Super Six** versus **18 yards for Class
A**. These are comparisons *within the recorded stopped-runner data*,
not causal effects of class membership or official team rankings. The
class definitions are source-recorded categories, and the dataset does
not by itself establish why they differ.

The **Race progression** tab supports a complementary question: at what
point did runners in the chosen cohort tend to stop, and were there
yards with more recorded stops than others? Use the chart’s tooltips and
stopping-details table to connect the counts with the individual
records.

## Summarise the data in R

The `wtc_stopped` dataset can be explored without the app:

``` r

head(wtc_stopped[, c("runner", "nation", "class", "yards")])
#>            runner                   nation     class yards
#> 1    Ivo Steyaert                  Belgium Super Six   124
#> 2   Merijn Geerts                  Belgium Super Six   124
#> 3        Jon Noll United States of America Super Six   106
#> 4 Kengo Takahashi                    Japan Super Six   104
#> 5  Julien Pierlot                   France Super Six   100
#> 6  Nicholas Steel United States of America Super Six    94
```

The exported
[`summarise_stopped_runners()`](../reference/summarise_stopped_runners.md)
function is also used by the app to calculate grouped statistics. It
returns group size, mean and median yards, maximum yards and total
yards.

``` r

summarise_stopped_runners(group = "class")
#>       group runners mean_yards median_yards max_yards total_yards
#> 1 Super Six      84   64.58333         62.5       124        5425
#> 2 Class AAA     252   40.85317         38.0        89       10295
#> 3  Class AA     278   28.85612         29.0        61        8022
#> 4   Class A     311   18.92283         18.0        42        5885
```

To compare nations among runners completing at least 50 yards:

``` r

head(summarise_stopped_runners(group = "nation", min_yards = 50))
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

## Empty selections and limitations

If you uncheck every competition class, the app explains that no runners
match rather than displaying a misleading chart. In Performance
comparison, selecting a minimum yard threshold above every runner in the
selected group also produces an informative message. Broaden the
selection or lower the threshold to continue.

The data comes from the [WTC 2026 Live
Dashboard](https://wtc2026.bigsbackyardultra.com/#race), captured as a
CSV snapshot after yard 124. It contains 925 *stopped* runners across 67
nations, not all competitors. It cannot be used to infer complete final
standings, and comparing nations with different numbers of runners
requires care.

## Further information

See [`?wtc_stopped`](../reference/wtc_stopped.md) for the data
dictionary,
[`?summarise_stopped_runners`](../reference/summarise_stopped_runners.md)
for the summary function and
[`?run_wtc_app`](../reference/run_wtc_app.md) for the app launcher.
