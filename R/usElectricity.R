#' Produce a clean analysis on the US Electricity Market
#' @description Assignment using data from the Energy Information Administration (EIA) API.
#' Your task is to perform analysis and render it as effective business communication.
#' @param name Tutorial name
#' @return 'learnr' module
#' @export usElectricity
#' @author Philippe Cote
#' @examples
#' \dontrun{
#' usElectricity()
#' }

usElectricity <- function(name = "us-electricity") {
  learnr::run_tutorial(name = name, package = "RTLedu")
}
