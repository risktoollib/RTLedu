#' Produce a clean analysis of returns properties and correlation across asset classes.
#' @description Analyzing financial returns across multiple asset classes.
#' Your task is to perform analysis and render it as effective business communication.
#' @param name Tutorial name
#' @return 'learnr' module
#' @export assetClasses
#' @author Philippe Cote
#' @examples
#' \dontrun{
#' assetClasses()
#' }

assetClasses <- function(name = "asset-classes") {
  learnr::run_tutorial(name = name, package = "RTLedu")
}
