library(tidyverse)
library(tidyquant)
library(jsonlite)
library(quantmod)
library(timetk)
library(RTL)
source("~/now/keys.R")

## Trading Hubs

tradeHubs <- dplyr::tibble(lat = c(53.54623,52.6735,35.94068,30.00623), long = c(-113.34684,-111.3075,-96.74536,-93.96882), hub = c("Edmonton","Hardisty", "Cushing", "Nederland"))
usethis::use_data(tradeHubs, overwrite = T)

crudepipelines <- RTL::getGIS(url = "https://www.eia.gov/maps/map_data/CrudeOil_Pipelines_US_EIA.zip")
usethis::use_data(crudepipelines, overwrite = T)

refineries <- RTL::getGIS(url = "https://www.eia.gov/maps/map_data/Petroleum_Refineries_US_EIA.zip")
usethis::use_data(refineries, overwrite = T)

sp500_desc <- tq_index("SP500") #%>% dplyr::filter(!stringr::str_detect(symbol,"BRK.B|BF.B"))
sp500_prices <- tidyquant::tq_get(grep(sp500_desc$symbol,pattern = "BRK.B|BF.B", value = TRUE, invert = TRUE),
                                  get  = "stock.prices",
                                  from = "2010-01-01",
                                  to = Sys.Date()) %>%
  stats::na.omit() %>%
  dplyr::group_by(symbol) %>%
  dplyr::select(symbol, date, close = adjusted) %>%
  tidyquant::tq_transmute(select = close, mutate_fun = to.monthly, indexAt = "lastof")
usethis::use_data(sp500_desc, overwrite = T)
usethis::use_data(sp500_prices, overwrite = T)

# lpg eia data set
lpgMonthly <- tibble::tribble(~ticker, ~series,
                       "PET.MLPEXUS2.M", "Exports",
                       "PET.MLPFPUS2.M","Production") %>%
  dplyr::mutate(key = EIAkey) %>%
  dplyr::mutate(df = purrr::pmap(list(ticker, key, name = series),.f = RTL::eia2tidy)) %>%
  dplyr::select(df) %>% tidyr::unnest(cols = c(df)) %>%
  dplyr::filter(date >= "1990-01-01") %>%
  dplyr::arrange(date)

lpgQuarterly <- lpgMonthly %>%
  tsibble::as_tsibble(key = series, index = date) %>%
  tsibble::group_by_key(series) %>%
  tsibble::index_by(freq = tsibble::yearquarter(date)) %>%
  dplyr::summarise(value = mean(value)) %>%
  dplyr::mutate(freq = lubridate::rollback(as.Date(freq) + months(3,abbreviate = TRUE))) %>%
  dplyr::rename(date = freq) %>%
  dplyr::ungroup() %>%
  dplyr::as_tibble()

usethis::use_data(lpgMonthly, overwrite = T)
usethis::use_data(lpgQuarterly, overwrite = T)


# parsing exercisea
quantmod::getSymbols('MSFT', src = 'yahoo')
microsoft <- MSFT %>% timetk::tk_tbl(preserve_index = TRUE, rename_index = "date")
usethis::use_data(microsoft, overwrite = T)

quantmod::getSymbols('AAPL', src = 'yahoo')
apple <- AAPL %>% timetk::tk_tbl(preserve_index = TRUE, rename_index = "date")
usethis::use_data(apple, overwrite = T)

# nonlin relationships

reg1 <- dplyr::tibble(x = 1:100, y = x + x^2 + x^5)
usethis::use_data(reg1, overwrite = T)

 tweets

# http://www.trumptwitterarchive.com/archive
# use geany text editor in Linux for very large files
twtrump <- jsonlite::fromJSON("./data-raw/twtrump.json")
twtrump <- twtrump %>%
   dplyr::mutate(created_at = as.POSIXct(created_at,tz = "GMT",format=c("%a %b %d %H:%M:%S +0000 %Y"))) %>%
   dplyr:::rename(favoriteCount = favorite_count, created = created_at, id = id_str) %>%
   as_tibble()
usethis::use_data(twtrump, overwrite = T)

# library(twitteR)
# twitteR::setup_twitter_oauth(consumer_key = tw$cons.key,consumer_secret = tw$cons.secret,access_token = tw$access.token, access_secret = tw$access.secret)
# musk <- twitteR::userTimeline("elonmusk", n = 3200,excludeReplies = TRUE, includeRts = FALSE)
# twmusk <- twListToDF(musk)


# run rpanda md game admin outside and then include these objects
#deals <- deals %>% dplyr::select(-TIME,-USERID,-structid, -dealid,-timestamp,-subid,-WEIGHT)
#usethis::use_data(deals, overwrite = T)
#risk <- risk %>% dplyr::select(-TIME,-USERID,-structid, -dealid,-timestamp,-subid,-WEIGHT)
#usethis::use_data(risk, overwrite = T)


# NLP Shell

library(rvest)
url <- "https://www.shell.com/media/speeches-and-articles.html"
urls <- rvest::read_html(url) %>%
  rvest::html_elements(css = ".main__base") %>%
  rvest::html_elements(css = "a") %>%
  rvest::html_attr(name = "href") %>%
  grep("/media/speeches-and-articles/", . ,value = TRUE) %>%
  unique(.) %>%
  grep("articles-by-date|speeches-and-articles-per-speaker", . ,value = TRUE,invert = TRUE) %>%
  paste0("https://www.shell.com",.)

nlpShell <- list()

for (u in urls) {
   tmp <- u %>%
    rvest::read_html() %>%
    rvest::html_elements("p") %>%
    rvest::html_text2() %>%
    dplyr::as_tibble()
   d <- as.character(as.Date(as.character(tmp[1,1]), "%b %d, %Y"))
   nlpShell[[d]] <- tmp %>% dplyr::slice(-1)
}

usethis::use_data(nlpShell, overwrite = T)

# expo
load("~/RTLedu/data/risk.rda")
m1 <- lubridate::rollback(Sys.Date() + months(2, abbreviate = TRUE), roll_to_first = TRUE)
expo <- risk %>%
  dplyr::slice(5) %>%
  dplyr::select(1,8) %>%
  dplyr::mutate(QUANTITY = 1e5, MONTH = m1) %>%
  tibble::add_row(TICKER = "CL",QUANTITY = -150000,MONTH = m1 + months(1, abbreviate = TRUE)) %>%
  tibble::add_row(TICKER = "RB",QUANTITY = 150000,MONTH = m1 + months(1, abbreviate = TRUE)) %>%
  tibble::add_row(TICKER = "CL",QUANTITY = 150000,MONTH = m1 + months(0, abbreviate = TRUE)) %>%
  tibble::add_row(TICKER = "CL",QUANTITY = -150000,MONTH = m1 + months(1, abbreviate = TRUE))

expo <- expo %>%
  tidyr::pivot_wider(names_from = MONTH, values_from = QUANTITY, values_fn = sum)
usethis::use_data(expo, overwrite = T)

# swap pricing

futs <- RTL::getPrices(
  feed = "CME_NymexFutures_EOD",
  contracts = c("@CL22K","@CL22M", "@CL22N", "@CL22Q","@CL22U"),
  from = "2022-03-04",
  iuser = mstar[[1]],
  ipassword = mstar[[2]]
)
usethis::use_data(futs, overwrite = T)


# Global
devtools::document()










