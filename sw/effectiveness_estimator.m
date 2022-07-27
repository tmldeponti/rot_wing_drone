function [G,G_indi] = effectiveness_estimator(I,order, skew, v, cmd, y)
%effectiveness_estimator General Estimation of effectiveness to be put in
%the controller
%
skew = deg2rad(skew);
cmd = pwm2pprz(cmd,[1100 1900],[-9600 9600]);
b_as = [0.65,0.65,0.665,0.665];
switch order
    case {0,1} %aileron
%         %roll
%         G_p = [sin(skew).^3.* v.^2 .*cmd .* b_as(1)]\y.Mx;
%         %pitch
%         G_q = [-1.*(cos(skew)-cos(skew).^3).*v.^2.*cmd.* b_as(1)]\y.My;
        %all together
        G_p = [sin(skew).^3.* v.^2 .*cmd .* b_as(1);-1.*(cos(skew)-cos(skew).^3).*v.^2.*cmd.* b_as(1)]\[y.Mx;y.My];
        G_q = G_p;
        %yaw
        G_r = [v.^2.*cmd.*b_as(1)]\y.Mz;
    case 2 %elevator
        %roll
        G_p = [v.^2.*cmd.*b_as(3)]\y.Mx;
        %pitch
        G_q = [v.^2.*cmd.* b_as(3)]\y.My;
        %yaw
        G_r = [v.^2.*cmd.*b_as(3)]\y.Mz;

    case 3 % Rudder
        %roll
        G_p = [v.^2.*cmd.*b_as(4)]\y.Mx;
        %pitch
        G_q = [v.^2.*cmd.*b_as(4)]\y.My;
        %yaw
        G_r = [v.^2.*cmd.* b_as(4)]\y.Mz;        
end
% switch order
%     case {0,1} %aileron
%         %roll
%         G_p = [sin(skew).^3.* v.^2 .*cmd .* b_as(1),ones(size(cmd))]\y.Mx;
%         %pitch
%         G_q = [(cos(skew)-cos(skew).^3).*v.^2.*cmd.* b_as(1),ones(size(cmd))]\y.My;
%         %yaw
%         G_r = [cmd.*b_as(1),ones(size(cmd))]\y.Mz;
%     case 2 %elevator
%         %roll
%         G_p = [cmd.*b_as(3),ones(size(cmd))]\y.Mx;
%         %pitch
%         G_q = [v.^2.*cmd.* b_as(3),ones(size(cmd))]\y.My;
%         %yaw
%         G_r = [cmd.*b_as(3),ones(size(cmd))]\y.Mz;
% 
%     case 3 % Rudder
%         %roll
%         G_p = [cmd.*b_as(4),ones(size(cmd))]\y.Mx;
%         %pitch
%         G_q = [cmd.*b_as(4),ones(size(cmd))]\y.My;
%         %yaw
%         G_r = [v.^2.*cmd.* b_as(4),ones(size(cmd))]\y.Mz;        
% end
G = [G_p.';G_q.';G_r.']; % Effectiveness for moment model 
G_indi = I^(-1) * [G_p.';G_q.';G_r.']; %Effectiveness for INDI controller
end

