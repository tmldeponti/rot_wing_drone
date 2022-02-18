function [ output ] = rate_lim( input, servo_delay, max_rate, fo_constant )
%SERVO_DYN Summary of this function goes here
%   Detailed explanation goes here
% servo delay is zero
% f0 zero constant is 0.1 
N = size(input,1);
%disp(N)
M = size(input,2);
%disp(M)
output = zeros(N,M);
for j = 1:M
    for i = 2+servo_delay:N
        output(i,j) = output(i-1,j) + fo_constant*(input(i-servo_delay,j)-output(i-1,j));
        if((output(i,j)-output(i-1,j))>max_rate)
            output(i,j) = output(i-1,j)+max_rate;
        elseif((output(i,j)-output(i-1,j))<-max_rate)
            output(i,j) = output(i-1,j)-max_rate;
        end
    end
end
end

