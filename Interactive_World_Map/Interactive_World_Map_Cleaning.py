import numpy as np
import pandas as pd
import plotly as py
import plotly.express as px
import plotly.graph_objs as go
from plotly.subplots import make_subplots
from plotly.offline import download_plotlyjs, init_notebook_mode, plot, iplot


df = pd.read_csv("World_Temp/GlobalLandTemperaturesByCountry.csv")
df = df.drop("AverageTemperatureUncertainty", axis=1)

df = df.rename(columns={'dt':'Date'})
df = df.rename(columns={'AverageTemperature':'AvTemp'})

df = df.dropna()

df_countries = df.groupby(['Country', 'Date']).sum().reset_index().sort_values('Date', ascending=False)




#Manipulating the original dataframe
df_countrydate = df_countries.groupby(['Date','Country']).sum().reset_index()

start_date = '1885-01-01'
end_date = '2013-04-01'

mask = (df_countries['Date'] > start_date) & (df_countries['Date'] <= end_date)

df_countries = df_countries.loc[mask]

print(df_countries.head(10))

#Manipulating the original dataframe
df_countrydate = df_countries.groupby(['Date','Country']).sum().reset_index()


#Rounding AverageTemperature
df_countrydate['AvTemp'] = df_countrydate['AvTemp'].round(1)

#Change Column Name
df_countrydate.rename(columns={'AvTemp': 'Average Temp in C'}, inplace=True)

print(df_countrydate)



#Creating the visualization
#Link: https://plotly.com/python/choropleth-maps/
fig = px.choropleth(df_countrydate,
locations="Country",
locationmode = "country names",
color="Average Temp in C",
hover_name="Country",
animation_frame="Date", 
color_continuous_scale=px.colors.diverging.Geyser,
range_color=[-10,35]
)

#Layout
fig.update_layout(
title_text = 'Average Temperature Change (1885 - 2013)',
title_x = 0.5,
xaxis=dict(tickformat="%d-%m"),
geo=dict(
showframe = False,
showcoastlines = False
))

fig.show()

fig.write_html("world_temperature.html")
