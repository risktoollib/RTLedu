#' Execution orders
#' @description Practice your understanding of market and limit orders.
#' @param name Tutorial name
#' @return 'learnr' module
#' @export orders
#' @author Philippe Cote
#' @examples
#' orders()

orders <- function(name = "orders") {
  learnr::run_tutorial(name = name, package = "RTLedu")
}
