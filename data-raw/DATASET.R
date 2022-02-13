library(tidyverse)
library(tidyquant)
library(jsonlite)
library(quantmod)
library(timetk)

## Trading Hubs

tradeHubs <- dplyr::tibble(lat = c(53.54623,52.6735,35.94068,30.00623), long = c(-113.34684,-111.3075,-96.74536,-93.96882), hub = c("Edmonton","Hardisty", "Cushing", "Nederland"))
usethis::use_data(tradeHubs, overwrite = T)

crudepipelines <- RTL::getGIS(url = "https://www.eia.gov/maps/map_data/CrudeOil_Pipelines_US_EIA.zip")
usethis::use_data(crudepipelines, overwrite = T)

refineries <- RTL::getGIS(url = "https://www.eia.gov/maps/map_data/Petroleum_Refineries_US_EIA.zip")
usethis::use_data(refineries, overwrite = T)

sp500_desc <- tq_index("SP500") %>% dplyr::filter(!stringr::str_detect(symbol,"BRK.B|BF.B|KEYS|WEC|XRAY"))
sp500_prices <- tidyquant::tq_get(sp500_desc$symbol,
                                  get  = "stock.prices",
                                  from = "2008-08-01",
                                  to = Sys.Date()) %>%
  stats::na.omit() %>%
  dplyr::group_by(symbol) %>%
  dplyr::select(symbol, date, close = adjusted) %>%
  tidyquant::tq_transmute(select = close, mutate_fun = to.monthly, indexAt = "lastof")
usethis::use_data(sp500_desc, overwrite = T)
usethis::use_data(sp500_prices, overwrite = T)

# parsing exercise
quantmod::getSymbols('MSFT',src='yahoo')
microsoft <- MSFT %>% timetk::tk_tbl(preserve_index = TRUE, rename_index = "date")
usethis::use_data(microsoft, overwrite = T)

# tweets

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
  rvest::html_elements(".main__base") %>%
  rvest::html_elements("a") %>%
  rvest::html_attr("href") %>%
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


# Global
devtools::document()










