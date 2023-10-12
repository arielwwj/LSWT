clc
clear all

Total_temp = csvread('I:\20230213修订后数据表格\20230921大修文件\LSWT_result\RHSAT19852021.csv',1,0);

Year = Total_temp(1:end,1);
Month = Total_temp(1:end,2);
Day = Total_temp(1:end,3);


CLI = [];
FRE = [];
CUM = [];
INTENSITY = [];

for lake_i = 1:2311
    total_lake_i = Total_temp(1:end,lake_i+3);
    climatotal = [];
    
    %%%将LSWT整理成横向为行，纵向为DOY的表格
    for year_i = 1985:2021
        total_lake_i_year = total_lake_i(Year == year_i);
        climatotal = [climatotal,total_lake_i_year];
    end
    
    %%%%%%计算每个湖泊每一年对应的滑动气候态均值
    climatotal_summer= climatotal(152:273,:);  %%夏季真实值
    climatotal_summer_yearly = [];
    
    climatotal_summer_90= climatotal(147:278,:);%计算90百分位
    climatotal_summer_yearly_90 = [];
    
    for j = 1:37
        if j<17
            climatotal_summer_j =  climatotal_summer(:,1:31);
            climatotal_summer_j_90 = climatotal_summer_90(:,1:31);
        else if j<23
                climatotal_summer_j =  climatotal_summer(:,j-15:j+15);
                climatotal_summer_j_90 = climatotal_summer_90(:,j-15:j+15);
            else
                climatotal_summer_j =  climatotal_summer(:,7:37);
                climatotal_summer_j_90 = climatotal_summer_90(:,7:37);
            end
        end
        mean_j = mean(climatotal_summer_j,2);
        climatotal_summer_yearly = [climatotal_summer_yearly,mean_j];
        
        threshold_90_i = [];
        for k = 6:127
            climatotal_summer_j_90_k0 = climatotal_summer_j_90(k-5:k+5,:);
            climatotal_summer_j_90_k1 = reshape(climatotal_summer_j_90_k0,[],1);
            climatotal_summer_j_90_k2 = prctile(climatotal_summer_j_90_k1,90);
            threshold_90_i = [threshold_90_i;climatotal_summer_j_90_k2];
        end
        climatotal_summer_yearly_90 = [climatotal_summer_yearly_90,threshold_90_i];
    end
    
   %%计算频率、强度和累计热量
    %频率
    [a_day,b_year] = size(climatotal_summer);
    fre0 = ones(a_day,b_year);
    fre0(climatotal_summer<=climatotal_summer_yearly_90) = 0;
    fre1 = sum(fre0)';
    %累计热量
    cum0 = (climatotal_summer - climatotal_summer_yearly_90) .* fre0;
    cum1 = sum(cum0)';
    %强度
    intensity = cum1./fre1;
    intensity((isnan(intensity))) = 0;
    
    %%%%替换
    climatotal_summer(climatotal_summer>climatotal_summer_yearly_90) = climatotal_summer_yearly(climatotal_summer>climatotal_summer_yearly_90);
    climatotal(152:273,:) = climatotal_summer;
    climatotal_rh = reshape(climatotal,[],1);
    
    CLI = [CLI ,climatotal_rh];
    FRE = [FRE,fre1];
    CUM = [CUM,cum1];
    INTENSITY = [INTENSITY,intensity];
end

% writematrix(CLI,'I:\20230213修订后数据表格\20230921大修文件\LSWT_result\heat extremes 指标计算\RHLSWT2021_0926.csv'); 
writematrix(FRE,'I:\20230213修订后数据表格\20230921大修文件\LSWT_result\heat extremes 指标计算\frequencRHLSWT2021.csv'); 
writematrix(CUM,'I:\20230213修订后数据表格\20230921大修文件\LSWT_result\heat extremes 指标计算\cumulativeRHLSWT2021.csv'); 
writematrix(INTENSITY,'I:\20230213修订后数据表格\20230921大修文件\LSWT_result\heat extremes 指标计算\intensityRHLSWT2021.csv'); 


