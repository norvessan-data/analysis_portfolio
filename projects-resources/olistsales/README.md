# Data modelling
In this section, I will describe the process of data cleaning and preparation performed on the dataset.


### Data cleaning
For cleaning, SQL was used. It contains the following.

Capitalization and standardization of cities and State names
- Many of the cities names were found to be inconsistent, some of them being written with Brazilian accents, some of them not, with sometimes redundant spaces and most of them being not capitalized.
I decided to fix the capitalization problem by creating a separate user-defined SQL function, @string_clean_capitalize, which iterated through all of the separate words by spaces and in case the word is more than 2 letters, it capitalized the word.
- To clean the misused symbols in city names(some of them had -/~/, etc at the end), I used CASE WHEN function to resolve the inconsistency.
 Translation of Brazilian words and replacement words with accents
- payment_type column involved Brazilian wording, it was replaced with english words.
- geolocation_city column involved Brazilian accents, they were replaced by alternative english letters.

The sql file can be found above.

### DAX
Plenty of DAX function were used during modelling process, including SELECTEDVALUE(), CALCULATE(), DATEADD(), DATESBETWEEN(), SWITCH(), FORMAT(), AVERAGEX(), KEEPFILTERS() and some others. Mainly measures added were about YoY, MoM, QoQ, some custom titles, and a field parameter. 

### Power BI
Main goal for creating visuals was to answer most of the executive questions that may rise with as little ink as possible. I sought to keep some free space between most of the visuals so they are not overwhelming. Mostly, the visuals involve showing trends using line charts, as well as breakdown of MoM trends with a table visual and some others.
