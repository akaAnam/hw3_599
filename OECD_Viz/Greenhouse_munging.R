##### ANLY503 Project #####
# Dataset: Greenhouse Gas Emissions
# https://stats.oecd.org/Index.aspx?DataSetCode=AIR_GHG

library(tidyverse)
library(lubridate)
library(plotly)

# Load data ---------------------------
df_GG <- read_csv("./data/Greenhouse.csv")

# Data preparation -------------------------------
# replace the blank space or special character in column names with underscore
df_GG <- df_GG %>%
  select_all(~ gsub("\\s+|\\.", "_", .)) %>%
  select_all(tolower)

df_GG_1 <- df_GG %>%
  filter(pol == "GHG" | pol == "CO2") %>%
  filter(var == "TOTAL" | var == "GHG_CAP") %>%
  filter(!str_detect(country, "OECD")) %>%
  filter(!str_detect(country, "European")) %>%
  select(c(country, pol, var, year, value))

df_GG_2 <- df_GG_1 %>% mutate(variable = paste(pol, var, "_")) %>%
  select(-c(pol, var)) %>%
  pivot_wider(names_from = variable, values_from = value)

df_GG_2 <- df_GG_1 %>%
  group_by(country, pol, var) %>%
  top_n(1, year) %>%
  group_by(country) %>%
  mutate(row_count = nrow(across(everything()))) %>%
  filter(row_count == 3) %>%
  select(-c(year, row_count)) %>%
  mutate(variable = paste(pol, var, "_")) %>%
  select(-c(pol, var)) %>%
  pivot_wider(names_from = variable, values_from = value)

# rename the column names for better understanding
colnames(df_GG_2) <- c("country", "year", "ghg_total", "ghg_cap", "co2_total")

# edit country name for better visualization
df_GG_2$country[df_GG_2$country == "China (People's Republic of)"] <- "China"

df_GG_2$country <- as.factor(df_GG_2$country)

df_GG_3 <- df_GG_2 %>% mutate(status = case_when(
  country %in% c("Argentina", "China", "Brazil", "India",
                 "Singapore", "South Africa", "Thailand",
                 "Saudi Arabia", "Indonesia") ~ "Non-OECD",
  TRUE ~ "OECD"
))

# add OECD status
df_GG_1 <- as.data.frame(df_GG_1)
df_GG_2 <- df_GG_1 %>%
  mutate(id = row_number()) %>%
  mutate(region = case_when(
    id <= 33 ~ "OECD",
    id %in% c(35:37, 40:41) ~ "OECD",
    id %in% c(34, 38:39, 42:46) ~ "Non-OECD",
  )) %>%
  select(-c(id))

# export the final dataset
write.csv(df_GG_3, "./data/GH-data.csv", row.names = FALSE)
