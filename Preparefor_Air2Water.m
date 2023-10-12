%提取air2water的所需cccv文件
clear all
clc

% LSWTcc0 = xlsread("H:\remove heat extremes\ORI_preparecccvOLI-去除30%数据230418.xlsx",1);
% LSWTcv0 = xlsread("H:\remove heat extremes\ORI_preparecccvOLI-去除30%数据230418.xlsx",2);
% Tempcc0 = xlsread("H:\remove heat extremes\ORI_preparecccvOLI-去除30%数据230418.xlsx",3);
% Tempcv0 = xlsread("H:\remove heat extremes\ORI_preparecccvOLI-去除30%数据230418.xlsx",4);
% LSWTcc0 = xlsread("H:\CMIP6\OLIDATA.xlsx",1);
% LSWTcv0 = xlsread("H:\CMIP6\OLIDATA.xlsx",2);
% Tempcc0 = csvread("H:\CMIP6\sspforcccv585_1.csv",1,0);
% Tempcv0 = csvread("H:\CMIP6\SSP585revise_forcccv_0.csv",1,0);

LSWTcc0 = xlsread("I:\20230213修订后数据表格\20230921大修文件\1985-2021RHSAT_onelandsat.xlsx",3);
LSWTcv0 = xlsread("I:\20230213修订后数据表格\20230921大修文件\1985-2021RHSAT_onelandsat.xlsx",4);
path_0 = 'I:\20230213修订后数据表格\20230921大修文件\';
File = dir(fullfile(path_0,'*2021RHSAT_onelandsat.xlsx'));
FileNames = {File.name}';

for name = 1:1
    name_i = FileNames{name,1}
    file_path_1 = [path_0,name_i];
    Tempcc0 = xlsread(file_path_1,1);
    Tempcv0 = xlsread(file_path_1,2);
    
    datecc = LSWTcc0(2:end,1:3);
    datecv = LSWTcv0(2:end,1:3);
    
    IDlist = LSWTcc0(1,4:end);
    Tempcc1 = Tempcc0(2:end,4:end);
    Tempcv1 = Tempcv0(2:end,4:end);
    LSWTcc1 = LSWTcc0(2:end,4:end);
    LSWTcv1 = LSWTcv0(2:end,4:end);
    
    LSWTcc1(find(isnan(LSWTcc1)==1)) = -999.000;
    LSWTcv1(find(isnan(LSWTcv1)==1)) = -999.000;
    
    for i = 1:length(IDlist)
        ID_i = IDlist(i);
        Tempcc1_i = Tempcc1(:,i);
        Tempcv1_i = Tempcv1(:,i);
        LSWTcc1_i = LSWTcc1(:,i);
        LSWTcv1_i = LSWTcv1(:,i);
        cc = [datecc,Tempcc1_i,LSWTcc1_i];
        cv = [datecv,Tempcv1_i,LSWTcv1_i];
        
%         name_i1 = name_i(1,1:end-4)
%         mkdir('H:\CMIP6\GCMS_TAS\For_air2water\',name_i1);
        pathcc = 'I:\20230213修订后数据表格\20230921大修文件\RHSAT19852021\CC_IN\';
        filenamecc = [ pathcc,int2str(ID_i),'_cc.txt'];
        pathcv = 'I:\20230213修订后数据表格\20230921大修文件\RHSAT19852021\CV_IN\';
        filenamecv = [pathcv,int2str(ID_i),'_cv.txt'];
        fidcc = fopen(filenamecc,'w');
        fprintf(fidcc,[repmat('%5.3f\t', 1, size(cc,2)), '\n'], cc');
        fclose(fidcc);
        fidcv = fopen(filenamecv,'w');
        fprintf(fidcv,[repmat('%5.3f\t', 1, size(cv,2)), '\n'], cv');
        fclose(fidcv);
        
    end
    
end