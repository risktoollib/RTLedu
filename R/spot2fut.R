#' Spot To Futures Relationship
#' @description Deepen and test our understanding of the important spot to futures relationship in Finance.
#' @param name Tutorial name
#' @return 'learnr' module
#' @export spot2fut
#' @author Philippe Cote
#' @examples
#' spot2fut()

spot2fut <- function(name = "spot2fut") {
  learnr::run_tutorial(name = name, package = "RTLedu")
}
