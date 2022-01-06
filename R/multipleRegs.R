#' Produce a clean analysis of recursively running a multivariate regression.
#' @description Apply a practitioner's mindset to decide what to include and excludes in your multiple regression.
#' Your task is to perform analysis and render it as effective business communication.
#' @param name Tutorial name
#' @return 'learnr' module
#' @export multipleRegs
#' @author Philippe Cote
#' @examples
#' multipleRegs()

multipleRegs <- function(name = "multivariate-regressions") {
  learnr::run_tutorial(name = name, package = "RTLedu")
}
