%removeheat_ERA5-POLYGEN

% % part 1: calculate mean value for every grid of every day (122 days in total)
% clc
% clear all
% 
% path0 = 'I:\20230213修订后数据表格\20230921大修文件\AT_tif\summer_layerstacking_clip\';
% 
% % for yearid = 1985:2009
% % for yearid = 1985:2022
% % inputfile=[path0,num2str(yearid),'_summerlayer.tif'];
% 
% outputfile='I:\20230213修订后数据表格\20230921大修文件\AT_tif\clima_mean\2007\';
% 
% img_path_list = dir(strcat(path0,'*.tif'));
% 
% %img_num = length(img_path_list);%获取图像总数量
% %group_num = floor(img_num/8);
% year = length(img_path_list);
% 
% % for j = 32:153
% parfor j = 6:127
%     totalband = 0;
%     for i = 8:38
%         [inputdata, R] = geotiffread([path0 img_path_list(i).name]); %R为空间参考文件
%         info = geotiffinfo([path0 img_path_list(i).name]);
%         fprintf('%d %d %s\n',i,strcat([path0, img_path_list(i).name]));% 显示正在处理的图像名
%         [hang,lie,day] = size(inputdata);
%         
%         inputdataB1 = double(inputdata(:,:,j));
%         B0 = reshape(inputdataB1,hang*lie,1);
%         B_double = double(B0);
%         totalband = totalband + B_double;
%     end
%     
%     totalband1 = totalband/year;
%     bandmean_img = reshape(totalband1,[hang,lie,1]);
%     geotiffwrite([outputfile num2str(j-5) '_mean.tif' ],bandmean_img,R, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);  %写出带有地理信息的geotif文件
% end

%% 
% %%%%%%%%%%%%%%%%%%%

%%%%part 2:build the 11days dataset

% clc
% clear all
% 
% path0 = 'I:\20230213修订后数据表格\20230921大修文件\AT_tif\summer_layerstacking_clip\';
% 
% outputfile='I:\20230213修订后数据表格\20230921大修文件\AT_tif\clima_90\2007\';
% 
% img_path_list = dir(strcat(path0,'*.tif'));
% 
% year = length(img_path_list);
% 
% parfor j = 6:127
%     totalband = [];
%     for i = 8:38
%         [inputdata, R] = geotiffread([path0 img_path_list(i).name]); %R为空间参考文件
%         info = geotiffinfo([path0 img_path_list(i).name]);
%         fprintf('%d %d %s\n',i,strcat([path0, img_path_list(i).name]));% 显示正在处理的图像名
%         [hang,lie,day] = size(inputdata);
%         totalband_year = [];
%         for n = j-5:j+5
%             inputdataB1 = double(inputdata(:,:,n));
%             B0 = reshape(inputdataB1,hang*lie,1);
%             B_double = double(B0);
%             totalband_year = [totalband_year,B_double];
%         end
%         totalband = [totalband,totalband_year];
%     end
%     
% %     [hang31,lie31] = size(totalband);
% %     per90 = [];
% %     for hang_m = 1:hang31
% %         data_grid = totalband(hang_m,:);
% %         y_m = prctile(data_grid,90);
% %         per90 = [per90;y_m];
% %     end
%     per_90_1 = prctile(totalband,90,2);
%     bandmean_img = reshape(per_90_1,[hang,lie,1]);
%     geotiffwrite([outputfile num2str(j-5) '_90percent.tif' ],bandmean_img,R, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);  %写出带有地理信息的geotif文件
% end
% 
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%part3 change heat extremes

clc
clear all

path0 = 'I:\20230213修订后数据表格\20230921大修文件\AT_tif\summer_layerstacking_clip\';
% for yearid = 1985:2009
inputfile_90 =  'I:\20230213修订后数据表格\20230921大修文件\AT_tif\clima_90\2001\';
inputfile_mean = 'I:\20230213修订后数据表格\20230921大修文件\AT_tif\clima_mean\2001\';
img_path_list_90 = dir(strcat( inputfile_90,'*.tif'));
img_path_list_mean = dir(strcat( inputfile_mean,'*.tif'));

img_path_list0 = dir(strcat(path0,'*.tif'));%获取该文件夹中所有tif格式的图像
outputfile='I:\20230213修订后数据表格\20230921大修文件\AT_tif\RH2022\';


year = length(img_path_list0);

for i = 17:17
    %     outputfile1 = [outputfile,num2str(year+1984)];
    [inputdata, R] = geotiffread([path0 img_path_list0(i).name]); %R为空间参考文件
    info = geotiffinfo([path0 img_path_list0(i).name]);
    fprintf('%d %d %s\n',i,strcat([path0, img_path_list0(i).name]));% 显示正在处理的图像名
    
    parfor year_day = 6:127
        inputdataB1 = double(inputdata(:,:,year_day));
        
        [inputdata_90, R] = geotiffread([inputfile_90 num2str(year_day-5) '_90percent.tif']);
        [inputdata_mean, R] = geotiffread([inputfile_mean num2str(year_day-5) '_mean.tif']);
        inputdataB1_90 = double(inputdata_90(:,:,1));
        inputdataB1_mean = double(inputdata_mean(:,:,1));
        [hang,lie] = size(inputdataB1);
        B0 = reshape(inputdataB1,hang*lie,1);
        B0_90 = reshape(inputdataB1_90,hang*lie,1);
        B0_mean = reshape(inputdataB1_mean,hang*lie,1);
        B_double = double(B0);
        B_double_90 = double(B0_90);
        B_double_mean = double(B0_mean);
        B_double(B_double>B_double_90) = B_double_mean(B_double>B_double_90);
        
        bandmean_img = reshape(B_double,[hang,lie,1]);
        geotiffwrite([outputfile num2str(i+1984) '\' num2str(year_day-5) '_rh.tif' ],bandmean_img,R, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);  %写出带有地理信息的geotif文件
    end
end

%% 
% part 4: calculate the number of heatdays in eatch grid of eatch year 

% clc
% clear all
% 
% path0 = 'I:\20230213修订后数据表格\20230921大修文件\AT_tif\summer_layerstacking_clip\';
% 
% inputfile_90 =  'I:\20230213修订后数据表格\20230921大修文件\AT_tif\clima_90\2006\';
% % inputfile_mean = 'H:\ERA5-tifout\temp\layerstacking_summer\summerlayerstacking\meanvalue\';
% img_path_list_90 = dir(strcat( inputfile_90,'*.tif'));
% % img_path_list_mean = dir(strcat( 'H:\ERA5-tifout\temp\layerstacking_summer\summerlayerstacking\meanvalue\','*.tif'));
% 
% img_path_list0 = dir(strcat(path0,'*.tif'));%获取该文件夹中所有tif格式的图像
% outputfile='I:\20230213修订后数据表格\20230921大修文件\AT_tif\heat extremes_2021\';
% 
% 
% year = length(img_path_list0);
% 
% for i = 22:37
%     %     outputfile1 = [outputfile,num2str(year+1984)];
%     [inputdata, R] = geotiffread([path0 img_path_list0(i).name]); %R为空间参考文件
%     info = geotiffinfo([path0 img_path_list0(i).name]);
%     fprintf('%d %d %s\n',i,strcat([path0, img_path_list0(i).name]));% 显示正在处理的图像名
%     Heat_extreme_days = 0;
%     for year_day = 6:127
%         inputdataB1 = double(inputdata(:,:,year_day));
%         
%         [inputdata_90, R] = geotiffread([inputfile_90 num2str(year_day-5) '_90percent.tif']);
%         %         [inputdata_mean, R] = geotiffread([inputfile_mean img_path_list_mean(kk).name]);
%         inputdataB1_90 = double(inputdata_90(:,:,1));
%         %         inputdataB1_mean = double(inputdata_mean(:,:,1));
%         [hang,lie] = size(inputdataB1);
%         B0 = reshape(inputdataB1,hang*lie,1);
%         B0_90 = reshape(inputdataB1_90,hang*lie,1);
%         %         B0_mean = reshape(inputdataB1_mean,hang*lie,1);
%         B_double = double(B0);
%         B_double_90 = double(B0_90);
%         %         B_double_mean = double(B0_mean);
%         B_double_1 = zeros(hang*lie,1);
%         B_double_1(B_double>B_double_90) = 1;
%         %          B_double_1(B_double<=B_double_90) = 0;
%         Heat_extreme_days = Heat_extreme_days + B_double_1;
%      end   
%         bandmean_img = reshape(Heat_extreme_days,[hang,lie,1]);
%         geotiffwrite([outputfile  num2str(i+1984) '_heatdays.tif' ],bandmean_img,R, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);  %写出带有地理信息的geotif文件
%     
% end
%% part 4.5 calculate the cumulative heat and the intense (2023.04.26)

% clc
% clear all
% 
% path0 = 'I:\20230213修订后数据表格\20230921大修文件\AT_tif\summer_layerstacking_clip\';
% 
% inputfile_90 =  'I:\20230213修订后数据表格\20230921大修文件\AT_tif\clima_90\2006\';
% % inputfile_mean = 'H:\ERA5-tifout\temp\layerstacking_summer\summerlayerstacking\meanvalue\';
% img_path_list_90 = dir(strcat( inputfile_90,'*.tif'));
% % img_path_list_mean = dir(strcat( 'H:\ERA5-tifout\temp\layerstacking_summer\summerlayerstacking\meanvalue\','*.tif'));
% 
% img_path_list0 = dir(strcat(path0,'*.tif'));%获取该文件夹中所有tif格式的图像
% outputfile='I:\20230213修订后数据表格\20230921大修文件\AT_tif\cumulative heat_2021\';
% outputfile1='I:\20230213修订后数据表格\20230921大修文件\AT_tif\heat intense_2021\';
% 
% 
% year = length(img_path_list0);
% 
% for i = 22:38
% %         outputfile1 = [outputfile,num2str(year+1984)];
%     [inputdata, R] = geotiffread([path0 img_path_list0(i).name]); %R为空间参考文件
%     info = geotiffinfo([path0 img_path_list0(i).name]);
%     fprintf('%d %d %s\n',i,strcat([path0, img_path_list0(i).name]));% 显示正在处理的图像名
%     cumulative_heat = 0;
%     Heat_extreme_days = 0;
%     for year_day = 6:127
%         inputdataB1 = double(inputdata(:,:,year_day));
%         
%         [inputdata_90, R] = geotiffread([inputfile_90 num2str(year_day-5) '_90percent.tif']);
% %                 [inputdata_mean, R] = geotiffread([inputfile_mean img_path_list_mean(kk).name]);
%         inputdataB1_90 = double(inputdata_90(:,:,1));
% %                 inputdataB1_mean = double(inputdata_mean(:,:,1));
%         [hang,lie] = size(inputdataB1);
%         B0 = reshape(inputdataB1,hang*lie,1);
%         B0_90 = reshape(inputdataB1_90,hang*lie,1);
% %                 B0_mean = reshape(inputdataB1_mean,hang*lie,1);
%         B_double = double(B0);
%         B_double_90 = double(B0_90);
%         B_double(isnan(B_double))=0;
%         B_double_90(isnan(B_double_90))=0;
% %                 B_double_mean = double(B0_mean);
%         B_double_1 = B_double-B_double_90;
%         B_double_1(B_double_1<0) = 0;
%         cumulative_heat = cumulative_heat + B_double_1;
%         B_double_2 = zeros(hang*lie,1);
%         B_double_2(B_double>B_double_90) = 1;
%         Heat_extreme_days = Heat_extreme_days + B_double_2;
%     end
%     heat_intense = cumulative_heat./ Heat_extreme_days;
%     heat_intense(heat_intense==Inf)=0;
%       heat_intense(isnan(heat_intense))=0;
%     bandmean_img = reshape(cumulative_heat,[hang,lie,1]);
%     intense_img = reshape(heat_intense,[hang,lie,1]);
%     geotiffwrite([outputfile  num2str(i+1984) '_cumulative_heat.tif' ],bandmean_img,R, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);  %写出带有地理信息的geotif文件
%     geotiffwrite([outputfile1  num2str(i+1984) '_heatintense.tif' ],intense_img,R, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);
% end
% 


%% 
% %% part 5 calculate the sum of heat extreme days
% 
% clc
% clear all
% 
% path0 = 'I:\20230213修订后数据表格\20230921大修文件\AT_tif\heat extremes\';
% img_path_list0 = dir(strcat(path0,'*.tif'));
% outputfile='I:\20230213修订后数据表格\20230921大修文件\AT_tif\sum_trend\';
% year = length(img_path_list0);
% 
% Heat_extreme_days =0;
% for i = 1:year-1
%     [inputdata, R] = geotiffread([path0 img_path_list0(i).name]); %R为空间参考文件
%     info = geotiffinfo([path0 img_path_list0(i).name]);
%     fprintf('%d %d %s\n',i,strcat([path0, img_path_list0(i).name]));% 显示正在处理的图像名
%     Heat_extreme_days = Heat_extreme_days+inputdata;
% end
%  geotiffwrite([outputfile 'total_heatdays_2021_1.tif' ],Heat_extreme_days,R, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);