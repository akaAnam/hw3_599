# Load libraries required

library(threejs)
library(dplyr)
library(tidyr)
library(stringr)

# Read data from Berkeley Earth, exploring global temperatures since 1750. We're using the major cities subset.
# https://www.kaggle.com/datasets/berkeleyearth/climate-change-earth-surface-temperature-data

# Drop unnecessary variables and rename. 
df <- read.csv("./data/temperature.csv")
df <- df[ -c(1, 3, 5)]
colnames(df) <- c("avgtemp", "city", "lat", "long")
df <- na.omit(df)

# Get max change in avg temperature by city. 
groups <- df %>% select(avgtemp, city)

diff <- groups %>%
  group_by(city) %>%
  mutate(
    maxdiff = max(avgtemp, na.rm = T)) %>%
  arrange(city)
diff <- diff[, -1]
diff <- distinct(diff)
df <- merge(diff, df, all.x = TRUE)
df <- df[, -3]
df <- distinct(df)

# globejs plots latitude (neg = south, pos = north) and longitude (neg = west, pos = east)
df %>%
  separate(lat, 
           into = c("lat_d", "lat"), 
           sep = "(?<=[A-Za-z])(?=[0-9])"
  )
df$lat_d <- (str_extract(df$lat, "[aA-zZ]+"))
df$long_d <-(str_extract(df$long, "[aA-zZ]+"))

df$lat = as.numeric(substr(df$lat,1,nchar(df$lat)-1))
df$long = as.numeric(substr(df$long,1,nchar(df$long)-1))

df$lat <- with(df, ifelse(lat_d == 'S', -lat, lat))
df$long <- with(df, ifelse(long_d == 'W', -long, long))


# Set colors on a scale of 1 to 10 by percentile.

colors = as.numeric(cut(df$maxdiff,
                        breaks = quantile(df$maxdiff, probs = seq(0, 1, 0.1),
                                          include.lowest = TRUE, na.rm = TRUE)))

ncolors <- 10
my_palette <- grDevices::colorRampPalette(c("green","yellow", "red"))(ncolors)

my_df <- data.frame(value=df$maxdiff_pct, color=my_palette[cut(df$maxdiff_pct,ncolors)])

# Plot values via percentile to show contrast
df$maxdiff_pct <- ecdf(df$maxdiff)(df$maxdiff)

globejs(lat = df$lat,
        long = df$long,
        val = df$maxdiff_pct*50,
        # val = 2 * log(df$maxdiff),
        color = my_df$color,
        pointsize = .6,
        atmosphere = TRUE)