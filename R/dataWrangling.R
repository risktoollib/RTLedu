#' Data Wrangling Quiz
#' @description Testing your understanding of basic data wrangling concepts.
#' @param name Tutorial name
#' @return 'learnr' module
#' @export dataWrangling
#' @author Philippe Cote
#' @examples
#' \dontrun{
#' dataWrangling()
#' }

dataWrangling <- function(name = "data-wrangling") {
  learnr::run_tutorial(name = name, package = "RTLedu")
}
