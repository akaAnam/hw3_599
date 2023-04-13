#install.packages("dygraphs")

#Reference: https://rstudio.github.io/dygraphs/

library(dygraphs)
library(dplyr)


data = read.csv("Continent_Consumption_TWH.csv")

data = data %>%
  select(-c('OECD',"BRICS", "CIS"))

names(data)[names(data) == "North.America"] <- "North America"
names(data)[names(data) == "Latin.America"] <- "Latin America"
names(data)[names(data) == "North.America"] <- "North America"
names(data)[names(data) == "Middle.East"] <- "Middle East"


dygraph(data, main = "Total Energy Conumption of the Globe", ) %>%
  dyRangeSelector(height = 40) %>%
  dyOptions(colors = RColorBrewer::brewer.pal(8, "Set2"), stackedGraph = TRUE, axisLineWidth = 1.5)%>%
  dyAxis("y", label = "(TWh)") %>%
  dyAxis("x", label = "Years")

