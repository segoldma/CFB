library(rvest)
library(dplyr)
library(lubridate)

# Function: getOffensiveGamelogs ------------------------------------------
# Takes two arguments: team_name and year.
# Returns a dataframe with the team's offensive gamelog for that year, and saves it to the global environment.
# Game logs don't seem to be available prior to the 2000 season

getOffensiveGamelogs <- function(team_name,year = lubridate::year(lubridate::now())){
  team_name <- as.character(team_name)
  year <- as.character(year)
  
  if (year < 2000){ stop(message("Please try with the 2000 season or later"))}
  
  gamelogs_offense <- read_html(paste("https://www.sports-reference.com/cfb/schools",team_name,year,"gamelog/", sep = "/")) %>% 
    html_nodes("#offense") %>% 
    html_table(fill = TRUE) %>% 
    as.data.frame()
  
  colnames(gamelogs_offense) <- c("Rank", "Date","School","Opponent","Result", "Pass.Cmp", "Pass.Att", "Pass.Pct",
                                  "Pass.Yds", "Pass.Tds", "Rush.Att", "Rush.Yds", "Rush.Avg", "Rush.Tds",
                                  "Tot.Plays","Tot.Yds","Tot.Avg", "First.Down.Pass", "First.Down.Rush",
                                  "First.Down.Pen", "First.Down.Tot", "Penalty.Num","Penalty.Yds", 
                                  "Turnover.Fum", "Turnover.Int", "Turnover.Tot")
  
  gamelogs_offense <- gamelogs_offense %>% 
    filter(!Opponent %in% c("","Opponent"))
  
  assign(x = paste("gamelogs_offense",team_name,year,sep = "-"),gamelogs_offense, envir = .GlobalEnv)
  
}

# Test it out
getOffensiveGamelogs("maryland",2001)
