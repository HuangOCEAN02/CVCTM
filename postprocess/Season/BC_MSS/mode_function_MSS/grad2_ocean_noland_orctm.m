function [dFdx, dFdy] = grad2_ocean_noland_orctm(F, wetmask, dx, dy)
%GRAD2_OCEAN_NOLAND_MODELXY Horizontal gradient on ocean points only (model x/y convention).
%
%   [dFdx, dFdy] = grad2_ocean_noland_modelxy(F, wetmask, dx, dy)
%
% Purpose
%   Compute horizontal gradients while avoiding land contamination (no
%   differencing through land cells). The function follows YOUR model-axis
%   convention:
%
%   - Array ROW direction (1st dimension)   = model x-direction
%   - Positive x is downward in the array
%   - Array COLUMN direction (2nd dimension)= model y-direction
%   - Positive y is leftward in the array
%
%   Therefore:
%   - dFdx is based on row differences, positive downward
%   - dFdy is based on column differences, but sign-flipped so positive is leftward
%
% Inputs
%   F       : 2-D scalar field, size [ie, je]
%   wetmask : 2-D logical/numeric mask, same size as F
%             wetmask(i,j)=true/1 for ocean, false/0 for land
%   dx      : x-grid spacing (meters), scalar or 2-D array same size as F
%             (x = row direction)
%   dy      : y-grid spacing (meters), scalar or 2-D array same size as F
%             (y = column direction)
%
% Outputs
%   dFdx    : gradient in model x-direction (positive downward), size [ie, je]
%   dFdy    : gradient in model y-direction (positive leftward),  size [ie, je]
%
% Method
%   At each ocean point:
%   1) Prefer centered difference if both neighboring ocean points exist
%   2) Otherwise use one-sided difference if only one ocean neighbor exists
%   3) Return NaN if no valid ocean neighbor exists in that direction
%
% Notes
%   - Land points are returned as NaN.
%   - This routine is intended for horizontal slices (one k-level at a time).
%   - If dx/dy are spatially varying, this function uses local spacing:
%       centered x: (F(i+1,j)-F(i-1,j)) / (dx(i,j)+dx(i-1,j))
%       centered y: -(F(i,j+1)-F(i,j-1)) / (dy(i,j)+dy(i,j-1))
%
% Example
%   [dBx, dBy] = grad2_ocean_noland_modelxy(B(:,:,k), weto_p(:,:,k)~=0, 1800, 1800);

    if ndims(F) ~= 2
        error('F must be a 2-D array.');
    end
    if ~isequal(size(F), size(wetmask))
        error('F and wetmask must have the same size.');
    end

    wet = (wetmask ~= 0);
    [ie, je] = size(F);

    if isscalar(dx), dx = dx .* ones(ie, je); end
    if isscalar(dy), dy = dy .* ones(ie, je); end
    if ~isequal(size(dx), [ie, je]) || ~isequal(size(dy), [ie, je])
        error('dx and dy must be scalars or arrays with the same size as F.');
    end

    dFdx = nan(ie, je);   % model x (row), positive downward
    dFdy = nan(ie, je);   % model y (col), positive leftward

    % dFdx: row direction
    for i = 1:ie
        for j = 1:je
            if ~wet(i,j), continue; end

            has_up   = (i-1 >= 1)  && wet(i-1,j);
            has_down = (i+1 <= ie) && wet(i+1,j);

            if has_up && has_down
                dFdx(i,j) = (F(i+1,j) - F(i-1,j)) / (dx(i,j) + dx(i-1,j));
            elseif has_down
                dFdx(i,j) = (F(i+1,j) - F(i,j)) / dx(i,j);
            elseif has_up
                dFdx(i,j) = (F(i,j) - F(i-1,j)) / dx(i-1,j);
            else
                dFdx(i,j) = 0;
            end
        end
    end

    % dFdy: column direction (flip sign because model y positive is leftward)
    for i = 1:ie
        for j = 1:je
            if ~wet(i,j), continue; end

            has_left  = (j-1 >= 1)  && wet(i,j-1);
            has_right = (j+1 <= je) && wet(i,j+1);

            if has_left && has_right
                dFdy(i,j) = -(F(i,j+1) - F(i,j-1)) / (dy(i,j) + dy(i,j-1));
            elseif has_right
                dFdy(i,j) = -(F(i,j+1) - F(i,j)) / dy(i,j);
            elseif has_left
                dFdy(i,j) = -(F(i,j) - F(i,j-1)) / dy(i,j-1);
            else
                dFdy(i,j) = 0;
            end
        end
    end
end
