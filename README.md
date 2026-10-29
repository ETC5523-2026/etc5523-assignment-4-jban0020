# backyardWTC

An R package and interactive Shiny application for exploring runner performance at the 2026 Backyard Ultra World Team Championships.

## Overview

The `backyardWTC` package allows users to investigate how runner performance varies across nations and competition classes.

The package is designed for backyard ultra spectators, running enthusiasts and performance analysts who want to explore differences in the number of yards completed.

It includes a prepared dataset, a summary function and an interactive Shiny dashboard.

## Data

The package contains `wtc_stopped`, a dataset of 925 stopped runners representing 67 nations and four competition classes.

The dataset contains nine variables:

- `runner`: Runner's name
- `nation`: Nation represented
- `class`: Competition class
- `yards`: Number of completed yards
- `code`: Stopping reason code
- `reason`: Description of the stopping reason
- `stopped_utc`: Stopping date and time in UTC
- `local_time`: Recorded local stopping time
- `qualified_yards`: Recorded qualifying yard count

The original CSV is stored in `data-raw/`, alongside a reproducible R script used to prepare the packaged dataset.

**Data source:** Big's Backyard Ultra World Team Championship (2026), [WTC 2026 Live Dashboard](https://wtc2026.bigsbackyardultra.com/#race), developed by Naresh Kumar using the official championship leaderboard.

The dataset was downloaded from the dashboard's stopped-runner results as a CSV snapshot after yard 124. It contains 925 stopped runners across 67 nations. As the live dashboard continues to update, the data included in this package represents an earlier point in the competition rather than the final results.

**Limitation:** The data represents a snapshot of runners recorded as stopped after yard 124. It does not represent the complete championship roster or official team standings.

The original data remains subject to its source's reuse and attribution conditions.

## Installation

You can install the development version of `backyardWTC` from GitHub using:

```r
install.packages("remotes")

remotes::install_github(
  "ETC5523-2026/etc5523-assignment-4-jban0020"
)
```

Then load the package:

```r
library(backyardWTC)
```

## Launch the Shiny app

Launch the interactive dashboard using:

```r
backyardWTC::run_wtc_app()
```

The application allows users to:

- Compare runner performance by nation or competition class
- Filter runners by nation and competition class
- Set a minimum number of completed yards
- Compare mean and median performance
- Explore performance charts and summary statistics

The dashboard updates automatically when users change the filters.

## Summary function

The package provides `summarise_stopped_runners()` for summarising runner performance.

For example, compare nations:

```r
summarise_stopped_runners(group = "nation")
```

Compare competition classes:

```r
summarise_stopped_runners(group = "class")
```

Or restrict the summary to runners completing at least 50 yards:

```r
summarise_stopped_runners(
  group = "nation",
  min_yards = 50
)
```

The function returns runner counts, mean yards, median yards, maximum yards and total yards for each group.

## Documentation

Help pages are available in R using:

```r
?wtc_stopped
?summarise_stopped_runners
?run_wtc_app
```

## Licence

The package code is released under the MIT licence. See `LICENSE.md` for details.

## Generative AI declaration

I used ChatGPT to assist with planning the R package structure, developing and debugging R functions, writing documentation, and creating the Shiny application and its styling. I reviewed and tested the code and outputs, and revised the suggested material for this assignment.
