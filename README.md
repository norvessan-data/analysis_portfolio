
# Project 1: Austria Inflation Analysis

## Project background
Eurostat, the statistical office of the European Union, provides plenty of high-quality data on various topics. 
Driven by an interest in Austria’s inflation trends, I collected and analyzed data on inflation in Austria for the years 2016–2024 to uncover insights into how prices
evolved over these years.

Insights are provided in the following key areas:

- Overall HICP Dynamics: Examination of the Harmonised Index of Consumer Prices (HICP) with a focus on year-over-year (YoY) changes. 
Particular attention is given to periods of sharp increases in the index to highlight inflationary spikes over time.
- Category-Level Inflation and Contributions: Detailed analysis of individual goods categories, combining their YoY price index changes with weighted contributions to overall inflation. 
This approach makes it possible to identify which categories were the main drivers of inflation and, consequently, which groups of people are most likely to be affected during the period.
  
  
An interactive Power BI report can be viewed [here]([https://app.powerbi.com/view?r=eyJrIjoiNGJiOGYwZTEtMTYwYi00MjZhLTllYWQtNWJiZDVmNWQ4NTBhIiwidCI6IjJmNzE5YzAyLTc1ZmQtNDNiOC1iYzYxLTI4ZTUyYjE4YzQ4YiIsImMiOjl9](https://app.powerbi.com/view?r=eyJrIjoiNGJiOGYwZTEtMTYwYi00MjZhLTllYWQtNWJiZDVmNWQ4NTBhIiwidCI6IjJmNzE5YzAyLTc1ZmQtNDNiOC1iYzYxLTI4ZTUyYjE4YzQ4YiIsImMiOjl9)).  
  
## Tools used
- SQL: Category hierarchy modeling + measure table queries.
- Python(pandas): Aggegations and data transformations.
- Power BI and DAX: Interactive reports for inflation trends, multiple measures and field parameters using DAX.
   
Overview and a more detailed explanation of used functions, queries, and transformations I did in Power BI, SQL and Python can be viewed [here](projects-resources/inflationAT).  

The SQL queries that I implemented to establish a working category hierarchy for my data model is [here](projects-resources/inflationAT/contributionhierarchy.sql).  
The Python(mostly pandas) aggregations and data transformations functions that I used is [here](projects-resources/inflationAT/data_transformpandas.py).  

## Data structure
The measure tables include the corresponding value for each category of each year. I decided to have them in each table, despite having the same structure, because 
almost none of them are used in the same visual, and it would affect the convenience of creating separate visuals if all were included in one table. Same principal is applied for the totalhicpyoychange, which consists of 9 rows of total HICP Index for each year. 
<img width="509" height="300" alt="image" src="https://github.com/user-attachments/assets/69713067-6566-4c3e-b9a1-41d92c8f2c91" />

## Insights summary
After a stable and fairly low inflation trend in the years from 2016 up to 2021, even surpassing the COVID-19 pandemic period seemingly well without particular spikes,
the inflation skyrocketed in 2022, obviously caused by the war in Ukraine, up to 8.6% and kept as high as 7.70% in the year 2023, dropping to 2.9% only in 2024. 
The following section will explore which categories of goods and services were affected the most and whether any major category saw a decline in prices in 2024.

Below is main page from the Power BI report that includes summary over the 2022-2024 years. The standout of Food, Housing, Restaraunts and Transport categories can already be noticed. This will be explored further, as well as functionality examples will be included further in the section.  
<img width="600" height="300" alt="image" src="https://github.com/user-attachments/assets/4f4558b5-cf85-4891-b972-0aaf3a11bad6" />



## Discovered trends
- **Three categories are contributing 11.57% out of 19.2% total inflation** in years 2022-2024, which are Food and non-alcoholic beverages; Housing, water, electricity and other fuels; Restaraunts and hotels. Including transport category contribution, the number goes up to **14.28%**. This indicates that regular households took the strongest hit of the inflation increase across main categories of goods all families buy. 
- Gas price, despite a 2024 drop of -16.14%, still maintains a disappointing inflation of price of **118.97%** in years 2022-2024, with Heat energy price falling not too far apart with a drop of -11.64% in 2024 but still maintaining a **70.18%**  increase in the 2022-2024, together making a 2.05% contribution to the Total inflation of 19.20% in the 3 years period.
- Food prices, while not as dramatic as the housing prices, still show a concerning growth of **24.32%** altogether. Such categories as Bread and cereals, Fish and seafood, Meat, Milk and Vegetables, showed a similar price movements over the crisis years resulting in **20-30% price increase in 2022-2024**. However, unlike housing prices, the food categories almost did not make a price drop whatsoever, with the inflation only slowing down to 2-4% in 2024, and only milk hitting a price decrease of -0.46%.
- In the Transport section, such categories as Diesel and Petrol, as opposed to others were showing a rather distinct trend. The inflation was fluctuating since 2020, when showed a similar **-12% drop** for both, and a rapid increase in 2021 continued in **2022 reaching its highest peak at 35%-47% increase** and HICP Index of 162.14 for Diesel and 143.80 for Petrol. However, these two dropped again **in 2023 with -9.53% and -7.55%, accordingly,** and continued decreasing in **2024 with -2.73% and -1.6%**, together making up 1.13% contribution for the last 3 years.

The images provide a visual understanding of the discovered trends. You can view the whole report [here](https://app.powerbi.com/view?r=eyJrIjoiNGJiOGYwZTEtMTYwYi00MjZhLTllYWQtNWJiZDVmNWQ4NTBhIiwidCI6IjJmNzE5YzAyLTc1ZmQtNDNiOC1iYzYxLTI4ZTUyYjE4YzQ4YiIsImMiOjl9).
<img width="370" height="200" alt="image" src="https://github.com/user-attachments/assets/7382e7f5-d41b-49c6-a23c-2ceb5660a023" />
<img width="370" height="200" alt="image" src="https://github.com/user-attachments/assets/79fd6d75-b9f2-4a3f-a864-a3ce44608703" />
<img width="370" height="200" alt="image" src="https://github.com/user-attachments/assets/542d2ae4-d0b0-4c65-8417-8b446aef964a" />

## Conclusion

- Essential categories such as food, housing, and transport were the primary drivers of inflation, accounting for the largest share of the increase. This indicates that regular households suffered the strongest burden, as these goods and services are unavoidable daily expenses.

- While some categories, particularly energy (gas, heat, and fuels), showed partial price declines in 2024, most essential goods did not revert to pre-crisis levels. Instead, they remained elevated, suggesting that the crisis has led to a structural increase in living costs.

- The limited recovery raises concerns that inflationary pressures may not fully flatten in the long term. Even with overall inflation easing in 2024, household vulnerability remains high, particularly among lower-income groups who spend more on essentials.

- Overall, the findings highlight the importance of policy interventions (e.g., targeted subsidies, energy relief, or food price stabilization measures) to protect households from lasting effects of inflation shocks.

   



