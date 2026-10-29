
#' Launch the Backyard Ultra Shiny App
#'
#' Launches an interactive Shiny dashboard for exploring
#' stopped-runner performance at the 2026 Backyard Ultra
#' World Team Championships.
#'
#' The application allows users to compare nations and
#' competition classes, apply performance filters and
#' explore summary statistics.
#'
#' @return Launches the Shiny application in a web browser.
#'
#' @examples
#' \dontrun{
#' run_wtc_app()
#' }
#'
#' @importFrom ggplot2 ggplot
#' @export

run_wtc_app <- function() {
  
  app_dir <- system.file(
    "app",
    package = "backyardWTC"
  )
  
  if (app_dir == "") {
    stop("Could not find the Shiny application.")
  }
  
  shiny::runApp(
    appDir = app_dir,
    launch.browser = TRUE
  )
}
