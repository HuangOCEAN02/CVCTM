function [U] = project_line(u,v,theta)
% The theta is the less than 90 and larger than 0
% 求取切线速度
M = length(u);
alpah = zeros(M);

for i = 1 : M
%     alpha(i) = atan2d(v(i),u(i));
%     if (u(i) >= 0)
%         U(i) = sqrt(v(i)^2+u(i)^2)*cosd(alpha(i) + theta);
%     else
%         U(i) = -sqrt(v(i)^2+u(i)^2)*cosd(alpha(i) + theta);       
%     end

    U(i) = u(i)*cosd(90-theta) + v(i)*cosd(theta);
end
end

