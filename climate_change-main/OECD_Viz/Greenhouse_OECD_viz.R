library(plotly)
library(lubridate)
library(lazyeval)
library(tidyverse)


GH_data <- read_csv("./data/GH-data.csv")

m <- list(
  l = 50,
  r = 50,
  b = 100,
  t = 100,
  pad = 4
)


t1 <- list(
  color = "black",
  size = 20
)

#color = ~region, colors = c("orange", "darkolivegreen3"),

fig <- plot_ly(GH_data, x = ~ghg_cap, y = ~co2_total, 
               text = ~country,
               frame = ~year,
               type = 'scatter', mode = 'markers',
               size = ~ghg_total,
               color = ~status, colors = c("orange", "darkolivegreen3"),
               marker = list(sizemode = 'diameter',
                             opacity = 0.5),
               hovertemplate = paste(
                 "<b>%{text}</b><br><br>",
                 "%{yaxis.title.text}: %{y:}<br>",
                 "%{xaxis.title.text}: %{x:}<br>",
                 "Total Greenhouse Gas:", format(GH_data$ghg_total, nsmall=1,big.mark=","),
                 "<extra></extra>"))

fig <- fig %>% layout(title= list(text = "Greenhouse Gas Emissions Among Countries",
                                  font = t1), 
                     xaxis = list(title = 'Total Greenhouse Gas Emissions per capita'),
                     yaxis = list(title = 'Log(Total CO2 Emissions)'),
                     legend = list(title=list(text='<b> Status </b>')),
                     margin = m,
                     template = "plotly_dark") %>%
  animation_opts(
    2000, redraw = FALSE
  ) %>%
  animation_slider(
    currentvalue = list(prefix = "YEAR ", font = list(color="red"))
  )

fig

htmlwidgets::saveWidget(fig, "plotly.html")

