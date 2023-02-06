#' Practice Foundational Risk Management Skills
#' @description Practice RM skills and presentation with a real life context problem.
#' @param name Tutorial name
#' @return 'learnr' module
#' @export rmNYHulsd
#' @author Philippe Cote
#' @examples
#' if (interactive()) {
#'   rmNYHulsd()
#' }

rmNYHulsd <- function(name = "rmNYHulsd") {
  learnr::run_tutorial(name = name, package = "RTLedu")
}
