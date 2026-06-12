function [Outdata] = Exclude_sponge(spongew,spongee,spongen,sponges,Indata)

Outdata = Indata;
[~,~,k]=size(Outdata);

%% check sponge conditions
% if sponge == 1
% there are no sponge layers

if k~=1

    if (spongew ~= 1)
        Outdata([1:spongew],:,:)=[];
    end
    
    if (spongee ~= 1)
        Outdata([end-spongee+1:end],:,:)=[];
    end
    
    if (spongen ~= 1)
        Outdata(:,[1:spongen],:)=[];
    end
    
    if (sponges ~= 1)
        Outdata(:,[end-sponges+1:end],:)=[];
    end


else

    if (spongew ~= 1)
        Outdata([1:spongew],:)=[];
    end
    
    if (spongee ~= 1)
        Outdata([end-spongee+1:end],:)=[];
    end
    
    if (spongen ~= 1)
        Outdata(:,[1:spongen])=[];
    end
    
    if (sponges ~= 1)
        Outdata(:,[end-sponges+1:end])=[];
    end

end

end