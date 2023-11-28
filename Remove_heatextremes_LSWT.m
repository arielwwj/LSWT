clc
clear all

Total_temp = csvread('path');

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
    
    %%%Organize LSWT into tables with rows horizontally and DOY vertically
    for year_i = 1985:2021
        total_lake_i_year = total_lake_i(Year == year_i);
        climatotal = [climatotal,total_lake_i_year];
    end
    
    %%%%%%Calculate the sliding climatological average corresponding to each year for each lake
    climatotal_summer= climatotal(152:273,:); 
    climatotal_summer_yearly = [];
    
    climatotal_summer_90= climatotal(147:278,:);
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
    
   %%Calculate frequency, intensity and cumulative heat
    %frequency
    [a_day,b_year] = size(climatotal_summer);
    fre0 = ones(a_day,b_year);
    fre0(climatotal_summer<=climatotal_summer_yearly_90) = 0;
    fre1 = sum(fre0)';
    %cumulative heat
    cum0 = (climatotal_summer - climatotal_summer_yearly_90) .* fre0;
    cum1 = sum(cum0)';
    %intensity
    intensity = cum1./fre1;
    intensity((isnan(intensity))) = 0;
    
    %%%%replace
    climatotal_summer(climatotal_summer>climatotal_summer_yearly_90) = climatotal_summer_yearly(climatotal_summer>climatotal_summer_yearly_90);
    climatotal(152:273,:) = climatotal_summer;
    climatotal_rh = reshape(climatotal,[],1);
    
    CLI = [CLI ,climatotal_rh];
    FRE = [FRE,fre1];
    CUM = [CUM,cum1];
    INTENSITY = [INTENSITY,intensity];
end

writematrix(CLI,'path'); 
writematrix(FRE,'path'); 
writematrix(CUM,'path'); 
writematrix(INTENSITY,'path'); 


