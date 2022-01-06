#' Getting Started Quiz
#' @description Testing your understanding of R concepts.
#' @param name Tutorial name
#' @return 'learnr' module
#' @export gettingStarted
#' @author Philippe Cote
#' @examples
#' gettingStarted()

gettingStarted <- function(name = "getting-started") {
  learnr::run_tutorial(name = name, package = "RTLedu")
}
