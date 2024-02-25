#' Practice Foundational Risk Management Skills
#' @description Practice RM skills and presentation with a real life context problem.
#' @param name riskIntoPractice
#' @return 'learnr' module
#' @export riskIntoPractice
#' @author Philippe Cote
#' @examples
#' if (interactive()) {
#'   riskIntoPractice()
#' }

riskIntoPractice <- function(name = "riskIntoPractice") {
  learnr::run_tutorial(name = name, package = "RTLedu")
}
