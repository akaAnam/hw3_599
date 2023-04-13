# libraries 
library(tidyverse)
library(dplyr)
library(ggplot2)
library(plotly)

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





# Reading munged CSVs from "climate_munge.R"
air <- read.csv("./data/munged_air_pollution_deaths.csv")


## ----------------------------------------
## MORTALITY BY CAUSE OF DEATH & POLLU TYPE
## ----------------------------------------

# number of unique countries 
length(unique(air$country))

us.air <- air[air$country == "United States of America" &
                air$cause != "Total",]
us.air <- us.air[us.air$pollution_type != "ambient and household" ,]

china.air <- air[air$country == "China"  &
                   air$cause != "Total",]

china.air <- china.air[china.air$pollution_type != "ambient and household" ,]

india.air <- air[air$country == "India"  &
                             air$cause != "Total",]

india.air <- india.air[india.air$pollution_type != "ambient and household" ,]


## SHORTHANDS:
# ------------------------------------------------------
##    COPD - chronic obstructive pulmonary disease
##    IHD - ischaemic heart disease
##    LRI - Lower Respiratory Infection
##    Stroke
##    T,B,Lung Cancers - Trachea, Bronchus, Lung Cancers
# ------------------------------------------------------

us.cause_type <- ggplot(us.air, aes(x=cause, y=value, fill=pollution_type))+
  geom_bar(position="stack", stat="identity") +
  facet_grid(~ sex) +
  theme(axis.text.x = element_text(angle = 90)) +
  scale_x_discrete(labels = c("COPD", "IHD", "LRI", "Stroke", "T,B,Lung Cancers"))+
  ggtitle("US Mortality Rate Attributable to Air Pollution by Type (2016)")

china.cause_type <- ggplot(china.air, aes(x=cause, y=value, fill=pollution_type))+
  geom_bar(position="stack", stat="identity") +
  facet_grid(~ sex) +
  theme(axis.text.x = element_text(angle = 90)) +
  scale_x_discrete(labels = c("COPD", "IHD", "LRI", "Stroke", "T,B,Lung Cancers"))+
  ggtitle("China Mortality Rate Attributable to Air Pollution by Type (2016)")


india.cause_type <- ggplot(india.air, aes(x=cause, y=value, fill=pollution_type))+
  geom_bar(position="stack", stat="identity") +
  facet_grid(~ sex) +
  theme(axis.text.x = element_text(angle = 90)) +
  scale_x_discrete(labels = c("COPD", "IHD", "LRI", "Stroke", "T,B,Lung Cancers"))+
  ggtitle("India Mortality Rate Attributable to Air Pollution by Type (2016)")


china.cause_type
india.cause_type
us.cause_type

## -----------
## PLOTLY EDA 
## -----------


########################
## Stacked + grouped BAR
########################

# CHINA 
# ----------

china.both_sexes <- china.air %>% filter(sex == "Both sexes") %>%
  group_by(pollution_type) %>%
  arrange(pollution_type) %>%
  plot_ly(
    x= ~cause,
    y= ~value,
    color = ~pollution_type,
    colors = "Purples",
    type = "bar",
    legendgroup = ~pollution_type) %>%
  layout(xaxis = list(
    title = "Both Sexes",
    ticktext = list("COPD", "IHD", "LRI", "Stroke", "T,B,LC"),
    tickvals = list(0,1,2,3,4),
    tickmode = "array"))

china.female <- china.air %>% filter(sex == "Female") %>%
  group_by(pollution_type) %>%
  arrange(pollution_type) %>%
  plot_ly(
    x= ~cause,
    y= ~value,
    color = ~pollution_type,
    colors = "Reds",
    type = "bar",
    legendgroup = ~pollution_type,
    showlegend = F) %>%
  layout(xaxis = list(
    title = "Female",
    ticktext = list("COPD", "IHD", "LRI", "Stroke", "T,B,LC"),
    tickvals = list(0,1,2,3,4),
    tickmode = "array"))


china.male <- china.air %>% filter(sex == "Male") %>%
  group_by(pollution_type) %>%
  arrange(pollution_type) %>%
  plot_ly(
    x= ~cause,
    y= ~value,
    color = ~pollution_type,
    colors = "Blues",
    type = "bar",
    legendgroup = ~pollution_type,
    showlegend = F) %>%
  layout(xaxis = list(
    title = "Male",
    ticktext = list("COPD", "IHD", "LRI", "Stroke", "T,B,LC"),
    tickvals = list(0,1,2,3,4),
    tickmode = "array"))

# Plot all 3 china plots on the same subplot 
china.cause_type.plotly <- subplot(china.both_sexes, china.female, china.male,
        titleX = T, shareY = T) %>%
  layout(barmode = 'stack', showlegend = TRUE,
         title = "China Mortality Rate Attributable to Air Pollution by Type (2016)",
         legend=list(title = list(text = "<b> Pollution Type <b>")))


# INDIA 
# ----------

india.both_sexes <- india.air %>% filter(sex == "Both sexes") %>%
  group_by(pollution_type) %>%
  arrange(pollution_type) %>%
  plot_ly(
    x= ~cause,
    y= ~value,
    color = ~pollution_type,
    colors = "Purples",
    type = "bar",
    legendgroup = ~pollution_type) %>%
  layout(xaxis = list(
    title = "Both Sexes",
    ticktext = list("COPD", "IHD", "LRI", "Stroke", "T,B,LC"),
    tickvals = list(0,1,2,3,4),
    tickmode = "array"))

india.female <- india.air %>% filter(sex == "Female") %>%
  group_by(pollution_type) %>%
  arrange(pollution_type) %>%
  plot_ly(
    x= ~cause,
    y= ~value,
    color = ~pollution_type,
    colors = "Reds",
    type = "bar",
    legendgroup = ~pollution_type,
    showlegend = F) %>%
  layout(xaxis = list(
    title = "Female",
    ticktext = list("COPD", "IHD", "LRI", "Stroke", "T,B,LC"),
    tickvals = list(0,1,2,3,4),
    tickmode = "array"))


india.male <- india.air %>% filter(sex == "Male") %>%
  group_by(pollution_type) %>%
  arrange(pollution_type) %>%
  plot_ly(
    x= ~cause,
    y= ~value,
    color = ~pollution_type,
    colors = "Blues",
    type = "bar",
    legendgroup = ~pollution_type,
    showlegend = F) %>%
  layout(xaxis = list(
    title = "Male",
    ticktext = list("COPD", "IHD", "LRI", "Stroke", "T,B,LC"),
    tickvals = list(0,1,2,3,4),
    tickmode = "array"))

# Plot all 3 INDIA plots on the same subplot 
india.cause_type.plotly <- subplot(india.both_sexes, india.female, india.male,
                                   titleX = T, shareY = T) %>%
  layout(barmode = 'stack', showlegend = TRUE,
         title = "India Mortality Rate Attributable to Air Pollution by Type (2016)",
         legend=list(title = list(text = "<b> Pollution Type <b>")))


# USA 
# ----------

us.both_sexes <- us.air %>% filter(sex == "Both sexes") %>%
  group_by(pollution_type) %>%
  arrange(pollution_type) %>%
  plot_ly(
    x= ~cause,
    y= ~value,
    color = ~pollution_type,
    colors = "Purples",
    type = "bar",
    legendgroup = ~pollution_type) %>%
  layout(xaxis = list(
    title = "Both Sexes",
    ticktext = list("COPD", "IHD", "LRI", "Stroke", "T,B,LC"),
    tickvals = list(0,1,2,3,4),
    tickmode = "array"))

us.female <- us.air %>% filter(sex == "Female") %>%
  group_by(pollution_type) %>%
  arrange(pollution_type) %>%
  plot_ly(
    x= ~cause,
    y= ~value,
    color = ~pollution_type,
    colors = "Reds",
    type = "bar",
    legendgroup = ~pollution_type,
    showlegend = F) %>%
  layout(xaxis = list(
    title = "Female",
    ticktext = list("COPD", "IHD", "LRI", "Stroke", "T,B,LC"),
    tickvals = list(0,1,2,3,4),
    tickmode = "array"))


us.male <- us.air %>% filter(sex == "Male") %>%
  group_by(pollution_type) %>%
  arrange(pollution_type) %>%
  plot_ly(
    x= ~cause,
    y= ~value,
    color = ~pollution_type,
    colors = "Blues",
    type = "bar",
    legendgroup = ~pollution_type,
    showlegend = F) %>%
  layout(xaxis = list(
    title = "Male",
    ticktext = list("COPD", "IHD", "LRI", "Stroke", "T,B,LC"),
    tickvals = list(0,1,2,3,4),
    tickmode = "array"))

# Plot all 3 US plots on the same subplot 
us.cause_type.plotly <- subplot(us.both_sexes, us.female, us.male,
                                   titleX = T, shareY = T) %>%
  layout(barmode = 'stack', showlegend = TRUE,
         title = "US Mortality Rate Attributable to Air Pollution by Type (2016)",
         legend=list(title = list(text = "<b> Pollution Type <b>"))
         )

china.cause_type.plotly
india.cause_type.plotly
us.cause_type.plotly



#########
## BUBBLE 
#########

# We want all countries, cause = total (all deaths), Both sexes, and both 
#   ambient and household pollution types 

air.bubble0 <- air %>% filter(cause == "Total") %>%
  filter(sex == "Both sexes") %>%
  filter(pollution_type == "ambient and household")

# order the data frame by highest values 
air.bubble0 <- air.bubble0[rev(order(air.bubble0["value"])), ]

# get the top 50 countries 
top50 <- head(air.bubble0$country, 183)

air.bubble <- air %>% filter(cause == "Total") %>%
  filter(pollution_type == "ambient and household")

# subset the bubble DF to only contain data for top 50 countries
air.bubble <- air.bubble[air.bubble$country %in% top50, ]
air.bubble <- air.bubble[order(air.bubble$country), ]

# get relevent data columns 
bubble.female <- air.bubble$value[air.bubble$sex == "Female"]
bubble.male <- air.bubble$value[air.bubble$sex == "Male"]
bubble.bothsexes <- air.bubble$value[air.bubble$sex == "Both sexes"]
bubble.country <- unique(air.bubble$country)

# create a new DF for bubble chart
air.bubble <- data.frame(bubble.country, bubble.bothsexes, bubble.female, bubble.male)

# Note to TA - can disregard the commented code below, I was playing around with appearance 
# plot
# --------
# fig.bubble <- plot_ly(air.bubble, x = ~bubble.female, y = ~bubble.male,
#                       type = 'scatter', mode = 'markers',
#                size = ~bubble.bothsexes, color = ~bubble.country, 
#                colors = 'Paired',     # change to "Paired" for 1 color per country 
#                sizes = c(10, 80),
#                marker = list(opacity = 0.5, sizemode = 'diameter'),
#                hoverinfo = 'text',
#                text = ~paste(bubble.country, '<br>Total Mortality:', bubble.bothsexes))
# fig.bubble <- fig.bubble %>% layout(title = 'Total Mortality Rate Attributable to Air Pollution by Country',
#                       xaxis = list(showgrid = FALSE),
#                       yaxis = list(showgrid = FALSE),
#                       showlegend = FALSE)
# 
# fig.bubble
# air.bubble$thirty = NA
# air.bubble$fifty = NA
# air.bubble$hundred = NA
# 
# test <- air.bubble %>% 
#   arrange(desc(bubble.bothsexes)) %>%
#   slice(1:30) 
# 
# air.bubble$thirty <- ifelse (air.bubble$bubble.country %in% test$bubble.country,  1, 0)
# 
# test2 <- air.bubble %>% 
#   arrange(desc(bubble.bothsexes)) %>%
#   slice(1:50) 
# 
# air.bubble$fifty <- ifelse (air.bubble$bubble.country %in% test2$bubble.country,  1, 0)
# 
# test3 <- air.bubble %>% 
#   arrange(desc(bubble.bothsexes)) %>%
#   slice(1:150) 
# 
# air.bubble$hundred <- ifelse (air.bubble$bubble.country %in% test3$bubble.country,  1, 0)
# --------


## DROPDOWN for BUBBLE 
# ----------

fig = plot_ly()

fig = fig %>% add_trace(data =  air.bubble %>% 
                          arrange(desc(bubble.bothsexes)) %>%
                          slice(1:30) ,
                        x = ~bubble.female, y = ~bubble.male,
                        type = 'scatter', mode = 'markers',
                        size = ~bubble.bothsexes, color = ~bubble.country, 
                        colors = 'Paired',     # change to "Paired" for 1 color per country 
                        sizes = c(10, 80),
                        marker = list(opacity = 0.5, sizemode = 'diameter'),
                        hoverinfo = 'text',
                        text = ~paste(bubble.country, '<br>Total Mortality:', bubble.bothsexes),
                        visible = T)

fig = fig %>% add_trace(data =   air.bubble %>% 
                          arrange(desc(bubble.bothsexes)) %>%
                          slice(1:50) ,
                        x = ~bubble.female, y = ~bubble.male,
                        type = 'scatter', mode = 'markers',
                        size = ~bubble.bothsexes, color = ~bubble.country, 
                        colors = 'Paired',     # change to "Paired" for 1 color per country 
                        sizes = c(10, 80),
                        marker = list(opacity = 0.5, sizemode = 'diameter'),
                        hoverinfo = 'text',
                        text = ~paste(bubble.country, '<br>Total Mortality:', bubble.bothsexes),
                        visible = F)


fig = fig %>% add_trace(data =   air.bubble %>% 
                          arrange(desc(bubble.bothsexes)) %>%
                          slice(1:100) ,
                        x = ~bubble.female, y = ~bubble.male,
                        type = 'scatter', mode = 'markers',
                        size = ~bubble.bothsexes, color = ~bubble.country, 
                        colors = 'Paired',     # change to "Paired" for 1 color per country 
                        sizes = c(10, 80),
                        marker = list(opacity = 0.5, sizemode = 'diameter'),
                        hoverinfo = 'text',
                        text = ~paste(bubble.country, '<br>Total Mortality:', bubble.bothsexes),
                        visible = F)



fig %>% layout(title = 'Total Mortality Rate Attributable to Air Pollution by Country',
               showlegend = FALSE,
               xaxis = list(title = "Female death rate (per 100,000 people)", size=8,
                            domain = c(0.05, 1), showgrid = FALSE),
               yaxis = list(title = "Male death rate (per 100,000 people)", showgrid = FALSE),
      
               updatemenus = list(
                 list(
                   y = 0.7,
                   buttons = list(
                     
                     list(method = "update",
                          args = list(list(visible = c(TRUE, FALSE, FALSE))),
                          label = "Top 30 Countries"),
                     
                     list(method = "restyle",
                          args = list(list(visible = c(FALSE, TRUE, FALSE))),
                          label = "Top 50 Countries"),
                     
                     list(method = "restyle",
                          args = list(list(visible = c(FALSE, FALSE, TRUE))),
                          label = "Top 150 Countries")
                     ))))


