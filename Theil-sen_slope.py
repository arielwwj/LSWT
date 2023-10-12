# -*- coding: utf-8 -*-
"""
Created on Sat Aug 12 21:24:45 2023

@author: DELL
"""

from scipy.stats import norm
import numpy as np
# import xlrd
# import xlsxwriter
from scipy import stats
import pandas as pd

def mk(x, alpha=0.1):  # 0<alpha<0.5 1-alpha/2为置信度
    n = len(x)
    # 计算S的值
    s = 0
    for j in range(n - 1):
        for i in range(j + 1, n):
            s += np.sign(x[i] - x[j])

         
    # 判断x里面是否存在重复的数，输出唯一数队列unique_x,重复数数量队列tp
    unique_x, tp = np.unique(x, return_counts=True)
    g = len(unique_x)
    # 计算方差VAR(S)
    if n == g:  # 如果不存在重复点
        var_s = (n * (n - 1) * (2 * n + 5)) / 18
    else:
        var_s = (n * (n - 1) * (2 * n + 5) - np.sum(tp * (tp - 1) * (2 * tp + 5))) / 18
    # 计算z_value
    if n <= 10:  # n<=10属于特例
        z = s / (n * (n - 1) / 2)
    else:
        if s > 0:
            z = (s - 1) / np.sqrt(var_s)
        elif s < 0:
            z = (s + 1) / np.sqrt(var_s)
        else:
            z = 0
            
    # sheetw.write(a,k,z)
    # 计算p_value，可以选择性先对p_value进行验证
    p = 2 * (1 - norm.cdf(abs(z)))
    
    #print(p);
    
    # sheetw.write(a+1,k,p)
    # 计算Z(1-alpha/2)
    h = abs(z) > norm.ppf(1 - alpha / 2)
    # 趋势判断
    if (z < 0) and h:
        trend = 'decreasing'
    elif (z > 0) and h:
        trend = 'increasing'
    else:
        trend = 'no trend'
    return trend


import os
import pandas as pd
 
file_path = 'I:\\20230213修订后数据表格\\20230921大修文件\\LSWT_result\\heat extremes 指标计算' # 设置文件路径
 
# 建立空list
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
        # 获取一共多少行,列数为table.ncols,行数为table.nrows
        colsnum = xl.shape[1]
        mk_GCM = pd.DataFrame()
        for k in range(1, colsnum):
            # todo 获取第一列的整列的内容
            LSWT = xl.iloc[:,k:k+1].values
    
            res = stats.theilslopes(LSWT, Time, 0.95)
            res1 = res[0]
            intercept = res[1]
    
            ztrend = mk(LSWT)
            mk_i = pd.DataFrame({'slope': res1, 'intercept':intercept},index=[0])
            mk_GCM = pd.concat([mk_GCM,mk_i],axis=0)
        total_mk = pd.concat([total_mk,mk_GCM],axis=1)
            
            # print(ztrend)
            # print(res1)
            #print(intercept)
    Total_mk = pd.concat([Total_mk,total_mk],axis=1)
    

    print(Total_mk)
    # writename = file_path +'/mk/mk6099_'+ code_list[gcm_i]+'vali.csv'
    # total_mk.to_csv(writename, index=False) 
    


# todo 位置写入
#sheetw.write_string('B1','password')