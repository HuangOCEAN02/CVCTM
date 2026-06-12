function [profile_all,Z] = Fillcolumn(z,profile,depto)
    % profile without surface and bottom
    % z should have nan vaule below the seafloor
    KE = length(profile);
    Z = zeros(KE+2,1);
    profile_all = zeros(KE+2,1);
    
    mask = zeros(size(z));
    mask(:) = 1 ;
    mask(isnan(z))=0;
    
    btm_ind = sum(mask);
    
    [z,inx]= rmmissing(z);
    profile(inx)=[];

    for k =  1: btm_ind
        if depto < z(k)
            profile(k)=profile(k-1);
            z(k)=depto;
        end
    end

    profile_all(2:btm_ind+1) = profile(:);
    Z(2:btm_ind+1) = z(1:btm_ind);
    
    profile_all(1) = profile(1);
    Z(1) = 0;
    
    profile_all(btm_ind+2:end) = profile(btm_ind);
    Z(btm_ind+2:end) = depto;
end