#' Practice Fondational Risk Management Skills
#' @description Practice RM skills and presentation with a real life context problem.
#' @param name Tutorial name
#' @return 'learnr' module
#' @export riskintopracticeEnergy
#' @author Philippe Cote
#' @examples
#' if (interactive()) {
#'   riskintopracticeEnergy()
#' }

riskintopracticeEnergy <- function(name = "riskintopractice-energy") {
  learnr::run_tutorial(name = name, package = "RTLedu")
}
