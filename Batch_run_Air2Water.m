clear all
clc
fileFolder=fullfile('path'); %file folder path
dirOutput=dir(fullfile(fileFolder));      
fileNames={dirOutput.name}';            

IDLIST = xlsread('path'); %lake ID for lakes need to be simulated
path_parameter = 'path';

for gcm = 1:length(fileNames)
    
    gcm_i = fileNames{1,gcm};
    Pathcc = ['path'];                   % file folder path of cc
    Pathcv = ['path'];                   % file folder path of cv
    DST_PATH_t0 = 'path';                % folders to batch run Air2Water
    
    newcc = 'stndrck_sat_cc.txt';
    newcv = 'stndrck_sat_cv.txt';
    newpara = 'parameters.txt';
    ccoutput = ['path'];
    cvoutput = ['path'];
    otherfiles_path = ['path'];   %path for other output files

    Length_ID = size(IDLIST,1);
    
    for k = 1:Length_ID
        imname = IDLIST(k);
        workpath_i = [DST_PATH_t0,num2str(imname)];
        cd(workpath_i)
        
        DST_PATH_t = [DST_PATH_t0,num2str(imname),'\Superior\'];
        FileNamescc = [int2str(imname),'_cc.txt'];
        FileNamescv = [int2str(imname),'_cv.txt'];

        K_Trace_cc = strcat(Pathcc, FileNamescc);
        K_Trace_cv = strcat(Pathcv, FileNamescv);
        
        K_Trace_paraname = [path_parameter,'parameters_ID=',int2str(imname),'.txt'];

        
        copyfile(K_Trace_cc,[DST_PATH_t, newcc]);
        copyfile(K_Trace_cv,[DST_PATH_t, newcv]);
        copyfile(K_Trace_paraname,[DST_PATH_t, newpara]);
        cmd = [workpath_i,'\air2water_v2.0.exe'];

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
        
        copyfile(satfilename_cc,ccoutname);
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
