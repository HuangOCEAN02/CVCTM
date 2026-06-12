function [dphidx, dphidy] = phase_gradient_unitcomplex(phi,dx,dy)
    Z = exp(1i*phi);
    [dZdy,dZdx] = gradient(Z);
    dphidx = imag(conj(Z).*dZdx) ./ dx;
    dphidy = -imag(conj(Z).*dZdy) ./ dy;
end