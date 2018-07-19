library(rvest)
library(dplyr)
library(lubridate)

GetSeasonResults <- function(year = lubridate::year(lubridate::now())){
  
  year <- as.numeric(year)
  
  url <- paste0("https://www.sports-reference.com/cfb/years/", year, "-schedule.html")
  
  season_results <- read_html(url) %>% 
    html_nodes("#schedule") %>% 
    html_table(fill = TRUE) %>% 
    as.data.frame() %>% 
    rename("At" = `Var.8`,
           "W.Pts" = `Pts`,
           "L.Pts" = `Pts.1`)
  
  assign(x = paste0("season_results_",year), season_results, envir = .GlobalEnv)
  
}


# Try it out
GetSeasonResults(2014)

