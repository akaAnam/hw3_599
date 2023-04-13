---
title: "Globe, World Temperature Slider, Interactive Scatter/Histogram plot, and Heat Map markdown"
output: 
  html_notebook:
    pandoc_args: [
      "--number-offset=1,0"
      ]
    fig_caption: true
    number_sections: yes
    toc: yes
    toc_depth: 3
editor_options: 
  chunk_output_type: inline
---

## World Temperature Slider

<img src="global_temperature.png">

This graph, designed in plotly via Python, depicts the overall temperatures of countries across the world. The uniqueness of this graph comes from the slider underneath, which allows the users to slide across the various years from 1885 - 2013. This graph is also animated, as once you open index.html it'll automatically allow the transition between the years to happen. Another interesting design perspective chosen here, is the color scheme. We chose a very unique color scheme of red-pallets which will allow the readers to immediately identify which countries are hot, moderate, or cold in a given year. We felt that this color scheme best impacts the map, giving it a fresh and vibrant feel (as compared to the ones that are readily available online).

[World Temperature Slider - Data Source](https://www.kaggle.com/datasets/berkeleyearth/climate-change-earth-surface-temperature-data
)


## Interactive Scatter/Histogram 

<img src="innovative_view1.png">

The interactive scatter plot and histogram serves as the main crux for understanding this project. The basic design principle of the intertwined graph is the ability to select various points on the scatter plot, which represent the countries across the years along with the average temperature, and seeing the changes being done to the histogram. The changes on the histogram will directly correlate to what points are being chosen and will give the viewers a first hand feel and experience to compare how the different countries compare to each other instead of just a table (or a line graph per se).

This view focuses on interaction via data abstraction on the plot and derives a new data frame which the users can utilize. The scales are dynamically changing along with the colors chosen via the country. This graph will ultimately combine with the 3D world mock up to give a new and refreshing user experienced focus data visualization for our final project.

[Interactive Scatter/Histogram  - Data Source](https://www.kaggle.com/datasets/berkeleyearth/climate-change-earth-surface-temperature-data
)
 
## Heat Map

<img src="heatmap.png">

The interactive heat map was achieved via the visualization tools within JavaScript and D3. The main focus of this was to get a unique perspective on understanding how the global temperatures varies across the years in color. The unique color schemes gives the audience an underlying feel of being cognizant of what times of the year the temperatures are the highest and lowest globally. The unique design choice here was just the ethos of a plain and simple graph coupled with hover of the date (month,year), temperature, and the variance of the temperature. However simple it may be and coupled with the world temperature by country slider graph, gives the reader a true understanding of how the Earth is getting warmer.

[Heat Map  - Data Source](https://github.com/freeCodeCamp/ProjectReferenceData)


## Globe Visualization

<img src="innovative_view2.png">

The globe plot visualization displays the maximum change in temperature in the last three hundred years for over a hundred cities across the globe. The plot was built using threejs, and allows the end-user to swivel, zoom, and pan across the globe at will to investigate the change in temperature by city. The three-dimensional nature of the globe allows the end-user to see the impacts of climate change at the scale they’re most interested in. The globejs function from threejs allows easy, repeatable three-dimensional plotting of any value given that a dataset contains a accompanying latitude, longitude, and value object for the plot they wish to create. 

[Globe Visualization  - Data Source](https://www.kaggle.com/datasets/berkeleyearth/climate-change-earth-surface-temperature-data
)
