function [MLD, idx_cross] = mld_threshold_from_density(rho, z, threshold, ref_depth)
% MLD_FROM_DENSITY_3D  由密度场阈值法计算混合层厚度（逐列）
%
% [MLD, idx_cross] = mld_from_density_3d(rho, z, threshold, ref_depth)
%
% 输入:
%   rho        : 密度 3D 数组 [nx, ny, nz] (kg/m^3)。陆地/海底以下为 0
%   z          : 深度 3D 数组 [nx, ny, nz]（向下可正可负，内部会排序）
%   threshold  : Δσ 阈值，默认 0.03 (kg/m^3)
%   ref_depth  : 参考深度，默认 10 (m)
%
% 输出:
%   MLD       : 混合层厚度 (m)，[nx, ny]
%   idx_cross : 首次越阈所在层的索引（在清洗、排序后的列中），无则 NaN
%
% 规则与边界条件：
%   - 列内有效层 < 2   => MLD = NaN
%   - 列内有效层 == 2  => MLD = 第一层厚度（|z2 - z1|）
%   - 参考密度：若列深度覆盖 ref_depth，则线性插值；否则用最浅层密度
%   - 若全列未越阈：MLD = 最深深度 - 最浅深度（如需改为 NaN，可在相应处修改）

    if nargin < 3 || isempty(threshold), threshold = 0.03; end
    if nargin < 4 || isempty(ref_depth), ref_depth = 10;  end

    [nx, ny, nz] = size(rho);
    MLD       = nan(nx, ny);
    idx_cross = nan(nx, ny);

    for ix = 1:nx
        for iy = 1:ny
            zcol   = squeeze(z(ix, iy, :));
            rhocol = squeeze(rho(ix, iy, :));

            % ---- 1) 剔除无效：0 或 NaN 都视为无效层 ----
            valid = isfinite(zcol) & isfinite(rhocol) & (zcol ~= 0) & (rhocol ~= 0);
            if nnz(valid) < 2
                MLD(ix, iy)       = NaN;
                idx_cross(ix, iy) = NaN;
                continue;
            end
            zc = zcol(valid);
            rc = rhocol(valid);

            % ---- 2) 从浅到深排序（z 可能为负，排序保证单调）----
            [zc, ord] = sort(zc, 'ascend');
            rc = rc(ord);

            % 去重，避免重复深度引起插值问题
            [zc, uniqIdx] = unique(zc, 'stable');
            rc = rc(uniqIdx);
            nlev = numel(zc);

            % ---- 3) 仅 2 层：按要求，用第一层厚度 ----
            if nlev == 2
                MLD(ix, iy)       = abs(zc(2) - zc(1));
                idx_cross(ix, iy) = 2;   % 仅作记录
                continue;
            end

            z_top = zc(1);     % 最浅层深度
            z_bot = zc(end);   % 最深层深度

            % ---- 4) 参考密度 ----
            if (ref_depth >= z_top) && (ref_depth <= z_bot)
                rho_ref = interp1(zc, rc, ref_depth, 'linear');
            else
                % 列深度不够：用最浅层密度
                rho_ref = rc(1);
            end

            % ---- 5) 阈值 Δσ ----
            dR = rc - rho_ref;

            % 首次越阈（≥ 阈值）
            k = find(dR >= threshold, 1, 'first');

            if isempty(k)
                % 未越阈：返回整列厚度（若想返回 NaN，请改为：MLD(ix,iy)=NaN）
                MLD(ix, iy)       = abs(z_bot - z_top);
                idx_cross(ix, iy) = NaN;
            elseif k == 1
                % 顶层即越阈
                MLD(ix, iy)       = abs(zc(1) - z_top);
                idx_cross(ix, iy) = 1;
            else
                % ---- 6) 在线性段内插，精确越阈深度 ----
                z1 = zc(k-1); z2 = zc(k);
                d1 = dR(k-1); d2 = dR(k);
                if d2 == d1
                    z_thr = z2;
                else
                    z_thr = z1 + (threshold - d1) * (z2 - z1) / (d2 - d1);
                end
                MLD(ix, iy)       = abs(z_thr - z_top);
                idx_cross(ix, iy) = k;
            end
        end
    end
end