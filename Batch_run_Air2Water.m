clear all
clc
fileFolder=fullfile('I:\20230213修订后数据表格\20230921大修文件\'); %引号内是需要遍历的路径，填绝对路径，然后保存在fileFolder
dirOutput=dir(fullfile(fileFolder));      %引号内是文件的后缀，写'.png'则读取后缀为'.png'的文件
fileNames={dirOutput.name}';             %将所有文件名，以矩阵形式按行排列，保存到fileNames中
fileNames(1:15) = [];
fileNames(2:end) = [];
% fileNames(3) = [];
% fileNames(19) = [];
%  
% IDLIST = xlsread('H:\Air2Water\try\moveheat\runID.xlsx',6);
IDLIST = [5];
path_parameter = 'H:\Air2Water\try\moveheat\parameterdepth\';

for gcm = 1:length(fileNames)
    
    gcm_i = fileNames{1,gcm};
    Pathcc = ['I:\20230213修订后数据表格\20230921大修文件\',gcm_i,'\CC_IN\'];                   % 设置数据存放的文件夹路径
    Pathcv = ['I:\20230213修订后数据表格\20230921大修文件\',gcm_i,'\CV_IN\'];
    DST_PATH_t0 = 'H:\Air2Water\try\moveheat\MATLAB_partfor\Air2Water_';
    
    newcc = 'stndrck_sat_cc.txt';
    newcv = 'stndrck_sat_cv.txt';
    newpara = 'parameters.txt';
    ccoutput = ['I:\20230213修订后数据表格\20230921大修文件\',gcm_i,'\CC_OUT\'];
    cvoutput = ['I:\20230213修订后数据表格\20230921大修文件\',gcm_i,'\CV_OUT\'];
    otherfiles_path = ['I:\20230213修订后数据表格\20230921大修文件\',gcm_i,'\OTHERS\'];
    % File = dir(fullfile(Pathcc,'*.txt'));  % 显示文件夹下所有符合后缀名为.txt文件的完整信息
    % FileNames = {File.name}';     % 提取符合后缀名为.txt的所有文件的文件名，转换为n行1列
    Length_ID = size(IDLIST,1);
    % for k = 1:Length_ID
    
    for k = 1:1
        imname = IDLIST(k);
        workpath_i = [DST_PATH_t0,num2str(imname)];
        cd(workpath_i)
        
        DST_PATH_t = [DST_PATH_t0,num2str(imname),'\Superior\'];
        FileNamescc = [int2str(imname),'_cc.txt'];
        FileNamescv = [int2str(imname),'_cv.txt'];
        % 连接路径和文件名得到完整的文件路径
        K_Trace_cc = strcat(Pathcc, FileNamescc);
        K_Trace_cv = strcat(Pathcv, FileNamescv);
        
        K_Trace_paraname = [path_parameter,'parameters_ID=',int2str(imname),'.txt'];
        %movefile(filetotalnamecc,DST_PATH_t);
        
        copyfile(K_Trace_cc,[DST_PATH_t, newcc]);% 可使用movefile作剪切
        copyfile(K_Trace_cv,[DST_PATH_t, newcv]);
        copyfile(K_Trace_paraname,[DST_PATH_t, newpara]);
        cmd = [workpath_i,'\air2water_v2.0.exe'];
        %     cmd = 'H:\Air2Water\try\moveheat\MATLAB_partfor\air2water_v2.0.exe';
        system(cmd);
        ccoutname = [ccoutput,int2str(imname),'_cc.out'];
        cvoutname = [cvoutput,int2str(imname),'_cv.out'];
        bestparaname = [otherfiles_path,int2str(imname),'_bestparaname.out'];
        mixccname = [otherfiles_path,int2str(imname),'_mixcc.out'];
        mixcvname = [otherfiles_path,int2str(imname),'_mixcv.out'];
        
        satfilename_cc = [DST_PATH_t,'output_3\2_PSO_RMS_stndrck_sat_cc_1d.out'];
        satfilename_cv = [DST_PATH_t,'output_3\3_PSO_RMS_stndrck_sat_cv_1d.out'];
        satfilename_bestpara = [DST_PATH_t,'output_3\1_PSO_RMS_stndrck_sat_c_1d.out'];
        satfilename_mixcc = [DST_PATH_t,'output_3\4_PSO_RMS_stndrck_sat_cc_1d.out'];
        satfilename_mixcv = [DST_PATH_t,'output_3\5_PSO_RMS_stndrck_sat_cv_1d.out'];
        
        copyfile(satfilename_cc,ccoutname);% 可使用movefile作剪切
        copyfile(satfilename_cv,cvoutname);
        copyfile(satfilename_bestpara,bestparaname);
        copyfile(satfilename_mixcc,mixccname);
        copyfile(satfilename_mixcv,mixcvname);
        delete([DST_PATH_t, newcc]);
        delete([DST_PATH_t, newcv]);
        delete([DST_PATH_t, newpara]);
        output3path = [DST_PATH_t,'output_3'];
        [status, message, messageid] = rmdir(output3path, 's')
    end
    
end