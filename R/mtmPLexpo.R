#' Compute PL and Exposure
#' @description Given a set a transaction you must compute Profit and Loss and current Exposure
#' @param name Tutorial name
#' @return 'learnr' module
#' @export mtmPLexpo
#' @author Philippe Cote
#' @examples
#' if (interactive()) {
#'   mtmPLexpo()
#' }

mtmPLexpo <- function(name = "mtmPLexpo") {
  learnr::run_tutorial(name = name, package = "RTLedu")
}
