
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
  
  
An interactive Power BI report can be viewed [here](https://app.powerbi.com/view?r=eyJrIjoiNGJiOGYwZTEtMTYwYi00MjZhLTllYWQtNWJiZDVmNWQ4NTBhIiwidCI6IjJmNzE5YzAyLTc1ZmQtNDNiOC1iYzYxLTI4ZTUyYjE4YzQ4YiIsImMiOjl9).    
  
## Tools used
- SQL: Category hierarchy modeling + measure table queries.
- Python(pandas): Aggegations and data transformations.
- Power BI and DAX: Interactive reports for inflation trends, multiple measures and field parameters using DAX.
   
Overview and a more detailed explanation of used functions, queries, and transformations I did in Power BI, SQL and Python can be viewed [here](projects-resources/inflationAT).  

The SQL queries that I implemented to establish a working category hierarchy for my data model is [here](projects-resources/inflationAT/contributionhierarchy.sql).  
The Python(mostly pandas) aggregations and data transformations functions that I used is [here](projects-resources/inflationAT/data_transformpandas.py).  

## Data structure
The measure tables include the corresponding value for each category of each year. I decided to have them each in a separate table, despite having the same structure, because 
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
- Gas price, despite a 2024 drop of -16.14%, still maintains a highly elevated level of inflation of **118.97%** in years 2022-2024, with Heat energy price falling not too far apart with a drop of -11.64% in 2024 but still maintaining a **70.18%**  increase in the 2022-2024, together making a 2.05% contribution to the Total inflation of 19.20% in the 3 years period.
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

   

# Project 2: E-commerce Sales analysis

## Background
Olist is a Brazilian e-commerce company, established in 2015, that specifies on connecting small and medium sized businesses to customers. In just 6 years of existence it was able to become a company-unicorn with more than $1 bln in valuation, and is continuing to rise now, in 2025. 

The company has a significant amount of data including sales, sellers, customers and stretches across whole of Brazil. In this project, the data made publicly available for years 2016-2018 by the company itself, will be cleaned, polished and analysed, uncovering insights and trends in early years of its boom.

Insight are provided in key following areas:
- Sales Analysis: Evaluation of Historical patterns, focusing on such metrics as Sales Revenue, AOV and Order Volume in total and by region.
- Product Categories Breakdown: Analyzing most profitable/underperforming categories, revealing major impacts on MoM sales by different categories in Net Revenue Change.
- Regional Analysis: Comparison of Brazil states' performance in sales.

Power BI report can be viewed [here](https://app.powerbi.com/reportEmbed?reportId=7629a19a-8df4-4f5d-b5c3-93e62302bc34&autoAuth=true&ctid=2f719c02-75fd-43b8-bc61-28e52b18c48b)

## Tools used 

- SQL: Plenty of data cleaning was performed, involving resolving naming issues for cities, regions, creating a consistent framework with standardized columns
- Power Query and DAX: Data modeling, advanced queries in M language and multiple measures/calculated columns were completed in order to establish a reliable and convenient semantic model.
- Power BI: Visualizations
  
A more detailed overview and explanation of data modeling(SQL queries used, some measures described etc) process can be viewed [here](project-resources/olistsales)

## Data structure

The semantic model involves following structure with a total row count of 112650
<img width="452" height="300" alt="image" src="https://github.com/user-attachments/assets/a8f4cae3-64a7-4d94-b5a5-98a1690aa3db" />

## Summary

After the development stage of refinment the platform and raising funds in 2016, the popularity of the platform boomed for both sellers and customers in early 2017, which led to a continuously increasing revenue and order count, which the platform was able to keep up until August-September 2018, the end of the observation period, showing +20% YoY in Revenue, +21.5% in Order Volume from the whole of 2017 just over the 9 months period. Despite the initial success however, the dynamics in late 2018 show alerting stagnation, which may require active engagement in order for high numbers to preserve. Providing insights in that regard will be the main goal of the analysis.

Main overview page can be viewed below. Alternatively, view the whole report [here](https://app.powerbi.com/reportEmbed?reportId=7629a19a-8df4-4f5d-b5c3-93e62302bc34&autoAuth=true&ctid=2f719c02-75fd-43b8-bc61-28e52b18c48b).
<img width="551" height="300" alt="image" src="https://github.com/user-attachments/assets/7e6a88cd-adde-4ce8-a421-1f3d0ad86600" />

## Discovered trends
### Sales Summary
- 2017 became the first major success of the company. Sales and order volumes accelerated for almost the whole of 2017, showing only a couple months of minor fluctuations and a seasonal drop in December, generating **$6.16M** in Revenue and **43.4K** Orders for the period of 12 months, peaking in November with $1.1M Revenue and 7289 Orders, a **52% MoM** increase.
- 2018 was able to hold up with the late 2017 numbers, showing excellent growth of **+21% YoY in Revenue** for 9 months period against the whole of 2017 and with **50%**(later months)-**700%**(Jan-Feb) YoY** growth for individual months.  However, despite such drastical increase in YoY values, MoM is on a consecutive decline, August showing 11% less revenue than January, indicating a risk of potential stagnation.
- AOV was fluctuating in both year, ranging from $130 to $160, with 2018 being lower on most months, with declines from (1%) to (16%) YoY.
<img width="900" height="300" alt="image" src="https://github.com/user-attachments/assets/1a5c2488-af4f-4107-9dad-66f1979b7343" />

### Categories Breakdown
- Overall, many most-earning product categories were on similar range, showing a good diversification, with top 3 by revenue (over whole observation period) being Health Beauty($1.4M), Watches Gifts($1.3M) and Bed Bath Table($1.24M) out of $13.59M total revenue.
- Health Beauty category was not only the best performing, but also showed the most stable growth, declining in MoM only with the company's overall drops, and saw a 60% increase in August compared to January, unlike Total Revenue. On par with Total Revenue, it showed excellent YoY growth ranging from **+106% to +476% YoY**. AOV trend for the category is similar to the Total AOV trend, ranging mostly from $130 to $150. 
- Watches Gifts, being second best,  was much more prone to swings in MoM trajectory, which is rather expected for such kind of category. YoY-wise, it showed great growth on all of the 9 months in 2018, ranging from 98% to 835%(in earlier months) YoY. Watches Gifts shows excellent AOV ranging from $190 to $240 in 2018.
- Bed Bath Table shows good, but weaker YoY growth than other categories, with mainly being +100% YoY and even showing a decline of (13.8%) YoY in July 2018. AOV for the category is also considerably less than Total AOV, usually in range of $110-$120 against typical $140 for total.
<img width="1200" height="300" alt="image" src="https://github.com/user-attachments/assets/045fbdc5-fc65-4491-84ba-b745a1b2a2bf" />

### Regional numbers Breakdown
- **São Paulo** is by far most profitable State for the company, making up for **$5.3M or 40%** of total revenue and 40K out of 96.5K total orders in the observed period. Its average delivery time in days is significantly lower than total average(8.7 Days against 12.5). YoY wise, it ranges in +76% - +220% YoY in most months. It is also on the lower side of the total AOV, ranging mostly from $120-$130. 
- It is followed up by Rio da Janeiro ($1.82M revenue with 12.4K order volume) and Minas Gerais ($1.59M and 11.4K, accordignly). Rio da Janeiro has significantly slower delivery than São Paulo or even total average, 15.24 days, and lower On-Time delivery rate(87% against 92% average). Showed similar growth to total revenue in YoY in earlier months, however was significantly lower in July and August 2018, showing only 22% and 34.6% YoY growth, accordingly. Minas Gerais is close to total average in delivery metrics (11.94 days avg. and 94% On-Time rate). It also performed very similar to total average in YoY regard, ranging in 50%ish area in later months and 230%-770% in first months.
<img width="550" height="300" alt="image" src="https://github.com/user-attachments/assets/5c7fbda6-92f1-46e5-8dd4-a8729a1a5123" />


## Conclusion
- Company showed excellent revenue across pretty much the whole 2017-2018 period, rapidly revealing its massive potential.
- Despite the overall growth, MoM values show concerning stagnation, slightly declining over the 2018 period in number of orders and revenue. As most lucrative months(October, November) are still ahead however, it's too early to make a conclusion of risk of complete decline. Overall, 2018 showed amazing revenue and orders, being ahead of 2017 even without 3 months of data.

- **Product category** diversification is solid, with top categories (Health Beauty, Watches Gifts, Bed Bath Table) driving most of the revenue. However, reliance on a few top performers poses concentration risk. Further development of mid-tier categories could smooth out fluctuations and reduce exposure.

- **Regional Imbalance**: Regional revenue is heavily concentrated in São Paulo, which accounts for ~40% of total revenue. While São Paulo is efficient in delivery, underperformance in Rio de Janeiro, for instance, highlights the need for operational improvements outside the core market. Strengthening logistics and customer experience in weaker regions could unlock significant additional growth.

- **Customer Metrics**: Customer and seller counts show steady growth, but the declining quarter-on-quarter customer count trend is concerning. Investment in retention strategies may be needed to maintain long-term growth.
