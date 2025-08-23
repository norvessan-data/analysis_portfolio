# Data modeling process
This folder contains Python code and SQL queries I used in the process of data preparation.  
I will also specify some DAX functions that I used in the process of data visualisation below.

## Breakdown of the main problems encountered, the process of modeling and functions used:
- Python: I used pandas library to calculate the categories' YoY change and Contribution to total HICP tables, and standardize the tables so the structure between measures is well aligned.
    
- SQL: SQL was used as the main tool of data cleaning and preparation for contribution table's hierarchies. The contribution table had two problems:
  1. It had years as columns, which was inefficient for further data modeling process and preparation of the visualisations. The problem was solved by using unpivot function in SQL.
  2. The main problem: the retrived dataset itself had a structure of hierarchies, with major category(Sector) as a main one, and up to 3 more subcategory levels down the hierarchy.
  As the parents had their own values, which basically represented all the children values summed up, it introduced doublecounting when summarizing in a tool like Power BI.
  Not all parents had the full list of included children as some of them were too subtle to bother, I decided
  to start by creating a new category "Other" to assign the difference between a parent value and children values summed up where it was somewhat significant, to minimize the error.
  I summed up all the children values in the corresponding levels of hierarchies for each parent, followed by subtracting the sums from parents values, and put it in the "Other" category of the
  corresponding level and parent.
  If the difference was too subtle, i.e. less than 0.02%, I ignored the value. Finally, I assigned the parents' values to 0 and the contribution table was prepared.
  
- Power BI: multiple measures and a few parameters were created in DAX. They include the field parameters to provide users a choice of aggregation(Average or Sum) for Total Inflation and Categories' contribution in
  the main page of the visual using SUM, AVERAGEX, SUMMARIZE and COALESCE(to avoid blank values) functions. To retrieve Top 3 categories for Contribution and Inflation on the second, drill-through page, I decided to use
  a RANKX() function in combination with another measure to make a filter for the visual. Mutliple title measures were created mainly by using HASONEVALUE() and SELECTEDVALUE() functions. Finally,
  bookmarks were used to allow the user to toggle between Top 3 Contributors and Top 3 Inflating categories in the drill-through page.  
  When building the visuals, I tried to achieve the goal of using as less amount of visuals as possible the least possible complexity, while still fulfilling the purpose of delivering the intended insights. First, I built the cards visuals, to allow users clearly see the inflation and the selected categories' contribution to the inflation over years they would like to select. To allow
  them to see the trends of inflation and selected categories' contribution over time against each other, I added a line chart with two Y-axes.  
  Finally, to allow them to compare all the categories contributions side-by-side with an ability to drill down to multiple levels of hierarchy, I added a Stacked column chart. This allowed me to also introduce the ability of drilling through to the second page to see the breakdown of a category that is selected on the chart with the "See details" button.
  The second page includes a table, where a user can see each category of the sector they selected alongside their YoY Change, and average HICP index for the selected year(Averaged if selected multiple years). Also, I included a stacked column chart to show the Top 3 Contributors or Top 3 most inflating subcategories, up the user's choice. Finally, a line chart was added to showcase the inflation trend over time for the category selected in the table.  
