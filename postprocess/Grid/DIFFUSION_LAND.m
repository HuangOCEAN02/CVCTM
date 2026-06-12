% function  [t,s] = DIFFUSION_LAND(ttt_ori,sss_ori,mask)
function  [t] = DIFFUSION_LAND(ttt_ori,mask)
count=0;
sum_t=0;
% sum_s=0;
for i = 1 : size(mask,1)
    for j = 1: size(mask,2)
        if (mask(i,j)==1)
            count = count + 1;
            sum_t = sum_t + ttt_ori(i,j);
%             sum_s = sum_s + sss_ori(i,j); 
        end
    end
end
ave_t = sum_t./count;
% ave_s = sum_s./count;

for i = 1 : size(mask,1)
    for j = 1: size(mask,2)
        if (mask(i,j)==0)        
        ttt_ori(i,j) = ave_t;
%         sss_ori(i,j) = ave_s;   
        end
    end
end

t = ttt_ori;
% s = sss_ori;

end

