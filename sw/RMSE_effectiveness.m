function [rmse] = RMSE_effectiveness(G,order, skew, v, cmd, y)
%RMSE_effectiveness calculate rmse of the estimation
%
%
skew = deg2rad(skew);
cmd = pwm2pprz(cmd,[1100 1900],[-9600 9600]);
b_as = [0.65,0.65,0.665,0.665];
switch order
    case {0,1} %aileron
        M_p = sin(skew).^3.* v.^2 .*cmd .* b_as(1).*G(1,order+1);
        M_q = -1.*(cos(skew)-cos(skew).^3).*v.^2.*cmd.* b_as(1).*G(2,order+1);
        M_r = v.^2.*cmd.*b_as(1).*G(3,order+1);
    case 2 %elevator
        M_p = v.^2.*cmd.*b_as(order+1).*G(1,order+1);
        M_q = v.^2.*cmd.*b_as(order+1).*G(2,order+1);
        M_r = v.^2.*cmd.*b_as(order+1).*G(3,order+1);
    case 3 % Rudder
        M_p = v.^2.*cmd.*b_as(order+1).*G(1,order+1);
        M_q = v.^2.*cmd.*b_as(order+1).*G(2,order+1);
        M_r = v.^2.*cmd.*b_as(order+1).*G(3,order+1);      
end
M = [M_p,M_q,M_r];
a = [y.Mx,y.My,y.Mz] ;
rmse = rms((M-a));
end

