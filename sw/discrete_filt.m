function [outputArg1] = discrete_filt(x,fc,sf)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
A = tf(fc,[1 fc]);
A = c2d(A,1/sf);
max_rate = 10000;
[num,den] = tfdata(A);
num = cell2mat(num);
den = cell2mat(den);
alpha =  num(end);
beta = abs(den(end));

N = size(x,1);
M = size(x,2);
output = zeros(N,M);
for j = 1:M
    for i = 2:N
        output(i,j) = output(i-1,j) * beta + alpha*x(i-1,j);
        if((output(i,j)-output(i-1,j))>max_rate)
            output(i,j) = output(i-1,j)+max_rate;
        elseif((output(i,j)-output(i-1,j))<-max_rate)
            output(i,j) = output(i-1,j)-max_rate;
        end
    end
end

outputArg1 = output;
end