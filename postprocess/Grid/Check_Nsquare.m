function [N_result] = Check_Nsquare(Nsq2, D_nsq) 


    epsv = 1e-8;              % 极小正数
% No.1 check nan
    N2 = fillmissing(Nsq2,'linear','EndValues','nearest');
% No.2 check negative or zero values 
    N2(N2<=0)=epsv;



    % 输出
    N_result = N2;
end