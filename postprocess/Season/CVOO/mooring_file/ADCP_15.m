clear;clc;close all
%% 15  is ADCP
Loc = './kpo_1128/';
file= 'kpo_1128_instr_15.nc';
name = [Loc,file];
ncdisp(name)
%% No.1 Basic info.
LONGITUDE = ncread(name,'LONGITUDE');
LATITUDE = ncread(name,'LATITUDE');

TIME = ncread(name,'TIME')+712224.0; % matlab datenum
TIME_QC = ncread(name,'TIME_QC');

DEPTH = ncread(name,'DEPTH'); % bins for vertical interpolation
FULL_DEPTH    = ncread(name,'FULL_DEPTH');
FULL_DEPTH_QC = ncread(name,'FULL_DEPTH_QC');

FULL_DEPTH(isnan(FULL_DEPTH)) = 0;
FULL_DEPTH(FULL_DEPTH<=0)=0;

%% No.2 MASK_ori is based on the FULL_DEPTH and TIME
FULL_DEPTH_QC(FULL_DEPTH_QC==2)=1;
FULL_DEPTH_QC(FULL_DEPTH_QC>=3)=0;
FULL_DEPTH = FULL_DEPTH.*double(FULL_DEPTH_QC);

TIME_QC(TIME_QC==2)=1;
TIME_QC(TIME_QC>=3)=0;
TIME(TIME_QC==0)=0;

time_mask = sum(FULL_DEPTH,1);

Depth = FULL_DEPTH(:,find(time_mask~=0));
TIME(time_mask==0)=[];
%% No.3 Percentgood for correcting data
PERCENT_GOOD    = ncread(name,'PERCENT_GOOD');
PERCENT_GOOD_QC = ncread(name,'PERCENT_GOOD_QC');

PERCENT_GOOD_QC(PERCENT_GOOD_QC==2)=1;
PERCENT_GOOD_QC(PERCENT_GOOD_QC>=3)=0;
PERCENT_GOOD(PERCENT_GOOD_QC==0)=0;
%% No.4 UUU
run ADCP_U.m
%% No.5 VVV
run ADCP_V.m
%% No.6 UV_mask and Boundary mask correct 
UV_mask = U_mask.*V_mask;

Depth(UV_mask==0) = nan;
V_timecheck(UV_mask==0) = nan;
U_timecheck(UV_mask==0) = nan;
[U_check,ixu,jyu] = Remove_boundary(U_timecheck);
[V_check,~,~] = Remove_boundary(V_timecheck);
clear U_timecheck V_timecheck U_mask V_mask UV_mask

TIME([jyu])=[];
Depth(ixu,:)=[];
Depth(:,jyu)=[];
clear PERCENT_GOOD FULL_DEPTH_QC TIME_QC 
%% No.7 Time correct
Strat_time = datetime(2014,04,21,0,0,0,'Locale','en_US');
End_time = datetime(2015,04,21,0,0,0,'Locale','en_US');
tt_new=[Strat_time:duration(1,0,0):End_time]'; % hourly interval

int = find(datetime(TIME,'ConvertFrom','datenum')>=Strat_time);
t_start = int(1);
int = find(datetime(TIME,'ConvertFrom','datenum')<=End_time);
t_end = int(end);

t_area = [t_start:1:t_end];
tt = datetime(TIME(t_area),'ConvertFrom','datenum','Locale','en_US');

Depth = Depth(:,t_area);
U_check = U_check(:,t_area);
V_check = V_check(:,t_area);

clear TIME jyu ixu 
clear t_end t_start int
%% No.8 Vertical refilling For Z-axis
d_inter = [30:5:290]'
ke = length(d_inter);
% mask for vertical refilling
Mask_refilling = zeros(size(U_check))+1;
Mask_refilling(isnan(U_check)==1)=0;

u_dd = zeros(ke,size(U_check,2));
v_dd = zeros(ke,size(V_check,2));

for t=1:size(U_check,2)
    disp(['timestep = ',num2str(t)])
    clear ind ins
    ind =  Mask_refilling(:,t);
    [i_s] = find(ind==1);
    % d_min = zz(i_s(1),t);
    % d_max = zz(i_s(end),t);
    u_dd(:,t) = interp1(Depth(i_s,t),U_check(i_s,t),d_inter,'linear');
    v_dd(:,t) = interp1(Depth(i_s,t),V_check(i_s,t),d_inter,'linear');
end

clear Mask_refilling U_check V_check
%% No.9 Temporal refilling For X-axis
Mask_refilling = zeros(size(u_dd))+1;
Mask_refilling(isnan(u_dd))=0;

U_inter1 = zeros(size(u_dd));
V_inter1 = zeros(size(u_dd));
dt = hours(1);
for k = 1:ke
     disp(['k level = ',num2str(k)])
     clear t_inter ind
     ind =  Mask_refilling(k,:);
     [t_s] = find(ind==1);
     t_inter = [t_s(1):1:t_s(end)];
     % Refilling
     U_inter1(k,t_s(1):1:t_s(end))= ...
             fillmissing(u_dd(k,t_s(1):1:t_s(end)),'linear','SamplePoints',t_inter);
     V_inter1(k,t_s(1):1:t_s(end))= ...
             fillmissing(v_dd(k,t_s(1):1:t_s(end)),'linear','SamplePoints',t_inter);

     u_refill_original = retime(timetable(tt(:),U_inter1(k,:)'),'regular','linear','TimeStep',dt);
     v_refill_original = retime(timetable(tt(:),V_inter1(k,:)'),'regular','linear','TimeStep',dt);

     u_time_original(k,:) = double(u_refill_original.Var1);
     v_time_original(k,:) = double(v_refill_original.Var1);

end

time_original=u_refill_original.Time;
clear u_dd v_dd
clear U_inter1 V_inter1 Mask_refilling
clear u_refill_original v_refill_original

%% No.9 Save data for drawing
save CVOO_ADCP_grid.mat d_inter
save CVOO_ADCP_time.mat time_original
save CVOO_ADCP_u.mat  u_time_original
save CVOO_ADCP_v.mat  v_time_original
%% No.10
figure;
pcolor(time_original,d_inter,u_time_original);shading interp;
clim([-0.5 0.5])



