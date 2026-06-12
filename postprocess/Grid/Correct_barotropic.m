function [USO_new, VSE_new] = Correct_barotropic( ...
        uso, vse, uko, vke, zoo, Hu, Hv)

% Mask
    
    mu = zeros(size(Hu)) + 1;
    mv = zeros(size(Hv)) + 1;

    mu(uso==0)=0;
    mv(vse==0)=0;

    eta_u  =zeros(size(mu));
    eta_v  =zeros(size(mv));
    [ie,je] = size(zoo);
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

    USO_new = (uko.*eta_u + uso.*Hu)./(Hu + eta_u);
    VSE_new = (vke.*eta_v + vse.*Hv)./(Hv + eta_v);

    USO_new(isnan(Hu))=0;
    VSE_new(isnan(Hv))=0;

end