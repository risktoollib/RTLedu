#' Produce a clean analysis on the US Electricity Market
#' @description Assignment using data from the Energy Information Administration (EIA) API.
#' @param name Tutorial name
#' @return 'learnr' module
#' @export usGeneration
#' @author Philippe Cote
#' @examples
#' if (interactive()) {
#'   usGeneration()
#' }

usGeneration <- function(name = "usGeneration") {
  learnr::run_tutorial(name = name, package = "RTLedu")
}
