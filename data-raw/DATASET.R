attachment::att_from_rscripts()
attachment::att_from_rmd(path = "./inst/tutorials/asset-classes/asset-classes.Rmd")
attachment::att_from_rmd(path = "./inst/tutorials/data-wrangling/data-wrangling.Rmd")
attachment::att_from_rmd(path = "./inst/tutorials/getting-started/getting-started.Rmd")
attachment::att_from_rmd(path = "./inst/tutorials/marketMaking/marketMaking.Rmd")
attachment::att_from_rmd(path = "./inst/tutorials/mtmPLexpo/mtmPLexpo.Rmd")
attachment::att_from_rmd(path = "./inst/tutorials/multivariate-regressions/multivariate-regressions.Rmd")
attachment::att_from_rmd(path = "./inst/tutorials/orders/orders.Rmd")
attachment::att_from_rmd(path = "./inst/tutorials/sp500risk/sp500risk.Rmd")
attachment::att_from_rmd(path = "./inst/tutorials/spot2fut/risk-spot2fut.Rmd")
attachment::att_from_rmd(path = "./inst/tutorials/us-electricity/us-electricity.Rmd")


usethis::use_pipe()
usethis::use_package("RTL")
usethis::use_package("sp")
usethis::use_package("lubridate")
usethis::use_package("gt")
usethis::use_package("dplyr")
usethis::use_package("tidyr")
usethis::use_package("ggplot2")
usethis::use_package("plotly")

library(tidyverse)
library(tidyquant)
library(jsonlite)
library(quantmod)
library(timetk)
library(RTL)
library(tidyquant)
source("~/now/packages.R")

## Trading Hubs

sp500_desc <- tidyquant::tq_index("SP500") #%>% dplyr::filter(!stringr::str_detect(symbol,"BRK.B|BF.B"))

sp500_prices <- tidyquant::tq_get(sort(grep(sp500_desc$symbol,pattern = "BRK.B|BF.B|DD", value = TRUE, invert = TRUE)),
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

lpgMonthly <- RTL::eia2tidy_all(tickers = tibble::tribble(~ticker, ~name,
                                       "PET.MLPEXUS2.M", "Exports",
                                       "PET.MLPFPUS2.M","Production",
                                       "PET.MLPIMUS2.M", "Imports"),
             key = EIAkey, long = TRUE) %>%
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


# parsing exercises
quantmod::getSymbols('MSFT', src = 'yahoo')
microsoft <- MSFT %>% timetk::tk_tbl(preserve_index = TRUE, rename_index = "date")
usethis::use_data(microsoft, overwrite = T)

quantmod::getSymbols('AAPL', src = 'yahoo')
apple <- AAPL %>% timetk::tk_tbl(preserve_index = TRUE, rename_index = "date")
usethis::use_data(apple, overwrite = T)

quantmod::getSymbols('CVX', src = 'yahoo')
chevron <- CVX %>% timetk::tk_tbl(preserve_index = TRUE, rename_index = "date")
usethis::use_data(chevron, overwrite = T)

# nonlin relationships
reg1 <- dplyr::tibble(x = 1:100, y = x + x^2 + x^5)
usethis::use_data(reg1, overwrite = T)
reg2 <- dplyr::tibble(x = seq(from =0,4*pi,,100),
                      y = 2 * sin(2 * x) + x * 0.75)
#reg2 %>% ggplot(aes(x=x,y=y)) + geom_line()
#reg <- lm(y ~ x,data = RTLedu::reg2)
#summary(reg)
usethis::use_data(reg2, overwrite = T)
reg3 <- tidyquant::tq_get(x = c("ICLN","XLE"), get = "stock.prices",
                            from = lubridate::rollback(Sys.Date() - months(120)), to = lubridate::rollback(Sys.Date())) %>%
  dplyr::transmute(date, series = symbol, value = adjusted) %>%
  dplyr::group_by(series) %>%
  dplyr::mutate(value = log(value/dplyr::lag(value))) %>%
  tidyr::drop_na() %>%
  tidyr::pivot_wider(names_from = series,values_from = value)
usethis::use_data(reg3, overwrite = T)

# seasonality
library(tidyverse)
unemployment <- tidyquant::tq_get(x = c("AKURN","CAURN","NJURN"), get = "economic.data",
                                  from = "1990-01-01", to = Sys.Date()) %>%
  dplyr::transmute(date,
                   state = case_when(symbol == "NJURN" ~ "NewJersey",
                                      symbol == "AKURN" ~ "Alaska",
                                     symbol == "CAURN" ~ "California"),
                   rate = price/100) %>%
  dplyr::filter(date != dplyr::last(date)) %>%
  dplyr::group_by(state)
usethis::use_data(unemployment, overwrite = T)

# correlation

correlation <- tidyquant::tq_get(c("IYR","SPY") ,get = "stock.prices",from = "2017-01-01", to = Sys.Date()) %>%
  dplyr::select(date, series = symbol, value = adjusted) %>%
  dplyr::mutate(series = stringr::str_replace_all(series,c("IYR" = "RealEstate", "SPY" = "sp500" )))
usethis::use_data(correlation, overwrite = T)

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
library(RSelenium)
url <- "https://www.shell.com/media/speeches-and-articles.html"
rD <- rsDriver(browser = "firefox", chromever = NULL)
remDr <- rD[["client"]]
Sys.sleep(2)
remDr$navigate(url)
Sys.sleep(2)
#remDr$findElement(using = 'class', value = 'productTemplate')$clickElement()
page <- remDr$getPageSource()

urls <- read_html(page[[1]]) %>%
  rvest::html_elements(css = ".grid") %>%
  rvest::html_elements(css = "a") %>%
  rvest::html_attr(name = "href") %>%
  grep("/media/speeches-and-articles/", . ,value = TRUE) %>%
  unique(.) %>%
  grep("articles-by-date|speeches-and-articles-per-speaker", . ,value = TRUE,invert = TRUE) %>%
  grep("2018|2017", . ,value = TRUE,invert = TRUE)

nlpShell <- list()

for (u in urls) {
  print(u)
  remDr$navigate(u)
  Sys.sleep(5)
  page <- remDr$getPageSource()
  Sys.sleep(3)
  page <- rvest::read_html(page[[1]])
  Sys.sleep(3)
  tmp <- page %>%
    rvest::html_elements("p") %>%
    rvest::html_text2() %>%
    dplyr::as_tibble()
   d <- page %>% rvest::html_element(".time") %>% rvest::html_attr("datetime") %>% substr(.,1,10)
   if (is.na(d)) {
     d <- page %>% rvest::html_element("#main > div:nth-child(1) > section:nth-child(1) > div:nth-child(1) > div:nth-child(1) > div:nth-child(2) > div:nth-child(1)") %>%
       rvest::html_elements(".p")  %>% .[2] %>%
       rvest::html_text() %>% as.Date(.,"%d  %b %Y") %>% as.character(.)
   }
   nlpShell[[d]] <- tmp %>% dplyr::slice(-1)
}

remDr$close()
rD[["server"]]$stop()

usethis::use_data(nlpShell, overwrite = T)

# expo
load("~/RTLedu/data/risk.rda")
m1 <- lubridate::rollback(Sys.Date() + months(2, abbreviate = TRUE), roll_to_first = TRUE)
expo <- risk %>%
  dplyr::slice(5) %>%
  dplyr::select(1,8) %>%
  dplyr::mutate(QUANTITY = 1e5, MONTH = m1) %>%
  tibble::add_row(TICKER = "CL",QUANTITY = -300000,MONTH = m1 + months(1, abbreviate = TRUE)) %>%
  tibble::add_row(TICKER = "RB",QUANTITY = 150000,MONTH = m1 + months(1, abbreviate = TRUE)) %>%
  tibble::add_row(TICKER = "HO",QUANTITY = 150000,MONTH = m1 + months(1, abbreviate = TRUE)) %>%
  tibble::add_row(TICKER = "CL",QUANTITY = 200000,MONTH = m1 + months(0, abbreviate = TRUE)) %>%
  tibble::add_row(TICKER = "CL",QUANTITY = -200000,MONTH = m1 + months(1, abbreviate = TRUE))

expo <- expo %>%
  tidyr::pivot_wider(names_from = MONTH, values_from = QUANTITY, values_fn = sum)
usethis::use_data(expo, overwrite = T)

# swap pricing

futs <- RTL::getPrices(
  feed = "CME_NymexFutures_EOD",
  contracts = c("@CL23U","@CL23V", "@CL23X", "@CL23Z"),
  from = Sys.Date() - months(2),
  iuser = mstar[[1]],
  ipassword = mstar[[2]]
)
usethis::use_data(futs, overwrite = T)

# payoffs

callpayoff <- function(price,strike) {max(price - strike,0)}
putpayoff <- function(price,strike) {max(strike - price,0)}
payoffs <- dplyr::tibble(Price = seq(0, 80, 1),
              PayoffatMaturity = (mapply(callpayoff,Price,strike = 45)
                                  + mapply(callpayoff,Price,strike = 50)
                                  - 2 * mapply(callpayoff,Price,strike = 60)
                                  - 1 * mapply(callpayoff,Price,strike = 70)
                                  + mapply(putpayoff,Price,strike = 35)
                                  + mapply(putpayoff,Price,strike = 30)
                                  - 2 * mapply(putpayoff,Price,strike = 20))
              - mapply(putpayoff,Price,strike = 10))
payoffs %>%
  plotly::plot_ly(x = ~Price, y = ~PayoffatMaturity)

usethis::use_data(payoffs, overwrite = T)



# ercot
setwd(paste0(here::here(),"/data-raw/"))
library(rvest)
library(readxl)
url = "https://www.ercot.com/misapp/GetReports.do?reportTypeId=13060&reportTitle=Historical%20DAM%20Load%20Zone%20and%20Hub%20Prices&showHTMLView=&mimicKey"
urls <- rvest::read_html(url) %>%
  rvest::html_elements("body > form > table") %>%
  rvest::html_elements("a") %>%
  rvest::html_attr("href") %>%
  paste0("https://www.ercot.com",.)

for (i in 1:length(urls)) {

  url <- urls[i]
  destfile <- paste0("ercot.zip")
  curl::curl_download(url, destfile)
  utils::unzip(destfile)
  ff <- list.files(pattern = "rpt",)
  if (i == 1) {
    ercot <- lapply(readxl::excel_sheets(ff), read_excel, path = ff) %>% do.call(rbind, .)
  } else {
    tmp <- lapply(readxl::excel_sheets(ff), read_excel, path = ff) %>% do.call(rbind, .)
    ercot <- rbind(ercot, tmp)
  }
  file.remove(ff)
  file.remove(destfile)
}

ercot <- ercot %>%
  dplyr::as_tibble(.name_repair = "universal") %>%
  dplyr::mutate(Delivery.Date = as.Date(Delivery.Date, "%m/%d/%Y"),
                Hour.Ending = lubridate::hm(Hour.Ending),
                Date = lubridate::as_datetime(paste(Delivery.Date, Hour.Ending))) %>%
  dplyr::select(Date, everything())

usethis::use_data(ercot, overwrite = T)

toy <- dplyr::tibble(RTLeduUpdate = paste("RTLedu is updated as of:",Sys.Date()))
usethis::use_data(toy, overwrite = T)

# use of chart pairs
cpairs <- dplyr::tibble(
  year = c("2018", "2019", "2020","2021","2022","2023"),
  first = c("@HO8H", "@HO9H", "@HO0H","@HO21H","@HO22H","@HO23H"),
  second = c("@HO8J", "@HO9J", "@HO0J","@HO21J","@HO22J","@HO23J"),
  expiry = c(NA,NA,NA,NA,NA,"2023-02-23")
)

spreads = list()

spreads[[1]] <- RTL::chart_spreads(
  cpairs = cpairs, daysFromExpiry = 200, from = "2017-01-01",
  conversion = c(42, 42), feed = "CME_NymexFutures_EOD",
  iuser = mstar[[1]], ipassword = mstar[[2]],
  title = "March ULSD vs WTI Nymex Crack Spreads",
  yaxis = "$ per bbl",
  output = "chart"
)
usethis::use_data(spreads, overwrite = T)

# bankOffer

bankOffer <- tidyquant::tq_get(x = c("DGS1","DGS3","DGS5","DGS7","DGS10"),get = "economic.data") %>%
  dplyr::filter(date == max(date)) %>%
  dplyr::transmute(maturity = round(readr::parse_number(symbol),3),
                   rate = price / 100)
usethis::use_data(bankOffer, overwrite = T)

# Global
devtools::document()










