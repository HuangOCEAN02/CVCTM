function [dudz, z_dudz] = vertical_gradient_upward(u, zzout, varargin)
%VERTICAL_GRADIENT_UPWARD du/dz with z positive upward, while input depth is positive downward.
%
%   [dudz, z_dudz] = vertical_gradient_upward(u, zzout)
%
% INPUT
%   u     : field, size [ie,je,ke] (or ND)
%   zzout : depth (meters), same size as u. Depth is POSITIVE downward.
%           Land/below-bottom convention: zzout==0 for invalid levels.
%           If an entire column is 0 -> land grid cell.
%
% OUTPUT
%   dudz   : du/dz where z is POSITIVE UPWARD, same size as u.
%            Invalid (land/below-bottom) levels are NaN.
%   z_dudz : z coordinate (positive upward) at which dudz is defined,
%            same size as u. For valid ocean levels: z_dudz = -zzout.
%            Invalid levels: NaN.
%
% OPTIONS (name-value)
%   'dim'    : vertical dimension (default 3)
%   'method' : 'gradient' (default) or 'finite-diff'
%   'strict_monotonic' : true/false (default false)
%
% NOTES
%   - Computes column-wise derivative at the same grid points (cell centers).
%   - Because z = -depth, we compute du/dz = du/d(-depth) = -(du/ddepth).
%     Implemented directly by using z = -zzout in the derivative.
%   - If a column has <2 valid points -> all NaN.
%
% -------------------------------------------------------------------------

% ---- parse ----
p = inputParser;
p.addRequired('u', @(x) isnumeric(x) && ndims(x) >= 3);
p.addRequired('zzout', @(x) isnumeric(x) && isequal(size(x), size(u)));
p.addParameter('dim', 3, @(x) isscalar(x) && x>=1 && x<=ndims(u));
p.addParameter('method', 'gradient', @(s) ischar(s) || isstring(s));
p.addParameter('strict_monotonic', false, @(x) islogical(x) && isscalar(x));
p.parse(u, zzout, varargin{:});

dim = p.Results.dim;
method = lower(string(p.Results.method));
strictMon = p.Results.strict_monotonic;

% ---- permute so vertical dim is 3 ----
nd = ndims(u);
perm = 1:nd;
perm([3, dim]) = perm([dim, 3]);
uP = permute(u, perm);
zDepthP = permute(zzout, perm);

[ie, je, ke] = size(uP);

dudzP  = nan(size(uP), 'like', uP);
z_dudzP = nan(size(uP), 'like', zDepthP);

% ---- loop columns ----
for i = 1:ie
    for j = 1:je
        ucol = squeeze(uP(i,j,:));
        dcol = squeeze(zDepthP(i,j,:)); % depth, positive downward

        % valid ocean levels: depth > 0 and finite, plus u finite
        good = isfinite(ucol) & isfinite(dcol) & (dcol > 0);

        if nnz(good) < 2
            % land or too shallow: keep NaN
            continue;
        end

        idx = find(good);

        uu = ucol(idx);
        depth = dcol(idx);

        % Convert to z (positive upward)
        zz = -depth;

        % optional monotonic check on zz
        dzz = diff(zz);
        if strictMon
            if any(dzz == 0) || ~(all(dzz > 0) || all(dzz < 0))
                error('vertical_gradient_upward:NonMonotonicZ', ...
                      'z is not strictly monotonic at (i=%d,j=%d).', i, j);
            end
        end

        % derivative at same points
        switch method
            case "gradient"
                g = gradient(uu, zz);

            case "finite-diff"
                n = numel(uu);
                g = nan(size(uu), 'like', uu);

                if n == 2
                    dz = zz(2) - zz(1);
                    if dz ~= 0
                        g(:) = (uu(2) - uu(1)) / dz;
                    end
                else
                    % forward
                    dz = zz(2) - zz(1);
                    if dz ~= 0
                        g(1) = (uu(2) - uu(1)) / dz;
                    end

                    % central (3-point, nonuniform)
                    for k = 2:n-1
                        z1 = zz(k-1); z2 = zz(k); z3 = zz(k+1);
                        u1 = uu(k-1); u2 = uu(k); u3 = uu(k+1);
                        h1 = z2 - z1;
                        h2 = z3 - z2;

                        if h1 == 0 || h2 == 0
                            g(k) = NaN;
                        else
                            g(k) = ( -h2/(h1*(h1+h2))*u1 ...
                                     + (h2-h1)/(h1*h2)*u2 ...
                                     + h1/(h2*(h1+h2))*u3 );
                        end
                    end

                    % backward
                    dz = zz(end) - zz(end-1);
                    if dz ~= 0
                        g(end) = (uu(end) - uu(end-1)) / dz;
                    end
                end

            otherwise
                error('vertical_gradient_upward:UnknownMethod', ...
                      'Unknown method "%s". Use "gradient" or "finite-diff".', method);
        end

        % write back
        tmpg = nan(size(ucol), 'like', ucol);
        tmpz = nan(size(ucol), 'like', dcol);

        tmpg(idx) = g;
        tmpz(idx) = zz;

        dudzP(i,j,:)   = tmpg;
        z_dudzP(i,j,:) = tmpz;
    end
end

% ---- back to original dims ----
dudz  = ipermute(dudzP, perm);
z_dudz = ipermute(z_dudzP, perm);

end
