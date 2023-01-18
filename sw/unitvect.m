function [output] = unitvect(A,B)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
output = (B-A)./norm(B-A);
end

