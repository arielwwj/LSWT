%% run ANN
clc
clear all

i = 1;
while i < Lake_num   % Lake_num is the number of studied lakes
    kk = 0;
    while kk<20      % Provides 20 runs to find results that meet requirements
        name1 = ['path'];  % X-data path
        name2 = ['path'];  % Y-data path
        X = csvread(name1,0,0);
        Y = csvread(name2,0,0);
        
        totalnum = length(Y);
        num70 = round(totalnum*0.7);
        
        temp = randperm(size(X,1));
        % train dataseet
        P_train = X(temp(1:num70),:)';
        T_train = Y(temp(1:num70),:)';
        % test dataset
        P_test = X(temp(num70+1:end),:)';
        T_test = Y(temp(num70+1:end),:)';
        
        P_total = X';
        T_total = Y';
        
        N_test = size(P_test,2);
        N_train = size(P_train,2);
        N_all = size(P_total,2);
        
        [p_total, ps_input] = mapminmax(P_total,0,1);
        p_test = mapminmax('apply',P_test,ps_input);
        p_train = mapminmax('apply',P_train,ps_input);
        [t_total, ps_output] = mapminmax(T_total,0,1);
        t_train = mapminmax('apply',T_train,ps_output);
        t_test = mapminmax('apply',T_test,ps_output);
        
        %Create net
        
        net = newff(p_train,t_train,3);
        
        % set the training parameter
        net.trainParam.epochs = 1000;
        net.trainParam.goal = 1e-3;
        net.trainParam.lr = 0.01;
        
        % train the net
        LSWT_model = train(net,p_train,t_train);
        
        %test
        t_sim_test_LSWT = sim(LSWT_model,p_test);
        t_sim_train_LSWT = sim(LSWT_model,p_train);
        t_sim_total_LSWT = sim(LSWT_model,p_total);
        
        T_sim_test_LSWT = mapminmax('reverse',t_sim_test_LSWT,ps_output);
        T_sim_train_LSWT = mapminmax('reverse',t_sim_train_LSWT,ps_output);
        T_sim_total_LSWT = mapminmax('reverse',t_sim_total_LSWT,ps_output);
        
        error1 = abs(T_sim_test_LSWT - T_test)./T_test;
        error2 = abs(T_sim_train_LSWT - T_train)./T_train;
        error3 = abs(T_sim_total_LSWT - T_total)./T_total;
        
        %R^2
        R2_1_LSWT = (N_test * sum(T_sim_test_LSWT .* T_test) - sum(T_sim_test_LSWT) * sum(T_test))^2 / ((N_test * sum((T_sim_test_LSWT).^2) - (sum(T_sim_test_LSWT))^2) * (N_test * sum((T_test).^2) - (sum(T_test))^2));
        R2_2_LSWT = (N_train * sum(T_sim_train_LSWT .* T_train) - sum(T_sim_train_LSWT) * sum(T_train))^2 / ((N_train * sum((T_sim_train_LSWT).^2) - (sum(T_sim_train_LSWT))^2) * (N_train * sum((T_train).^2) - (sum(T_train))^2));
        R2_3_LSWT = (N_all * sum(T_sim_total_LSWT .* T_total) - sum(T_sim_total_LSWT) * sum(T_total))^2 / ((N_all * sum((T_sim_total_LSWT).^2) - (sum(T_sim_total_LSWT))^2) * (N_all * sum((T_total).^2) - (sum(T_total))^2));
        
        %rRMSE
        LSWT_Rrmse_test =sqrt(sum(((T_sim_test_LSWT-T_test)./T_test).^2)./length(T_test))*100;%??rRMSE
        LSWT_Rrmse_train =sqrt(sum(((T_sim_train_LSWT - T_train)./T_train).^2)./length(T_train))*100;
        LSWT_Rrmse_all =sqrt(sum(((T_sim_total_LSWT - T_total)./T_total).^2)./length(T_total))*100;
        
        %MRE
        LSWT_MRE_test =(sum(abs((T_sim_test_LSWT-T_test)./T_test))./length(T_test))*100;%??MRE
        LSWT_MRE_train =(sum(abs((T_sim_train_LSWT - T_train)./T_train))./length(T_train))*100;
        LSWT_MRE_all =(sum(abs((T_sim_total_LSWT - T_total)./T_total))./length(T_total))*100;
        
        %MAE
        LSWT_MAE_test =(sum(abs(T_sim_test_LSWT-T_test))./length(T_test));%??MAE
        LSWT_MAE_train =(sum(abs(T_sim_train_LSWT - T_train))./length(T_train));
        LSWT_MAE_all =(sum(abs(T_sim_total_LSWT - T_total))./length(T_total));
        
        %RMSE
        LSWT_rmse_test =sqrt((sum((T_sim_test_LSWT-T_test).^2))./length(T_test));%??RMSE
        LSWT_rmse_train =sqrt((sum((T_sim_train_LSWT - T_train).^2))./length(T_train));
        LSWT_rmse_all =sqrt((sum((T_sim_total_LSWT - T_total).^2))./length(T_total));
        
        
        if R2_2_LSWT < 0.85
            kk = kk+1
            continue
            
        else
            Xlsxstring = ['path'];  %write path
            xlswrite(Xlsxstring,T_total','T_total')
            xlswrite(Xlsxstring,T_sim_total_LSWT','T_sim_total_LSWT')
        end
        i = i+1
        
    end
    Xlsxstring = ['path'];
    xlswrite(Xlsxstring,T_total','T_total')
    xlswrite(Xlsxstring,T_sim_total_LSWT','T_sim_total_LSWT')
    i = i+1
end


