VCUR = ncread(name,'VCUR');
VCUR_QC = ncread(name,'VCUR_QC');
VCUR_QC(VCUR_QC==2)=1;
VCUR_QC(VCUR_QC>=3)=0;
VCUR = VCUR.*double(VCUR_QC);
VCUR(PERCENT_GOOD_QC~=1)=nan;

V_timecheck = VCUR(:,find(time_mask~=0));

clear VCUR_QC VCUR

%% MASK_VVV check again
V_timecheck(isnan(V_timecheck))=0;
V_mask = zeros(size(V_timecheck))+1;
V_mask(V_timecheck==0)=0;