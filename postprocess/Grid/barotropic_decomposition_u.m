function [u_bt, u_bc] = barotropic_decomposition_u( ...
        uko, dduo_grid, zoo)
% BAROTROPIC_DECOMPOSITION


    % 尺寸
    [iu, ku] = size(uko);
    u_bc = zeros(iu,ku);
    u_bt = zeros(iu,1);

    % === 2) 分母：整柱厚度 (加顶层 η 修正) ===
    Hu = sum(dduo_grid) + zoo;   % (ie+1, je)

    % === 3) 分子：输运 (加顶层 u1*η / v1*η) ===
    Tu = sum(uko .* dduo_grid) + uko(:,1) .* zoo;

    % === 4) 正压（深度平均） ===
    u_bt = (Tu ./ Hu);   % mask 海域

    % === 5) 斜压残差 ===
    for k=1:ku
        u_bc(:,k) = uko(:,k) - u_bt; 
    end

end