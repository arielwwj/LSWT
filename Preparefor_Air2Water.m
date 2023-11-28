% prepare cc and cv files for Air2Water model
clear all
clc

%the first line in the excel file is the lake ID, the first three columns are year, month, and day,respectively.
LSWTcc0 = xlsread('path');  %path of cc in excel file
LSWTcv0 = xlsread('path');  %path of cv in excel file
path_0 = 'path';
File = dir(fullfile(path_0,'*.xlsx'));
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
        
        pathcc = 'path'; %write path of cc txt
        filenamecc = [ pathcc,int2str(ID_i),'_cc.txt'];
        pathcv = 'path'; %write path of cv txt
        filenamecv = [pathcv,int2str(ID_i),'_cv.txt'];
        fidcc = fopen(filenamecc,'w');
        fprintf(fidcc,[repmat('%5.3f\t', 1, size(cc,2)), '\n'], cc');
        fclose(fidcc);
        fidcv = fopen(filenamecv,'w');
        fprintf(fidcv,[repmat('%5.3f\t', 1, size(cv,2)), '\n'], cv');
        fclose(fidcv);
        
    end
    
end
