
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

An interactive Power BI report can be viewed [here](https://app.powerbi.com/view?r=eyJrIjoiNGJiOGYwZTEtMTYwYi00MjZhLTllYWQtNWJiZDVmNWQ4NTBhIiwidCI6IjJmNzE5YzAyLTc1ZmQtNDNiOC1iYzYxLTI4ZTUyYjE4YzQ4YiIsImMiOjl9)  

Overview and a more detailed explanation of used functions, queries, and transformations I did in Power BI, SQL and Python can be viewed [here](projects-resources/inflationAT).  

The SQL queries that I implemented to establish a working category hierarchy for my data model is [here](projectresources/inflationAT/contributionhierarchy.sql).  
The Python(mostly pandas) aggregations and data transformations functions that I used is [here](projectresources/inflationAT/datatransform-pandas.py).  


## Data structure
erDiagram
    ORDERS {
      string   customer_id
      string   id
      date     purchase_ts
      string   product_id
      string   product_name
      string   currency
      float    local_price
      float    usd_price
      string   purchase_platform
    }

    CUSTOMERS {
      string   id
      string   marketing_channel
      string   account_creation_method
      string   country_code
      int      loyalty_program
      date     created_on
    }

    ORDER_STATUS {
      string   order_id
      date     purchase_ts
      date     ship_ts
      date     delivery_ts
      date     refund_ts
    }

    GEO_LOOKUP {
      string   country
      string   region
    }

    %% Relationships
    CUSTOMERS ||--o{ ORDERS : "id → customer_id"
    ORDERS    ||--o{ ORDER_STATUS : "id → order_id"
    GEO_LOOKUP ||--o{ CUSTOMERS : "country → country_code"
