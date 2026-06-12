function [yy] = Density_interp1(x,y,xx)
%  x:r : density
%  y:z : depth
% xx:R : density coordinates
%% check mixed density
unique_x = unique(x);
unique_y = zeros(size(unique_x));

for i = 1:length(unique_x)
    unique_y(i) = mean(y(x == unique_x(i)));
end

%%
yy = interp1(unique_x,unique_y,xx); 

end