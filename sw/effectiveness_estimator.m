function [G] = effectiveness_estimator(I,order, skew, v, cmd, y)
%effectiveness_estimator General Estimation of effectiveness to be put in
%the controller
%
skew = deg2rad(skew);
cmd = pwm2pprz(cmd,[1100 1900],[-9600 9600]);
b_as = [0.65,0.65,0.665,0.665];
switch order
    case 1 %aileron
        %roll
        G_p = [sin(skew).^3.* v.^2 .*cmd .* b_as(1)]\y(:,1);
        %pitch
        G_q = [(cos(skew)-cos(skew).^3).*v.^2.*cmd.* b_as(1)]\y(:,2);
        %yaw
        G_r = [cmd.*b_as(1),ones(size(cmd))]\y(:,3);
    case 2 %elevator
        %roll
        G_p = [cmd.*b_as(3),ones(size(cmd))]\y(:,1);
        %pitch
        G_q = [v.^2.*cmd.* b_as(3)]\y(:,2);
        %yaw
        G_r = [cmd.*b_as(3),ones(size(cmd))]\y(:,3);

    case 3 % Rudder
        %roll
        G_p = [cmd.*b_as(4),ones(size(cmd))]\y(:,1);
        %pitch
        G_q = [cmd.*b_as(4),ones(size(cmd))]\y(:,2);
        %yaw
        G_r = [v.^2.*cmd.* b_as(4)]\y(:,3);        
end

end