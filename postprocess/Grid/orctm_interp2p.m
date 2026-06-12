function [OUTdata] = orctm_interp2p(INdata,IE,JE,CHA)


MM = INdata;

[ie,je]=size(MM);

if IE == ie-1 && JE == je && CHA =='u' % u
    MAT = zeros(ie-1,je);
    MAT(1:1:ie-1,:) = (MM(1:1:ie-1,:) + MM(2:1:ie,:))./2.0;
end

if IE == ie && JE == je-1 && CHA =='v' % v
    MAT = zeros(ie,je-1);
    MAT(:,1:1:je-1) = (MM(:,1:1:je-1) + MM(:,2:1:je))./2.0;
end


OUTdata = MAT;
end