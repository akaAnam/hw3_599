# libraries 
library(tidyverse)
library(dplyr)
library(ggplot2)

# Datasets: United Nations Statistics Division (UNSD) 
# Link: https://unstats.un.org/unsd/envstats/qindicators.cshtml
# -----
#   1. Green House Gas Emissions by Sector (% values)
#       total col = million tonnes of CO2 Equivalent 
#   2. CO2 Emmissions (for the year 2011)


# Datasets: World Health Organization (WHO) 
# Link: https://www.who.int/data/gho/data/indicators/indicator-details/GHO/ambient-and-household-air-pollution-attributable-death-rate-(per-100-000-population-age-standardized)
# -----
#   3. Ambient and Household Air pollution attributable death rate (per 100,000 people) - age standardized
#       dataset also has age un-standardized but I'm going to remove that 
#   4. Ambient Air pollution attributable death rate (per 100,000 people) - age standardized
#       Ambient air pollution only 




# ANAM - working on some general EDA for air pollution 




# Reading munged CSVs from "climate_munge.R"
air <- read.csv("data/munged_air_pollution_deaths.csv")




