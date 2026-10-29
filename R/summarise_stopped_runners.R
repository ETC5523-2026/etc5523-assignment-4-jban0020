utils::globalVariables("wtc_stopped")

#' Summarise Backyard Ultra Runner Performance
#'
#' Summarises the performance of stopped runners from the
#' 2026 Backyard Ultra World Team Championships.
#' Results can be grouped by nation or competition class.
#'
#' @param data A data frame containing runner information.
#'   Defaults to `wtc_stopped`.
#' @param group Variable used to group results. Either
#'   "nation" or "class".
#' @param min_yards Minimum number of completed yards
#'   required for a runner to be included.
#'
#' @return A data frame containing the group, runner count,
#'   mean yards, median yards, maximum yards and total yards.
#'
#' @examples
#' summarise_stopped_runners(group = "nation")
#' summarise_stopped_runners(group = "class")
#' summarise_stopped_runners(group = "nation", min_yards = 50)
#'
#' @export

summarise_stopped_runners <- function(data = wtc_stopped,
                                      group = "nation",
                                      min_yards = 0) {
  
  if (!group %in% c("nation", "class") || length(group) != 1) {
    stop("group must be either 'nation' or 'class'")
  }
  
  if (!is.numeric(min_yards) || length(min_yards) != 1 ||
      is.na(min_yards) || !is.finite(min_yards) || min_yards < 0) {
    stop("min_yards must be a non-negative number")
  }
  
  # Filter runners by completed yards
  
  filtered_data <- data[
    !is.na(data$yards) &
      data$yards >= min_yards &
      !is.na(data[[group]]),
    ,
    drop = FALSE
  ]
  
  # Handle an empty result
  
  if (nrow(filtered_data) == 0) {
    return(data.frame(
      group = character(),
      runners = integer(),
      mean_yards = numeric(),
      median_yards = numeric(),
      max_yards = numeric(),
      total_yards = numeric()
    ))
  }
  
  # Separate yard counts by group
  
  groups <- split(
    filtered_data$yards,
    filtered_data[[group]],
    drop = TRUE
  )
  
  # Calculate summary statistics
  
  result <- data.frame(
    group = names(groups),
    runners = vapply(groups, length, integer(1)),
    mean_yards = vapply(groups, mean, numeric(1)),
    median_yards = vapply(groups, stats::median, numeric(1)),
    max_yards = vapply(groups, max, numeric(1)),
    total_yards = vapply(groups, sum, numeric(1)),
    row.names = NULL
  )
  
  # Sort by median yards, highest first
  
  result <- result[
    order(-result$median_yards, result$group),
    ,
    drop = FALSE
  ]
  
  rownames(result) <- NULL
  
  return(result)
}
