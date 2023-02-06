#' Practice Foundational Risk Management Skills
#' @description Practice RM skills and presentation with a real life context problem.
#' @param name Tutorial name
#' @return 'learnr' module
#' @export rmCanCrude
#' @author Philippe Cote
#' @examples
#' if (interactive()) {
#'   rmCanCrude()
#' }

rmCanCrude <- function(name = "rmCanCrude") {
  learnr::run_tutorial(name = name, package = "RTLedu")
}
