library(tidyverse)

# link: https://xang1234.github.io/chorddiagrams/

migration_data <- read_csv("migration_data.csv")

migration_data$region_orig <- as.factor(migration_data$region_orig)
migration_data$country_orig <- as.factor(migration_data$country_orig)
migration_data$region_dest <- as.factor(migration_data$region_dest)
migration_data$country_dest <- as.factor(migration_data$country_dest)


# 2005 
migration_data<- migration_data %>% select(country_orig, country_dest, region_orig, region_dest,countryflow_2005 )

library(chorddiag)

#choosing only top 200,000 contries which have flow
migration_data_flow<-migration_data %>% filter(countryflow_2005>=200000)

migration_data_flow<-as.matrix(as_adjacency_matrix(as_tbl_graph(migration_data_flow),attr = "countryflow_2005"))


chorddiagram<-chorddiagramdiag(data = migration_data_flow,
                 groupnamePadding = 10,
                 groupPadding = 4,
                 groupnameFontsize = 12 ,
                 showTicks = FALSE,
                 margin=150
)
chorddiagram
