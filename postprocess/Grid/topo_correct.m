function [MAT_correct] = topo_correct(MAT,area)

MAT_correct = MAT;

if area == 'MSS'
    MAT(287,75) = nan;
    MAT(283:284,80:83) = nan;
    MAT(282,82:83) = nan;

    MAT_correct(283:284,80:83) =  mean(MAT(281:285,79:84),'all','omitmissing');
    MAT_correct(282,82:83) =  mean(MAT(281:285,79:84),'all','omitmissing');
    MAT_correct(287,75) = mean(MAT(286:288,74:76),'all','omitmissing');
end

if area == 'CVA'

     MAT(203,162) = nan;
     MAT(186,161) = nan;
     MAT(200,140) = nan;

    MAT_correct(203,162) =  mean(MAT(202:204,161:163),'all','omitmissing');
    MAT_correct(186,161) =  mean(MAT(185:187,160:162),'all','omitmissing');
    MAT_correct(200,140) = mean(MAT(199:201,139:141),'all','omitmissing');
end