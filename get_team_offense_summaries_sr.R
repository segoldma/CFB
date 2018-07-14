library(rvest)
library(dplyr)
library(magrittr)

## Get team offense stats from SR
team_offense <- read_html("https://www.sports-reference.com/cfb/years/2017-team-offense.html") %>% 
  html_nodes("#offense") %>% 
  html_table(fill = TRUE) %>% 
  as.data.frame() 

## Rename Columns
headers <- c("Rank","School","Games","Pts", "Pass.Cmp", "Pass.Att", "Pass.Pct",
             "Pass.Yds", "Pass.Tds", "Rush.Att", "Rush.Yds", "Rush.Avg", "Rush.Tds",
             "Tot.Plays","Tot.Yds","Tot.Avg", "First.Down.Pass", "First.Down.Rush",
             "First.Down.Pen", "First.Down.Tot", "Penalty.Num","Penalty.Yds", 
             "Turnover.Fum", "Turnover.Int", "Turnover.Tot")

colnames(team_offense) <- headers

## Remove original columns in row 2, and table divider rows
team_offense <- team_offense %>% 
  slice(-1) %>% 
  filter(!School == "School" & !School == "")


## Summarise the team offense table
summary(team_offense)

## Update most columns to numeric
team_offense %<>% mutate_at(c(1,3:25), funs(as.double(.)))
