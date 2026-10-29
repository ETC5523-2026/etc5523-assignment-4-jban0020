# Importing data

wtc_stopped <- read.csv(
  "data-raw/wtc2026-stopped-after-yard-124.csv",
  stringsAsFactors = FALSE
)

# Checking data

str(wtc_stopped)
summary(wtc_stopped)

# Preparing variables

wtc_stopped$yards <- as.integer(wtc_stopped$yards)

wtc_stopped$qualified_yards <- as.integer(
  wtc_stopped$qualified_yards
)

wtc_stopped$stopped_utc <- as.POSIXct(
  wtc_stopped$stopped_utc,
  format = "%Y-%m-%d %H:%M",
  tz = "UTC"
)

# Checking missing values

colSums(is.na(wtc_stopped))

# Saving data in the package

usethis::use_data(wtc_stopped, overwrite = TRUE)
