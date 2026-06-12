clear;close all
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
m_select = 1;
SSH = zeros(807,599);
for m_select = 1:12
    load(['ave_ssh_',month_file{m_select},'mean_CVCTM.mat']);
    SSH =  SSH_month_mean + SSH;
end
SSH_mean=SSH/12;

save Average_ssh.mat SSH_mean
