
#devtools::install_github("hrbrmstr/streamgraph")

# Library
library(streamgraph)
library(reshape)


data = read.csv(file = "renewablePowerGeneration97-17.csv")
data <- melt(data, id=c("Year"))

data$variable <- as.character(data$variable)
data$variable[data$variable == "Hydro.TWh."] <- "Hydropower Energy (TWh)"
data$variable[data$variable == "Biofuel.TWh."] <- "Biofuel Energy (TWh)"
data$variable[data$variable == "Solar.PV..TWh."] <- "Solarpower Energy (TWh)"
data$variable[data$variable == "Geothermal..TWh."] <- "Geothermal Energy (TWh)"



summary(data)
# Stream graph with a legend
pp <- streamgraph(data, key="variable", value="value", date="Year", height="300px", width="1000") %>%
  sg_legend(show=TRUE, label="Energy type: ")%>%
  sg_axis_x(1, "year", "%Y")%>%
  sg_fill_brewer("PuOr")
pp

