function [p,q,r,t] = gyro_rates(ac_data, airframe)
%gyro_rates Summary of this function goes here
data = [ ac_data.IMU_GYRO_SCALED.gp_alt, ac_data.IMU_GYRO_SCALED.gq_alt, ac_data.IMU_GYRO_SCALED.gr_alt]/180*pi;
order = abs(airframe.IMU_Orientation);
direction = sign(airframe.IMU_Orientation);
data1 = data.*direction;
%[p,q,r] = [data1(:,find(order==1)), data1(:,find(order==2)), data1(:,find(order==3))];
output = data1(:,order);
p = output(:,1);
q = output(:,2);
r = output(:,3);
t = ac_data.IMU_GYRO_SCALED.timestamp;
end

