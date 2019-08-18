library(httr)
library(jsonlite)

base_path <- "https://api.collegefootballdata.com"

# Endpoints
games <- "/games?"
plays <- "/plays"
drives <- "/drives"
teams <- "/teams"
lines <- "/lines"



# Extract Games Data ------------------------------------------------------


# Create a function to get game data
getGames <- function(year = "2019", week = "1", seasonType = "regular"){
  
  year <- as.character(year)
  week <- as.character(week)
  seasonType <- as.character(seasonType)
  
  base_path <- "https://api.collegefootballdata.com"

  path <- paste0(base_path,"/games?year=",year,"&week=",week,"&seasonType=",seasonType)
  
  r <- httr::GET(url = path)
  
  r_content <- httr::content(r, "text")
  
  jsonlite::fromJSON(r_content)
  
}


# Commented out Game Runs -------------------------------------------------


# games_2019_list <- list()

# for (i in 1:14){
#   games_2019_list[[i]] <- getGames(year = 2019, 
#                                    week = i)
#   
#   Sys.sleep(15)
# }
# 
# all_games_2019 <- purrr::map_df(games_2019_list, dplyr::bind_rows)
# 
# rm(games_2019_list)
# 
# games_2018_list <- list()

# for (i in 1:14) {
# 
#       games_2018_list[[i]] <- getGames(year = 2018, week = i)
#   
#           Sys.sleep(15)
# }
# 
# all_games_2018 <- purrr::map_df(games_2018_list, dplyr::bind_rows)
# rm(games_2018_list)


# Extract Data in General -----------------------------------------------------

# Create a function that takes an endpoint, year, week, and seasontype
# and returns a dataframe as output

get_cfb_data <- function(endpoint = "/games?",
                         year = "2019", 
                         week = "1", 
                         seasonType = "regular"){
  
  endpoint_path <- dplyr::case_when(
    endpoint == "games" ~ "/games?",
    endpoint == "drives" ~ "/drives?",
    endpoint == "plays" ~ "/plays?",
    endpoint == "lines" ~ "/lines?",
    TRUE ~ "~/games?"
    
  )
  
  year <- as.character(year)
  week <- as.character(week)
  seasonType <- as.character(seasonType)
  
  base_path <- "https://api.collegefootballdata.com"
  
  path <- paste0(base_path,endpoint_path,"year=",year,"&week=",week,"&seasonType=",seasonType)
  
  r <- httr::GET(url = path)
  
  r_content <- httr::content(r, "text")
  
  jsonlite::fromJSON(r_content)
  
}

some_data <- get_cfb_data(endpoint = "drives", 
                          year = 2018,
                          week = 6)



# Execution Function ------------------------------------------------------

payload_list <- list()

for (i in 1:14){
  payload_list[[i]] <- get_cfb_data(endpoint = "drives",
                                    year = 2018,
                                    week = i,
                                    seasonType = "regular")

  Sys.sleep(15)
}

payload <- purrr::map_df(payload_list, dplyr::bind_rows)
