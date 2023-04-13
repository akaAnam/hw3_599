import altair as alt
from vega_datasets import data
import numpy as np
import pandas as pd



df = pd.read_csv("GlobalLandTemperaturesByCountry.csv")



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

#Manipulating the original dataframe
df_countrydate = df_countries.groupby(['Date','Country']).sum().reset_index()


#Rounding AverageTemperature
df_countrydate['AvTemp'] = df_countrydate['AvTemp'].round(1)

#Change Column Name
df_countrydate.rename(columns={'AvTemp': 'Average Temp in C'}, inplace=True)


df_countrydate['Date'] = pd.to_datetime(df_countrydate.Date)


df_countrydate['year'] = df_countrydate['Date'].dt.year


df_countrydate = df_countrydate.groupby(['Country','year']).mean()
df_countrydate.reset_index(inplace=True)

#Rounding AverageTemperature
df_countrydate['Average Temp in C'] = df_countrydate['Average Temp in C'].round(1)

print(df_countrydate)

df_countrydate_high = df_countrydate.nlargest(2499, ['Average Temp in C'])
df_countrydate_low = df_countrydate.nsmallest(2499, ['Average Temp in C'])


df_temp = [df_countrydate_high, df_countrydate_low]#
df_temp = pd.concat(df_temp).reset_index(drop=True)

df_temp = df_temp.iloc[::80, :]





interval = alt.selection_interval()



points = alt.Chart(df_temp).mark_point().encode(
  x='year:N',
  y='Average Temp in C:Q',
  color=alt.condition(interval, 'Country:N', alt.value('lightgray'))
).properties(
  selection=interval
)

histogram = alt.Chart(df_temp).mark_bar().encode(
  x='Average Temp in C:Q',
  y='Country:N',
  color='Country'
).transform_filter(interval)

(points&histogram).save("two_view.html")

alt.vconcat(points, histogram, data=df_temp).show()
