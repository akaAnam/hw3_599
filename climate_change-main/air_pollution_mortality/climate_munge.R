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





# Munging: GHG and CO2 datasets first (1 & 2)

# Reading in CSV 
GHG <- read.csv("./data/GHG_by_Sector_Perc.csv")
CO2 <- read.csv("./data/CO2_Emissions.csv")



# remove unnecessary rows and columns
GHG <- GHG[-1,]
CO2 <- CO2[-1,-c(3,5,7)]

# Changing column names 
ghg_colnames <- c("country", "last_year_available", "total_ghg", "energy", "transport from energy", 
                  "industrial", "agriculture", "waste")
colnames(GHG) <- ghg_colnames

co2_colnames <- c("country","total_co2", "perc_change_since_1990", "co2_per_capita", "co2_per_km_sq")
colnames(CO2) <- co2_colnames

# replacing "..." with NA
GHG[GHG == "..."] <- NA
CO2[CO2 == "..."] <- NA

# Identifying countries with NA data
GHG <- GHG[-which(is.na(GHG$last_year_available)),]

colSums(is.na(GHG)) # don't have as much data on GHG by Industrial Sector 

# Identifying the range of years available 
GHG$last_year_available <-  unlist(lapply(GHG$last_year_available, as.character))
min(as.numeric(GHG$last_year_available))
max(as.numeric(GHG$last_year_available))



# Tidy Format 
# Created a sector column anda  percentage column
tidy_GHG <- GHG %>% pivot_longer(cols = c("energy","transport from energy","industrial", "agriculture", "waste"), 
                     names_to = "sector", values_to = "percentage")

# ----
# *Note to group members* NAs were left in the datasets, not replaced with ""

write.csv(tidy_GHG,"data/munged_GHG_by_Sector.csv")
write.csv(CO2,"data/munged_CO2.csv")





# Munging: ambient air AND household pollution (3)

air_hh <- read.csv("data/ambient_and_household_air_pollution_deaths.csv")

# get only the age standardized data 
table(air_hh$IndicatorCode) # age standardized code - SDGAIRBODA
air_hh <- air_hh[air_hh$IndicatorCode == "SDGAIRBODA", ]

# remove unecessary columns 
air_hh.remove <- c(1:4,6:7,9,11:12,14,15,18:23,25:26,28,31:34)
air_hh <- air_hh[-air_hh.remove]

# column names 
air_hh.colnames <- c("parent_location", "country", "year", "sex","cause", "cause_indicator",
                     "ambient and household", "ambient_hh_low", "ambient_hh_high", "total_value")
colnames(air_hh) <- air_hh.colnames

# all the years are 2016. removing year column
table(air_hh$year)
air_hh <- air_hh[-3]

# the last column just summarizes the other 3 value columns. Removing last col 
air_hh <- air_hh[-9]
head(air_hh)

# getting the DF in alpha order by parent location & country
air_hh <- air_hh[order(air_hh$parent_location, air_hh$country),]

# duplicate rows when cause column = total. removing blank duplicate rows
table(air_hh$cause)
air_hh <- air_hh[!air_hh$cause == "",]



# Munging: ambient ONLY air pollution (4)

air <- read.csv("data/only_ambient_air_pollution_deaths.csv")

# remove unecessary columns 
air <- air[-air_hh.remove]

# column names 
air.colnames <- c("parent_location", "country", "year", "sex","cause", "cause_indicator",
                     "ambient", "ambient_low", "ambient_high", "total_value")
colnames(air) <- air.colnames

# all the years are 2016. removing year column
table(air$year)
air <- air[-3]

# the last column just summarizes the other 3 value columns. Removing last col 
air <- air[-9]
head(air)

# getting the DF in alpha order by parent location & country
air <- air[order(air$parent_location, air$country),]

# merging the ambient air pollution ONLY and the ambient and household air pollution DFs
air <- left_join(air, air_hh)


# calculating values for only household air pollution
air$household <- air$`ambient and household` - air$ambient
air$household_low <- air$ambient_hh_low - air$ambient_low
air$household_high <- air$ambient_hh_high - air$ambient_high

# tidying the data 
air <- air %>% pivot_longer(cols = c("ambient","ambient and household","household"), 
                                 names_to = "pollution_type", values_to = "value")

air$low_value <- 0
air$high_value <- 0

air$low_value[air$pollution_type == "ambient"] <- air$ambient_low[air$pollution_type == "ambient"]
air$high_value[air$pollution_type == "ambient"] <- air$ambient_high[air$pollution_type == "ambient"]

air$low_value[air$pollution_type == "ambient and household"] <- air$ambient_hh_low[air$pollution_type == "ambient and household"]
air$high_value[air$pollution_type == "ambient and household"] <- air$ambient_hh_high[air$pollution_type == "ambient and household"]

air$low_value[air$pollution_type == "household"] <- air$household_low[air$pollution_type == "household"]
air$high_value[air$pollution_type == "household"] <- air$household_high[air$pollution_type == "household"]

# remove uneccessary columns 
air <- air[-c(6:11)]


write.csv(air, "data/munged_air_pollution_deaths.csv")
