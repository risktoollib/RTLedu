#' Practice Foundational Data Science Skills
#' @description Practice skills and presentation with a real life context problem.
#' @param name Tutorial name
#' @return 'learnr' module
#' @export assetClass
#' @author Philippe Cote
#' @examples
#' if (interactive()) {
#'   assetClass()
#' }

assetClass <- function(name = "assetClass") {
  learnr::run_tutorial(name = name, package = "RTLedu")
}
