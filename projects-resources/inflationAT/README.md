# Data modeling process
This folder contains Python code and SQL queries I used in the process of data preparation.  
I will also specify some DAX functions that I used in the process of data visualisation below.

## Breakdown of the main problems encountered, the process of modeling and functions used:
- Python: I used pandas library to calculate the categories' YoY change and Contribution to total HICP tables, and standardize the tables so the structure between measures is well aligned.
    
- SQL: SQL was used as the main tool of data cleaning and preparation for contribution table's hierarchies. The contribution table had two problems:
  1. It had years as columns, which was inefficient for further data modeling process and preparation of the visualisations. The problem was solved by using unpivot function in SQL.
  2. The main problem: the retrived dataset itself had a structure of hierarchies, with major category(Sector) as a main one, and up to 3 more subcategories down the hierarchy.
  As the parents had their own values, which basically represented all the children values summed up, it introduced doublecounting when summarizing in a tool like Power BI.
  Not all parents had the full list of included categories as some of them were too subtle to bother, I decided
  to start by creating a new category "Other", where the difference between a parent value and children summed up was somewhat significant, to minimize the error.
  I summed up all the children values in the corresponding levels of hierarchies for each parent, followed by subtracting the sums from parents values, and putting it in "Other" category.
  If the difference was too subtle, i.e. less than 0.02%, I ignored the value. Finally, I assigned the parents' values to 0 and the contribution table was prepared.
  
- Power BI: multiple measures and a few parameters were created in DAX. They include the field parameters to provide users a choice of aggregation(Average or Sum) for Total Inflation and Categories' contribution in
  the main page of the visual using SUM, AVERAGEX, SUMMARIZE and COALESCE(to avoid blank values) functions. To retrieve Top 3 categories for Contribution and Inflation on the second, drill-through page, I decided to use
  a RANKX() function in combination with another measure to make a filter for the visual. Mutliple title measures were created mainly by using HASONEVALUE() and SELECTEDVALUE() functions. Finally,
  bookmarks were used to allow the user to toggle between Top 3 Contributors and Top 3 Inflating categories in the drill-through page.  
