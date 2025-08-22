import pandas as pd 
import numpy as np
import os
import glob


#retrieve data for indices
path1 = r'C:\DA\SQL\inflationAT\hicpindex'
all_files_index = glob.glob(os.path.join(path1, "*.csv"))
df_list_index = []
for index_file in all_files_index:
    temp_df = pd.read_csv(index_file)
    df_list_index.append(temp_df)
index_df = pd.concat(df_list_index, axis=0)
index_df["Measure"] = "HICP_Index"

#retrieve data for weights  
path2 = r'C:\DA\SQL\inflationAT\hicpweights'
all_files_weight = glob.glob(os.path.join(path2, "*.csv"))
df_list_weights = []
for weight_file in all_files_weight:
    temp_df = pd.read_csv(weight_file)
    df_list_weights.append(temp_df)
weight_df = pd.concat(df_list_weights, axis=0)
weight_df["Measure"] = "HICP_Weight"


#convert indices to Year over Year inflation rate
YoYchange_df = index_df.copy()
n = len(index_df["Category"])
for i in range(n):
    for j in range(3, 12):
        YoYchange_df.iloc[i, j] = ((index_df.iloc[i, j] - index_df.iloc[i, j - 1]) / index_df.iloc[i, j - 1]) * 100
YoYchange_df["Measure"] = "YoYchange"
YoYchange_df = YoYchange_df.round(2)

#normalize the data to decimal form
numeric_columns = weight_df.select_dtypes(include='number').columns
weight_df[numeric_columns] = weight_df[numeric_columns] / 1000
YoYchange_df[numeric_columns] = YoYchange_df[numeric_columns] / 100


#create a dataframe for a new measure of contribution to the total inflation
contribution_df = weight_df.sort_values("Category", ascending=True)
weight_df_numer = weight_df.sort_values("Category", ascending=True)[numeric_columns]
YoY_df_numer = YoYchange_df.sort_values("Category", ascending=True)[numeric_columns]

for i in range(n):
    contribution_df.iloc[i, 2 : -1] = weight_df_numer.iloc[i].multiply(YoY_df_numer.iloc[i])
contribution_df["Measure"] = "Contribution to total"

#export the files as csvs
weight_df.to_csv('hicpweights.csv')
YoYchange_df.to_csv('hicpchangeyoy.csv')
contribution_df.to_csv('hicpcontribution.csv')
index_df.to_csv('hicpindex.csv')
