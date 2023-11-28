
from scipy.stats import norm
import numpy as np
from scipy import stats
import pandas as pd

def mk(x, alpha=0.1):  # 0<alpha<0.5 
    n = len(x)
    s = 0
    for j in range(n - 1):
        for i in range(j + 1, n):
            s += np.sign(x[i] - x[j])

         
    # Determine whether there is a duplicate number inside x, output unique_x, duplicate number queue tp
    unique_x, tp = np.unique(x, return_counts=True)
    g = len(unique_x)
    # Calculate the variance VAR(S)
    if n == g:  # If no duplicate points exist
        var_s = (n * (n - 1) * (2 * n + 5)) / 18
    else:
        var_s = (n * (n - 1) * (2 * n + 5) - np.sum(tp * (tp - 1) * (2 * tp + 5))) / 18
    # Calcuate z_value
    if n <= 10:  # n<=10 is a special case
        z = s / (n * (n - 1) / 2)
    else:
        if s > 0:
            z = (s - 1) / np.sqrt(var_s)
        elif s < 0:
            z = (s + 1) / np.sqrt(var_s)
        else:
            z = 0
            
    # sheetw.write(a,k,z)
    # Calculate p_value, optionally validate p_value first
    p = 2 * (1 - norm.cdf(abs(z)))
    
    #print(p);
    
    # sheetw.write(a+1,k,p)
    # calculate Z(1-alpha/2)
    h = abs(z) > norm.ppf(1 - alpha / 2)
    # trend judgment
    if (z < 0) and h:
        trend = 'decreasing'
    elif (z > 0) and h:
        trend = 'increasing'
    else:
        trend = 'no trend'
    return trend


import os
import pandas as pd
 
file_path = 'path' 
 
# create empty list
code_list = []                         
for root, dirs, files in os.walk(file_path):
    # print(root)
    # print(dirs)
    # print(files)
    for filename in files:
        code_list.append(filename[:-5])
print(code_list)

Total_mk = pd.DataFrame()
for gcm_i in range (17,18):
    total_mk = pd.DataFrame()
    csvname_of_ice = file_path +'/'+ code_list[gcm_i] +'.xlsx'
    for r in range (7,8):
        xl = pd.read_excel(csvname_of_ice,sheet_name=r)
                
        
        Time = xl.iloc[:,0:1]
        # Get the total number of rows, the number of columns is table.ncols, the number of rows is table.nrows.
        colsnum = xl.shape[1]
        mk_GCM = pd.DataFrame()
        for k in range(1, colsnum):
            LSWT = xl.iloc[:,k:k+1].values
    
            res = stats.theilslopes(LSWT, Time, 0.95)
            res1 = res[0]
            intercept = res[1]
    
            ztrend = mk(LSWT)
            mk_i = pd.DataFrame({'slope': res1, 'intercept':intercept},index=[0])
            mk_GCM = pd.concat([mk_GCM,mk_i],axis=0)
        total_mk = pd.concat([total_mk,mk_GCM],axis=1)

    Total_mk = pd.concat([Total_mk,total_mk],axis=1)
    

    print(Total_mk)
