clear;clc;close all
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
addpath ../../Grid/
load('Grid_info.mat','ke','weto_p','depto_grid');
load('Grid_resolution.mat','dlxp','dlyp');
iw = 10;ie = 1;
jn = 10;js = 10;

weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
dlxp = Exclude_sponge(iw,ie,jn,js,dlxp);
dlyp = Exclude_sponge(iw,ie,jn,js,dlyp);

load('CoastalDakar_index.mat');
depto_grid   = depto_grid(select_indicex,select_indicey);
dlxp = dlxp(select_indicex,select_indicey);
dlyp = dlyp(select_indicex,select_indicey);

ie = size(depto_grid,1);
je = size(depto_grid,2);
load('./Pressure/NorthDakar_index.mat');
depto_grid_NDA = depto_grid(select_indicex,select_indicey);
dlxp_NDA = dlxp(select_indicex,select_indicey);
dlyp_NDA = dlyp(select_indicex,select_indicey);
ie_NDA = size(depto_grid_NDA,1);
je_NDA = size(depto_grid_NDA,2);
load('./Pressure/SouthDakar_index.mat');
depto_grid_SDA = depto_grid(select_indicex,select_indicey);
dlxp_SDA = dlxp(select_indicex,select_indicey);
dlyp_SDA = dlyp(select_indicex,select_indicey);

ie_SDA = size(depto_grid_SDA,1);
je_SDA = size(depto_grid_SDA,2);

 % Sorting
[depto_NDA_x,inx_NDA] = sort(depto_grid_NDA(:),'ascend');
[depto_SDA_x,inx_SDA] = sort(depto_grid_SDA(:),'ascend');
dlxp_NDA_x(:) = dlxp_NDA(inx_NDA);
dlyp_NDA_x(:) = dlyp_NDA(inx_NDA);
dlxp_SDA_x(:) = dlxp_SDA(inx_SDA);
dlyp_SDA_x(:) = dlyp_SDA(inx_SDA);
%%
% NDA_mode
% SDA_mode
imodes = 10;
inteval = 100;
ismask=0;
SaveLocation = './Energy_analysis'
for m_select = 1: 12
     load(['./mode_function_MSS/Mode_Gene_1/M2_Mode1_Conversion_',month_file{m_select},'.mat']); % C_mode
     load(['./mode_function_MSS/Mode_Flux/M2_Flux_Mode_',month_file{m_select},'.mat'],'Div_F'); % 
     if ismask 
         load('./Mode_function_MSS/Modal_mask_MSS.mat');
         C_mode = C_mode.*Eigen_mask;
         for mm=1:10
            Div_F(:,:,mm) = Div_F(:,:,mm).*Eigen_mask;
         end
     end
%% NDA
    load('./Pressure/NorthDakar_index.mat');
    C_NDA_month = C_mode(select_indicex,select_indicey);
    C_NDA_month = reshape(C_NDA_month,[ie_NDA*je_NDA,1]);
    D_NDA_month = Div_F(select_indicex,select_indicey,1);
    D_NDA_month = reshape(D_NDA_month,[ie_NDA*je_NDA,1]);
    % Sorting
    C_NDA_month_sorted = C_NDA_month(inx_NDA);
    C_NDA_month_sorted(C_NDA_month_sorted==0)=nan;
    D_NDA_month_sorted = D_NDA_month(inx_NDA);
    D_NDA_month_sorted(D_NDA_month_sorted==0)=nan;
%% SDA
    load('./Pressure/SouthDakar_index.mat');
    C_SDA_month = C_mode(select_indicex,select_indicey);
    C_SDA_month = reshape(C_SDA_month,ie_SDA*je_SDA,1);
    D_SDA_month = Div_F(select_indicex,select_indicey,1);
    D_SDA_month = reshape(D_SDA_month,ie_SDA*je_SDA,1);
    % Sorting
    C_SDA_month_sorted = C_SDA_month(inx_SDA);
    C_SDA_month_sorted(C_SDA_month_sorted==0)=nan;
    D_SDA_month_sorted = D_SDA_month(inx_SDA);
    D_SDA_month_sorted(D_SDA_month_sorted==0)=nan;
%%
    C_NDA_month_sorted(:)=C_NDA_month_sorted(:).*dlxp_NDA_x'.*dlyp_NDA_x'; % W
    C_SDA_month_sorted(:)=C_SDA_month_sorted(:).*dlxp_SDA_x'.*dlyp_SDA_x'; % W
    R_NDA_month_sorted(:)=C_NDA_month_sorted(:) - D_NDA_month_sorted(:).*dlxp_NDA_x'.*dlyp_NDA_x'; % W
    R_SDA_month_sorted(:)=C_SDA_month_sorted(:) - D_SDA_month_sorted(:).*dlxp_SDA_x'.*dlyp_SDA_x'; % W
        for iiz = 1:1:5000/inteval
            up =  (iiz-1)*inteval;
            dow = (iiz)*inteval;
            dpe(iiz) = (up+dow)./2;
            C_NDA_sum(iiz) = sum(C_NDA_month_sorted(depto_NDA_x<=dow & depto_NDA_x>up),'omitmissing');
            C_SDA_sum(iiz) = sum(C_SDA_month_sorted(depto_SDA_x<=dow & depto_SDA_x>up),'omitmissing');
            R_NDA_sum(iiz) = sum(R_NDA_month_sorted(depto_NDA_x<=dow & depto_NDA_x>up),'omitmissing');
            R_SDA_sum(iiz) = sum(R_SDA_month_sorted(depto_SDA_x<=dow & depto_SDA_x>up),'omitmissing');
        end

save([SaveLocation,'/Generation_depth_Mode1_', month_file{m_select}, '.mat'], ...
     'C_NDA_sum','C_SDA_sum','R_NDA_sum','R_SDA_sum','dpe','-v7.3');
end

for m_select = 1: 12
     load(['./mode_function_MSS/Mode_Gene_2/M2_Mode2_Conversion_',month_file{m_select},'.mat']); % C_mode
     load(['./mode_function_MSS/Mode_Flux/M2_Flux_Mode_',month_file{m_select},'.mat'],'Div_F'); % 
     if ismask 
         load('./Mode_function_MSS/Modal_mask_MSS.mat');
         C_mode = C_mode.*Eigen_mask;
         for mm=1:10
            Div_F(:,:,mm) = Div_F(:,:,mm).*Eigen_mask;
         end
     end
%% NDA
    load('./Pressure/NorthDakar_index.mat');
    C_NDA_month = C_mode(select_indicex,select_indicey);
    C_NDA_month = reshape(C_NDA_month,[ie_NDA*je_NDA,1]);
    D_NDA_month = Div_F(select_indicex,select_indicey,2);
    D_NDA_month = reshape(D_NDA_month,[ie_NDA*je_NDA,1]);
    % Sorting
    C_NDA_month_sorted = C_NDA_month(inx_NDA);
    C_NDA_month_sorted(C_NDA_month_sorted==0)=nan;
    D_NDA_month_sorted = D_NDA_month(inx_NDA);
    D_NDA_month_sorted(D_NDA_month_sorted==0)=nan;
%% SDA
    load('./Pressure/SouthDakar_index.mat');
    C_SDA_month = C_mode(select_indicex,select_indicey);
    C_SDA_month = reshape(C_SDA_month,ie_SDA*je_SDA,1);
    D_SDA_month = Div_F(select_indicex,select_indicey,2);
    D_SDA_month = reshape(D_SDA_month,ie_SDA*je_SDA,1);
    % Sorting
    C_SDA_month_sorted = C_SDA_month(inx_SDA);
    C_SDA_month_sorted(C_SDA_month_sorted==0)=nan;
    D_SDA_month_sorted = D_SDA_month(inx_SDA);
    D_SDA_month_sorted(D_SDA_month_sorted==0)=nan;
%%
    C_NDA_month_sorted(:)=C_NDA_month_sorted(:).*dlxp_NDA_x'.*dlyp_NDA_x'; % W
    C_SDA_month_sorted(:)=C_SDA_month_sorted(:).*dlxp_SDA_x'.*dlyp_SDA_x'; % W
    R_NDA_month_sorted(:)=C_NDA_month_sorted(:) - D_NDA_month_sorted(:).*dlxp_NDA_x'.*dlyp_NDA_x'; % W
    R_SDA_month_sorted(:)=C_SDA_month_sorted(:) - D_SDA_month_sorted(:).*dlxp_SDA_x'.*dlyp_SDA_x'; % W
  
        for iiz = 1:1:5000/inteval
            up =  (iiz-1)*inteval;
            dow = (iiz)*inteval;
            dpe(iiz) = (up+dow)./2;
            C_NDA_sum(iiz) = sum(C_NDA_month_sorted(depto_NDA_x<=dow & depto_NDA_x>up),'omitmissing');
            C_SDA_sum(iiz) = sum(C_SDA_month_sorted(depto_SDA_x<=dow & depto_SDA_x>up),'omitmissing');
            R_NDA_sum(iiz) = sum(R_NDA_month_sorted(depto_NDA_x<=dow & depto_NDA_x>up),'omitmissing');
            R_SDA_sum(iiz) = sum(R_SDA_month_sorted(depto_SDA_x<=dow & depto_SDA_x>up),'omitmissing');
        end

save([SaveLocation,'/Generation_depth_Mode2_', month_file{m_select}, '.mat'], ...
     'C_NDA_sum','C_SDA_sum','R_NDA_sum','R_SDA_sum','dpe','-v7.3');
end


for m_select = 1: 12
     load(['./mode_function_MSS/Mode_Gene_3/M2_High_Mode_Conversion_',month_file{m_select},'.mat']); % C_mode
     load(['./mode_function_MSS/Mode_Flux/M2_Flux_Mode_',month_file{m_select},'.mat'],'Div_F'); % 
     if ismask 
         load('./Mode_function_MSS/Modal_mask_MSS.mat');
         C_mode = C_mode.*Eigen_mask;
         for mm=1:10
            Div_F(:,:,mm) = Div_F(:,:,mm).*Eigen_mask;
         end
     end
%% NDA
    load('./Pressure/NorthDakar_index.mat');
    C_NDA_month = C_mode(select_indicex,select_indicey);
    C_NDA_month = reshape(C_NDA_month,[ie_NDA*je_NDA,1]);
    D_NDA_month = sum(Div_F(select_indicex,select_indicey,3:10),3,'omitmissing');
    D_NDA_month = reshape(D_NDA_month,ie_NDA*je_NDA,1);
    % Sorting
    C_NDA_month_sorted = C_NDA_month(inx_NDA);
    C_NDA_month_sorted(C_NDA_month_sorted==0)=nan;
    D_NDA_month_sorted = D_NDA_month(inx_NDA);
    D_NDA_month_sorted(D_NDA_month_sorted==0)=nan;
%% SDA
    load('./Pressure/SouthDakar_index.mat');
    C_SDA_month = C_mode(select_indicex,select_indicey);
    C_SDA_month = reshape(C_SDA_month,ie_SDA*je_SDA,1);
    D_SDA_month = sum(Div_F(select_indicex,select_indicey,3:10),3,'omitmissing');
    D_SDA_month = reshape(D_SDA_month,ie_SDA*je_SDA,1);
    % Sorting
    C_SDA_month_sorted = C_SDA_month(inx_SDA);
    C_SDA_month_sorted(C_SDA_month_sorted==0)=nan;
    D_SDA_month_sorted = D_SDA_month(inx_SDA);
    D_SDA_month_sorted(D_SDA_month_sorted==0)=nan;
    %%
    C_NDA_month_sorted(:)=C_NDA_month_sorted(:).*dlxp_NDA_x'.*dlyp_NDA_x'; % W
    C_SDA_month_sorted(:)=C_SDA_month_sorted(:).*dlxp_SDA_x'.*dlyp_SDA_x'; % W
    R_NDA_month_sorted(:)=C_NDA_month_sorted(:) - D_NDA_month_sorted(:).*dlxp_NDA_x'.*dlyp_NDA_x'; % W
    R_SDA_month_sorted(:)=C_SDA_month_sorted(:) - D_SDA_month_sorted(:).*dlxp_SDA_x'.*dlyp_SDA_x'; % W
  
        for iiz = 1:1:5000/inteval
            up =  (iiz-1)*inteval;
            dow = (iiz)*inteval;
            dpe(iiz) = (up+dow)./2;
            C_NDA_sum(iiz) = sum(C_NDA_month_sorted(depto_NDA_x<=dow & depto_NDA_x>up),'omitmissing');
            C_SDA_sum(iiz) = sum(C_SDA_month_sorted(depto_SDA_x<=dow & depto_SDA_x>up),'omitmissing');
            R_NDA_sum(iiz) = sum(R_NDA_month_sorted(depto_NDA_x<=dow & depto_NDA_x>up),'omitmissing');
            R_SDA_sum(iiz) = sum(R_SDA_month_sorted(depto_SDA_x<=dow & depto_SDA_x>up),'omitmissing');
       end

save([SaveLocation,'/Generation_depth_Mode3_', month_file{m_select}, '.mat'], ...
     'C_NDA_sum','C_SDA_sum','R_NDA_sum','R_SDA_sum','dpe','-v7.3');
end

%% ALL modes
for m_select = 1: 12
     load(['./mode_function_MSS/Mode_Gene/M2_Model_Conversion_',month_file{m_select},'.mat']); % C
     load(['./mode_function_MSS/Mode_Flux/M2_Flux_Mode_',month_file{m_select},'.mat'],'Div_F'); % 
     if ismask 
         load('./Mode_function_MSS/Modal_mask_MSS.mat');
         for mm=1:10
            C(:,:,mm) = C(:,:,mm).*Eigen_mask;
            Div_F(:,:,mm) = Div_F(:,:,mm).*Eigen_mask;
         end
     end
%% NDA
    load('./Pressure/NorthDakar_index.mat');
    C_NDA_month = sum(C(select_indicex,select_indicey,1:10),3,'omitmissing');
    C_NDA_month = reshape(C_NDA_month,[ie_NDA*je_NDA,1]);
    D_NDA_month = sum(Div_F(select_indicex,select_indicey,1:10),3,'omitmissing');
    D_NDA_month = reshape(D_NDA_month,ie_NDA*je_NDA,1);
    % Sorting
    C_NDA_month_sorted = C_NDA_month(inx_NDA);
    C_NDA_month_sorted(C_NDA_month_sorted==0)=nan;
    D_NDA_month_sorted = D_NDA_month(inx_NDA);
    D_NDA_month_sorted(D_NDA_month_sorted==0)=nan;
%% SDA
    load('./Pressure/SouthDakar_index.mat');
    C_SDA_month = sum(C(select_indicex,select_indicey,1:10),3,'omitmissing');
    C_SDA_month = reshape(C_SDA_month,ie_SDA*je_SDA,1);
    D_SDA_month = sum(Div_F(select_indicex,select_indicey,1:10),3,'omitmissing');
    D_SDA_month = reshape(D_SDA_month,ie_SDA*je_SDA,1);
    % Sorting
    C_SDA_month_sorted = C_SDA_month(inx_SDA);
    C_SDA_month_sorted(C_SDA_month_sorted==0)=nan;
    D_SDA_month_sorted = D_SDA_month(inx_SDA);
    D_SDA_month_sorted(D_SDA_month_sorted==0)=nan;
    %%
    C_NDA_month_sorted(:)=C_NDA_month_sorted(:).*dlxp_NDA_x'.*dlyp_NDA_x'; % W
    C_SDA_month_sorted(:)=C_SDA_month_sorted(:).*dlxp_SDA_x'.*dlyp_SDA_x'; % W
    R_NDA_month_sorted(:)=C_NDA_month_sorted(:) - D_NDA_month_sorted(:).*dlxp_NDA_x'.*dlyp_NDA_x'; % W
    R_SDA_month_sorted(:)=C_SDA_month_sorted(:) - D_SDA_month_sorted(:).*dlxp_SDA_x'.*dlyp_SDA_x'; % W
  
        for iiz = 1:1:5000/inteval
            up =  (iiz-1)*inteval;
            dow = (iiz)*inteval;
            dpe(iiz) = (up+dow)./2;
            C_NDA_sum(iiz) = sum(C_NDA_month_sorted(depto_NDA_x<=dow & depto_NDA_x>up),'omitmissing');
            C_SDA_sum(iiz) = sum(C_SDA_month_sorted(depto_SDA_x<=dow & depto_SDA_x>up),'omitmissing');
            R_NDA_sum(iiz) = sum(R_NDA_month_sorted(depto_NDA_x<=dow & depto_NDA_x>up),'omitmissing');
            R_SDA_sum(iiz) = sum(R_SDA_month_sorted(depto_SDA_x<=dow & depto_SDA_x>up),'omitmissing');
     end

save([SaveLocation,'/Generation_depth_ALLMode_', month_file{m_select}, '.mat'], ...
     'C_NDA_sum','C_SDA_sum','R_NDA_sum','R_SDA_sum','dpe','-v7.3');
end

%% Mode three
for m_select = 1: 12
     load(['./mode_function_MSS/Mode_Gene_3/M2_Mode3_Conversion_',month_file{m_select},'.mat']); % C
     load(['./mode_function_MSS/Mode_Flux/M2_Flux_Mode_',month_file{m_select},'.mat'],'Div_F'); % 
     if ismask 
         load('./Mode_function_MSS/Modal_mask_MSS.mat');
         C_mode = C_mode.*Eigen_mask;
         for mm=1:10
            Div_F(:,:,mm) = Div_F(:,:,mm).*Eigen_mask;
         end
     end
%% NDA
    load('./Pressure/NorthDakar_index.mat');
    C_NDA_month = C_mode(select_indicex,select_indicey);
    C_NDA_month = reshape(C_NDA_month,[ie_NDA*je_NDA,1]);
    D_NDA_month = sum(Div_F(select_indicex,select_indicey,3),3,'omitmissing');
    D_NDA_month = reshape(D_NDA_month,ie_NDA*je_NDA,1);
    % Sorting
    C_NDA_month_sorted = C_NDA_month(inx_NDA);
    C_NDA_month_sorted(C_NDA_month_sorted==0)=nan;
    D_NDA_month_sorted = D_NDA_month(inx_NDA);
    D_NDA_month_sorted(D_NDA_month_sorted==0)=nan;
%% SDA
    load('./Pressure/SouthDakar_index.mat');
    C_SDA_month = C_mode(select_indicex,select_indicey);
    C_SDA_month = reshape(C_SDA_month,ie_SDA*je_SDA,1);
    D_SDA_month = sum(Div_F(select_indicex,select_indicey,3),3,'omitmissing');
    D_SDA_month = reshape(D_SDA_month,ie_SDA*je_SDA,1);
    % Sorting
    C_SDA_month_sorted = C_SDA_month(inx_SDA);
    C_SDA_month_sorted(C_SDA_month_sorted==0)=nan;
    D_SDA_month_sorted = D_SDA_month(inx_SDA);
    D_SDA_month_sorted(D_SDA_month_sorted==0)=nan;
%%
    C_NDA_month_sorted(:)=C_NDA_month_sorted(:).*dlxp_NDA_x'.*dlyp_NDA_x'; % W
    C_SDA_month_sorted(:)=C_SDA_month_sorted(:).*dlxp_SDA_x'.*dlyp_SDA_x'; % W
    R_NDA_month_sorted(:)=C_NDA_month_sorted(:) - D_NDA_month_sorted(:).*dlxp_NDA_x'.*dlyp_NDA_x'; % W
    R_SDA_month_sorted(:)=C_SDA_month_sorted(:) - D_SDA_month_sorted(:).*dlxp_SDA_x'.*dlyp_SDA_x'; % W
  
        for iiz = 1:1:5000/inteval
            up =  (iiz-1)*inteval;
            dow = (iiz)*inteval;
            dpe(iiz) = (up+dow)./2;
            C_NDA_sum(iiz) = sum(C_NDA_month_sorted(depto_NDA_x<=dow & depto_NDA_x>up),'omitmissing');
            C_SDA_sum(iiz) = sum(C_SDA_month_sorted(depto_SDA_x<=dow & depto_SDA_x>up),'omitmissing');
            R_NDA_sum(iiz) = sum(R_NDA_month_sorted(depto_NDA_x<=dow & depto_NDA_x>up),'omitmissing');
            R_SDA_sum(iiz) = sum(R_SDA_month_sorted(depto_SDA_x<=dow & depto_SDA_x>up),'omitmissing');
     end

save([SaveLocation,'/Generation_depth_Mode_Three_', month_file{m_select}, '.mat'], ...
     'C_NDA_sum','C_SDA_sum','R_NDA_sum','R_SDA_sum','dpe','-v7.3');
end