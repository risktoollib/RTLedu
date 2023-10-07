#' Produce a recommendation for an emerging old athlete as a coach
#' @description Assignment using data from Strava user data.
#' @param name Tutorial name
#' @return 'learnr' module
#' @export fitness
#' @author Philippe Cote
#' @examples
#' if (interactive()) {
#'   fitness()
#' }

fitness <- function(name = "fitness") {
  learnr::run_tutorial(name = name, package = "RTLedu")
}
