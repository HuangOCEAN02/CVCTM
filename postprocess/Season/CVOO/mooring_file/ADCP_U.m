UCUR = ncread(name,'UCUR');
UCUR_QC = ncread(name,'UCUR_QC');
UCUR_QC(UCUR_QC==2)=1;
UCUR_QC(UCUR_QC>=3)=0;
UCUR = UCUR.*double(UCUR_QC);
UCUR(PERCENT_GOOD_QC~=1)=nan;

U_timecheck = UCUR(:,find(time_mask~=0));
% Uobs = UCUR(:,find(time_mask~=0));

clear UCUR_QC UCUR

%% MASK_UUU check again
U_timecheck(isnan(U_timecheck))=0;
U_mask = zeros(size(U_timecheck))+1;
U_mask(U_timecheck==0)=0;



