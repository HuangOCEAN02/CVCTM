clear;close all
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
month_str = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};
Location = './AVISO_data';
SSH = zeros(112,83);
for m_select = 1:12
name = [Location,'/CMEMS_AVISO_2014_',month_str{m_select},'.nc'];
%% Read
    lon  = double(ncread(name,'longitude'));
    lat  = double(ncread(name,'latitude'));
    adt  = double(ncread(name,'adt')); 
    SSH = SSH + mean(adt,3);
end
SSH_mean  =SSH/12;
save Average_ssh.mat SSH_mean