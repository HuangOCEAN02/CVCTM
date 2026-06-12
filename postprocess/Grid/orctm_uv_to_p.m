function [PPP] = orctm_uv_to_p(UUU,vector)

[m,n,q]=size(UUU);

if q~=1
    if vector =='u';
        UPP = zeros(m-1,n,q);
        for k=1:q
            UPP = (UUU(1:1:end-1,:,:) + UUU(2:1:end,:,:))/2;
        end
        PPP = UPP;
    end
    
    if vector =='v';
        VPP = zeros(m,n-1,q);
        for k=1:q
            VPP = (UUU(:,1:1:end-1,:) + UUU(:,2:1:end,:))/2;
        end
        PPP = VPP;
    end

else

    if vector =='u';
        UPP = zeros(m-1,n);
        for k=1:q
            UPP = (UUU(1:1:end-1,:) + UUU(2:1:end,:))/2;
        end
        PPP = UPP;
    end
    
    if vector =='v';
        VPP = zeros(m,n-1);
        for k=1:q
            VPP = (UUU(:,1:1:end-1) + UUU(:,2:1:end))/2;
        end
        PPP = VPP;
    end
end