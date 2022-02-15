#' Energy Futures and Swaps Market Making - WIP
#' @description Once you understand how to price swaps from futures and
#' want to practice being a market market and hedging the risk this is for you.
#' GAME IS CURRENTLY IN DEVELOPMENT AND EXPERIMENTAL
#' @param name Tutorial name
#' @return 'learnr' module
#' @export spot2fut
#' @author Philippe Cote
#' @examples
#' if (interactive()) {
#'   marketMaking()
#' }

marketMaking <- function(name = "marketMaking") {
  learnr::run_tutorial(name = name, package = "RTLedu")
}
