function [u_bt, v_bt, u_bc, v_bc] = barotropic_decomposition( ...
        uko, vke, dduo_grid, ddue_grid, zoo, weto_u, weto_v)
% BAROTROPIC_DECOMPOSITION
% 计算正压(深度平均)流速并得到斜压残差（逐时刻一帧）
%
% 输入:
%   uko        : (ie+1, je,) 
%   vke        : (ie,   je+1) 
%   dduo_grid  : (ie+1, je, ke)  
%   ddue_grid  : (ie,   je+1, ke) 
%   zoo        : (ie,   je)      η (m)
%   weto_u     : (ie+1, je,  1) 
%   weto_v     : (ie,   je+1, 1) 
%
% 输出:
%   u_bt       : (ie+1, je)   U 点正压(深度平均)流速
%   v_bt       : (ie,   je+1) V 点正压(深度平均)流速
%   u_bc       : (ie+1, je)   U 点斜压流速 (u_baroclinic = u - u_bt)
%   v_bc       : (ie,   je+1) V 点斜压流速
%
% 说明:
% - 使用厚度加权平均，并将自由面 η 经线性插值加到顶层厚度（仅顶层）。
% - 若 ddu* / ddu* 已经包含了随潮起伏的层厚，可自行将 “+ η_*” 去掉。
% - 自动防除零，并按 mask 掩蔽陆地。

    % 尺寸
    [iu, ju, ku] = size(uko);
    [iv, jv, kv] = size(vke);
    [ie, je]     = size(zoo);
    assert(iu == ie+1 && ju == je && iv == ie && jv == je+1, ...
        '网格尺寸与 zeta 不匹配');

    u_bc = zeros(iu,ju,ku);
    v_bc = zeros(iv,jv,kv);
    u_bt = zeros(iu,ju);
    v_bt = zeros(iv,jv);

    % 取 mask（允许传第1层或全层）
    mu = weto_u;
    mv = weto_v;

    % === 1) ρ 点自由面插值到 U/V 点 ===
    eta_u = zeros(iu, ju);
    eta_v = zeros(iv, jv);

    % U 点（经向平均）
    eta_u(2:ie, :) = 0.5 * (zoo(1:ie-1, :) + zoo(2:ie, :));
    eta_u(1,   :)  = zoo(1,   :);    % 西边界
    eta_u(end, :)  = zoo(end, :);    % 东边界
    eta_u = eta_u .* mu;

    % V 点（纬向平均）
    eta_v(:, 2:je) = 0.5 * (zoo(:, 1:je-1) + zoo(:, 2:je));
    eta_v(:, 1)    = zoo(:, 1);      % 北边界
    eta_v(:, end)  = zoo(:, end);    % 南边界
    eta_v = eta_v .* mv;

    % === 2) 分母：整柱厚度 (加顶层 η 修正) ===
    Hu = sum(dduo_grid, 3) + eta_u;   % (ie+1, je)
    Hv = sum(ddue_grid, 3) + eta_v;   % (ie,   je+1)

    % 防止除零
    Hu = Hu + (Hu==0) * eps;
    Hv = Hv + (Hv==0) * eps;

    % === 3) 分子：输运 (加顶层 u1*η / v1*η) ===
    Tu = sum(uko .* dduo_grid, 3) + uko(:,:,1) .* eta_u;
    Tv = sum(vke .* ddue_grid, 3) + vke(:,:,1) .* eta_v;

    % === 4) 正压（深度平均） ===
    u_bt = (Tu ./ Hu) .* mu;   % mask 海域
    v_bt = (Tv ./ Hv) .* mv;

    % === 5) 斜压残差 ===
    for k=1:ku
        u_bc(:,:,k) = uko(:,:,k) - u_bt; 
    end
    for k=1:kv
        v_bc(:,:,k) = vke(:,:,k) - v_bt;
    end

end