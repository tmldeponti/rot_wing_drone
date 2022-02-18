function [time] = wing_rot_finder(ac_data)
%STEP_FINDER Summary of this function goes here
%   Detailed explanation goes here
check = 0;
time = [];
x = ac_data.ROT_WING_CONTROLLER.wing_angle_deg;
sp = ac_data.ROT_WING_CONTROLLER.wing_angle_deg_sp;
diff = abs(sp-x);
mn = mean(diff);
for i = 2:size(x,1)
    if diff(i)> 5*mn && abs(diff(i)-diff(i-1))> abs(0.8*diff(i))
        time = [time, ac_data.ROT_WING_CONTROLLER.timestamp(i)];
    end
end
end

