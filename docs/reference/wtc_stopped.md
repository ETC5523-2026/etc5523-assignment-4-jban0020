# Stopped Runners at the 2026 Backyard Ultra World Team Championships

A dataset containing 925 runner records from the 2026 Backyard Ultra
World Team Championships. The data records runner performance, nation,
competition class and stopping information.

## Usage

``` r
wtc_stopped
```

## Format

A data frame with 925 rows and 9 variables:

- runner:

  Name of the runner.

- nation:

  Nation represented by the runner.

- class:

  Competition class of the runner.

- yards:

  Number of yards completed.

- code:

  Code indicating the stopping reason.

- reason:

  Description of why the runner stopped.

- stopped_utc:

  Stopping date and time in UTC.

- local_time:

  Local time recorded at stopping.

- qualified_yards:

  Recorded qualifying yard count.

## Source

Original CSV stored in `data-raw/wtc2026-stopped-after-yard-124.csv`.
The original public data source should also be attributed in the package
README.
